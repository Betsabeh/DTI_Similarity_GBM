function [X,ind_d,ind_p]=Create_Features(Data)
%This function create Similarity from different sources
%--------------------------------------------------------------------------
%preprocessing
global Drugs Prots data_name
global P_SW_simil D_finger_simil
Drug_list=Data(:,2);
if strcmp(data_name,'KIBA')==1  || strcmp(data_name,'KIBA_DeepDTI')==1  
    Prot_list=Data(:,5);  %KBIA for uniprot id =5
else
    Prot_list=Data(:,1); %%% Daivs and Metz 1 for gene ,
end
Smile_Seq=Data(:,4);
List_seq=Data(:,3);
[Drugs,index_d,~]=unique(Drug_list);
USmile=Smile_Seq(index_d,:);
[Prots,index_p,~]=unique(Prot_list);
USeq=List_seq(index_p,:);
Uniprot_id=Data(:,5);
Uni_prot=Uniprot_id(index_p);
clear index
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%% -0:1=Drug Features
[Feature1,NOT_find]=chem_feature_api(Drugs');
Feature_drug_finger=double(Feature1(:,33:end-7)); %%remove the 4 byte lenght prefix at first and 7 bit at end
[D,D_finger_simil]=Jaccard_sim_cal(Drugs,Feature_drug_finger); %      1- Jaccrad Similarity
[x,y]=find(isnan(D_finger_simil)==1);
for i=1:numel(x)
    D_finger_simil(x(i),y(i))=0;
end

%----------------------------------------------------------------------------
%-0:2=Prot features
[~,P_SW_simil]=Swaling_sim_cal(Prots,USeq,1);
[x,y]=find(isnan(P_SW_simil)==1);
for i=1:numel(x)
    P_SW_simil(x(i),y(i))=0;
end
%--------------------------------------------------------------------------
Kegg_Did=Data(:,2);
Kegg_Pid=Data(:,4);
for i=1:size(Data,1)
    ind_d(i)=find(ismember(Drugs,Drug_list(i))~=0);
    ind_p(i)=find(ismember(Prots,Prot_list(i))~=0);
    X(i,:)=[D_finger_simil(ind_d(i),:), P_SW_simil(ind_p(i),:)];
end
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function [list,Similarity]=Jaccard_sim_cal(list,F)
[list,ind]=unique(list);
F=F(ind,:);
Similarity=1-pdist2(F,F,'jaccard');
% Similarity=1-tanimoto(logical(F));
end
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
