function [Avg_AUPR,Avg_CI,Avg_RMSE,Avg_RM2]=CV(X,ind_d,ind_p,KD_Bind,seed)
%% This function run 5 cv 
global num_fold th data_name cv_setting
% % load('AUPR')
% % load('MSE')
% % load('RMSE')
% % load('CI')
% % load('RM2')
for i=1:num_fold
    if strcmp(data_name ,'KIBA')==1
        Y=2*(KD_Bind<=th)-1;
    else
        Y=2*(KD_Bind>=th)-1;
    end
    [Data_Test,KD_Test,Data_Train,KD_Train]=fold_Test_Train(X,ind_d,ind_p,KD_Bind,i, seed); 
    [mdl,AUPR(i,:),RMSE(i,:),CI(i,:),RM2(i,:)]=GBM_RMSE(Data_Train,KD_Train,Data_Test,KD_Test);
    
    fprintf('----------------------end fold=%d--------------------\n',i);
    % % %    save('AUPR','AUPR')
    % % %    save('MSE','MSE')
    % % %    save('RMSE','RMSE')
    % % %    save('CI','CI')
    % % %    save('RM2','RM2')
end  
%--------------------------------------------------------------------------
global fid shrink_rate
global Bag_rate feat_rate max_iter 
f_name=strcat('Result_RMSE_',data_name);
f_name=strcat(f_name,'.txt');
fid=fopen(f_name,'a+');
fprintf(fid,'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n');
fprintf(fid,'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%s~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n',date());
fprintf(fid,'============================PROCEDURE SETTING=%s=========================\n',cv_setting);
fprintf(fid,'Seed=%f\n',seed);
fprintf(fid,'subsampling without replacement with bag rate=%f for all\n',Bag_rate);
fprintf(fid,'feature sub sampling rate=%f with mod\n',feat_rate);
fprintf(fid,'learning rate* %f\n', shrink_rate);
fprintf(fid,'Max iteration=%d\n',max_iter);

iteration=100:100:max_iter;
for j=1:numel(iteration)
    fprintf('---------------RESULTS WITH  %d Iterations\n',iteration(j));
    fprintf(fid,'---------------RESULTS WITH  %d Iterations\n',iteration(j));
    for i=1:num_fold
        fprintf('fold=%d AUPR=%f  CI=%f    RMSE=%f RM2=%f\n',i,AUPR(i,j),CI(i,j),RMSE(i,j),RM2(i,j));
        fprintf(fid,'-------------fold=%d :\n',i);
        fprintf(fid,'fold=%d AUPR=%f  CI=%f   RMSE=%f RM2=%f\n',i,AUPR(i,j),CI(i,j),RMSE(i,j),RM2(i,j));
    end
    Avg_AUPR(j)=mean(AUPR(:,j));
    Avg_CI(j)=mean(CI(:,j));
    Avg_RMSE(j)=mean(RMSE(:,j));
    Avg_RM2(j)=mean(RM2(:,j));
    fprintf('---------------------------------------------------------------------\n');
    fprintf('\n');
    fprintf('   AVG    AUPR=%f  \n',   Avg_AUPR(j));
    fprintf('   AVG    CI=%f  \n',  Avg_CI(j));
    fprintf('   AVG    RMSE=%f  \n',  Avg_RMSE(j));
    fprintf('   AVG    RM2=%f  \n',  Avg_RM2(j));
    fprintf('===========================================================================\n');
    % print  the result in text file
    fprintf(fid,'-------------------------------------------------------------------\n');
    fprintf(fid,'-------------------------------------------------------------------\n');
    fprintf(fid,'   AVG    AUPR=%f  \n',   Avg_AUPR(j));
    fprintf(fid,'   AVG    CI=%f  \n',  Avg_CI(j));
    fprintf(fid,'   AVG    RMSE=%f  \n',  Avg_RMSE(j));
    fprintf(fid,'   AVG    RM2=%f  \n',  Avg_RM2(j));
    fprintf(fid,'\n=====================================================================\n');
    
end
Avg_AUPR=Avg_AUPR(end);
Avg_CI=Avg_CI(end);
Avg_RMSE=Avg_RMSE(end);
Avg_RM2=Avg_RM2(end);
end