function kGA = shear_stiffness(q_b1,q_b2,delta_1,delta_2,delta_3,delta_1_2,delta_2_3,h_1_2,h_2_3,scale)
% Do cung cat ngang hieu dung kappa*G*A (N) cua mat cat 3 khoang,
% tinh theo can bang nang luong bu bien dang:
%   kGA = S^2 / (tich phan vong q^2/(G*t) ds)
% voi luc cat S dat tai tam cat (khong xoan). Dau vao giong shear_center.m:
%   q_b1, q_b2         dong cat ho trong bung dam truoc / sau (N/m)
%   delta_*            tich phan ds/(G*t) cua tung vach (1/Pa)
%   h_1_2, h_2_3       chieu cao bung dam (phan so day cung)
%   scale              chieu dai day cung (m)
% Ket qua khong phu thuoc do lon cua S (q_b1, q_b2 ty le voi S).

M = [delta_1+delta_1_2 -delta_1_2 0;...
    -delta_1_2 delta_2+delta_1_2+delta_2_3 -delta_2_3;...
    0 -delta_2_3 delta_3+delta_2_3];
Qb = [-q_b1*delta_1_2;...
    q_b1*delta_1_2-q_b2*delta_2_3;...
    q_b2*delta_2_3];
Q = M\Qb;          % dong cat khep kin khi khong xoan (nhu shear_center.m)
q1 = Q(1); q2 = Q(2); q3 = Q(3);

% Nang luong: vo cac khoang chi co dong khep kin, bung dam co them dong ho
U = q1^2*delta_1 + q2^2*delta_2 + q3^2*delta_3 + ...
    (q1-q2+q_b1)^2*delta_1_2 + (q2-q3+q_b2)^2*delta_2_3;
S = (q_b1*h_1_2 + q_b2*h_2_3)*scale;   % tong luc cat thang dung (N)

if U <= 0 || S == 0
    warning('shear_stiffness: luc cat bang 0, khong tinh duoc kGA.');
    kGA = Inf;
else
    kGA = S^2/U;
end
