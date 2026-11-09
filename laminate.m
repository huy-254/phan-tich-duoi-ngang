function [A_lam, D_lam] = laminate(E1_layer,E2_layer,theta_layer,t_layer,G12_layer,nju_layer,h0)
n = length(theta_layer);
A_lam = zeros(3,3);
D_lam = zeros(3,3);
z0 = sum(t_layer)/2;
for i=1:n
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
   Q(:,3) = Q(:,3)*2;
   % Q_xy matrix
   T = [c^2 s^2 2*c*s; s^2 c^2 -2*c*s; -c*s c*s c^2-s^2]; % Gibson eq. 2.32
   Q0 = inv(T)*Q*T;
   Q0(:,3) = Q0(:,3)/2;
   % A_xy of composite laminate
   A_lam = A_lam+Q0*t_layer(i); % Gibson eq. 7.38
   % D_xy of composite laminate
   zk = -sum(t_layer)+sum(t_layer(1:n-i+1))+z0+h0;
   zk_1 = -sum(t_layer)+sum(t_layer(1:n-i))+z0+h0;
   D_lam = D_lam+Q0*(zk^3-zk_1^3)/3; % Gibson eq. 7.40
end

