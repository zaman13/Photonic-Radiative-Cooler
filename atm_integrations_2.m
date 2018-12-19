% Mohammad Asif Zaman
% July 2018 (comments: Dec. 2018)

% This code reads and plots solar spectrum and atmospheric transmittance
% data. It also calculates the radiative cooling power of a photonic
% multilayer structure. The emissivity data of the structure is read from a
% csv file, which is calculated from a separate file.


clear all;
close all;
clc; clf;
% 

% Data import
% <<<======================================================================
% M_mat = csvread('All_material_alt.csv');

% Read atmospheric transmittance data
M1 = dlmread('Atmospheric data/7-14r200.dat');    % Atmospheric transmission data 1
M2 = dlmread('Atmospheric data/16-26r100.dat');   % Atmospheric transmission data 2

% Read solar spectrum data
M3 = csvread('Atmospheric data/AM0AM1_5.csv');    %  AM1.5 solar data in Wm^-2 nm^-1


% Read Emissivity data


% E = csvread('E_Taguchi_alt_1_E.csv');
E = csvread('E_ref_alt_1_E.csv');   

% E = csvread('E_GA_1.csv');
% E = eye(size(E));

% ======================================================================>>>


data_write = 'n';
% file_name = 'P_Taguchi.csv';
% file_name = 'P_ref.csv';


% Independent variables.
% Note that the emissivity data is calculated for the same wavelengths 
% and angle values defined here. 
theta_in_set = linspace(0,pi/2,201);
lambda_set = [.4:.05:18]'*1e-6;    % Defining wavelength range
% lambda_set = M_mat(:,9);    % Defining wavelength range

% 

E0 = E(:,1);   % E(lambda) at theta = 0;

% Parameters
kB = 1.38e-23;
T0 = 300;
h = 6.626e-34;
c0 = 3e8;




lm = [M1(:,2); linspace(14,15.9,30)'; M2(:,2)];
y = [M1(:,3); 0*linspace(14,15.9,30)'; M2(:,3)];


y_atm_trans = interp1(lm*1e-6,y,lambda_set,'linear',0);
y_am15 = interp1(M3(:,1)*1e-9,M3(:,4),lambda_set,'linear',0);


% =========================================================================
% Aug. 20, 2018
% 30 deg to zenith conversion (negligible effect)

% y_atm_trans = (1-(1-y_atm_trans)).^(sqrt(3)/2);

% =========================================================================


plot(lambda_set*1e6,y_atm_trans,'r');
hold on;
plot(lambda_set*1e6,y_am15./max(y_am15),'b');
xlabel('Wavelength, \lambda (nm)');
ylabel('Relative amplitude');
legend('Atmospheric transmittance','Solar spectrum');
xlim([0.3 20]);


Psun = trapz(lambda_set*1e9,y_am15.*E0); %lambda in nm. So, integration output at W/m^2
fprintf('P_sun = %1.3f \n',Psun);




lambda_mat = ones(size(E));
y_atm_mat = ones(size(E));

for m = 1:size(E,2)           % loop for every theta angle
    lambda_mat(:,m) = lambda_set;
    y_atm_mat(:,m) = 1-y_atm_trans.^(1./ (cos(theta_in_set(m))+eps) );  % the 1 - part was missing aug 20, 2018
end

f1 = E./(lambda_mat.^5 .* (exp(h*c0./(lambda_mat*kB*T0))-1) );

i_atm = trapz(lambda_set,f1.*y_atm_mat);
Patm = 2*pi*h*c0^2 * trapz(theta_in_set, i_atm.*sin(2*theta_in_set));



Tset = linspace(250,350,5001);

for m = 1:length(Tset)
    T = Tset(m);
    f2 = E./(lambda_mat.^5 .* (exp(h*c0./(lambda_mat*kB*T))-1) );
    i_rad = trapz(lambda_set,f2);
    Prad(m) = 2*pi*h*c0^2 * trapz(theta_in_set, i_rad.*sin(2*theta_in_set));

end

% Prad
fprintf('P_atm = %1.3f \n',Patm);

Pcool_1 = Prad-Patm-Psun;
Pcool_2 = Pcool_1 - 6.9*(T0-Tset);
% figure, plot(Tset-T0,Pcool_1);
figure, plot(Pcool_2,Tset-T0);
xlabel('Cooling power, P_{cool} W/m^2');
ylabel('T-T_{amb}  (^{\circ}C)');
xlim([-20,40]);
% ylim([0,50]);


% write data to file
if data_write == 'y'
    Mwrite = [Pcool_1' Pcool_2' (Tset-T0)'];
    csvwrite(file_name, Mwrite);
end
% csvwrite('P_Taguchi.csv', Mwrite);



