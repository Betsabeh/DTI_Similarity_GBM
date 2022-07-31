# -*- coding: utf-8 -*-
"""

@author: betsa
"""

import sys
import argparse
import set_parameters
import os    
import numpy as np
import DTI

if __name__=='__main__':
    flag=set_parameters.arg_pars()
    param=set_parameters.set_param(flag.Dataset,flag.Mode) 
    # 1- create path
    path=flag.Data_path#
    Dataset_path=path+flag.Dataset+"/"+flag.Dataset+'.csv'
    print(path)
    Drug_sim_path=path+flag.Dataset+'/'+flag.Dataset+'_Drug_Fingerprint_sim.csv'
    Prot_sim_path=path+flag.Dataset+'/'+flag.Dataset+'_Prot_SW_sim.csv'
           
    # 2-read dataset and similarities
    Prot_name,Drug_id,KD_val=DTI.read_data(Dataset_path) 
    All_D_id,Drug_S=DTI.read_simarity(Drug_sim_path)
    All_P_id,Prot_S=DTI.read_simarity(Prot_sim_path)
    
    # 3-create dataset   
    index_d,index_p,Y =DTI.create_dataset(Prot_name, Drug_id, KD_val,All_D_id,All_P_id)
    
    # -4 fold_CV
    avg_MSE,avg_RMSE,avg_Rm2,avg_CI,avg_Aupr=DTI.CV_evaluation(index_d,index_p,Y,param[6],Drug_S,Prot_S,param,flag.Mode)