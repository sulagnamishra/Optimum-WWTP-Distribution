function[y] = ymaster()   % provide the array of slopes for each reach,overall n, maximum value of b and maximum value of q
tic
y0=1;                              % the function returns a master 
n = 0.035; %mannings
load('Network1907.mat'); %network properties needed to execute the slope details
s = VD(:,5)/100;
for i = 1:10   
b(i) = (i)*2 ;   %0,2,4,....30
q(i) = (i-1)*1;   %0,1,2,.....14
end


%b =[0.5,1];
%q = [0,0.1,0.2];
for i = 1:size(s,1)  %for producting multiple tables based on the number of reaches
     for r = 1:size(b,2)
     for c = 1:size(q,2)
     X(c,r,i) = ((q(1,c).*n).^(3/2))./(b(1,r).^(5/2).*s(i,1).^(3/4)); %after simplifying for y
     options = optimoptions('fsolve','Display','off');
     y(c,r,i) = fsolve(@f,y0,options,X(c,r,i),b(1,r)); 
     end
     end  
end
toc
end
