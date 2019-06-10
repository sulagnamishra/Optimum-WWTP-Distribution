function[y1,v,l]=depth(qtx,b,u) %n assumed to be 0.035 for the whole catchment
load ('ymaster.mat');
%b1= [0.8,0.9];
%q1 = [0.12,0.18];
%s1 = 1;
blimit = b/2;   %/2  +1 is based on the interval used to calculate the Ymaster
if (blimit<1)
    blimit = 1;
end
bindex = floor(blimit);
bfraction = blimit - bindex;
qlimit = qtx/1+1;    %/1 +1 is based on the interval and start value used to calculate Y master
qindex = floor(qlimit);
qfraction = qlimit - qindex;

     for j = 1:size(b,1)   % for all the reaches
        for i = 1:size(qtx,2) % for all time steps
            if bindex(j,i)==0 
            y1(j,i) = (y(qindex(j,i),bindex(j,i)+1,j)*(b(j,i)/2))*(1-qfraction(j,i))+( y(qindex(j,i)+1,bindex(j,i)+1,j)*(b(j,i)/2))*(qfraction(j,i));
            else
            y1(j,i) = (y(qindex(j,i),bindex(j,i),j)*(1-bfraction(j,i))+ y(qindex(j,i),bindex(j,i)+1,j)*(bfraction(j,i)))*(1-qfraction(j,i))+( y(qindex(j,i)+1,bindex(j,i),j)*(1-bfraction(j,i))+ y(qindex(j,i)+1,bindex(j,i)+1,j)*(bfraction(j,i)))*(qfraction(j,i));
            end
            end
     end
   
     v = qtx./(b.*y1); 
     l = 0.6931*v./(u./y1);%Considering very fine - fine sand sediment - 125 microm radius, u dep = .5 cm/sec

end
