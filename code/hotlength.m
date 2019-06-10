function[hl,k]=hotlength(k_lump,v1,out,qtx_av,load,flow_wwtp,safeconc) %with 5 Kd values
%k_lump=0;
maxlength=80001;
for i = 1:size(k_lump,2)       %make v2 and qtx 3D for different k_lump values                                   %have 3 similar y,u and q matrix
    v2 (:,:,i) = v1();
    qtx1 (:,:,i) = qtx_av();
end
%k_lump = zeros(size(qtx1,1),size(qtx1,2),size(k_lump,2));  %preallocation to save time
for i =1:size(k_lump,2)
    k(1:size(qtx1,1),1:size(qtx1,2),i)=k_lump(1,i);                           %3 matrix for 
end

q=qtx1*1000; %q in l/sec
%load = 25000/3; %CFU/1litre
%flow_wwtp=30; %flow out of the treatment plant l/sec
initconc = (load*flow_wwtp)./q;
num = (load*flow_wwtp)./(safeconc*q);
%time = zeros(size(qtx,1),size(qtx,2),size(u,2));  %preallocation to save time
time =log(num)./k; %time in seconds 
time((time < 0)) = 0;
%l = zeros(size(qtx,1),size(qtx,2),size(u,2));     %preallocation to save time
l = time.*v2;
for i = 1:size(k,3)   %for all k
for j = 1:size(k,1)   % for all the reaches
        for o = 1:size(k,2) % for all time steps
            if (l(j,o,i)==0) 
                l(j,o,i) = 0 ;
            elseif(k(j,o,i)==0)
                l(j,o,i)=out(j,4);
            elseif(l(j,o,i)>=out(j,4) && k(j,o,i)~=0)
                l(j,o,i)=out(j,4);
            end    
        end
end
end 

%connection table row 1 -> reach, row 2 -> next reach, row 3 -> row number
%of the next reach
contab = zeros(size(qtx1,1),3);
contab(:,1) = out(:,1);
for i = 1:size(qtx1,1)
    for j = 1:size(qtx1,1)
    if(out(i,3)==out(j,2))
        contab(i,2) = out(j,1);
        contab(i,3) = j;
    end
    end
end
%% 
%special case of u and growth rate = 0, only effect of dilution laken into consideration
hl = zeros(size(qtx1,1),size(qtx1,2),size(k,3));  %preallocation to save time
%hl = l;
initconc = (load*flow_wwtp)./q;                %calculation of initial concentration
timetr = out(:,4)./v2;  %time of travel in a reach for each packet
kt= k.*timetr;
fconc = initconc.*exp(-kt);
%fconc = initconc.*exp(-k.*timetr); 
for i = 1:size(k,3)     % for all k 
 for j = 1:size(k,1)    % for all the reaches
    for o = 1:size(k,2) % for all time steps
            p = 0;      % iteration control
            fconctemp=fconc(j,o,i);
            while(fconctemp > safeconc)
                p = p+1;
                [j1] = nextreach(j,p,contab);   %gives the reach based on the number of iteration
                    
                if (p>1)
                    prev = j1(1,p-1);           %previous reach
                else
                    prev = j; 
                end
                    this = j1(1,p);             %current reach
                   
                if( this > 0)                          %if there is a downstream node
                %jl(j,o,i) = 0;
                k1 = k(this,o,i);
                initconc1 = fconc(prev,o,i)*q(prev,o,i)/q(this,o,i);
                t1 = log(initconc1/safeconc)/k1;
                if (t1 < 0) 
                    t1 = 0; end      %for cases when safe conc is reached just by dilution at the reach
                l1 = t1*v2(this,o,i); %when l1 is 0 because of dilution, no changes are added to hl
                if (l1<out(this,4)&& l1>0)
                hl(j,o,i) = hl(j,o,i)+l1;  %affected length of the next reaches added
                %elseif (l1 == inf)
                elseif (l1 ==0 && k1<0)        %case where l is calculated negative because k is negative eg u is 0 or low.
                hl(j,o,i) = hl(j,o,i)+out(this,4);
                elseif (k1==0)   %case where k is 0 and l is inf
                hl(j,o,i) = hl(j,o,i)+out(this,4);    
                elseif (l1>=out(this,4)&& k1~=0)
                hl(j,o,i)=hl(j,o,i)+out(this,4);
                end
                fconctemp=initconc1*exp(-kt(this,o,i));
                %fconc(j,o,i) = initconc1*exp(-kt(this,o,i));
                %fconc(j,o,i)
                %hl(j,o,i)
                %this
                %prev
                %fconc(j,o,i) = initconc1*exp(-k1*timetr(this,o,i));
                %l12(1,p)=l1;
                else
                    fconctemp=safeconc/2;
                    hl(j,o,i)=hl(j,o,i)+maxlength*100;
                    %fconc(j,o,i) = safeconc/2;
                %fconc(j,o,i)
                %hl(j,o,i)
          end
             
            %else
            %   hl(j,o,i) = hl(j,o,i)+l(j,o,i);
            end
            hl(j,o,i) = hl(j,o,i)+l(j,o,i);
       end
    end
 end   
 end 
