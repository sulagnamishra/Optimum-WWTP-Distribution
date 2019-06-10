function [qtx,qtx_av,MR_av_q]= flowgenerator(out,days)
hours = days*24;
mins = days*1440;
%%Read the real time series of rainfall and flow files%%%
r_q= readtable('R_l_Q_k.txt');  %table from r-> combined Q and rainfall data
r_q_time=table2array(r_q(:,1)); %time
r_q_select=table2array(r_q(:,2:4)); %col 1<-flow, col2<-rainfall, col3<-date_num
t(:,2:4)=table2array(r_q(:,2:4));

datetime(now,'ConvertFrom','datenum'); %number to date
plot(r_q_time,r_q_select(:,1));

%% 
%plot of observed rainfall and observed flow
figure
   yyaxis left
    plot(r_q_time(1:hours),r_q_select(1:hours,1),'-k');
    legend('Observed flow in m3/sec');
    hold on
    %plot(r_q_time(1:hours),q_k_model(1:hours),'-kx','DisplayName','modelled flow');
    %y2 = Observed flow;
    ylabel('Flow at Kriesha in m3/sec')
    yyaxis right
    plot(r_q_time(1:hours),r_q_select(1:hours,2),'--k','DisplayName','Observed rainfall');
    set(gca,'ydir','reverse');
    ylabel('Recorded rainfall in mm/hour');
    %xlim([0,max(time_mins)]);
    %title('Modelled,observed Q & Rainfall at Kriesha station');
    xlabel('Time');
   
    hold off
%%
Rain_q=raingenerator(out,hours);  %hourly data
rain=[Rain_q zeros(1,2*length(Rain_q))];
effrain=rain.*0.5;
time=1:length(rain); %rain in hours
time_days=time/24;
c=0.5;
ST1=2.8*24;
ST2=-25*24;
areaupstream = out(84,8);
model1 = conv(1/(ST1).*exp(-time/ST1),effrain)*areaupstream*1000/3600;  %mm/hour -> m3/sec
model1 = model1(1:length(effrain));
slowpdf=time.^(ST2);
model2 = conv(slowpdf,effrain)*areaupstream*1000/3600;
model2 = model2(1:length(effrain));
model=((1-c).*model1+c.*model2);

%%
figure
   yyaxis left
    plot(r_q_time(1:hours),r_q_select(1:hours,1),'-r');
    legend('Observed flow in m3/sec');
    hold on
    plot(r_q_time(1:hours),model(1:hours),'-k','DisplayName','modelled flow');
    ylabel('Flow at Kriesha in m3/sec')
    yyaxis right
    plot(r_q_time(1:hours),r_q_select(1:hours,2),'--k','DisplayName','Observed rainfall');
    set(gca,'ydir','reverse');
    ylabel('Recorded rainfall in mm/hour');
    %xlim([0,max(time_mins)]);
    %title('Modelled,observed Q & Rainfall at Kriesha station');
    xlabel('Time');
    hold off
%%

q1=model;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%MR = qtx_k/arealock; % has to be m/sec
MR=(q1(1:days));
k=find(isnan(MR));
MR(k) = 0;
MR_av = quantile(MR,[0.1,0.25,0.5,0.75,0.9]);
%k = find(MR == MR_av);
MR_av_q = repmat(MR_av,size(out,1),1);  %to find the Q for the boundary values
MR = repmat(MR,size(out,1),1);
coef = 0.9;
%MR = repmat(q,size(out,1),1);
%MR = q/(out(83,8)/1e6); % has to be m3/sec/km2
area_power=power(out(:,8),coef);
%area= repmat(area_power,1,size(q,2));
qtx = MR.*area_power+.03;%Cubicmeter/sec 0.03 is the extra 30 litres of load from the treatment plant
qtx_av=MR_av_q.*area_power+.03;%Cubicmeter/sec

end
