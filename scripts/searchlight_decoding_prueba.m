%clear all
load RawData_group
tic
for s = 1%:size(oRawData_group,4)
    count = 0;
    smooth = 0;
    countsmooth = 0;
    for i = 1:1000 %4:2000
        count = count+1;
        
        
            
        %% 1 vs 2
        Class1 = cond1(1:10,:,i);
        Class2 = cond1(11:20,:,i);
        
        %scale across measures
%         Class1 = zscore(Class1,0,2);
%         Class2 = zscore(Class2,0,2);
        
        % 1st fold
        labeltrain = [ones(length(Class1)/2,1); ones(length(Class1)/2,1)*2];
        train_instances = [Class1(1:length(Class1)/2,:); Class2(1:length(Class2)/2,:)];
        SVMmodel = svmtrain(labeltrain, train_instances, '-s 0 -t 0 -q'); % train
        
        labeltest = [ones(length(Class1(length(Class1)/2:end,1)),1); ...
            ones(length(Class1(length(Class1)/2:end,1)),1)*2];
        test_instances = [Class1(length(Class1)/2:end,:); Class2(length(Class2)/2:end,:)];
        [predicted_label, accuracy(:,1), dv] = svmpredict(labeltest,test_instances,SVMmodel,'-q'); % test
        
        % 2nd fold
        SVMmodel = svmtrain(labeltest, test_instances, '-s 0 -t 0 -q'); % train
        
        [predicted_label,accuracy(:,2), dv] = svmpredict(labeltrain,train_instances,SVMmodel, '-q'); % test
        
        % compute accuracy across folds
        mean_acc(s,i,1) = (accuracy(1,1)+accuracy(1,2))/2;
        
        disp(['1vs2 Subject ' num2str(s), ' Timepoint ',num2str(i)])
        end
%         %% 1 vs 3
%         Class1 = RawTime(1:10,:);
%         Class2 = RawTime(21:30,:);
%         
%         % 1st fold
%         labeltrain = [ones(length(Class1)/2,1); ones(length(Class1)/2,1)*2];
%         train_instances = [Class1(1:length(Class1)/2,:); Class2(1:length(Class2)/2,:)];
%         SVMmodel = svmtrain(labeltrain, train_instances, '-s 0 -t 0 -q'); % train
%         
%         labeltest = [ones(length(Class1(length(Class1)/2:end,1)),1); ...
%             ones(length(Class1(length(Class1)/2:end,1)),1)*2];
%         test_instances = [Class1(length(Class1)/2:end,:); Class2(length(Class2)/2:end,:)];
%         [predicted_label, accuracy(:,1), dv] = svmpredict(labeltest,test_instances,SVMmodel,'-q'); % test
%         
%         % 2nd fold
%         SVMmodel = svmtrain(labeltest, test_instances, '-s 0 -t 0 -q'); % train
%         
%         [predicted_label,accuracy(:,2), dv] = svmpredict(labeltrain,train_instances,SVMmodel, '-q'); % test
%         
%         % compute accuracy across folds
%         mean_acc(s,i,2) = (accuracy(1,1)+accuracy(1,2))/2;
%         
%         disp(['1vs3 Subject ' num2str(s), ' Timepoint ',num2str(i)])
%         %% 2 vs 3
%         Class1 = RawTime(21:30,:);
%         Class2 = RawTime(11:20,:);
%         
%         % 1st fold
%         labeltrain = [ones(length(Class1)/2,1); ones(length(Class1)/2,1)*2];
%         train_instances = [Class1(1:length(Class1)/2,:); Class2(1:length(Class2)/2,:)];
%         SVMmodel = svmtrain(labeltrain, train_instances, '-s 0 -t 0 -q'); % train
%         
%         labeltest = [ones(length(Class1(length(Class1)/2:end,1)),1); ...
%             ones(length(Class1(length(Class1)/2:end,1)),1)*2];
%         test_instances = [Class1(length(Class1)/2:end,:); Class2(length(Class2)/2:end,:)];
%         [predicted_label, accuracy(:,1), dv] = svmpredict(labeltest,test_instances,SVMmodel,'-q'); % test
%         
%         % 2nd fold
%         SVMmodel = svmtrain(labeltest, test_instances, '-s 0 -t 0 -q'); % train
%         
%         [predicted_label,accuracy(:,2), dv] = svmpredict(labeltrain,train_instances,SVMmodel, '-q'); % test
%         
%         % compute accuracy across folds
%         mean_acc(s,i,3) = (accuracy(1,1)+accuracy(1,2))/2;
%         
%         disp(['2vs3 Subject ' num2str(s), ' Timepoint ',num2str(i)])
    end

toc

% plot(mean(mean_acc,1))