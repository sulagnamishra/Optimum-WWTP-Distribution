function[n,b,s,u, k_lump] = networkprop(qtx,VD) %with multiple Kd values
rows = size(qtx,1);
col = size(qtx,2);
n = 0.035;
%n = repmat(n,rows,col);
%b2 = exp(2.45)*qtx.^0.4;
b1 = 2.388 + 0.438 * log(qtx); %reylonds et al.
%b1 = 1.5359 + 0.438 * log(qtx); %calculated to make min b = 1
b = exp(b1);
for j = 1:rows
for i = 1:col
%if (b(j,i) < VD(j,2))
%    b(j,i) = VD(j,2);
%else
    if (b(j,i) > 18)
    b(j,i) = 18;
end
end
end
%b = repmat(VD(:,2),1,col);
s = VD(:,5);     %check slope again
%s = repmat(VD(:,5),1,col); % %rise/100 from arcgis
u = [0.00,0.000002,0.00002,0.0001,0.00025 ,0.0005,0.005,0.05]; %m/sec
k_lump = [0,5.2e-5,1e-4,2e-4,4.9e-4]; %1/sec
%u = repmat(.005,rows,col); %.5 cm/sec
end
