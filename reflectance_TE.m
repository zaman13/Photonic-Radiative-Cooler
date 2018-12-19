function R_TE = reflectance_TE(n0,nsubs,n_layers,d_layers,theta_in,lambda)

% Mohammad Asif Zaman
% June 3 and 4, 2018
% Reflectance calculaiton
% Arguments: 
% n0 = refractive index of the input medium
% nsubs = refractive index of the substrate
% n_layers = refractive indices of the thin-film layers
% theta_in = incident angle (in radians)
% lambda = wavelength
% R_TE = output = reflectivity


% -------------------------------- %
%                                  %
%               Air                %  
%                                  %  
% -------------------------------- % 
%             Layer 1              %
% -------------------------------- %
%             Layer 2              %
% -------------------------------- %
%                .                 %
%                .                 %
%                .                 %
% -------------------------------- %
%             Layer N              %  
% -------------------------------- %
%                                  %
%            Substrate             %   
%                                  %   
% -------------------------------- %


% We calculate the parameter theta, Z, and eta on all layers
% There are N dielectric layers. The air (or other) layer on top. And a
% substrate layer on bottom. So, total N+2 layers.
% We define (N+2)x 1 matrices for all quantities.
% Haus book.

Z0 = 377;




theta_out = asin(n0*sin(theta_in)/nsubs);


N = length(n_layers);
n = zeros(N+2,1);
theta =  zeros(N+2,1);
Z = zeros(N+2,1);
eta = zeros(N+2,1);

n(1) = n0; 
n(end) = nsubs;
n(2:end-1) = n_layers;



theta(1) = theta_in;
theta(end) = theta_out;

Z(1) = Z0./(n(1)*cos(theta(1)));
Z(end) = Z0./(n(end)*cos(theta(end)));

eta(1) = Z0./(cos(theta(1)) .*n(1));
eta(end) = Z0./(cos(theta(end)) .*n(end));




for k = N:-1:1    % Work backwards from the last layer. 
%   k represents index over the dielectric layers.
    m = k + 1;    % Layer index going from N+1 to 2. 
                  % since we know the parameters for layer 1 and layer N+2.
    
    % Calculate parameters at m layer using data from (m+1) layer 
    theta(m) = asin( n(m+1)*sin( theta(m+1) ) / n(m)  );
    eta(m) = Z0./( cos(theta(m)) .*n(m) );
    
    tmp = 2*pi*n(m)/lambda * cos(theta(m)) * d_layers(k);
    Z(m) = eta(m)*( Z(m+1) + i*eta(m)*tan(tmp) ) ./ (eta(m) + i*Z(m+1)*tan(tmp));
    
    
end
% theta
% eta
% Z

R_TE = abs( (Z(2)-Z(1) ) ./ ( Z(2)+Z(1) ) ).^2;

