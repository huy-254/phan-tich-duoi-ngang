clear; clc; close all;

%% 1. THONG SO HINH HOC CANH (NACA 0015, HINH CHU NHAT)
c = 0.550;          % Day cung (chord) = 550 mm = 0.55 m
L = 3.0;            % Sai canh (span) = 3.0 m
t_max = 0.15;       % Do day tuong doi NACA 0015 (15%)
x_EA = 0.25 * c;    % Truc dan hoi nam o 1/4 day cung tinh tu mep truoc (LE)
z_EA = 0;           % Profile doi xung nen truc dan hoi nam tren duong day cung

%% 2. TAO BIEN DANG AIRFOIL NACA 0015 (MAT CAT NGANG)
n_pts_airfoil = 60; % So diem nua tren/duoi
beta = linspace(0, pi, n_pts_airfoil)';
xc = 0.5 * (1 - cos(beta)); % Chia luoi theo phan bo cosin (min o LE va TE)

% Cong thuc chuan NACA 4 chu so (dong kin mep sau -0.1036)
zt = 5 * t_max * (0.2969*sqrt(xc) - 0.1260*xc - 0.3516*xc.^2 + 0.2843*xc.^3 - 0.1036*xc.^4);

% Ghep thanh 1 vong kin quanh bien dang (tu TE -> mat tren -> LE -> mat duoi -> TE)
x_prof = [flipud(xc); xc(2:end)] * c;
z_prof = [flipud(zt); -zt(2:end)] * c;
nProf = numel(x_prof);

%% 3. TAO LUOI DOC SAI CANH VA VECTOR MODE SHAPE GIA LAP V(:,1)
% Gia su mo hinh dam co nNode nut doc theo truc y (tu 0 den 3m)
nNode = 61; 
y_nodes = linspace(0, L, nNode)';

% Tao mode shape gia lap cho 5 DOF/nut: [w; theta; phi; u; psi]
% Dieu kien bien ngam 2 dau (y=0 va y=L): w = 0, dw/dy = 0, phi = 0, u = 0
w_node     = 0.5 * (1 - cos(2*pi*y_nodes / L));              % Uon dung mode 1 (ngam 2 dau)
theta_node = 0.5 * (2*pi/L) * sin(2*pi*y_nodes / L);         % Dao ham dw/dy
phi_node   = 0.12 * sin(pi*y_nodes / L);                     % Xoan nhe o giua nhip (rad)
u_node     = 0.08 * (1 - cos(2*pi*y_nodes / L));             % Uon trong mat phang (lead-lag)
psi_node   = 0.08 * (2*pi/L) * sin(2*pi*y_nodes / L);        % Dao ham du/dy

% Xep thanh vector cot V (5*nNode x 1) dung chuan cau truc cua ban
V = zeros(5*nNode, 1);
V(1:5:end, 1) = w_node;
V(2:5:end, 1) = theta_node;
V(3:5:end, 1) = phi_node;
V(4:5:end, 1) = u_node;
V(5:5:end, 1) = psi_node;

%% 4. TAI TAO BE MAT 3D TU VECTOR V(:,1) (DONG HOC MAT CAT CUNG)
% Tach lai cac bac tu do tai tung mat cat doc sai canh
w_s   = V(1:5:end, 1);
phi_s = V(3:5:end, 1);
u_s   = V(4:5:end, 1);

% Khoang cach tuong doi cua tung diem tren airfoil toi truc dan hoi
dx = x_prof - x_EA;
dz = z_prof - z_EA;

% Khoi tao luoi toa do 3D (nProf x nNode)
% X: huong day cung (LE -> TE), Y: doc sai canh, Z: huong thang dung
[Y_undeformed, X_undeformed] = meshgrid(y_nodes, x_prof);
Z_undeformed = repmat(z_prof, 1, nNode);

X_deformed = zeros(nProf, nNode);
Y_deformed = Y_undeformed;
Z_deformed = zeros(nProf, nNode);

% He so phong dai bien dang de de quan sat bang mat thuong
scale = 0.5; 

for j = 1:nNode
    w_j   = scale * w_s(j);
    phi_j = scale * phi_s(j);
    u_j   = scale * u_s(j);
    
    % Ap dung dung cong thuc dong hoc mat cat cung trong ham fit_section_motion:
    % uz = w + phi*dx
    % ux = u - phi*dz
    X_deformed(:, j) = x_prof + (u_j - phi_j * dz);
    Z_deformed(:, j) = z_prof + (w_j + phi_j * dx);
end

%% 5. VE DO THI 3D TRUC QUAN
figure('Color', 'w', 'Position', [100, 100, 1100, 650]);
hold on; grid on; box on;

% 5.1. Ve canh goc chua bien dang (dang luoi mo trong suot de doi chieu)
surf(X_undeformed, Y_undeformed, Z_undeformed, ...
    'FaceColor', [0.85 0.85 0.85], 'FaceAlpha', 0.25, ...
    'EdgeColor', [0.6 0.6 0.6], 'EdgeAlpha', 0.2, ...
    'DisplayName', 'Canh goc (Chua bien dang)');

% 5.2. Ve canh sau bien dang (to mau theo do chuyen vi dung Z)
surf(X_deformed, Y_deformed, Z_deformed, Z_deformed, ...
    'FaceColor', 'interp', 'EdgeColor', 'none', ...
    'FaceLighting', 'gouraud', 'AmbientStrength', 0.5, ...
    'DisplayName', 'Mode shape 1 (Bien dang)');

% 5.3. Ve cac duong suon (ribs) doc theo sai canh cho giong that
rib_indices = round(linspace(1, nNode, 13)); % 13 suon canh
for idx = rib_indices
    plot3(X_deformed(:, idx), Y_deformed(:, idx), Z_deformed(:, idx), ...
        'k-', 'LineWidth', 0.8, 'HandleVisibility', 'off');
end

% 5.4. Ve truc dan hoi (Elastic Axis) tai 25% chord
plot3(x_EA + scale*u_s, y_nodes, z_EA + scale*w_s, ...
    'r--', 'LineWidth', 2.2, 'DisplayName', 'Truc dan hoi (EA - 25%c)');

% 5.5. Ve 2 vach ngam hai dau canh (y = 0 va y = 3m)
patch([-0.1 0.7 0.7 -0.1], [0 0 0 0], [-0.2 -0.2 0.2 0.2], ...
    [0.3 0.3 0.3], 'FaceAlpha', 0.5, 'DisplayName', 'Dieu kien bien ngam');
patch([-0.1 0.7 0.7 -0.1], [L L L L], [-0.2 -0.2 0.2 0.2], ...
    [0.3 0.3 0.3], 'FaceAlpha', 0.5, 'HandleVisibility', 'off');

% Thiet lap goc nhin, anh sang va nhan truc
colormap(jet);
cb = colorbar;
cb.Label.String = 'Chuyen vi dung Z (m)';
cb.Label.FontSize = 11;

camlight('headlight');
lighting gouraud;
material dull;

axis equal; % Giu dung ty le that giua chord (0.55m) va span (3m)
view(-35, 25);
xlabel('X - Day cung (m)', 'FontWeight', 'bold');
ylabel('Y - Sai canh (m)', 'FontWeight', 'bold');
zlabel('Z - Chuyen vi dung (m)', 'FontWeight', 'bold');
title('Mode Shape 1 - Canh NACA 0015 Ngam Hai Dau (c = 0.55m, L = 3m)', 'FontSize', 13);
legend('Location', 'northeast');
