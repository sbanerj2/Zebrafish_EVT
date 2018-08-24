% Generating 1 hundred thousand samples through MCMC and applying SVM for classification 
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
        
%  % Fitting normal distribution to the control data
[parmhat,parmci] = gpfit(zebracontrol_data.RGCResponse);
k     = parmhat(1); % shape parameter
sigma = parmhat(2); % scale parameter


%  % Fitting normal distribution to the olfactory data
[mu_olfact,s_olfact] = normfit(zebraolfact_data.RGCResponse);


%  % Initialize vectors for storing 100,000 samples(RGC response/per class). Classes are binary: with olfaction or without olfaction
%  % Each random sample has 22 dimensions, i.e.  22 RGC responses in order
%  % to see whether it belongs to "with olfaction"(Label:0) or "without
%  olfaction" (Label:1)

randcontrol_resp = zeros(50000,23);
randolfact_resp = zeros(50000,23);

% Random samples with 22 dimensions
% Control%`
rand_sample = 50000;

for i = 1: rand_sample
    delta = 300;
    %pdf = @(x) normpdf(x,mu_control,s_control);
    pdf = @(X) gppdf(X,k,sigma); % Target distribution
    proppdf = @(x,y) unifpdf(y-x,-delta,delta);
    proprnd = @(x) x + rand*2*delta - delta;   
    nsamples = 22;
    randcontrol_resp(i, 1:nsamples) = abs(mhsample(30,nsamples,'pdf',pdf,'proprnd',proprnd,'symmetric',1));
    randcontrol_resp(i,23) = 0; %Label for classification
end

% Olfactory%
for i = 1: rand_sample
    delta = 300;
    pdf = @(x) normpdf(x,mu_olfact,s_olfact);
    proppdf = @(x,y) unifpdf(y-x,-delta,delta);
    proprnd = @(x) x + rand*2*delta - delta;   
    nsamples = 22;
    randolfact_resp(i, 1:nsamples) = abs(mhsample(1,nsamples,'pdf',pdf,'proprnd',proprnd,'symmetric',1));
    randolfact_resp(i,23) = 1;
end

RGC_response = cat(1, randcontrol_resp, randolfact_resp);
B = RGC_response(randperm(size(RGC_response,1)),: );
csvwrite('million_responses.csv',B)% write this data to csv to be used for MLP(code in python)

% %Dividing the dataset into 80% Training and 20% Testing samples
% %for the SVM
n = size(B);
all_samples = n(1,1);

% %Dividing the dataset into 80% Training and 20% Testing samples
% %for the SVM. The testing group is kept untouched. 

trainIndX = 0.8 * all_samples;
zebra_dataset = B (1 :all_samples, 1 :nsamples);

%Normalizing data
zebra_min = min(zebra_dataset(:));
zebra_max = max(zebra_dataset(:));
norm_zebra = zebra_dataset - zebra_min;
zebra_dataset = norm_zebra./ zebra_max;

group = B (1 :all_samples, 23);

%train_dataset = sparse(zebra_dataset(1 :trainIndX,:));
train_dataset = zebra_dataset(1 :trainIndX,:);
train_group = group(1 :trainIndX);

testIndx = trainIndX + 1;
%test_dataset = sparse(zebra_dataset(testIndx: all_samples , :));
test_dataset = zebra_dataset(testIndx: all_samples , :);
test_group = group (testIndx: all_samples);

% %Fitting SVM on the Training dataset 

                       
%# train an SVM model over training instances
options = statset('maxIter',100000);
svmModel = svmtrain(train_dataset, train_group, ...
                 'Autoscale',true, 'BoxConstraint',2e-1,'Showplot',false,'options',options);

%Testing Accuracy
%cp1 = classperf(test_group);
pred_test = svmclassify(svmModel, test_dataset, 'Showplot',false);
%[test_pred, test_accuracy, dec_values] = predict(test_group,test_dataset, svmModel);
cp1 = classperf(test_group, pred_test);

test_acc = cp1.CorrectRate;
fprintf('SVM testing naccuracy = %f\n', test_acc);
