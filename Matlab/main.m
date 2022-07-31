%This program run Drug-Target identification algorithm
clear all
close all
path= % add your path
addpath(genpath(path))
clc
%--------------------------------------------------------------------------
%------------------------Setting Parameters------------------------
global  cv_setting 
Procdeure{1}='warm';
Procdeure{2}='NewDrug';
Procdeure{3}='NewProt';
Procdeure{4}='New_both';
fprintf('Enter a Selected Procdeure:\n1-Warm  \n2-NewDrug \n3-NewProt \n4-both\n');
index=input('Enter a Selected Number:');
cv_setting=Procdeure{index};
fprintf('=====================================================\n');
global num_fold data_name
num_fold=5;
%----------------------------------------------------------------------------------
%------------- Data and Procedure------------------------------------------
datasets={'BindingDB','Davis','KIBA','Metz'};
fprintf('DataSets:\n 1-BindingDB \n 2-Davis \n 3-Large_KIBA \n 4-KIBA\n 5-Metz\n');
fprintf('=====================================================\n');
data_set_index=input('Enter a Number of Selected Dataset:');
switch data_set_index
    case 1
        load('BIND_data');
        KD_Bind=cell2mat(BIND_data(:,end-1));
        Data_Unlabel=create_Bind_Unlabled(BIND_data,KD_Bind);
        Data_Bind=[BIND_data;Data_Unlabel];
        KD_Bind=[KD_Bind;zeros(size(Data_Unlabel,1),1)];
    case 2
       data_name='Davis';
       Davis_Data=Read_data(data_name);
       KD_Bind=cell2mat(Davis_Data(:,end));
       Data_Bind=Davis_Data;
    case 3
        data_name='KIBA';
       KIBA_Data=Read_data(data_name);
       KD_Bind=cell2mat(KIBA_Data(:,end));
        Data_Bind=KIBA_Data;
    case 4
       data_name='KIBA_DeepDTI';
       KIBA_Data=Read_data(data_name);
       KD_Bind=cell2mat(KIBA_Data(:,end));
       Data_Bind=KIBA_Data;
        
    case 5
        data_name='Metz';
        Data_Bind=Read_data(data_name);
        KD_Bind=cell2mat(Data_Bind(:,end));    
        
     end
KD_Bind=set_paramters(KD_Bind);
[X,ind_d,ind_p]=Create_Features(Data_Bind);
[Avg_AUPR,Avg_CI,Avg_RMSE,Avg_RM2] = nfold_regression(X,ind_d,ind_p,KD_Bind);
