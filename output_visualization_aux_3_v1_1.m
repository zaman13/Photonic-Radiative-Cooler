% Mohammad Asif Zaman
% June-July 2018
% Comments: July 1, 2018
% Version v1_1
%   - Date: May 3, 2020
%   - Fixed figure labels and linewidths


% Notes: The refractive index of SiC used in the reference paper is
% incorrect. It's not even close to data found from Larruquert.

% Notes on converting to a function:
% Need to make sure that there are no file read/write calls in the
% function. The fitness function will be called many times, and the
% read/write operation time will accumulate.

clear all;
close all;
clc;
clf

% I/O setup
file_write = 'n';
fname = 'E_Taguchi_alt_1';
% fname = 'E_ref_alt_1';

% fname = 'E_GA_1.csv';


% Material order in the data file ref: (column #, material) (alt order on
% right)
% 1. Ag     
% 2. Al2O3
% 3. HfO2
% 4. MgF2  / SiC
% 5. SiC   / SiO2
% 6. SiN
% 7. SiO2  / MgF2
% 8. TiO2

% Material name set
Mat_str = {'Ag' 'Al_2O_3' 'HfO_2' 'SiC' 'SiO_2' 'SiN' 'MgF_2' 'TiO_2'};


% Importing material data (refractive index), either from calling the
% function or reading from a pre-written data file. Make sure that the
% all_material.csv file was written for the same wavelength range (and step
% size) as the one used here. That file must be re-written if we change the
% lambda_set variable in this code. 
% **Update: Embedded the wavelength inside the material data file. So, the
% above comments are no longer valid. Now, it will not be required to
% define the wavelength anywhere again in the code. There might be some 
% issues with old code files due to this change. However, I don't expect
% it.


% Importing data by calling function
% =========================================================================
theta_in_set = linspace(0,pi/2,201);
lambda_set = [.4:.05:18]*1e-6;    % Defining wavelength range
% M_mat = material_data_builder(lambda_set);    % original material order
M_mat = material_data_builder_alt(lambda_set);  % alternate material order



% reading data from csv file. 
% =========================================================================
% ref_data_path = 'Material_data/';
% M_mat = csvread([ref_data_path,'All_material_alt.csv']);
% lambda_set = M_mat(:,9)';
 




% <<<======================================================================
% Plotting the refractive indices of the materials. Any unusual behavior
% created by the interpolation/other issues will be visible in the plots.
for i = 1:8
    subplot(2,4,i),plot(lambda_set*1e6,real(M_mat(:,i)),'r','linewidth',2)
    hold on;
    plot(lambda_set*1e6,-imag(M_mat(:,i)),'linewidth',2)
    xlabel('\lambda (\mum)');
    ylabel('Refractive index');
    legend('n','k');
    title(Mat_str{i});
    legend boxoff;
end
% ======================================================================>>>




% TA

A_payload = [0.6069    0.8662    0.8253    0.8333    0.2726    0.1548    0.5462    0.4450   -0.1356   -0.7409   -0.2027   -0.8359    0.1737    0.0031];


% GA
% A_payload = [  -0.2225    0.2176    0.1913   -0.2432   -0.2237    0.1834   -0.2283    0.6384   -0.9341   -0.1787    0.6992   -0.0340   -0.0327    0.0590];



% min_d = 0.01e-6;              % lower limit of layer thickness
% max_d = 3.52e-6;          % higher limit of layer thickness

min_d = 0.07e-6;              % lower limit of layer thickness
max_d = 3.99e-6;          % higher limit of layer thickness

Nlayers = 7;


% Ref. structure
% <<<=================================================================
mat_order_ref = [5 2.3 5 2.3 5 2.3 5];
mat_thick_ref = [230 485 688 13 73 34 54]*1e-9;

% converting acutal dimensions to payload format
A_order_ref = (mat_order_ref-1)./(3.5) - 1;
A_thick_ref = 2*(mat_thick_ref-min_d)./(max_d - min_d) - 1;
% A_payload = [A_order_ref A_thick_ref];

% ==================================================================>>>



% Converting payload [-1 1] domain to physical domain
temp1 = A_payload(1:0.5*length(A_payload));
temp1 = round((temp1+1).*3 + 2,0);

temp2 = A_payload(0.5*length(A_payload) + 1:end); 
temp2 = 0.5*(temp2 + 1);          % mapt [-1,1] to [0,1]
temp2 = min_d + (max_d - min_d).*temp2;

fprintf('Optimized layer order %d\n',temp1);
fprintf('Optimized layer thickness %1.2f\n',temp2*1e6);

tic
for m = 1:length(theta_in_set)
    theta_in = theta_in_set(m);
    E(:,m) = spectrum_out(M_mat,A_payload,theta_in,min_d,max_d);
end
toc



E0 = E(:,1);   % Normal emission specturm

% Calculating average emission specturm (avg. over angles)
Eavg = trapz(theta_in_set, E, 2)';  % integrating over the incident angles
Eavg = Eavg/(0.5*pi);

% Write csv data file
if file_write == 'y'
    csvwrite([fname '_E.csv'],E);
    Mdata_write = [lambda_set'  E0  Eavg'];
    csvwrite([fname '_E0_Eavg.csv'],Mdata_write);
end


% Plotting normal and average emission spectrum
figure, plot(lambda_set*1e6, E0,'linewidth',2);
hold on;
plot(lambda_set*1e6, Eavg,'r','linewidth',2);
xlabel('Wavelength, \lambda (\mum)'); ylabel('Emissivity, E');
legend('Normal incidence','Averaged over all incident angles');
legend boxoff;

% 2D contour plot (wavelenght, theta vs E)
figure, contourf(theta_in_set*180/pi,lambda_set*1e6, E,100,'linestyle','none');
colormap hot;
cb = colorbar;
xlabel('Incident angle, \theta (deg)'); 
ylabel('Wavelength, \lambda (\mum)'); 
ylabel(cb,'Emissivity, E');


% plot E along with E_desired by calling fitness function with fig flag ON
% fitness(M_mat,A_payload,1)
% legend('Optimized spectrum','Target spectrum');
% legend boxoff;


