%% AS4 Carbon fiber (Daniel Table A.3)
E1f_carb = 235e9;
E2f_carb = 15e9;
G12f_carb = 27e9;
G23f_carb = 7e9;
nju12f_carb = 0.2;
nju23f_carb = 0.4;
sLf_tens_carb = 3.7e9;
rho_f_carb = 1810; % Table A1. Daniel and Ishai 394
vf_carb = 0.63;
style = 1;
phi = 2*pi/180;

%% Epoxy (3501-6) (Daniel Table A.3)
Em = 4.3e9;
G12m = 1.6e9;
nju12_m = 0.35;
sLm_tens = 69e6;
sLm_compr = 200e6;
sLTm = 100e6;
rho_m = 1270;

%% Composite woven lamina Style 282 (AS4 carbon) 
% Ply
style_282 = 1; % uniform distribution (1); layered distribution (0)
[E1_UD, E2_UD, G12_UD, nju12_UD, sL_tens_UD, sL_compr_UD, sT_tens_UD, sT_compr_UD, sLT_UD, rho_UD] = ...
    ply(E1f_carb, E2f_carb, G12f_carb, Em, G12m, vf_carb, sLf_tens_carb, sLm_tens,...
    phi, sLm_compr, sLTm, rho_f_carb, rho_m, nju12f_carb, nju12_m);

m_UD = 0.3; % mass of fiber per m^2 in each ply
Vf_UD = m_UD/rho_f_carb; % volume of fiber per m^2
V_UD = Vf_UD/vf_carb; % total volume of the ply per m^2
t_UD = V_UD; % ply thickness

% Woven lamina moduli
E1_woven_layer = [E1_UD E1_UD]; 
E2_woven_layer = [E2_UD E2_UD];
G12_woven_layer = [G12_UD G12_UD];
theta_woven_layer = [0 pi/2];
t_woven_layer = [t_UD t_UD];
nju12_woven_layer = [nju12_UD nju12_UD];

[A_lam, D_lam]= laminate(E1_woven_layer, E2_woven_layer, theta_woven_layer, t_woven_layer, G12_woven_layer, nju12_woven_layer, 0);
Q_lam = A_lam/sum(t_woven_layer);
S_lam = inv(Q_lam);
E1_woven = 1/S_lam(1,1);
E2_woven = 1/S_lam(2,2);
G12_woven = 1/S_lam(3,3);
nju12_woven = -S_lam(2,1)/S_lam(1,1);
t_woven = sum(t_woven_layer);

% Failure contants
E1_tens_layer = sL_tens_UD*ones(1,2);
E1_compr_layer = sL_compr_UD*ones(1,2);
E2_tens_layer = sT_tens_UD*ones(1,2);
E2_compr_layer = sT_compr_UD*ones(1,2);
G12_layer_strength = sLT_UD*ones(1,2);

% Longitudinal Tensile strength
stress = [1;0;0];
strain_xy = Q_lam\stress;
fos = THstrength(E1_woven_layer, E2_woven_layer, theta_woven_layer, ...
    G12_woven_layer, nju12_woven_layer, E1_tens_layer, E2_tens_layer, ...
    E1_compr_layer, E2_compr_layer, G12_layer_strength, strain_xy);
sL_tens_wov = 1/max(fos);

% Transverse Tensile strength
stress = [0;1;0];
strain_xy = Q_lam\stress;
fos = THstrength(E1_woven_layer, E2_woven_layer, theta_woven_layer, ...
    G12_woven_layer, nju12_woven_layer, E1_tens_layer, E2_tens_layer, ...
    E1_compr_layer, E2_compr_layer, G12_layer_strength, strain_xy);
sT_tens_wov = 1/max(fos);

% Longitudinal Compressive strength
stress = [-1;0;0];
strain_xy = Q_lam\stress;
fos = THstrength(E1_woven_layer, E2_woven_layer, theta_woven_layer, ...
    G12_woven_layer, nju12_woven_layer, E1_tens_layer, E2_tens_layer, ...
    E1_compr_layer, E2_compr_layer, G12_layer_strength, strain_xy);
sL_compr_wov = 1/max(fos);

% Transverse Compressive strength
stress = [0;-1;0];
strain_xy = Q_lam\stress;
fos = THstrength(E1_woven_layer, E2_woven_layer, theta_woven_layer, ...
    G12_woven_layer, nju12_woven_layer, E1_tens_layer, E2_tens_layer, ...
    E1_compr_layer, E2_compr_layer, G12_layer_strength, strain_xy);
sT_compr_wov = 1/max(fos);

% Shear strength
stress = [0;0;1];
strain_xy = Q_lam\stress;
fos = THstrength(E1_woven_layer, E2_woven_layer, theta_woven_layer, ...
    G12_woven_layer, nju12_woven_layer, E1_tens_layer, E2_tens_layer, ...
    E1_compr_layer, E2_compr_layer, G12_layer_strength, strain_xy);
sLT_wov = 1/max(fos);

