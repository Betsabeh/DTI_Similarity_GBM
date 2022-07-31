function [Avg_AUPR,Avg_CI,Avg_RMSE,Avg_RM2]=nfold_regression(X,ind_d,ind_p,KD_Bind)
%This function run 5-fold cross-validation 
% Cross-validation applied on different procedures(Warm,NewDrug,NewTarget)
% INPUT:
%  X:Similarity based feature vector,
%  KD_Bind:Source data Kd values
%  ind_d:drug index
%  ind_p:prot index
% OUTPUT:
%  Avg_APR:     average of 5 fold AUPR result
%  Avg_CI:         average of 5 fold-CI result
%  Avg_MSE:     average of 5 fold-MSE result
%  Avg_RMSE    average of 5 fold-RMSE result
%--------------------------------------------------------------------------
%% Setting
global fid  num_fold
num_run=5;
seeds=[8184    747    1074        5665        3755];
%--------------------------------------------------------------------------
for i=1:num_run
    [Avg_AUPR(i),Avg_CI(i),Avg_RMSE(i),Avg_RM2(i)]=CV(X,ind_d,ind_p,KD_Bind,seeds(i));
    fprintf(fid,'\n-----------------------end of run=%d-----------------\n',i);
end
Avg_AUPR=mean(Avg_AUPR);
Avg_CI=mean(Avg_CI);
Avg_RMSE=mean(Avg_RMSE);
Avg_RM2=mean(Avg_RM2);
end
