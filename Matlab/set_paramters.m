function BA=set_paramters(BA)
%% set paramters for each dataset
%% set binding affinity
global data_name
global max_iter
global max_leaf
global Bag_rate
global feat_rate
global cv_setting
global th
global shrink_rate
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%Specific settings
switch data_name
    case 'Davis'
        switch cv_setting
            case 'warm'
                shrink_rate=0.05;
                max_iter=1500;
                Bag_rate=0.9;
                feat_rate=0.2;
                BA=-log10(BA./(10^9));
                th=-log10(100/(10^9));
                max_leaf=200;
            case 'NewDrug'
                shrink_rate=0.005;
                max_iter=1500;
                Bag_rate=0.5;
                feat_rate=0.3;
                BA=-log10(BA./(10^9));
                th=-log10(100/(10^9));
                max_leaf=200;
            case 'NewProt'
                shrink_rate=0.05;
                max_iter=2000;
                Bag_rate=0.5;
                feat_rate=0.3;
                BA=-log10(BA./(10^9));
                th=-log10(100/(10^9));
                max_leaf=200;
            case 'New_both'
                shrink_rate=0.005;
                max_iter=2000;
                Bag_rate=0.3;
                feat_rate=0.1;
                BA=-log10(BA./(10^9));
                th=-log10(100/(10^9));
                max_leaf=200;

        end
        %************************************************************
    case 'KIBA'
         switch cv_setting
            case 'warm'
                shrink_rate=0.05;
                max_iter=1500;
                Bag_rate=0.5;
                feat_rate=0.3;
                th=3;%-log10(100/(10^9));
                max_leaf=256;
            case 'NewDrug'
                shrink_rate=0.05;
                max_iter=1500;
                Bag_rate=0.3;
                feat_rate=0.1;
                th=3;%-log10(100/(10^9));
                max_leaf=256;
            case 'NewProt'
                shrink_rate=0.05;
                max_iter=1500;
                Bag_rate=0.3;
                feat_rate=0.1;
                th=3;%-log10(100/(10^9));
                max_leaf=256;
            case 'New_both'
                shrink_rate=0.05;
                max_iter=1500;
                Bag_rate=0.3;
                feat_rate=0.1;
                th=3;%-log10(100/(10^9));
                max_leaf=256;
         end

       %************************************************************

    case 'KIBA_DeepDTI'
         switch cv_setting
            case 'warm'
                shrink_rate=0.05;
                max_iter=1500;
                Bag_rate=0.9;
                feat_rate=0.2;
                th=12.1;%-log10(100/(10^9));
                max_leaf=256;
            case 'NewDrug'
                shrink_rate=0.05;
                max_iter=1500;
                Bag_rate=0.3;
                feat_rate=0.1;
                th=12.1;%-log10(100/(10^9));
                max_leaf=256;
            case 'NewProt'
                shrink_rate=0.05;
                max_iter=1700;
                Bag_rate=0.3;
                feat_rate=0.1;
                th=12.1;%-log10(100/(10^9));
                max_leaf=256;
            case 'New_both'
                shrink_rate=0.05;
                max_iter=1500;
                Bag_rate=0.3;
                feat_rate=0.1;
                th=12.1;%-log10(100/(10^9));
                max_leaf=256;
         end
        
      
    case 'Metz'
        switch cv_setting
            case 'warm'
                shrink_rate=0.05;
                max_iter=1800;
                Bag_rate=0.9;
                feat_rate=0.2;
                th=7.6;%-log10(100/(10^9));
                max_leaf=256;
            case 'NewDrug'
                shrink_rate=0.01;
                max_iter=2000;
                Bag_rate=0.5;
                feat_rate=0.3;
                th=7.6;%-log10(100/(10^9));
                max_leaf=256;
            case 'NewProt'
                shrink_rate=0.05;
                max_iter=1500;
                Bag_rate=0.7;
                feat_rate=0.3;
                th=7.6;%-log10(100/(10^9));
                max_leaf=256;
            case 'New_both'
                shrink_rate=0.03;
                max_iter=1000;
                Bag_rate=0.5;
                feat_rate=0.3;
                th=7.6;%-log10(100/(10^9));
                max_leaf=256;
        end






end
end