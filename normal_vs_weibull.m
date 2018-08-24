% Comparison of RGC response before and after olfactory stimulation with 3 and 8 points using raw data%
% Light intensity to envoke a RGC response before olfactory stimulation is
% taken as 10^-5%
% Light intensity to envoke a RGC response after olfactory stimulation is
% taken as 10^-6%

%Data for control: JPhysio05review_olfactory.xlsx%
%Data for olfaction: JPhysio05review_olfactory.xlsx%
%Columns are: LogLightIntensity,Light Intensity,Bin,RGCresponse(in spikes/s)%


%  % Read the excelsheet containing the control data at light intensity 10^-5%
zebracontrol_data= readtable('JPhysio05review_control5.xlsx',...
            'ReadVariableNames',true);

%  % Read the excelsheet containing the data with olfaction at light intensity 10^-6%
zebraolfact_data= readtable('JPhysio05review_olfactory.xlsx',...
            'ReadVariableNames',true);
        
% % Sorting the table based on columns: RGCResponse value
zebracontrol_sort = sortrows(zebracontrol_data,{'RGCResponse'},{'descend'});
vars_control = {'Bin','RGCResponse'};

% % Sorting the table based on columns: RGCResponse value
zebraolfact_sort = sortrows(zebraolfact_data,{'RGCResponse'},{'descend'});
vars_olfact = {'Bin','RGCResponse'};

% % Take the first 3 rows from the table to create a table containing the three
% maximum values of RCG response
r3_control = zebracontrol_sort(1:3,vars_control);
r3_olfact  = zebraolfact_sort (1:3,vars_olfact);

r8_control = zebracontrol_sort(1:8,vars_control);
r8_olfact  = zebraolfact_sort (1:8,vars_olfact);


% % Flipping the response value for fitting the Weibull function for

% control %

maxcontrol_response = max(zebracontrol_sort.RGCResponse);
maxcontrol_response = maxcontrol_response + 1;
r3control_response = maxcontrol_response-r3_control.RGCResponse;
r8control_response = maxcontrol_response-r8_control.RGCResponse;

% olfactory %

maxolfact_response = max(zebraolfact_sort.RGCResponse);
maxolfact_response = maxolfact_response + 1;
r3olfact_response = maxolfact_response-r3_olfact.RGCResponse;
r8olfact_response = maxolfact_response-r8_olfact.RGCResponse;

% %Fitting Weibull distribution to individual data points%

% control %

parmhat_control3 = wblfit(r3control_response);
a3_control= parmhat_control3(1);
b3_control= parmhat_control3(2);
[m_control3,v_control3] = wblstat(a3_control,b3_control);

parmhat_control8 = wblfit(r8control_response);
a8_control= parmhat_control8(1);
b8_control= parmhat_control8(2);
[m_control8,v_control8] = wblstat(a8_control,b8_control);

% olfactory %

parmhat_olfact3 = wblfit(r3olfact_response);
a3_olfact= parmhat_olfact3(1);
b3_olfact= parmhat_olfact3(2);
[m_olfact3,v_olfact3] = wblstat(a3_olfact,b3_olfact);

parmhat_olfact8 = wblfit(r8olfact_response);
a8_olfact= parmhat_olfact8(1);
b8_olfact= parmhat_olfact8(2);
[m_olfact8,v_olfact8] = wblstat(a8_olfact,b8_olfact);

%Normal%
[mu_control,s_control] = normfit(zebracontrol_data.RGCResponse);
[mu_olfact,s_olfact] = normfit(zebraolfact_data.RGCResponse);


% Make the distributions with the fitted parameters %
pdcontrol_weibull3 = makedist('Weibull','a',a3_control,'b',b3_control);
pdolfact_weibull3 = makedist('Weibull','a',a3_olfact,'b',b3_olfact);

pdcontrol_weibull8 = makedist('Weibull','a',a8_control,'b',b8_control);
pdolfact_weibull8 = makedist('Weibull','a',a8_olfact,'b',b8_olfact);

%
x_values = linspace(0,500,1000);

pdcontrol_normal = makedist('Normal',mu_control,s_control);
pdolfact_normal = makedist('Normal',mu_olfact,s_olfact);


% CDF %
cdfcontrol_weibull3 = cdf(pdcontrol_weibull3,x_values);
cdfolfact_weibull3 = cdf(pdolfact_weibull3,x_values);

cdfcontrol_weibull8 = cdf(pdcontrol_weibull8,x_values);
cdfolfact_weibull8 = cdf(pdolfact_weibull8,x_values);

cdf_control = cdf(pdcontrol_normal,x_values);
cdf_olfact = cdf(pdolfact_normal,x_values);

% Plotting the cdf of olfactory response against those of control curves
X = zebraolfact_data.RGCResponse;


% Display only the values of RGC response as our data %
% zebracontrol_sort2 = sortrows(zebracontrol_data,{'RGCResponse'},{'ascend'});
zebra_sort2 = sortrows(zebraolfact_data,{'RGCResponse'},{'ascend'});
x = zebra_sort2.RGCResponse;
x1 =unique(x,'rows');
x2 =sortrows(x1);
n= size(x1);
for i=1:n(1,1)
    %if (x2(i)~=9 && x2(i)~=40 && x2(i)~=42 && x2(i)~=73)
    if (x2(i)~=15 && x2(i)~=30 && x2(i)~=38 && x2(i)~=69)
       x3(i) = x2(i);
    end
    
end
y = x3';
y2 = sortrows(y);
y1 =(unique(y2))';
cdf_co3 = wblcdf(y2,a3_control,b3_control);
cdf_co8 = wblcdf(y2,a8_control,b8_control);
cdf_o3 = wblcdf(y2,a3_olfact,b3_olfact);
cdf_o8 = wblcdf(y2,a8_olfact,b8_olfact);

% % Plot the cdf of each fitted distribution%
figure(1)
line(x_values,cdfcontrol_weibull3,'LineStyle','-','Color','b','LineWidth',2);
hold on;
line(x_values,cdfolfact_weibull3,'LineStyle','--','Color','b','LineWidth',2);
line(x_values,cdfcontrol_weibull8,'LineStyle','-','Color','r','LineWidth',2);
line(x_values,cdfolfact_weibull8,'LineStyle','--','Color','r','LineWidth',2);
line(x_values,cdf_control,'LineStyle','-','Color','g','LineWidth',2);
line(x_values,cdf_olfact,'LineStyle','--','Color','g','LineWidth',2);
plot(y2,cdf_co3,'square','Color','blue');
plot(y2,cdf_co8,'o','Color','red');
plot(y2,cdf_o3,'square','Color','blue');
plot(y2,cdf_o8,'o','Color','red');
set(gca,'XTick',y1,'FontSize', 20, 'Fontweight', 'bold');
set(gca, 'Layer', 'top');

l = legend('Weibull distribution without olfaction (3)','Weibull distribution with olfactory signal (3)','Weibull distribution without olfaction (8)','Weibull distribution with olfactory signal (8)','Normal distribution without olfaction','Normal distribution with olfactory signal',...
    'CDF of olfactory RGC response as against Control Curve (3)', 'CDF of olfactory RGC response as against Control Curve (8)'...
    ,'CDF of olfactory RGC response as against Olfactory Curve (3)', 'CDF of olfactory RGC response as against Olfactory Curve (8)');
%legend('boxoff');
set(l,'Location','best', 'FontSize', 17,'FontWeight', 'bold');
%title('Eentral vs EVT');
xlabel('RGC response in spikes/s', 'FontSize', 24, 'FontWeight', 'bold');
ylabel('Probability of occurrence', 'FontSize', 24, 'FontWeight','bold');
hold off;

