function [mdl,AUPR,RMSE,CI,RM2]=GBM_RMSE(X_Train,KD_Bind,X_test,L_KD_test)
% This function run GBM to combine and predict binding affinity values
%--------------------------------------------------------------------------
% [AUPR,RMSE,CI,RM2]=GBM_RMSE(X_KD,X_S,KD_Bind,X_test_KD,X_test_S,L_KD_test)
% Inputs:
% X_KD:       matrix of KNN binding affinity values for tarin data (N_train*25*KNN)
% X_S:        matrix of KNN similarity values for train data (N_train*25*KNN)
% KD_Bind:    Binding affinity of train data
% X_test_KD:  matrix of KNN binding affinity values for test data (N_test*25*KNN)
% X_test_S:   matrix of KNN similarity values for test data (N_test*25*KNN)
% L_KD_test:  Binding affinity of test data
%
% Outputs:
% AUPR,RMSE,CI,RM2
%--------------------------------------------------------------------------
global Bag_rate
global max_iter
global shrink_rate
global feat_rate
global th
global max_leaf
global data_name
%------------------------------------------------------
num_Bind=numel(KD_Bind);
num_f=size(X_Train,2);
num_test=numel(L_KD_test);

avg=mean(KD_Bind);
F_Bind=ones(num_Bind,1).*avg;
F_test=ones(num_test,1)*avg;

num_f_tr=ceil(feat_rate*num_f);
num_tr=ceil(Bag_rate*num_Bind);
it=1;
J(1,1)=0;
l=1;
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
while (it<=max_iter)
    %Gradient J1 RMse
    temp=(KD_Bind-F_Bind);
    J=sqrt(mean(temp.^2));
    Gradient_Bind=temp./J;
    %% Model
    Fix_S=randperm(num_Bind,num_tr);%ind;%
    feat_index=randperm(num_f,num_f_tr);
    mdl=fitrtree(X_Train(Fix_S,feat_index),Gradient_Bind(Fix_S),'MaxNumSplits',max_leaf);
    temp_Bind=predict(mdl,X_Train(:,feat_index));
    [Learning_rate,~]=fminunc(@(Learning_rate)learning_rate(KD_Bind,F_Bind,temp_Bind,Learning_rate),0);%,options);
    L_rate=Learning_rate*shrink_rate;
    F_Bind=F_Bind+L_rate*temp_Bind;

    F_test=F_test+L_rate*predict(mdl,X_test(:,feat_index));
    if mod(it,100)==0
        [AUPR(l),RMSE(l),CI(l),RM2(l)]=Validation(L_KD_test,F_test)
        l=l+1;
    end
    it=it+1;
end

end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function J=learning_rate(Y_Bind,F_Bind,temp_Bind,Learing_rate)
%this function try to find optimum learning rate for gradient boosting

F_Bind=F_Bind+Learing_rate.*temp_Bind;
temp=Y_Bind-F_Bind;
J=sqrt(mean((temp.^2)));
end