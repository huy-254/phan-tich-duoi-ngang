% hàm tính toán hệ số phá hủy của kết cấu theo Tsai - Hill
%------------input--------------------------------------------
% E1_layer: module đàn hồi theo phương x của lớp
% E2_layer: module đàn hồi theo phương y của lớp
% theta_layer: góc của xếp lớp
% G12_layer: module cắt theo mặt xy của lớp
% nju_layer: hệ số Poisson của lớp
% E1_tens_layer_strength: giới hạn bền chịu kéo theo phương x của các lớp vật liệu
% E2_tens_layer_strength:                                   y
% E1_compr_layer_strength: giới hạn bền chịu nén theo phương x của các lớp vật liệu
% E2_compr_layer_strength:                                   y
% G12_layer_strength: giới hạn cắt
% strain_xy0: véc tơ biến dạng eps_x, eps_y, eps_xy
% -------------------------------output --------------------------
% f: tiêu chuẩn phá hủy của vật liệu composite
%
%%
function f = THstrength(E1_layer,E2_layer,theta_layer,G12_layer,nju_layer,...
    E1_tens_layer_strength,E2_tens_layer_strength,E1_compr_layer_strength,...
    E2_compr_layer_strength,G12_layer_strength,strain_xy0)
%% Tsai-Hill criterion for failure test of composite laminate
n = length(theta_layer);
f = zeros(n,1);
for i=1:n
    strain_xy=strain_xy0;
    c = cos(theta_layer(i));
    s = sin(theta_layer(i));
    E1 = E1_layer(i);
    E2 = E2_layer(i);
    G12 = G12_layer(i);
    nju12 = nju_layer(i);
    % S_12 matrix (Gibson eq. 2.25)
    S11 = 1/E1;
    S22 = 1/E2;
    S12 = -nju12/E1;
    S21 = S12;
    S66 = 1/G12;
    S = [S11 S12 0; S21 S22 0; 0 0 S66];
    % Q_12 matrix
    Q = inv(S);
    T = [c^2 s^2 2*c*s; s^2 c^2 -2*c*s; -c*s c*s c^2-s^2]; % Gibson eq. 2.32
    % strain_12
    strain_xy(3) = strain_xy(3)/2;
    strain_12 = T*strain_xy; % Gibson eq. 2.33
    strain_12(3) = strain_12(3)*2;
    % sigma_12 in the layer
    sigma_12 = Q*strain_12;
    if(sigma_12(1)>0)
        E1_strength=E1_tens_layer_strength(i);
    else
        E1_strength=E1_compr_layer_strength(i);
    end
    
    if(sigma_12(2)>0)
        E2_strength=E2_tens_layer_strength(i);
    else
        E2_strength=E2_compr_layer_strength(i);
    end
    % Tsai-Hill equation (Gibson eq. 4.14)
    f(i) = sqrt((sigma_12(1)/E1_strength)^2-sigma_12(1)*sigma_12(2)/E1_strength^2+...
        (sigma_12(2)/E2_strength)^2+(sigma_12(3)/G12_layer_strength(i))^2);
end