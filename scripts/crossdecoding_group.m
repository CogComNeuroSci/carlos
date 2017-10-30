clear all
clc
load ../data/RawData_group

for s = 1:size(oRawData_group,4)
    %% 1 vs 2
    Class1 = oRawData_group(1:10,1:4,:,s);
    Class2 = oRawData_group(11:20,1:4,:,s);
    
    training_instance_matrix = zeros(20,4,1000);
    
    for ii = 1:1000
        timepoint_instance_matrix = zeros(20,4);
        
        timepoint_instance_matrix(1:10,:) = Class1(1:10,:,ii);
        timepoint_instance_matrix(11:20,:) = Class2(1:10,:,ii);
        
        %timepoint_instance_matrix(any(timepoint_instance_matrix==0,2),:)=[];
        % normalization, zscore across sensors
        % 2 = zscore across sensors/columns - where the mean of each row is ~0 and std is 1
        %     %or use 1 = zscore across images/rows - where the mean of each column is ~0 and std is 1
        %     for i = 1:size(timepoint_instance_matrix,2)
        %         timepoint_instance_matrix = zscore(timepoint_instance_matrix,0,2);
        %     end
        training_instance_matrix(:,:,ii) = timepoint_instance_matrix;
        
        
        
    end
    clear ii i timepoint_instance_matrix
    
    %% decoding
    
    for ii = 1:1000
        
        training_label_vector([1:size(training_instance_matrix(:,:,ii),1)/2],1) = 1;
        training_label_vector([(size(training_instance_matrix(:,:,ii),1)/2)+1:size(training_instance_matrix(:,:,ii),1)],1)= -1;
        m1 = find(training_label_vector ==  1);
        m2 = find(training_label_vector == -1);
        %     libsvm_options_train = ['-t 0 -c 1 -q']; % chooses linear kernal, sets cost = 1, and quietmode
        %     libsvm_options_test = ['-q']; % quietmode
        %     scale_data = 0; % scales data between -1 and 1, scales by trials/samples (default)
        
        %sorts and chooses training and test sets
        trainset = [m1(1:2:size(m1,1)) ; m2(1:2:size(m2,1))]; %odd
        testset =  [m1(2:2:size(m1,1)) ; m2(2:2:size(m2,1))]; %even
        %         trainset = [1:2:size(training_instance_matrix(:,:,ii),1)]'; %odd
        %         testset =  [2:2:size(training_instance_matrix(:,:,ii),1)]'; %even
        
        %%FOLD 1
        model = svmtrain(training_label_vector(trainset), training_instance_matrix(trainset,:,ii), '-t 0 -c 1 -q');
        for iii = 1:1000
            [predicted_label1, accuracy1, decision_values1] = svmpredict(training_label_vector(testset), training_instance_matrix(testset,:,iii), model, '-q');
            acc1(iii) = accuracy1(1);
            %%calculate for balanced accuracy for fold 1
            %output1(iii) = balancedacc(training_label_vector(testset),predicted_label1);
            output1(iii) = acc1(iii);
        end
        
        %%FOLD 2
        model=[];
        model = svmtrain(training_label_vector(testset), training_instance_matrix(testset,:,ii), '-t 0 -c 1 -q');
        for iii = 1:1000
            [predicted_label2, accuracy2, decision_values2] = svmpredict(training_label_vector(trainset), training_instance_matrix(trainset,:,iii), model, '-q');
            acc2(iii) = accuracy2(1);
            %%calculate for balanced accuracy for fold 2
            %output2(iii) = balancedacc(training_label_vector(trainset), predicted_label2);
            output2(iii) = acc2(iii);
        end
        
        %%averaged accuracy across 2 folds
        mean_acc(ii,:,s,1) = (acc1 + acc2) / 2;

        disp(['1vs2 Subject ' num2str(s), ' Timepoint ',num2str(ii)])
    end
    %% 1 vs 3
    Class1 = oRawData_group(1:10,1:4,:,s);
    Class2 = oRawData_group(21:30,1:4,:,s);
    
    training_instance_matrix = zeros(20,4,1000);
    
    for ii = 1:1000
        timepoint_instance_matrix = zeros(20,4);
        
        timepoint_instance_matrix(1:10,:) = Class1(1:10,:,ii);
        timepoint_instance_matrix(11:20,:) = Class2(1:10,:,ii);
        
        %timepoint_instance_matrix(any(timepoint_instance_matrix==0,2),:)=[];
        % normalization, zscore across sensors
        % 2 = zscore across sensors/columns - where the mean of each row is ~0 and std is 1
        %     %or use 1 = zscore across images/rows - where the mean of each column is ~0 and std is 1
        %     for i = 1:size(timepoint_instance_matrix,2)
        %         timepoint_instance_matrix = zscore(timepoint_instance_matrix,0,2);
        %     end
        training_instance_matrix(:,:,ii) = timepoint_instance_matrix;
        
        
        
    end
    clear ii i timepoint_instance_matrix
    
    %% decoding
    
    for ii = 1:1000
        
        training_label_vector([1:size(training_instance_matrix(:,:,ii),1)/2],1) = 1;
        training_label_vector([(size(training_instance_matrix(:,:,ii),1)/2)+1:size(training_instance_matrix(:,:,ii),1)],1)= -1;
        m1 = find(training_label_vector ==  1);
        m2 = find(training_label_vector == -1);
        %     libsvm_options_train = ['-t 0 -c 1 -q']; % chooses linear kernal, sets cost = 1, and quietmode
        %     libsvm_options_test = ['-q']; % quietmode
        %     scale_data = 0; % scales data between -1 and 1, scales by trials/samples (default)
        
        %sorts and chooses training and test sets
        trainset = [m1(1:2:size(m1,1)) ; m2(1:2:size(m2,1))]; %odd
        testset =  [m1(2:2:size(m1,1)) ; m2(2:2:size(m2,1))]; %even
        %         trainset = [1:2:size(training_instance_matrix(:,:,ii),1)]'; %odd
        %         testset =  [2:2:size(training_instance_matrix(:,:,ii),1)]'; %even
        
        %%FOLD 1
        model = svmtrain(training_label_vector(trainset), training_instance_matrix(trainset,:,ii), '-t 0 -c 1 -q');
        for iii = 1:1000
            [predicted_label1, accuracy1, decision_values1] = svmpredict(training_label_vector(testset), training_instance_matrix(testset,:,iii), model, '-q');
            acc1(iii) = accuracy1(1);
            %%calculate for balanced accuracy for fold 1
            %output1(iii) = balancedacc(training_label_vector(testset),predicted_label1);
            output1(iii) = acc1(iii);
        end
        
        %%FOLD 2
        model=[];
        model = svmtrain(training_label_vector(testset), training_instance_matrix(testset,:,ii), '-t 0 -c 1 -q');
        for iii = 1:1000
            [predicted_label2, accuracy2, decision_values2] = svmpredict(training_label_vector(trainset), training_instance_matrix(trainset,:,iii), model, '-q');
            acc2(iii) = accuracy2(1);
            %%calculate for balanced accuracy for fold 2
            %output2(iii) = balancedacc(training_label_vector(trainset), predicted_label2);
            output2(iii) = acc2(iii);
        end
        
        %%averaged accuracy across 2 folds
        mean_acc(ii,:,s,2) = (acc1 + acc2) / 2;

        disp(['1vs3 Subject ' num2str(s), ' Timepoint ',num2str(ii)])
    end
    %% 3 vs 2
    Class1 = oRawData_group(21:30,1:4,:,s);
    Class2 = oRawData_group(11:20,1:4,:,s);
    
    training_instance_matrix = zeros(20,4,1000);
    
    for ii = 1:1000
        timepoint_instance_matrix = zeros(20,4);
        
        timepoint_instance_matrix(1:10,:) = Class1(1:10,:,ii);
        timepoint_instance_matrix(11:20,:) = Class2(1:10,:,ii);
        
        %timepoint_instance_matrix(any(timepoint_instance_matrix==0,2),:)=[];
        % normalization, zscore across sensors
        % 2 = zscore across sensors/columns - where the mean of each row is ~0 and std is 1
        %     %or use 1 = zscore across images/rows - where the mean of each column is ~0 and std is 1
        %     for i = 1:size(timepoint_instance_matrix,2)
        %         timepoint_instance_matrix = zscore(timepoint_instance_matrix,0,2);
        %     end
        training_instance_matrix(:,:,ii) = timepoint_instance_matrix;
        
        
        
    end
    clear ii i timepoint_instance_matrix
    
    %% decoding
    
    for ii = 1:1000
        
        training_label_vector([1:size(training_instance_matrix(:,:,ii),1)/2],1) = 1;
        training_label_vector([(size(training_instance_matrix(:,:,ii),1)/2)+1:size(training_instance_matrix(:,:,ii),1)],1)= -1;
        m1 = find(training_label_vector ==  1);
        m2 = find(training_label_vector == -1);
        %     libsvm_options_train = ['-t 0 -c 1 -q']; % chooses linear kernal, sets cost = 1, and quietmode
        %     libsvm_options_test = ['-q']; % quietmode
        %     scale_data = 0; % scales data between -1 and 1, scales by trials/samples (default)
        
        %sorts and chooses training and test sets
        trainset = [m1(1:2:size(m1,1)) ; m2(1:2:size(m2,1))]; %odd
        testset =  [m1(2:2:size(m1,1)) ; m2(2:2:size(m2,1))]; %even
        %         trainset = [1:2:size(training_instance_matrix(:,:,ii),1)]'; %odd
        %         testset =  [2:2:size(training_instance_matrix(:,:,ii),1)]'; %even
        
        %%FOLD 1
        model = svmtrain(training_label_vector(trainset), training_instance_matrix(trainset,:,ii), '-t 0 -c 1 -q');
        for iii = 1:1000
            [predicted_label1, accuracy1, decision_values1] = svmpredict(training_label_vector(testset), training_instance_matrix(testset,:,iii), model, '-q');
            acc1(iii) = accuracy1(1);
            %%calculate for balanced accuracy for fold 1
            %output1(iii) = balancedacc(training_label_vector(testset),predicted_label1);
            output1(iii) = acc1(iii);
        end
        
        %%FOLD 2
        model=[];
        model = svmtrain(training_label_vector(testset), training_instance_matrix(testset,:,ii), '-t 0 -c 1 -q');
        for iii = 1:1000
            [predicted_label2, accuracy2, decision_values2] = svmpredict(training_label_vector(trainset), training_instance_matrix(trainset,:,iii), model, '-q');
            acc2(iii) = accuracy2(1);
            %%calculate for balanced accuracy for fold 2
            %output2(iii) = balancedacc(training_label_vector(trainset), predicted_label2);
            output2(iii) = acc2(iii);
        end
        
        %%averaged accuracy across 2 folds
        mean_acc(ii,:,s,3) = (acc1 + acc2) / 2;

        disp(['3vs2 Subject ' num2str(s), ' Timepoint ',num2str(ii)])
    end
end