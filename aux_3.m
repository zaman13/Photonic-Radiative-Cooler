% Mohammad Asif Zaman
% June-July 2018
% Comments: July 1, 2018


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


% Material order in the data file ref: (column #, material)
% 1. Ag     
% 2. Al2O2
% 3. HfO2
% 4. MgF2  / SiC
% 5. SiC   / SiO2
% 6. SiN
% 7. SiO2  / MgF2
% 8. TiO2




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
    subplot(2,4,i),plot(lambda_set*1e6,real(M_mat(:,i)),'r')
    hold on;
    plot(lambda_set*1e6,-imag(M_mat(:,i)))
    xlabel('\lambda (\mum)');
    ylabel('Refractive index');
    legend('n','k');
end
% ======================================================================>>>




% TA
% A_payload = [-0.3761   -0.6753    0.2951   -0.3385    0.9107   -0.2797   -0.8501   -0.0834    0.0103   -0.3385    0.0708   -0.2326   -0.9513   -0.8742];


% TA alt material
% A_payload = [0.6069    0.8662    0.8253    0.8333    0.2726    0.1548    0.5462    0.4450   -0.1356   -0.7409   -0.2027   -0.8359    0.1737    0.0031];
% A_payload = [0.5071    0.8419    0.8590    0.5570    0.2203    0.1591    0.7494    0.3264   -0.2003   -0.9867    0.0994   -0.8145    0.8591   -0.0542];
A_payload = [0.6069    0.8662    0.8253    0.8333    0.2726    0.1548    0.5462    0.4450   -0.1356   -0.7409   -0.2027   -0.8359    0.1737    0.0031];


% GA
% A_payload = [  -0.2225    0.2176    0.1913   -0.2432   -0.2237    0.1834   -0.2283    0.6384   -0.9341   -0.1787    0.6992   -0.0340   -0.0327    0.0590];



% min_d = 0.01e-6;              % lower limit of layer thickness
% max_d = 3.52e-6;          % higher limit of layer thickness

min_d = 0.07e-6;              % lower limit of layer thickness
max_d = 3.99e-6;          % higher limit of layer thickness

Nlayers = 7;

% temp1 = A_payload(1:6);
% temp1 = round((temp1+1).*3 + 2,0);
% 
% temp2 = A_payload(7:12); 
% temp2 = 0.5*(temp2 + 1);          % mapt [-1,1] to [0,1]
% temp2 = min_d + (max_d - min_d).*temp2;
% temp1
% temp2

% Ref. structure
% <<<=================================================================
mat_order_ref = [5 2.3 5 2.3 5 2.3 5];
mat_thick_ref = [230 485 688 13 73 34 54]*1e-9;

% converting acutal dimensions to payload format
A_order_ref = (mat_order_ref-1)./(3.5) - 1;
A_thick_ref = 2*(mat_thick_ref-min_d)./(max_d - min_d) - 1;
% A_payload = [A_order_ref A_thick_ref];

% ==================================================================>>>

% tic
% for m = 1:100
%     fitness(M_mat,A_payload,0);
% end
% toc
% fitness(M_mat,A_payload,1)



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
figure, plot(lambda_set*1e6, E0);
hold on;
plot(lambda_set*1e6, Eavg,'r');
xlabel('Wavelength, \lambda (\mum)'); ylabel('E');
legend('Normal','Avg.');


% 2D contour plot (wavelenght, theta vs E)
figure, contourf(theta_in_set*180/pi,lambda_set*1e6, E,100,'linestyle','none');
colormap hot;
colorbar;
xlabel('Incident angle, \theta (deg)'); 
ylabel('Wavelength, \lambda (\mum)'); 



% plot E along with E_desired by calling fitness function with fig flag ON
fitness(M_mat,A_payload,1)
legend('Optimized spectrum','Target spectrum');

% Collection of good results obtained from various optimization algorithms
% =========================================================================
% 
% temp1
% temp2

% Decent solutions: GA
%    -0.1762    0.9155   -0.1809    0.2153   -0.2246    0.3400    0.1269   -0.0066    0.1709    0.0035    0.0132   -0.9513
%  -0.1891    0.8892    0.2090   -0.1754   -0.2186   -0.1931    0.2344   -0.6028   -0.1075    0.0003   -0.4634 
% -0.1851   -0.1690    0.9651   -0.2954    0.5025    0.3031   -0.0000   -0.3923    0.0025    0.0457   -0.0001   -0.7824

% -0.1714    0.1707   -0.3170   -0.1809    0.5906   -0.3024   -0.1770    0.5627   -0.1854   -0.0044   -0.0166    0.0162    0.0086   -0.4788
%  -0.1749   -0.1866    0.9693   -0.1669    0.6936   -0.2543   -0.1444    0.0246   -0.0034    0.0010   -0.5328    0.1333
%  -0.2355    0.8826    0.1720   -0.1710    0.9169   -0.1689   -0.1787   -0.0472    0.0009   -0.5584    0.0137   -0.3753   -0.6676    0.7758
% -0.2519    0.1734   -0.3047    0.2694   -0.2326    0.2239   -0.1805    0.6162    0.0008   -0.0050   -0.3921    0.0418   -0.7897    0.2383



% DE
% -0.3110   -0.3447    0.2231    0.5678   -0.3431    0.6761   -0.1408   -0.0654   -0.4035   -0.4475    0.5036   -0.8397
%%% -0.2301    0.9036   -0.2356   -0.8829    0.6958   -0.8690    0.3708   -0.1138   -0.1060   -0.9019   -0.3207    0.0715
% -0.2116    0.9926   -0.2377   -0.5439   -0.3095    0.3004   -0.6741    0.4115   -0.1554    0.1510    0.2154   -0.5544   -0.1929    0.9877
% 0.2429    0.9397   -0.1821    0.7183   -0.6804   -0.6745    0.0211    0.1550    0.1568   -0.6006   -0.6363   -0.7025
%%%  -0.4035   -0.6052   -0.2896    0.4561   -0.4943    0.6936    0.3077   -0.8893   -0.1115   -0.2912   -0.3705   -0.3076
% -0.2173   -0.5069    0.3765   -0.4323   -0.3909    0.7438   -0.2806   -0.1659   -0.4906    0.4066   -0.1686   -0.3076
% % % -0.4953    0.2251   -0.2099   -0.7284    0.9024   -0.4856    0.1057   -0.0624   -0.0004   -0.7985   -0.4220    0.5302
% % % -0.2637    0.1860   -0.2053   -0.6594    0.6375   -0.2783    0.4683   -0.2155   -0.0398    0.6429    0.5751    0.0766


% The best so far. No repeating layers.
% % %  -0.2470    0.8437    0.7106    0.2361   -0.6998   -0.1858    0.5088    0.5069   -0.7027   -0.7959   -0.2672   -0.2736    0.1085   -0.4738




%  -0.2183    0.1850   -0.2971   -0.3907    0.7663   -0.2217   -0.9114    0.6691   -0.2528    0.2254    0.0787   -0.9576   -0.6875    0.2271


% TA_7
%  0.01, 3.4
%  -0.3492   -0.3783    0.4888   -0.3491    0.5348   -0.5145   -0.9667   -0.6759    0.7589   -0.1240   -0.4380   -0.1370   -0.9082   -0.7751

% Perfect!! 0.01,3.52
% % %  -0.2303   -0.3902    0.9026   -0.9664    0.7922   -0.7897   -1.0000   -0.0984   -0.3195    0.6646   -0.3849   -0.5678   -0.4020   -0.6861

% 0.01, 3.51
% % % -0.3761   -0.6753    0.2951   -0.3385    0.9107   -0.2797   -0.8501   -0.0834    0.0103   -0.3385    0.0708   -0.2326   -0.9513   -0.8742

% 0.01 3.521
% % %  -0.2898   -0.5080    0.8333   -0.8339    0.8252   -0.8184   -0.9953   -0.2615   -0.5131    0.5245   -0.5822   -0.6707   -0.3691   -0.6826



