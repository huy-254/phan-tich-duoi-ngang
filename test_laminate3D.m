%% Kiem tra laminate3D / ply3D
% Gia tri "ky vong" trong ngoac duoc tinh bang ban Python doc lap cua cung
% thuat toan.
clear; clc;
material_3D

UD   = {E1_UD,   E2_UD,   E3_UD,   G12_UD,   G13_UD,   G23_UD,   nju12_UD,   nju13_UD,   nju23_UD};
CORE = {E1_core, E2_core, E3_core, G12_core, G13_core, G23_core, nju12_core, nju13_core, nju23_core};
% Ghep thuoc tinh lop theo chuoi ky tu 'U' (UD) / 'C' (foam)
build = @(kinds, k) arrayfun(@(c) (c=='U')*UD{k} + (c=='C')*CORE{k}, kinds);

%% 1. Vo KV1 [woven/UD/foam10/UD/woven]: A, D phai trung laminate.m
kinds = 'UUUCUUU';
th = [pi/4 -pi/4 0 0 0 pi/4 -pi/4];
t  = [t_UD t_UD t_UD 0.01 t_UD t_UD t_UD];
a = cell(1,9); for k = 1:9, a{k} = build(kinds,k); end
[A3, D3, L] = laminate3D(a{:}, th, t, 0);
[A2, D2] = laminate(a{1}, a{2}, th, t, a{4}, a{7}, 0);
fprintf('1. Vo KV1: sai khac A = %.1e, D = %.1e  (~1e-16)\n', ...
    max(abs(A3(:)-A2(:)))/max(abs(A2(:))), max(abs(D3(:)-D2(:)))/max(abs(D2(:))));
fprintf('   Ex = %.4g (8.687e9), Exf = %.4g (2.102e10), k55 = %.4f (0.0406), Gxz = %.4g (2.603e7), Ez = %.4g (1.085e8)\n', ...
    L.Ex, L.Exf, L.k55, L.Gxz, L.E3D.Ez);

%% 2. Mu dam truoc KV1 (28 woven / 108 UD) voi offset h0 = 0.05 m
kinds = repmat('U', 1, 164);
th = [repmat([pi/4 -pi/4 0 0 0 0], 1, 27) pi/4 -pi/4];
t  = t_UD*ones(1, 164);
for k = 1:9, a{k} = build(kinds,k); end
[A3, D3, L] = laminate3D(a{:}, th, t, 0.05);
[A2, D2] = laminate(a{1}, a{2}, th, t, a{4}, a{7}, 0.05);
fprintf('2. Mu dam: sai khac A = %.1e, D = %.1e; D11 = %.5g (1.3129e7)\n', ...
    max(abs(A3(:)-A2(:)))/max(abs(A2(:))), max(abs(D3(:)-D2(:)))/max(abs(D2(:))), D3(1,1));
fprintf('   Ex = %.4g (1.061e11), Gxz = %.4g (4.022e9), Gyz = %.4g (2.724e9), Ez = %.4g (1.05e10)\n', ...
    L.Ex, L.Gxz, L.Gyz, L.E3D.Ez);

%% 3. Mot lop dong nhat: k = 5/6, dong nhat hoa 3D tra lai dung hang so lop
[~, ~, L] = laminate3D(UD{:}, 0, 1e-3, 0);
fprintf('3. Mot lop: k55 = %.5f, k44 = %.5f (0.83333); Ez = %.5g (%.5g); nuyz = %.4f (%.4f); E(90 do) = %.5g (%.5g)\n', ...
    L.k55, L.k44, L.E3D.Ez, E3_UD, L.E3D.nuyz, nju23_UD, L.polar.E1(L.polar.angle==90), E2_UD);

%% 4. Lop khong doi xung chieu day [UD 0.263 mm / foam 10 mm]
kinds = 'UC'; th = [0 0]; t = [t_UD 0.01];
for k = 1:9, a{k} = build(kinds,k); end
[~, D3] = laminate3D(a{:}, th, t, 0);
[~, D2] = laminate(a{1}, a{2}, th, t, a{4}, a{7}, 0);
fprintf('4. Khong doi xung: D11 laminate.m = %.5g (12544), laminate3D = %.5g (994.65)\n', D2(1,1), D3(1,1));
fprintf('   -> laminate.m gan sai chieu day lop khi t(i) ~= t(n-i+1)\n');

%% 5. Woven [0/90] tuong duong
fprintf('5. Woven 3D: Ex = %.4g (7.944e10), Ez = %.4g (1.124e10), Gxz = %.4g (3.766e9), nuxz = %.4f (0.436)\n', ...
    woven3D.Ex, woven3D.Ez, woven3D.Gxz, woven3D.nuxz);
