% Generating 100000 samples through MCMC method -
% Metropolis Hastings Algorithm.
% Proposal distribution is Uniform distribution and the target ditribution
% is Normal for RGC responses with olfactory signal and generalised Pareto
% distribution for RGC responses without olfactory response
% RGCresponse after fitting a normal distribution over 22/29  points. And
% fitting Weibull curve on the 50 and 250 maximum points
% Light intensity to envoke a RGC response before olfactory stimulation is
% taken as 10^-5%
% Light intensity to envoke a RGC response after olfactory stimulation is
% taken as 10^-6%
% Data for control(without olfaction): JPhysio05review_control5.xlsx%
% Data for olfaction: JPhysio05review_olfactory.xlsx%
%Columns are: LogLightIntensity,Light Intensity,Bin,RGCresponse(in spikes/s)%
%Note that the program estimates distribution parameters from the raw data mentioned above 
% and fits ditribution everytime. Hence the 100000 samples generated from
% the respective distribution varies. So the curves is not always the same.
% However, the Weibull cumulative distributions for data with 
% and without olfaction are always widely separated, with the curve 
% for data with olfaction shifting leftward, giving some probability to 
% RGC responses below the threshold which is practically improbable 
% under normal situations (without olfaction)



%  % Read the excelsheet containing the control data at light intensity 10^-5%
zebracontrol_data= readtable('JPhysio05review_control5.xlsx',...
            'ReadVariableNames',true);

%  % Read the excelsheet containing the data with olfaction at light intensity 10^-6%
zebraolfact_data= readtable('JPhysio05review_olfactory.xlsx',...
            'ReadVariableNames',true);
        
%  % Fitting generalized pareto distribution to the control data
[parmhat,parmci] = gpfit(zebracontrol_data.RGCResponse);
k     = parmhat(1); % shape parameter
sigma = parmhat(2); % scale parameter


%  % Fitting normal distribution to the olfactory data
[mu_olfact,s_olfact] = normfit(zebraolfact_data.RGCResponse);


% %  % Sort the random RGCresponse in descending order and get the first 50
% and 250 maximum values from them
% 
% % Control%

delta = 200;
%pdf = @(x) normpdf(x,mu_control,s_control);
pdf = @(X) gppdf(X,k,sigma); % Target distribution
proppdf = @(x,y) unifpdf(y-x,-delta,delta);
proprnd = @(x) x + rand*2*delta - delta;   
nsamples = 100000;
randcontrol_resp = abs(mhsample(1,nsamples,'pdf',pdf,'proprnd',proprnd,'proppdf',proppdf,'symmetric',1));
% 
randcontrol_sort = sortrows(randcontrol_resp,-1);
maxcontrol_50 = randcontrol_sort(1:50);
maxcontrol_250 = randcontrol_sort (1:250);

maxcntl_sort = max(randcontrol_sort);
maxcntl_sort = maxcntl_sort + 1;
maxcntl_50 = maxcntl_sort - maxcontrol_50;
maxcntl_250 = maxcntl_sort - maxcontrol_250;
% 
% % Olfactory%
% randolfact_resp = abs(random (pd_olfact,1000000,1));
delta = 100;
pdf = @(X) normpdf(X,mu_olfact,s_olfact);
proppdf = @(X,Y) unifpdf(Y-X,-delta,delta);
proprnd = @(X) X + rand*2*delta - delta;   
nsamples = 100000;
randolfact_resp = abs(mhsample(1,nsamples,'pdf',pdf,'proprnd',proprnd,'symmetric',1));
% 
maximum = max(randolfact_resp);
randolfact_sort = sortrows(randolfact_resp,-1);
maxolfact_50 = randolfact_sort(1:50);
maxolfact_250 = randolfact_sort (1:250);

max_sort = max(randolfact_sort);
max_sort = max_sort + 1;
maxol_50 = max_sort - maxolfact_50;
maxol_250 = max_sort - maxolfact_250;
% 
% % % Fitting Weibull
% 
% % Control%
parm_control50 = wblfit(maxcntl_50);
a50_cntl= parm_control50(1);
b50_cntl= parm_control50(2);
[m_cntl50,v_cntl50] = wblstat(a50_cntl,b50_cntl);
% 
parm_control250 = wblfit(maxcntl_250);
a250_cntl= parm_control250(1);
b250_cntl= parm_control250(2);
[m_cntl8,v_cntl8] = wblstat(a250_cntl,b250_cntl);
% 
% % Olfactory%
parm_olfact50 = wblfit(maxol_50);
a50_ol= parm_olfact50(1);
b50_ol= parm_olfact50(2);
[m_ol50,v_ol50] = wblstat(a50_ol,b50_ol);

parm_olfact250 = wblfit(maxol_250);
a250_ol= parm_olfact250(1);
b250_ol= parm_olfact250(2);
[m_ol250,v_ol250] = wblstat(a250_ol,b250_ol);
% 
% % Create the distributions with the fitted parameters %
pdcntl_weibull50 = makedist('Weibull','a',a50_cntl,'b',b50_cntl);
pdcntl_weibull250 = makedist('Weibull','a',a250_cntl,'b',b250_cntl);
% 
pdol_weibull50 = makedist('Weibull','a',a50_ol,'b',b50_ol);
pdol_weibull250 = makedist('Weibull','a',a250_ol,'b',b250_ol);
% 

x_values = linspace(0,500,1000);

% % CDF %
cdfcntl_weibull50 = cdf(pdcntl_weibull50,x_values);
cdfcntl_weibull250 = cdf(pdcntl_weibull250,x_values);
% 
cdfol_weibull50 = cdf(pdol_weibull50,x_values);
cdfol_weibull250 = cdf(pdol_weibull250,x_values);
% 
% % Display only the values of RGC response as our data %
% % zebracontrol_sort2 = sortrows(zebracontrol_data,{'RGCResponse'},{'ascend'});
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
% 
% % Plotting the cdf of olfactory response against those of control curves
X = zebraolfact_data.RGCResponse;
cdf_co50 = wblcdf(y2,a50_cntl,b50_cntl);
cdf_co250 = wblcdf(y2,a250_cntl,b250_cntl);
cdf_o50 = wblcdf(y2,a50_ol,b50_ol);
cdf_o250 = wblcdf(y2,a250_ol,b250_ol);
% 


% % % Plot the cdf of each fitted distribution%

figure(1)
line(x_values,cdfcntl_weibull50,'LineStyle','-','Color','blue','LineWidth',2);
hold on;
line(x_values,cdfcntl_weibull250,'LineStyle','-','Color','r','LineWidth',2);
line(x_values,cdfol_weibull50,'LineStyle','--','Color','blue','LineWidth',2);
line(x_values,cdfol_weibull250,'LineStyle','--','Color','red','LineWidth',2);
plot(y2,cdf_co50,'square','Color','blue');
plot(y2,cdf_co250,'o','Color','red');
plot(y2,cdf_o50,'square','Color','blue');
plot(y2,cdf_o250,'o','Color','red');
set(gca,'XTick',y1,'FontSize', 20, 'Fontweight', 'bold');
l = legend('Weibull distribution with top-50 RGC response without olfaction','Weibull distribution with top-250 RGC response without olfaction', 'Weibull distribution with top-50 RGC response with olfactory signals','Weibull distribution with top-250 RGC response with olfactory signals',...
    'CDF of olfactory RGCresponse as against Control Curve (50)','CDF of olfactory RGCresponse as against Control Curve (250)','CDF of olfactory RGCresponse as against Olfactory Curve (50)',...
    'CDF of olfactory RGCresponse as against Olfactory Curve (250)');
%legend('boxoff');
set(l,'Location','Best','FontSize', 17, 'Fontweight', 'bold');
%title('MCMC');
xlabel('RGC response in spikes/s', 'FontSize', 24, 'FontWeight','bold');
ylabel('Probability of occurrence', 'FontSize', 24, 'FontWeight','bold');
hold off;

% 
