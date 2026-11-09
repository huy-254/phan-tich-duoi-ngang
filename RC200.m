%% T700s Carbon fiber / Table A.2
E1f_carb = 230e9;
E2f_carb = 15e9; % from AS-4
G12f_carb = 27e9; % from AS-4
nju12f_carb = 0.2; % from AS-4
sLf_tens_carb = 4.9e9;
phi = 2*pi/180; % initial fiber misalignment
rho_f_carb = 1810; 
m_carb = 0.205/2; % mass of fiber per m^2 in each ply
m_mat = m_carb/.58*.42; % mass of resin per m^2 in each ply
%% Matrix (F201-10)
Em = 2.9e9;
nju12_m = 0.35; % From Epoxy 3501-6
G12m = Em/2/(1+nju12_m);
sLm_tens = 155e6;
sLm_compr = 200e6; % From Epoxy 3501-6
sLTm = 175e6; % Adjusted to fit data
rho_m = 1200; % From LY 564 / Aradur 560
vf_carb = m_carb/rho_f_carb/(m_carb/rho_f_carb+m_mat/rho_m);
%% Single ply
[E1c_200, E2c_200, G12c_200, nju12c_200, sLc_tens_200, sLc_compr_200, sTc_tens_200, sTc_compr_200, sLTc_200, rho_c_200] = ...
    ply(E1f_carb,E2f_carb,G12f_carb,Em,G12m,vf_carb,sLf_tens_carb,sLm_tens,...
    phi,sLm_compr,sLTm,rho_f_carb,rho_m,nju12f_carb,nju12_m);
Vfc_200 = m_carb/rho_f_carb; % volume of fiber per m^2
Vc_200 = Vfc_200/vf_carb; % total volume of the ply per m^2
tc_200 = Vc_200; % ply thickness
%% Woven lamina moduli
E1_layer = [E1c_200 E1c_200]; 
E2_layer = [E2c_200 E2c_200];
G12_layer = [G12c_200 G12c_200];
theta_layer = [pi/4 -pi/4];
t_layer = [tc_200 tc_200];
nju_layer = [nju12c_200 nju12c_200];
%[A_lam, D_lam]= laminate(E1_layer,E2_layer,theta_layer,t_layer,G12_layer,nju_layer); 
[A_lam, D_lam]= laminate(E1_layer,E2_layer,theta_layer,t_layer,G12_layer,nju_layer,0);
Q_lam = A_lam/(sum(t_layer));
S_lam = inv(Q_lam);
E1_200 = 1/S_lam(1,1); % Gibson Eq. 2.25
E2_200 = 1/S_lam(2,2);
G12_200 = 1/S_lam(3,3);
stress = [1;0;0];
strain_12 = S_lam*stress;
nju12_200 = -strain_12(2)/strain_12(1);
t_200 = 2*tc_200;
rho_200 = rho_c_200;
% Failure contants
E1_tens_layer_strength = sLc_tens_200*ones(1,2);
E1_compr_layer_strength = sLc_compr_200*ones(1,2);
E2_tens_layer_strength = sTc_tens_200*ones(1,2);
E2_compr_layer_strength = sTc_compr_200*ones(1,2);
G12_layer_strength = sLTc_200*ones(1,2);
% Longitudinal Tensile strength
stress = [1;0;0];
strain = S_lam*stress;
f = THstrength(E1_layer,E2_layer,theta_layer,G12_layer,nju_layer,...
    E1_tens_layer_strength,E2_tens_layer_strength,E1_compr_layer_strength,...
    E2_compr_layer_strength,G12_layer_strength,strain);
sL_tens_200 = 1/max(f);
% Longitudinal compressive strength
stress = [-1;0;0];
strain = S_lam*stress;
f = THstrength(E1_layer,E2_layer,theta_layer,G12_layer,nju_layer,...
    E1_tens_layer_strength,E2_tens_layer_strength,E1_compr_layer_strength,...
    E2_compr_layer_strength,G12_layer_strength,strain);
sL_compr_200 = 1/max(f);
% Transverse Tensile strength
stress = [0;1;0];
strain = S_lam*stress;
f = THstrength(E1_layer,E2_layer,theta_layer,G12_layer,nju_layer,...
    E1_tens_layer_strength,E2_tens_layer_strength,E1_compr_layer_strength,...
    E2_compr_layer_strength,G12_layer_strength,strain);
sT_tens_200 = 1/max(f);
% Transverse compressive strength
stress = [0;-1;0];
strain = S_lam*stress;
f = THstrength(E1_layer,E2_layer,theta_layer,G12_layer,nju_layer,...
    E1_tens_layer_strength,E2_tens_layer_strength,E1_compr_layer_strength,...
    E2_compr_layer_strength,G12_layer_strength,strain);
sT_compr_200 = 1/max(f);
% Shear  strength
stress = [0;0;1];
strain = S_lam*stress;
f = THstrength(E1_layer,E2_layer,theta_layer,G12_layer,nju_layer,...
    E1_tens_layer_strength,E2_tens_layer_strength,E1_compr_layer_strength,...
    E2_compr_layer_strength,G12_layer_strength,strain);
sLT_200 = 1/max(f);