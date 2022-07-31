function [Data_Test,KD_Test,Data_Train,KD_Train]=fold_Test_Train(X,ind_d,ind_p,KD_Bind,curr_fold,seed)
% this function determine the test and train
global num_fold cv_setting
switch cv_setting
       case 'warm'
        num=numel(KD_Bind);
        rng('default')
        rng(seed);
        rand_ind = randperm(num);
        test_ind = rand_ind((floor((curr_fold-1)*num/num_fold)+1:floor(curr_fold*num/num_fold))');
        k=1;
        l=1;
        for i=1:numel(ind_d)
            if isempty(find(test_ind==i))==0
                index_test(k)=i;
                k=k+1;
            else
                index_train(l)=i;
                l=l+1;
            end
        end
        Data_Train=X(index_train,:);
        KD_Train=KD_Bind(index_train,:);
        
        Data_Test=X(index_test,:);
        KD_Test=KD_Bind(index_test,:);
       % KD_Test=-log10(KD_Test);
        
    case 'NewDrug'
        global Drugs
        num_drug=numel(Drugs);
        rng('default')
        rng(seed);
        rand_ind = randperm(num_drug);
        test_ind = rand_ind((floor((curr_fold-1)*num_drug/num_fold)+1:floor(curr_fold*num_drug/num_fold))');
        k=1;
        l=1;
        for i=1:numel(ind_d)
            if isempty(find(test_ind==ind_d(i)))==0
                index_test(k)=i;
                k=k+1;
            else
                index_train(l)=i;
                l=l+1;
            end
        end
        Data_Train=X(index_train,:);
        KD_Train=KD_Bind(index_train,:);
        
        Data_Test=X(index_test,:);
        KD_Test=KD_Bind(index_test,:);
        
    case 'NewProt'
       
        global Prots
        num_prot=numel(Prots);
        rng('default')
        rng(seed);
        rand_ind = randperm(num_prot);
        test_ind = rand_ind((floor((curr_fold-1)*num_prot/num_fold)+1:floor(curr_fold*num_prot/num_fold))');
        k=1;
        l=1;
        for i=1:numel(ind_p)
            if isempty(find(test_ind==ind_p(i)))==0
                index_test(k)=i;
                k=k+1;
            else
                index_train(l)=i;
                l=l+1;
            end
        end
        Data_Train=X(index_train,:);
        KD_Train=KD_Bind(index_train,:);
        
        Data_Test=X(index_test,:);
        KD_Test=KD_Bind(index_test,:);
   
    case 'New_both'
        global Drugs Prots
        num_fold=5;
        num_drug=numel(Drugs);
        num_prot=numel(Prots);
        rng('default')
        rng(seed);
        rand_ind = randperm(num_drug);
        Drug_test_ind = rand_ind((floor((curr_fold-1)*num_drug/num_fold)+1:floor(curr_fold*num_drug/num_fold))');
        
        rand_ind = randperm(num_prot);
        Prot_test_ind = rand_ind((floor((curr_fold-1)*num_prot/num_fold)+1:floor(curr_fold*num_prot/num_fold))');
        
        k=1;
        l=1;
        for i=1:numel(ind_d)
            if (isempty(find(Prot_test_ind==ind_p(i)))==0) || (isempty(find(Drug_test_ind==ind_d(i)))==0 )
                index_test(k)=i;
                k=k+1;
            else
                index_train(l)=i;
                l=l+1;
            end
        end
        Data_Train=X(index_train,:);
        KD_Train=KD_Bind(index_train,:);
        
        Data_Test=X(index_test,:);
        KD_Test=KD_Bind(index_test,:);
        
end
end
