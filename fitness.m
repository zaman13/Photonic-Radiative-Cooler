% Mohammad Asif Zaman
% June-July 2018
% Comments: July 1, 2018


% Notes: The refractive index of SiC used in the reference paper is
% incorrect. It's not even close to data found from Larruquert.

% Notes on converting to a function:
% Need to make sure that there are no file read/write calls in the
% function. The fitness function will be called many times, and the
% read/write operation time will accumulate.

function yout = fitness(M_mat,A_payload,flag_fig)

% Material order in the data file ref: (column #, material)
% 1. Ag     
% 2. Al2O2
% 3. HfO2
% 4. MgF2
% 5. SiC
% 6. SiN
% 7. SiO2
% 8. TiO2



% Defining wavelength range
% lambda_set = [.3:.1:20]*1e-6;



% Importing material data (refractive index), either from calling the
% function or reading from a pre-written data file. Make sure that the
% all_material.csv file was written for the same wavelength range (and step
% size) as the one used here. That file must be re-written if we change the
% lambda_set variable in this code. 

% M_mat = material_data_builder(lambda_set);   
% uncomment the above line if function calling is preferred

% reading data from csv file. 
lambda_set = M_mat(:,9)';


% <<<======================================================================
% --------------Mapping-----------------

% Let's assume that the optimization algorithm will output values in the
% range [-1,1] for all parameter. It's better to map these values to our
% parameter range in the fitness function here rather than modifying the
% optimization algoirthm. 
% The first 6 parameters: A_payload(1:6) will be integer mapped into values
% [2,8]. 

min_d = 0.07e-6;              % lower limit of layer thickness
max_d = 3.99e-6;           % higher limit of layer thickness

temp1 = A_payload(1:0.5*length(A_payload));
temp1 = round((temp1+1).*3 + 2,0);

temp2 = A_payload(0.5*length(A_payload) + 1:end); 
temp2 = 0.5*(temp2 + 1);          % mapt [-1,1] to [0,1]
temp2 = min_d + (max_d - min_d).*temp2;


% <<<======================================================================
%  Defining the layer materials and thickness.
%  The layer m_layers[] array specifies the layer materials. Each number
%  corresponds to a column in the material file (thus a specific material)

n0 = 1;                                      % superstrate
m_layers = temp1;                            % layers (from top down)
                                               
% m_layers = [4 3 5 4 5 4];


d_layers = temp2;                            % layer thickness
% m_layers = [3 8 4];
% d_layers = [3.25 2.8 3.1]*1e-6;

% ======================================================================>>>




% <<<======================================================================
% Reflectance/Emissivity calculation


theta_in_deg = 0;                   % incident angle (radian)
theta_in = pi*theta_in_deg/180;     % incident angle (degree)

% Looping over the wavelengths
for m = 1:length(lambda_set)
    lambda = lambda_set(m);
    nsubs = M_mat(m,1);
    n_layers = M_mat(m,m_layers(1:length(m_layers)));
    R_TE(m) = reflectance_TE(n0,nsubs,n_layers,d_layers,theta_in,lambda);
    R_TM(m) = reflectance_TM(n0,nsubs,n_layers,d_layers,theta_in,lambda);
end

Rnorm = 0.5*(R_TE + R_TM);     % polarization averaged reflectance

Enorm = 1 - Rnorm;             % emissivity

% ======================================================================>>>









% <<<======================================================================
% Target spectra and cost calculation

% Defining target spectra
ind1 = find(lambda_set >= 8e-6 & lambda_set <= 13e-6);
ind2 = find(lambda_set >= 9.3e-6 & lambda_set <= 10e-6);


Edesired = zeros(size(lambda_set));
Edesired(ind1) = 1;
Edesired(ind2) = 0;


% Sub-dividing the target spectr into 2 parts
% The refletive target area is defiend for lambda = 0 to 1.85 micron
% The transmission target area is define for lambda = 6 to 20 micron 
lambda_R = 1.85e-6;
lambda_T1 = 6e-6;

ind_R = find(lambda_set < lambda_R);
ind_T = find(lambda_set > lambda_T1);

lambda_T = lambda_set(ind_T);
lambda_R = lambda_set(ind_R);

ETdesired = Edesired(ind_T);
ERdesired = Edesired(ind_R);

if flag_fig == 1
    figure
    plot(lambda_set*1e6,Enorm);
    xlabel('\lambda (\mum)');
    ylabel('E');
    hold on;
    stairs(lambda_R*1e6,ERdesired, 'g');
    stairs(lambda_T*1e6,ETdesired, 'g');
    m_layers
    d_layers
end

err1 = sum((ERdesired - Enorm(ind_R)).^2);
err2 = sum((ETdesired - Enorm(ind_T)).^2);


% fprintf('Error in the reflection regime %f\n',err1)
% fprintf('Error in the transmission regime %f\n',err2)


% ======================================================================>>>


% csvwrite('ERD.csv',[lambda_R' ERdesired']);
% csvwrite('ETD.csv',[lambda_T' ETdesired']);

yout = -1*(err1 + err2);