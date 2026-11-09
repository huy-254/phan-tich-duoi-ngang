%% Thong so vat lieu 3D
% Chay thay cho cap "material_2D; PVC_Foam" trong main_CW.m.
% Giu nguyen moi bien 2D va gioi han ben cu, them cac bien 3D theo cung quy
% uoc ten de dung duoc voi eval(strrep(stack,'par',...)):
%   E3_UD G13_UD G23_UD nju13_UD nju23_UD
%   E3_core G13_core G23_core nju13_core nju23_core

material_2D
PVC_Foam

%% Lop UD 3D (AS4 / 3501-6)
p_UD = ply3D(E1f_carb, E2f_carb, G12f_carb, Em, G12m, vf_carb, sLf_tens_carb, sLm_tens, ...
    phi, sLm_compr, sLTm, rho_f_carb, rho_m, nju12f_carb, nju12_m, ...
    G23f_carb, nju23f_carb, 'foye');
E3_UD    = p_UD.E3;
G13_UD   = p_UD.G13;
G23_UD   = p_UD.G23;
nju13_UD = p_UD.nu13;
nju23_UD = p_UD.nu23;
% E1_UD, E2_UD, G12_UD, nju12_UD da co tu material_2D (trung voi p_UD)

%% Foam PVC (dang huong): G = E/(2(1+nu)) = 26.92 MPa, khop G12_core
E3_core    = E1_core;
G13_core   = G12_core;
G23_core   = G12_core;
nju13_core = nju12_core;
nju23_core = nju12_core;

%% Woven = 2 lop UD [0 90] -> hang so 3D tuong duong (dung cho Engineering Data)
[~, ~, L_woven] = laminate3D([E1_UD E1_UD], [E2_UD E2_UD], [E3_UD E3_UD], ...
    [G12_UD G12_UD], [G13_UD G13_UD], [G23_UD G23_UD], ...
    [nju12_UD nju12_UD], [nju13_UD nju13_UD], [nju23_UD nju23_UD], ...
    [0 pi/2], [t_UD t_UD], 0, struct('coupling', false));
woven3D = L_woven.E3D;

%% In bang hang so 3D
fprintf('\nHang so 3D (GPa cho module):\n');
fprintf('%-8s %8s %8s %8s %8s %8s %8s %7s %7s %7s\n', '', 'E1', 'E2', 'E3', ...
    'G12', 'G13', 'G23', 'nu12', 'nu13', 'nu23');
fprintf('%-8s %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %7.4f %7.4f %7.4f\n', 'UD', ...
    [p_UD.E1 p_UD.E2 p_UD.E3 p_UD.G12 p_UD.G13 p_UD.G23]/1e9, p_UD.nu12, p_UD.nu13, p_UD.nu23);
fprintf('%-8s %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %7.4f %7.4f %7.4f\n', 'Woven', ...
    [woven3D.Ex woven3D.Ey woven3D.Ez woven3D.Gxy woven3D.Gxz woven3D.Gyz]/1e9, ...
    woven3D.nuxy, woven3D.nuxz, woven3D.nuyz);
fprintf('%-8s %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %7.4f %7.4f %7.4f\n', 'PVC foam', ...
    [E1_core E2_core E3_core G12_core G13_core G23_core]/1e9, nju12_core, nju13_core, nju23_core);
fprintf('Woven: rho = %.0f kg/m^3, t = %.4f mm\n\n', rho_UD, 2*t_UD*1e3);
