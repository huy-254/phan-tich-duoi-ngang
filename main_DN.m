clear ;
close all;
clc;

% Duoi ngang (cum duoi chu U, twin boom) ngam chat tai hai dau y = +-fix_loc
fix_loc = 1500e-3;

% Thong so vat lieu
material_2D
PVC_Foam

% Thong so hinh hoc
dy = 0.02;
y_coord = 0:dy:1.50;
n = length(y_coord);
c_length = 0.55*ones(n,1);
x_LE = 0.55*ones(n,1); % x_cooord of leading edge

n_load = 1;


% compute ribs spacing (full wing)
y_rib = [-1.500 -1.200 0 1.200 1.500];
rib_size = length(y_rib);
rib_spacing_3 = zeros(n,1);
for ii=n:-1:1
    scale = c_length(ii); 
        if y_coord(ii)>y_rib(rib_size)
            rib_spacing_3(ii) = (y_rib(rib_size) - y_rib(rib_size-1))/scale;
        else
            for jj = rib_size:-1:2
                if y_coord(ii)<= y_rib(jj)
                    rib_spacing_3(ii) = (y_rib(jj) - y_rib(jj-1))/scale;
                end 
            end     
        end
end

%% Wing configuration
% % vi tri dam truoc va dam sau
% for i = 1:length(y_coord)
%     if y_coord(i) < 1.75
%         x_spar_1(i) = x_LE(i) - 0.2*c_length(i) - 0.020/2;
%     else
%         x_spar_1(i) = x_LE(i) - 0.2*c_length(i) - 0.034/2;
%     end
% end
% x_spar_2 = x_LE - 0.75*c_length + 0.017/2;
% 
% % Plot hinh dang canh
% plot(y_coord, x_LE, 'b-', 'LineWidth', 2);
% x_trailing_edge = x_LE - c_length;
% hold on;
% plot(y_coord, x_trailing_edge, 'b-', 'LineWidth', 2);
% plot(y_coord, x_spar_1, 'r--', 'LineWidth', 1.5);
% plot(y_coord, x_spar_2, 'r--', 'LineWidth', 1.5);
% xlabel('X Coordinate');
% ylabel('Y Coordinate');
% title('Cross-Sectional Shape of the Wing');
% grid on;
% axis equal;

%% loading airfoil
% NACA 0015, day cung 550 mm; file gom 3 cot [x 0 z] (mm), chi lay [x z]
upper_point = load('upper_point_DN.dat'); % load upper points
lower_point = load('lower_point_DN.dat'); % load lower points
upper_point = upper_point(:,[1 3]);
lower_point = lower_point(:,[1 3]);
% chuan hoa theo day cung
upper_point = upper_point/upper_point(1,1);
lower_point = lower_point/lower_point(end,1);
figure
plot(upper_point(:,1), upper_point(:,2))
hold on
plot(lower_point(:,1), lower_point(:,2))

% Tai khi dong: luc tap trung [y (m)  F (N)] cho toan duoi ngang, da nhan he so.
% Chi lay nua phai (y >= 0); luc tai y = 0 chia doi cho hai nua duoi.
load aerodynamic_load.txt;
aerodynamic_data = sortrows(aerodynamic_load(aerodynamic_load(:,1) >= 0,:));
aerodynamic_data(aerodynamic_data(:,1) == 0,2) = aerodynamic_data(aerodynamic_data(:,1) == 0,2)/2;

y_point = aerodynamic_data(:,1);
F_point = aerodynamic_data(:,2);

% Tai phan bo F_dist (N/m), dung tinh nen/cat suon: moi luc tap trung duoc rai
% deu tren vung anh huong (giua trung diem voi cac diem dat luc lan can)
y_bound = [0; (y_point(1:end-1)+y_point(2:end))/2; y_coord(end)];
F_dist = zeros(n,1);
for ii = 1:length(y_point)
    in_zone = y_coord >= y_bound(ii) & y_coord <= y_bound(ii+1);
    F_dist(in_zone) = F_point(ii)/(y_bound(ii+1)-y_bound(ii));
end

% Khoi tao cac mang chua HSAT
f_u_skin = zeros(n,100);
f_l_skin = zeros(n,100);
f_u_skin_reinf = zeros(n,100);
f_l_skin_reinf = zeros(n,100);
f_u_spar_1 = zeros(n,100);
f_u_spar_2 = zeros(n,100);
f_l_spar_1 = zeros(n,100);
f_l_spar_2 = zeros(n,100);
f_u_cap_1 = zeros(n,100);
f_u_cap_2 = zeros(n,100);
f_l_cap_1 = zeros(n,100);
f_l_cap_2 = zeros(n,100);
f_rib = zeros(n,100);
f_front_rib = zeros(n,100);
f_rear_rib = zeros(n,100);
f_u_side_cap_1 = zeros(n,100);
f_l_side_cap_1 = zeros(n,100);
f_u_side_cap_2 = zeros(n,100);
f_l_side_cap_2 = zeros(n,100);
spar_1_up_0 = zeros(n,1);
spar_1_low_0 = zeros(n,1);
spar_2_up_0 = zeros(n,1);
spar_2_low_0 = zeros(n,1);
x_spar_1_0 = zeros(n,1);
x_spar_2_0 = zeros(n,1);

eq_strain_u_skin = zeros(n,1);
eq_strain_l_skin = zeros(n,1);
eq_strain_u_skin_reinf = zeros(n,1);
eq_strain_l_skin_reinf = zeros(n,1);
eq_strain_u_cap_1 = zeros(n,1);
eq_strain_l_cap_1 = zeros(n,1);
eq_strain_u_cap_2 = zeros(n,1);
eq_strain_l_cap_2 = zeros(n,1);

x_spar_1 = 0.1618;
x_spar_2 = 0.6909;
core_thickness_skin = .005; 
core_thickness_rib = .01;
core_thickness_spar_1 = 0.014;
core_thickness_spar_2 = 0.016;

% cross section analysis
% Duoi ngang ngam 2 dau -> sieu tinh. Do doi xung, tai y = 0: luc cat = 0, mo men
% xoan = 0, goc nghieng = 0. Phan luc tai dau mut y = fix_loc:
%   F_react, M_react : tu dieu kien luc cat, mo men xoan tai y = 0 bang 0
%   M_fix            : mo men ngam, tu dieu kien tich phan M_b/EI tren [0, fix_loc] = 0
% Lan 1: phan luc = 0 -> lay m_airfoil, EI, x_E va noi luc do tai phia ngoai mat cat
% Lan 2: tinh lai noi luc, ung suat, HSAT voi phan luc tai dau mut
F_react = 0;
M_react = 0;
M_fix = 0;
for pass = 1:2
    for ii=n:-1:1
        scale = c_length(ii);
        d_side_cap_1 = 0.011148/scale; % front side cap width (fraction of chord length)
        d_side_cap_2 = 0.011225/scale; % aft side cap width (fraction of chord length)
        d_reinf_1 = .040/scale;
        d_reinf_2 = .042/scale;
        rib_spacing = rib_spacing_3(ii);
        cross_section_analysis_DN;
    end
    if pass == 1
        F_react = -F_shear(1);
        M_react = -M_t(1);
        M_b_p = M_b + F_react*(fix_loc - y_coord);
        M_fix = -trapz(y_coord, M_b_p./EI)/trapz(y_coord, 1./EI);
    end
end


% FEM analysis
modeNumber_f = 20;
coupled_beam

% In tan so, kieu doi xung va dang dao dong chiem uu the cua tung mode
% Ba cot cuoi: ty le dong nang cua tung nhom bac tu do
tbl_head = sprintf(' %4s | %11s | %-13s | %-13s | %9s | %9s | %9s ',...
    'Mode', 'Tan so (Hz)', 'Doi xung', 'Dang dao dong', 'Uon dung', 'Xoan', 'Uon ngang');
tbl_line = regexprep(tbl_head, '[^|]', '-');
tbl_line(tbl_line == '|') = '+';
fprintf('Tan so rieng:\n%s\n%s\n', tbl_head, tbl_line);
for kk = 1:modeNumber_f
    fprintf(' %4d | %11.3f | %-13s | %-13s | %8.0f%% | %8.0f%% | %8.0f%% \n', kk, Df(kk),...
        mode_type(kk), mode_kind(kk), 100*mode_energy(:,kk));
end
fprintf('%s\n\n', tbl_line);
fprintf('Tong khoi luong duoi ngang: %.3f kg\n', sum(m_full*dy));

% Ve mode shape
% Moi mat cat (day cung) xoay quanh truc dan hoi (tam cung x_E) mot goc phi,
% tinh tien theo phuong z mot doan w va theo phuong x mot doan u. Truc x huong
% ve phia truoc, mep sau nam tai x_LE - c. Khoang cach co dau tu truc dan hoi
% den mep truoc / mep sau:
%   d_LE = x_E*c,  d_TE = -(1-x_E)*c
% Toa do sau bien dang (cung quy uoc dau voi so hang lien ket quan tinh -rhoA*e
% trong BernoulliBeam: phi > 0: mep truoc di len, mep sau di xuong):
%   x = x_EA + u + d*cos(phi),  z = w + d*sin(phi)
% Vector rieng co bien do tuy y nen nhan ca vector voi 1 he so ty le chung
% (giu nguyen ty le w/u/phi cua mode) sao cho max(|w|,|u|) <= w_plot_max va
% max|phi| <= phi_plot_max.
w_plot_max = 0.1*max(y_full);  % chuyen vi lon nhat khi ve (m)
phi_plot_max = 30*pi/180;      % goc xoan lon nhat khi ve (rad)

x_EA_full = x_LE_full - x_E_full.*c_full; % toa do x cua truc dan hoi
d_LE = x_E_full.*c_full;
d_TE = -(1-x_E_full).*c_full;
% Thang mau 9 dai kieu ANSYS: xanh duong (Min) -> do (Max)
cmap_contour = [0 0 1; 0 .7 1; 0 1 1; 0 1 .7; 0 1 0;...
    .7 1 0; 1 1 0; 1 .7 0; 1 0 0];
for kk = 1:modeNumber_f
    figure
    hold on
    mode_deflec = Vf(:,kk);
    w_mode = mode_deflec(1:5:end)';
    phi_mode = mode_deflec(3:5:end)';
    u_mode = mode_deflec(4:5:end)';
    scale_mode = min(w_plot_max/max(max(abs([w_mode u_mode])),eps),...
        phi_plot_max/max(max(abs(phi_mode)),eps));
    w_mode = scale_mode*w_mode;
    phi_mode = scale_mode*phi_mode;
    u_mode = scale_mode*u_mode;

    % Toa do mep truoc, mep sau sau bien dang
    x_LE_def = x_EA_full + u_mode + d_LE.*cos(phi_mode);
    z_LE_def = w_mode + d_LE.*sin(phi_mode);
    x_TE_def = x_EA_full + u_mode + d_TE.*cos(phi_mode);
    z_TE_def = w_mode + d_TE.*sin(phi_mode);

    % Hinh dang canh chua bien dang (tham chieu)
    plot3(x_LE_full, y_full, zeros(size(y_full)), '--', 'Color', [.6 .6 .6])
    plot3(x_LE_full-c_full, y_full, zeros(size(y_full)), '--', 'Color', [.6 .6 .6])

    % Be mat canh sau bien dang, to mau theo do lon chuyen vi toan phan
    % sqrt(ux^2+uz^2) tai tung diem (giong Total Deformation cua ANSYS; z ban
    % dau = 0, da gom ca anh huong cua goc xoan).
    % Hang 1: mep truoc, hang 2: mep sau; mau noi suy doc theo day cung
    uz_abs = sqrt(([x_LE_def; x_TE_def]-[x_LE_full; x_LE_full-c_full]).^2 +...
        [z_LE_def; z_TE_def].^2);
    surf([x_LE_def; x_TE_def], [y_full; y_full], [z_LE_def; z_TE_def], uz_abs,...
        'FaceColor', 'interp', 'EdgeColor', 'none')
    colormap(cmap_contour)
    w_min = min(uz_abs(:));
    w_max = max(uz_abs(:));
    if w_max - w_min < eps
        w_max = w_min + eps;
    end
    clim([w_min w_max])
    w_ticks = linspace(w_min, w_max, size(cmap_contour,1)+1);
    w_labels = compose('%.3g', w_ticks);
    w_labels{1} = [w_labels{1} ' Min'];
    w_labels{end} = [w_labels{end} ' Max'];
    cb = colorbar('Ticks', w_ticks, 'TickLabels', w_labels);
    cb.Label.String = '|u| (m)';

    xlabel('x (m)'); ylabel('y (m)'); zlabel('z (m)')
    title({['Mode shape so ', num2str(kk), ', tan so ', num2str(Df(kk), '%.3f'), ' Hz'],...
        ['(', char(mode_kind(kk)), ', ', char(mode_type(kk)), ')']}, 'FontSize', 18)
    axis equal tight
    axis off
    view(-55,30) % nhin tu phia sau (-x) ra phia truoc
    grid on
end

%% Xuat thong so dam tuong duong cua toan canh ra file txt
% x_E, x_C, x_N: tinh theo phan day cung, tu mep truoc ve phia sau
% (toa do x tuyet doi = x_LE - x_E*c)
% EI: uon dung (quanh truc x), EI_z: uon ngang (quanh truc z), EI_xz: uon xien
% z_E, z_C: z cua truc trung hoa va trong tam (phan day cung, he toa do airfoil)
EA_full = mirror(EA(:)');
x_N_full = mirror(x_N(:)');
beam_data = [y_full; c_full; x_LE_full; EI_full; GJ_full; EA_full;...
    m_full; Im_full; x_E_full; xc_full; EI_z_full; EI_xz_full; x_N_full; z_E_full; zc_full]';
fid = fopen('equivalent_beam_DN.txt', 'w');
fprintf(fid, '%12s %12s %12s %14s %14s %14s %12s %12s %12s %12s %14s %14s %12s %12s %12s\n',...
    'y', 'c', 'x_LE', 'EI', 'GJ', 'EA', 'm', 'Im', 'x_E', 'x_C', 'EI_z', 'EI_xz', 'x_N', 'z_E', 'z_C');
fprintf(fid, '%12s %12s %12s %14s %14s %14s %12s %12s %12s %12s %14s %14s %12s %12s %12s\n',...
    '(m)', '(m)', '(m)', '(N.m^2)', '(N.m^2)', '(N)', '(kg/m)', '(kg.m)', '(-/c)', '(-/c)',...
    '(N.m^2)', '(N.m^2)', '(-/c)', '(-/c)', '(-/c)');
fprintf(fid, ['%12.4f %12.4f %12.4f %14.6e %14.6e %14.6e %12.6f %12.6e %12.6f %12.6f',...
    ' %14.6e %14.6e %12.6f %12.6f %12.6f\n'], beam_data');
fclose(fid);
