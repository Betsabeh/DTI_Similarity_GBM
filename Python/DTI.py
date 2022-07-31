# -*- coding: utf-8 -*-
"""

@author: betsa
"""

import numpy as np
import pandas as pd
import set_parameters 
import tensorflow as tf
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.metrics import mean_squared_error
import csv
import metrics
import matplotlib.pyplot as plt
#-------------------------------------------
def read_data(file_name):
    f=open(file_name)
    data=csv.reader(f)
    Drug_id=next(data)
    Drug_id=Drug_id[4:]
    next(data)
    next(data)
 #   print(Drug_id)
    Prot_name=[]
    KD_val=[]
    for r in data:
        Prot_name.append(r[2])
        temp=r[4:]
        temp1=[]
        for t in temp:
            if t=='':
               temp1.append(10000) 
            else:
               temp1.append(float(t))
               
        KD_val.append(temp1)
       
        
    return Prot_name, Drug_id, KD_val
#----------------------------------------------------------
def create_dataset(Prot_name, Drug_id, KD_val,All_D_id,All_P_id):
    num_drug=len(All_D_id)
    num_prot=len(All_P_id)
    index_d=[]
    index_p=[]
    Y_matrix=np.zeros(shape=(num_drug,num_prot))
    Y=[]
    KD_val=np.array(KD_val)
    t=KD_val/(10**9)
    KD_val=-1*np.log10(t)
    for i in range(num_drug):
        temp=[]
        #s1=np.array(Drug_S[index_d])
        for j in range(num_prot):
            ind1=All_D_id.index(Drug_id[i])
            index_d.append(ind1)
            ind2=All_P_id.index(Prot_name[j])
            index_p.append(ind2)
            #s2=np.array(Prot_S[index_p])
            #feature=np.concatenate((s1,s2))
            # a=interaction(index_d, index_p,feature)
            #X.append(feature)
            temp.append(KD_val[j][i])
            Y.append(KD_val[j][i])
           # Y_matrix[ind1][ind2]=KD_val[j][i]
        '''if (len(Y)>5000):
                break'''
    return index_d,index_p,Y 
#-------------------------------------------
def read_simarity(file_name):
    f=open(file_name)
    Data=csv.reader(f)
    ID=next(Data)
    N=len(ID)
    i=0
    S=tf.zeros(shape=(N,N),dtype=tf.float64)
    for temp in Data:
        # j=0
        #for t2 in temp:
        v=np.float64(temp)
        S=tf.tensor_scatter_nd_update(S, [[i,]], [v])
        #  j=j+1
        i=i+1    
                        
    return ID, S
                
#-------------------------------------------------
def create_Features(ind_d_Tr,ind_p_Tr,ind_d_Te,ind_p_Te,Drug_S,Prot_S):
 N_Tr=len(ind_d_Tr)
 N_Te=len(ind_d_Te)

 S1=np.array(Drug_S)
 S2=np.array(Prot_S)
 X_Train=[]
 X_Test=[]
 for i in range(0,N_Tr):
     ind1=ind_d_Tr[i]
     ind2=ind_p_Tr[i]
     t1=S1[ind1]
     t2=S2[ind2]
     temp_X=np.concatenate([t1,t2])
     X_Train.append(temp_X)  
     #---------   
 for i in range(0,N_Te):
    ind1=ind_d_Te[i]
    ind2=ind_p_Te[i]
    t1=S1[ind1]
    t2=S2[ind2]
    temp_X=np.concatenate([t1,t2])
    X_Test.append(temp_X)
    
     
    
       
 return X_Train,X_Test
#-------------------------------------------
def cross_validation_Train_Test1(index_d,index_p,Y,num_fold,curr_fold,mode):
    if mode=='Warm':
        N=len(index_d)
        fold_size=np.floor(N/num_fold)
        np.random.seed(845)
        index=np.random.permutation(N)
        index=np.array(index)
        
        low=np.int64((curr_fold-1)*fold_size)
        high=np.int64(curr_fold*fold_size)
        Test_ind=index[low:high]
        Train_ind=np.setdiff1d(range(0,N) ,Test_ind)
        Test_ind=np.array(Test_ind)
        Train_ind=np.array(Train_ind)
        index_d=np.array(index_d)
        index_p=np.array(index_p)
        ind_d_Tr=index_d[Train_ind]
        ind_p_Tr=index_p[Train_ind]
        ind_d_Te=index_d[Test_ind]
        ind_p_Te=index_p[Test_ind]
        Y=np.array(Y)
        Y_Train=Y[Train_ind]
        Y_Test=Y[Test_ind]
   #-----------------------------------------------  
    if mode=='Cold-Drug':
        All_drug=np.unique(index_d)
        N=len(All_drug)
        fold_size=np.floor(N/num_fold)
        np.random.seed(845)
        index=np.random.permutation(N)
        index=np.array(index)
        
        low=np.int64((curr_fold-1)*fold_size)
        high=np.int64(curr_fold*fold_size)
        Test_ind=index[low:high]
        Train_ind=np.setdiff1d(range(0,N) ,Test_ind)
        index_d=np.array(index_d)
        index_p=np.array(index_p)
        Y=np.array(Y)
        ind_d_Tr=[]
        ind_p_Tr=[]
        Y_Train=[]
        ind_d_Te=[]
        ind_p_Te=[]
        Y_Test=[]
        for i in range(len(index_d)):
            if index_d[i] in Test_ind:
                ind_d_Te.append(index_d[i])
                ind_p_Te.append(index_p[i])
                Y_Test.append(Y[i])
            else: 
                ind_d_Tr.append(index_d[i])
                ind_p_Tr.append(index_p[i])
                Y_Train.append(Y[i])
       
        ind_d_Te=np.array(ind_d_Te)  
        ind_p_Te=np.array(ind_p_Te) 
        Y_Test=np.array(Y_Test) 
        ind_d_Tr=np.array(ind_d_Tr) 
        ind_p_Tr=np.array(ind_p_Tr) 
        Y_Train=np.array(Y_Train) 
    #---------------------------------------------    
    if mode=='Cold-Prot':
        All_prot=np.unique(index_p)
        N=len(All_prot)
        fold_size=np.floor(N/num_fold)
        np.random.seed(845)
        index=np.random.permutation(N)
        index=np.array(index)
         
        low=np.int64((curr_fold-1)*fold_size)
        high=np.int64(curr_fold*fold_size)
        Test_ind=index[low:high]
        Train_ind=np.setdiff1d(range(0,N) ,Test_ind)
        index_d=np.array(index_d)
        index_p=np.array(index_p)
        Y=np.array(Y)
        ind_d_Tr=[]
        ind_p_Tr=[]
        Y_Train=[]
        ind_d_Te=[]
        ind_p_Te=[]
        Y_Test=[]
        for i in range(len(index_p)):
            if index_p[i] in Test_ind:
                 ind_d_Te.append(index_d[i])
                 ind_p_Te.append(index_p[i])
                 Y_Test.append(Y[i])
            else: 
                 ind_d_Tr.append(index_d[i])
                 ind_p_Tr.append(index_p[i])
                 Y_Train.append(Y[i])
        
        ind_d_Te=np.array(ind_d_Te)  
        ind_p_Te=np.array(ind_p_Te) 
        Y_Test=np.array(Y_Test) 
        ind_d_Tr=np.array(ind_d_Tr) 
        ind_p_Tr=np.array(ind_p_Tr) 
        Y_Train=np.array(Y_Train)    
           
    #---------------------------------------------
    if mode=='Both':
        All_prot=np.unique(index_p)
        N_p=len(All_prot)
        All_drug=np.unique(index_d)
        N_d=len(All_drug)
        
        np.random.seed(845)
        fold_size_d=np.floor(N_d/num_fold)
        fold_size_p=np.floor(N_p/num_fold)
        
        index1=np.random.permutation(N_d)
        index1=np.array(index1)
        index2=np.random.permutation(N_p)
        index2=np.array(index2) 
        
        low=np.int64((curr_fold-1)*fold_size_d)
        high=np.int64(curr_fold*fold_size_d)
        Test_ind_d=index1[low:high]
        
        low=np.int64((curr_fold-1)*fold_size_p)
        high=np.int64(curr_fold*fold_size_p)
        Test_ind_p=index2[low:high]
        
        index_d=np.array(index_d)
        index_p=np.array(index_p)
        Y=np.array(Y)
        ind_d_Tr=[]
        ind_p_Tr=[]
        Y_Train=[]
        ind_d_Te=[]
        ind_p_Te=[]
        Y_Test=[]
        for i in range(len(index_p)):
            if ((index_p[i] in Test_ind_p) or (index_d[i] in Test_ind_d)):
                 ind_d_Te.append(index_d[i])
                 ind_p_Te.append(index_p[i])
                 Y_Test.append(Y[i])
            else: 
                 ind_d_Tr.append(index_d[i])
                 ind_p_Tr.append(index_p[i])
                 Y_Train.append(Y[i])
        
        ind_d_Te=np.array(ind_d_Te)  
        ind_p_Te=np.array(ind_p_Te) 
        Y_Test=np.array(Y_Test) 
        ind_d_Tr=np.array(ind_d_Tr) 
        ind_p_Tr=np.array(ind_p_Tr) 
        Y_Train=np.array(Y_Train)    
    
        
    
    return ind_d_Tr,ind_p_Tr,ind_d_Te,ind_p_Te,Y_Train,Y_Test  
#--------------------------------------------------------
def CV_evaluation(index_d,index_p,Y,num_fold,Drug_S,Prot_S,param,option):
    # parameters
    folds=range(1,num_fold+1)
    Lrate=param[0]
    max_depth=param[1]
    max_iter=param[2]
    bag_rate=param[3]
    feat_rate=param[4]
    RMSE_folds=[]
    MSE_folds=[]
    Rm2=[]
    CI=[]
    AUPR=[]
    for i in folds:
        ind_d_Tr,ind_p_Tr,ind_d_Te,ind_p_Te,Y_Train,Y_Test=cross_validation_Train_Test1(index_d,
                                                                                        index_p,Y,num_fold,i,option)
        X_Train,X_Test=create_Features(ind_d_Tr,ind_p_Tr,
                                             ind_d_Te,ind_p_Te,
                                             Drug_S,Prot_S)
        n_samples=np.int64(bag_rate*len(ind_d_Tr))
        n_features=np.int64(feat_rate*np.size(X_Train,1))
        mdl=GradientBoostingRegressor(subsample=bag_rate,
                                      max_features=feat_rate,
                                      loss="squared_error",
                                      learning_rate=Lrate,
                                      max_depth=max_depth,
                                      n_estimators=max_iter,verbose=1)
        mdl.fit(X_Train,Y_Train)
        Y_hat1=mdl.predict(X_Test)
        mse,RMSE = metrics.cal_RMSE(Y_Test,Y_hat1 )
        MSE_folds.append(mse)
        print(mse)
        RMSE_folds.append(RMSE)
        Rm2.append(metrics.cal_rm2(Y_Test,Y_hat1))
        CI.append(metrics.cal_cindex(Y_Test,Y_hat1))
        AUPR.append(metrics.cal_Aupr(Y_Test>=param[5],Y_hat1))
        
        test_score = np.zeros((max_iter,), dtype=np.float64)
        for i, y_pred in enumerate(mdl.staged_predict(X_Test)):
            test_score[i] = mdl.loss_(Y_Test, y_pred)
        #print('-----------------MT Train Error------------------------') 
        Y_hat2=mdl.predict(X_Train)
        mse_tr,RMSE_tr = metrics.cal_RMSE(Y_Train,Y_hat2 )
        #print('MSE:',mse_tr)
        #print('RMSE:',RMSE_tr)

        Y_Test=np.array(Y_Test)
        Y_Test=np.reshape(Y_Test,np.shape(Y_hat1))
        

        
        '''fig=plt.figure(figsize=(12,6))
        plt.subplot(1,2,1)
        plt.plot(mdl.train_score_,'b')
        plt.plot(test_score,'r')
        plt.xlabel('iteration',size=10)
        plt.ylabel('loss',size=10)
        plt.legend(loc="upper right")
       
        
        
        
        plt.subplot(1,2,2)
        plt.plot(Y_hat1,Y_Test,'o')
        plt.plot(range(4,11),range(4,11),'r:o')
        plt.xlabel('Predicted label',size=10)
        plt.ylabel('True label',size=10)
        plt.show()'''
      
    
    Rm2=np.array(Rm2)
    avg_Rm2=np.mean(Rm2)
    CI=np.array(CI)
    avg_CI=np.mean(CI)
    AUPR=np.array(AUPR)
    avg_Aupr=np.mean(AUPR)
    MSE_folds=np.array(MSE_folds)    
    avg_MSE=np.mean(MSE_folds)
    RMSE_folds=np.array(RMSE_folds)    
    avg_RMSE=np.mean(RMSE_folds)
    print('=================================================')
    print('-------------Test Result-------------------------')
    for i in range(num_fold):
        print("\n fold_"+str(i)+'\n  MSE=',np.round(MSE_folds[i],3),'RMSE=',
              np.round(RMSE_folds[i],3))
        print("Rm2=",np.round(Rm2[i],3),"CI=",np.round(CI[i],3),
              "AUPR=",np.round(AUPR[i],3))
    
    
    print('---------------- fold Results--------------------')
    print('AVG+std  MSE 5 folds:',np.round(avg_MSE,3),'+',
          np.round(np.std(MSE_folds),3))
    print('AVG+std   RMSE 5 folds:',np.round(avg_RMSE,3),'+',
          np.round(np.std(RMSE_folds),3))   
    print('AVG+std   CI 5 folds:',np.round(avg_CI,3),'+',
          np.round(np.std(CI),3))
    print('AVG+std   Rm2 5 folds:',np.round(avg_Rm2,3),'+',
          np.round(np.std(Rm2),3))
    print('AVG+std   Aupr 5 folds:',np.round(avg_Aupr,3),'+',
          np.round(np.std(AUPR),3))
    
    return avg_MSE,avg_RMSE,avg_Rm2,avg_CI,avg_Aupr
#=========================================================           
#=========================================================
#=========================================================
