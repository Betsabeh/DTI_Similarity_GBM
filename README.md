# DTI_Similarity_GBM
Brief Description This repository has been created to hold the source code for "Using drug-drug and protein-protein similarities as feature vector for drug-target binding prediction".

https://doi.org/10.1016/j.chemolab.2021.104405

DTI_Similarity_GBM used the gradient boosting machine to predict the binding affinity. The feature vector of each drug-target interaction is created by using drug fingerprint similarity and protein SW similarity values.
Both Python and Matlab implementation of DTI_Similarity_GBM is available.

References:

• Davis, M. I., Hunt, J. P., Herrgard, S., Ciceri, P., Wodicka, L. M., Pallares, G., Hocker, M., Treiber, D. K., & Zarrinkar, P. P. (2011). Comprehensive analysis of kinase inhibitor selectivity. Nature Biotechnology, 29(11), 1046-1051. https://doi.org/10.1038/nbt.1990

• Kim, S., Chen, J., Cheng, T., Gindulyte, A., He, J., He, S., Li, Q., Shoemaker, B. A., Thiessen, P. A., Yu, B., Zaslavsky, L., Zhang, J., & Bolton, E. E. (2019). PubChem 2019 update: improved access to chemical data. Nucleic Acids Research, 47(D1), D1102-d1109. https://doi.org/10.1093/nar/gky1033

• Metz, J. T., Johnson, E. F., Soni, N. B., Merta, P. J., Kifle, L., & Hajduk, P. J. (2011). Navigating the kinome. Nature Chemical Biology, 7(4), 200-202. https://doi.org/10.1038/nchembio.530

• Tang, J., Szwajda, A., Shakyawar, S., Xu, T., Hintsanen, P., Wennerberg, K., & Aittokallio, T. (2014). Making sense of large-scale kinase inhibitor bioactivity data sets: a comparative and integrative analysis. Journal of Chemical Information and Modeling, 54(3), 735-743. https://doi.org/10.1021/ci400709d

#----------------------------------------------------------------------

In Matlab, the GBM minimizes the root mean squared error

To run Matlab: 
Add your path that contains files and datasets at first line of main.m
run main.m file and input the datasets and cross-validation setting

#----------------------------------------------------------------------

Python

The GBM minimizes the mean squared error 

Python version requires several Python packages, including Numpy, scikit-learn,csv, matplotlib.

Running python:

To get the results of different methods, please run run_DTI.py by setting suitable values for the following parameters:

     Dataset: choose the benchmark dataset, i.e., Davis, Metz, Kiba
     
     Mode:	  choose the cross-validation setting, i.e., warm, NewDrug, NewProt,Both
     
     Data_path:   choose the path on your system that contains datasets and similarities
     
Here are some examples of running on cmd:

	Python run_DTI.py Davis warm e:/Data
	Python run_DTI.py Davis NewDrug e:/Data

Run in spyder console:
runfile('run_DTI.py', args='Davis Warm E:/ Data/')


