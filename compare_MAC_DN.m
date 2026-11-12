%% So sanh mode shape mo hinh dam (MATLAB) va mo hinh shell (ANSYS) bang MAC
% Chay SAU main_DN.m (dung bien trong workspace: Vf, Df, y_full, x_LE_full,
% x_E_full, c_full, z_E_full, mode_type, mode_kind, dy).
% Du lieu ANSYS: chay DN_shell.inp (sinh tu gen_apdl_DN.py) -> DN_modes.txt
%   DN_mode_nodes.txt : node | tram | nhom | x | y | z   (Python ghi, dong '%' la comment)
%   DN_modes.txt      : mode | f (Hz) | node | UX | UY | UZ  (APDL ghi, cac mode noi tiep nhau,
%                       trong moi mode thu tu nut giong het DN_mode_nodes.txt)
% Ham phu: fit_section_motion.m, beam_mode_at_stations.m, mac.m

%% B0. Kiem tra dau vao
% - exist('Vf','var') va exist('y_full','var'); neu khong co thi bao "chay main_DN truoc".
% - exist('DN_modes.txt','file') va exist('DN_mode_nodes.txt','file').

%% B1. Doc danh sach nut cac tram
% - nd = load('DN_mode_nodes.txt');   (load tu bo qua dong bat dau bang %)
% - tach cot: node_id, st (so thu tu tram), grp (nhom), xn, yn, zn.
% - nS = max(st);  ys = y cua tung tram (vd. accumarray(st, yn, [], @mean)).
% - kiem tra: moi tram co cung 1 gia tri y (max - min cua yn trong tram ~ 0).

%% B2. Doc mode shape ANSYS
% - md = load('DN_modes.txt');
% - NN = so nut = size(nd,1);  nModeA = size(md,1)/NN  (phai la so nguyen).
% - kiem tra thu tu nut: md(1:NN,3) == node_id.
% - f_ansys = md(1:NN:end, 2)            -> nModeA x 1
% - UX = reshape(md(:,4), NN, nModeA);  UZ = reshape(md(:,6), NN, nModeA)
%   (moi cot = 1 mode, moi hang = 1 nut theo thu tu DN_mode_nodes.txt)

%% B3. Truc dan hoi tai cac tram (lay tu mo hinh dam)
% - x_EA tren luoi dam: x_LE_full - x_E_full.*c_full   (giong main_DN.m)
% - z_EA tren luoi dam: z_E_full.*c_full   (z_E la phan day cung, he toa do airfoil;
%   NACA 0015 doi xung nen gan 0)
% - noi suy ve tram: x_EA_s = interp1(y_full, ..., ys), z_EA_s = interp1(y_full, ..., ys)

%% B4. Khop [w; phi; u] cho mode ANSYS (cach A)
% - Cap phat: wA, phiA, uA (nS x nModeA), resA (nS x nModeA).
% - for k = 1:nS
%     id = (st == k)   (co the them & grp > 0 neu chi dung nut bung dam)
%     [q, res] = fit_section_motion(xn(id), zn(id), UX(id,:), UZ(id,:), x_EA_s(k), z_EA_s(k));
%     wA(k,:) = q(1,:);  phiA(k,:) = q(2,:);  uA(k,:) = q(3,:);  resA(k,:) = res;
%   end
% - Chi so bien dang tiet dien moi mode: res_mode = max(resA, [], 1) (hoac mean).

%% B5. Lay [w; phi; u] cua mode dam tai cung cac tram
% - [wB, phiB, uB] = beam_mode_at_stations(Vf, y_full, ys);   -> nS x modeNumber_f

%% B6. Ghep vector so sanh cung don vi (m)
% Doi phi thanh chuyen vi dung tai 2 diem ao o vi tri dam truoc / dam sau:
% - XI1 = 0.1618, XI2 = 0.6909 (giong gen_apdl_DN.py), phan day cung tu mep truoc.
% - x cua dam: x_sp1 = x_LE - XI1*c, x_sp2 = x_LE - XI2*c (noi suy ve tram nhu B3).
% - d1 = x_sp1 - x_EA_s, d2 = x_sp2 - x_EA_s   (nS x 1, co dau: > 0 o phia truoc truc).
% - Ham ghep (dung chung cho ca hai mo hinh):
%     Phi = [ w + d1.*phi ;      % uz tai dam truoc
%             w + d2.*phi ;      % uz tai dam sau
%             u            ]     % ux
%   -> (3*nS) x nMode.  Tao PhiA (ANSYS) va PhiB (dam).
% - Nho: d1.*phi voi d1 la cot, phi la ma tran -> MATLAB tu mo rong theo cot.

%% B7. Tinh MAC
% - MAC_all = mac(PhiB, PhiA);              -> modeNumber_f x nModeA
% - MAC rieng tung thanh phan de chan doan:
%     MAC_w   = mac(wB, wA);  MAC_phi = mac(phiB, phiA);  MAC_u = mac(uB, uA);
%   (MAC_w cao ma MAC_all thap -> sai o phan xoan: x_E, do lech tam e, dau phi...)

%% B8. Ghep cap mode va in bang
% - Voi moi mode dam i: [MACmax, j] = max(MAC_all(i,:)) -> mode ANSYS tuong ung.
% - Sai lech tan so: 100*(Df(i) - f_ansys(j))/f_ansys(j).
% - In bang (cung kieu bang tan so trong main_DN.m):
%     Mode dam | f dam | Kieu (mode_kind, mode_type) | Mode ANSYS | f ANSYS | df (%) | MAC | MAC_w | MAC_phi | MAC_u | res
% - Canh bao neu: 2 mode dam cung ghep vao 1 mode ANSYS; MACmax < 0.8.
% - Liet ke mode ANSYS khong ghep voi mode dam nao: neu res_mode lon -> mode cuc bo (vo/rib).

%% B9. Ve
% - Hinh 1: imagesc(MAC_all), colorbar, clim([0 1]), ghi gia tri tung o bang text(...).
%   Truc: nhan mode dam kem f (Hz), mode ANSYS kem f (Hz).
% - Hinh 2 (moi cap mode da ghep): ve w, phi, u doc theo ys, dam va ANSYS chong len nhau.
%   Truoc khi ve, dua ANSYS ve cung ty le + dau voi dam bang he so chieu:
%     a = (PhiA(:,j)' * PhiB(:,i)) / (PhiA(:,j)' * PhiA(:,j))
%   roi nhan wA(:,j), phiA(:,j), uA(:,j) voi a.
% - (Tuy chon) Hinh 3: resA theo ys cho tung mode -> thay vung tiet dien bi bien dang.

%% B10. Kiem tra hop ly (nen lam lan dau)
% - mac(PhiB, PhiB): duong cheo = 1.
% - Mode xoan thuan: phi ANSYS va phi dam cung dau sau khi nhan he so a (B9)
%   ma w cung dau -> quy uoc dau phi dung. Neu MAC_w ~ 1, MAC_phi ~ 1 nhung
%   MAC_all thap -> dau phi giua 2 mo hinh nguoc nhau.
% - Cap mode doi xung / phan doi xung tan so gan nhau: neu MAC thap ca hai,
%   thu tach mode ANSYS thanh phan doi xung/phan doi xung theo y -> -y
%   (ys doi xung qua 0: tram k <-> tram nS+1-k) giong coupled_beam.m.
