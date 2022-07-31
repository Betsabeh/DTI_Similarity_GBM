function [AUPR,RMSE,CI,rm2]=Validation(KD,Pred_KD)
global th data_name
if strcmp(data_name ,'Large_KIBA')==1
    Y_True=(KD<=th);
    AUPR= calculate_aupr(1./Pred_KD,Y_True)
else
    Y_True=(KD>=th);
    AUPR= calculate_aupr(Pred_KD,Y_True)
end
MSE=(1/numel(KD))*sum((KD-Pred_KD).^2)
RMSE=sqrt(MSE)
%--------------------CI
Z=0;
s=0;
for i=1:numel(KD)
    index=find(KD(i)>KD);
    Z=Z+numel(index);
    t=Pred_KD(i)-Pred_KD(index);
    s=s+1*sum(t>0);
    s=s+0.5*sum(t==0);
end
CI=s/Z
rm2=calculte_rm2(KD,Pred_KD)
end