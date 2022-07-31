# -*- coding: utf-8 -*-
"""

@author: betsa
"""

import numpy as np
import pandas as pd
import os
import argparse



def set_param(dataset,option):
    if ((dataset=='Davis') and (option=='Warm')):
        lrate=0.05
        max_depth=8
        max_iter=1300
        bag_rate=0.9
        feat_rate=0.2
        num_fold=5
        threshold=-np.log10(100/(10**9))
    if  ((dataset=='Davis') and (option=='Cold-Drug')):
        lrate=0.005
        max_depth=8
        max_iter=1500
        bag_rate=0.5
        feat_rate=0.3
        num_fold=5
        threshold=-np.log10(100/(10**9)) 
    if  ((dataset=='Davis') and (option=='Cold-Prot')):
         lrate=0.05
         max_depth=8
         max_iter=1500
         bag_rate=0.5
         feat_rate=0.3
         num_fold=5
         threshold=-np.log10(100/(10**9))  
    if  ((dataset=='Davis') and (option=='Both')):
         lrate=0.005
         max_depth=8
         max_iter=1500
         bag_rate=0.3
         feat_rate=0.1
         num_fold=5
         threshold=-np.log10(100/(10**9))  
              
        
        
    print('---------------------Parameters------------------------')
    print('Lrate max_depth  max_iter  bag_rate  feat_rate threshold  num_fold')    
    params=[lrate,max_depth,max_iter,bag_rate,feat_rate,threshold,num_fold] 
    print(params)
    
    return params  

def arg_pars():
    parser=argparse.ArgumentParser()
    parser.add_argument('Dataset', 
                        type=str, default='Davis', help='Dataset name')
    
    parser.add_argument('Mode', 
                        type=str, default='Warm', help='Mode setting')
    parser.add_argument('Data_path', type=str, help='Dataset and similarity path')
    FLAGS, unparsed = parser.parse_known_args()
    return FLAGS
        