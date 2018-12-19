function M_mat = material_data_builder_alt(lambda_range)

% June 4, 2018
% Impedance method. Refractive index notation n_complex = n - ik. 
% Haus book.

ref_data_path = 'Material_data/';

% M_Ag = xlsread([ref_data_path,'mat_Ag.xlsx']);

M_Ag = csvread([ref_data_path,'Ag_Yang.csv']);

M_Al2O3 = xlsread([ref_data_path,'mat_Al2O3']);
M_HfO2 = xlsread([ref_data_path,'mat_HfO2']);
M_MgF2 = xlsread([ref_data_path,'mat_MgF2']);
M_SiC = csvread([ref_data_path,'SiC_Larruquert.csv']);

% M_SiC = xlsread([ref_data_path,'mat_SiC']);
M_SiN = xlsread([ref_data_path,'mat_SiN']);
M_SiO2 = xlsread([ref_data_path,'mat_SiO2']);
% M_TiO2 = xlsread([ref_data_path,'mat_TiO2']);
M_TiO2 = csvread([ref_data_path,'TiO2_Siefke.csv']);








n_Ag = interp1(M_Ag(:,1)*1e-6,M_Ag(:,2),lambda_range);
k_Ag = interp1(M_Ag(:,1)*1e-6,M_Ag(:,3),lambda_range);


n_Al2O3 = interp1(M_Al2O3(:,1)*1e-6,M_Al2O3(:,2),lambda_range);
k_Al2O3 = interp1(M_Al2O3(:,1)*1e-6,M_Al2O3(:,3),lambda_range);

n_HfO2 = interp1(M_HfO2(:,1)*1e-6,M_HfO2(:,2),lambda_range);
k_HfO2 = interp1(M_HfO2(:,1)*1e-6,M_HfO2(:,3),lambda_range);


n_MgF2 = interp1(M_MgF2(:,1)*1e-6,M_MgF2(:,2),lambda_range);
k_MgF2 = interp1(M_MgF2(:,1)*1e-6,M_MgF2(:,3),lambda_range);


n_SiC = interp1(M_SiC(:,1)*1e-6,M_SiC(:,2),lambda_range);
k_SiC = interp1(M_SiC(:,1)*1e-6,M_SiC(:,3),lambda_range);

n_SiN = interp1(M_SiN(:,1)*1e-6,M_SiN(:,2),lambda_range);
k_SiN = interp1(M_SiN(:,1)*1e-6,M_SiN(:,3),lambda_range);

n_SiO2 = interp1(M_SiO2(:,1)*1e-6,M_SiO2(:,2),lambda_range);
k_SiO2 = interp1(M_SiO2(:,1)*1e-6,M_SiO2(:,3),lambda_range);


n_TiO2 = interp1(M_TiO2(:,1)*1e-6,M_TiO2(:,2),lambda_range);
k_TiO2 = interp1(M_TiO2(:,1)*1e-6,M_TiO2(:,3),lambda_range);



M_mat(:,1) = n_Ag - i*k_Ag;

M_mat(:,2) = n_Al2O3 - i*k_Al2O3;
M_mat(:,3) = n_HfO2 - i*k_HfO2;
M_mat(:,4) = n_SiC - i*k_SiC;
M_mat(:,5) = n_SiO2 - i*k_SiO2;
M_mat(:,6) = n_SiN - i*k_SiN;
M_mat(:,7) = n_MgF2 - i*k_MgF2;
M_mat(:,8) = n_TiO2 - i*k_TiO2;
M_mat(:,9) = lambda_range';


