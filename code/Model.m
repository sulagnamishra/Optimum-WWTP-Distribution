clear;
tic
%Function definations have been provided in the README.md
%lockwitz folder contains input files with the stream nodes(to,from,reach), area of the subcatchment and length of the reach
%VD file has the slope corresponding to each reach mentioned in lockwitz file (extracted from GIS)

load('lockwitz.mat')

out = Sum_Properties(lockwitz); 
%columns of out: reachno, to node, from node,length of node, area upstream , 
%total upstream area, total distance to the outlet, strahlar order 

% Step 1
% Flow generator
[qtx,qtx_av,MSD_av] = Flowgenerator(out,days); %returns flow time series, Flow quartiles (to compute extreme cases) and Mean specific discharge the number of days specified

%Flowgenerator includes a stocastic rainfall generator.

%Step 2
%Defining network properties conditions
 
[n,b,s,k_lump] = networkprop(qtx,VD); %(Mannings coef., Base width, slope, multiple values of single order in-stream loss constant)
[n1,b1,s1,u1,k_lump] = networkprop(qtx_av,VD);  %for boundary case calculations (Only the quartile values)


%Step 3 : Calculation of velocity and depth
[y,v] = depth(qtx,b); %calculations done for day (depth function computes depth of water in the stream, y and velocity of flow v using mannings equation)
[y1,v1]= depth(qtx_av,b1); %boundary case calculations


%Step 4 : Hot spot length calculation (Load and flow from WWTP is user defined based on catchment)
%lumped in-stream loss coef.  
safeconc = 1260; CFU/ml  
load=25000;      From the WWTP
flow_wwtp=30;    Total load from the plant 

[l,k2] = hotlength(k_lump,v,out,qtx,load,flow_wwtp,safeconc); % l in meters, multiple 'Kd' values are provided and 30 litres added to the flow in Q function

[l1,k1] = hotlength(k_lump,v1,out,qtx_av,load,flow_wwtp,safeconc);
.........

%% All cases for different treatment plants for variable k
n=[1,4,6,10];  %different number of treatment plants
k=[5.2e-5,2e-4,4.9e-4]; %range of Kd to test

count=1;
for i = 1:size(n,2)
    for j = 1:size(k,2)
[l_case,k_case] = hotlength(k(j),v1,out,qtx_av,load,flow_wwtp/n(i),safeconc);
l_k_n(:,count) = (l_case(:,2)/1000);
%name=['k',num2str(j),',n',num2str(i)];
%l_k_n.Properties.VariableNames([count])={'name'};
count=count+1;
    end
end
index = (1:size(l1,1))';
table_allcases=[index,l_k_n];
final_allcases = array2table(table_allcases);
writetable(final_allcases,'finalallcases.txt');
%%




