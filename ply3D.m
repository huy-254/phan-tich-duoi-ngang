function p = ply3D(E1f,E2f,G12f,Em,G12m,vf,sLf_tens,sLm_tens,phi,sLm_compr,sLTm,...
    rho_f,rho_m,nju12_f,nju12_m,G23f,nju23f,method23)
%PLY3D  Hang so dan hoi 3D cua mot lop UD (truc 1 = phuong soi; 2, 3 vuong goc soi)
%
%   p = ply3D(E1f,E2f,G12f,Em,G12m,vf,sLf_tens,sLm_tens,phi,sLm_compr,sLTm,...
%             rho_f,rho_m,nju12_f,nju12_m,G23f,nju23f,method23)
%
%   15 tham so dau giong het ham ply.m (cac hang so trong mat phang va gioi han
%   ben duoc lay truc tiep tu ply.m). Them:
%     G23f     : module cat ngang cua soi (mat 2-3), Pa
%     nju23f   : he so Poisson ngang cua soi (2-3)
%     method23 : cach tinh nu23 / G23 cua lop
%                'foye'   (mac dinh) nu23 = vf*nu23f + (1-vf)*(2*num - nu21),
%                         G23 = E2/(2(1+nu23))
%                'chamis' G23 cung dang voi cong thuc E2, G12 trong ply.m
%                         (Gibson eq. 3.50), nu23 = E2/(2*G23) - 1
%
%   Gia thiet lop dang huong ngang quanh truc 1: E3 = E2, G13 = G12, nu13 = nu12.
%
%   Ket qua p (struct):
%     E1 E2 E3 G12 G13 G23 nu12 nu13 nu23 rho
%     sL_tens sL_compr sT_tens sT_compr sLT     (tu ply.m)
%     sZ_tens sZ_compr s13                      (= sT_tens, sT_compr, sLT theo
%                                                 gia thiet dang huong ngang)
%     s23                                       (NaN: ply.m khong cung cap)
%     C, S : ma tran do cung / do mem 6x6, thu tu Voigt [11 22 33 23 13 12]
%            (chu y: ANSYS dung thu tu [x y z xy yz xz])

if nargin < 18 || isempty(method23)
    method23 = 'foye';
end

[E1, E2, G12, nu12, sL_t, sL_c, sT_t, sT_c, sLT, rho] = ply(E1f, E2f, G12f, Em, G12m, ...
    vf, sLf_tens, sLm_tens, phi, sLm_compr, sLTm, rho_f, rho_m, nju12_f, nju12_m);

% Dang huong ngang quanh truc soi
E3 = E2;
G13 = G12;
nu13 = nu12;

switch lower(method23)
    case 'foye'
        nu21 = nu12*E2/E1;
        nu23 = vf*nju23f + (1-vf)*(2*nju12_m - nu21);
        G23 = E2/(2*(1+nu23));
    case 'chamis'
        G23 = G12m*((1-sqrt(vf)) + sqrt(vf)/(1-sqrt(vf)*(1-G12m/G23f)));
        nu23 = E2/(2*G23) - 1;
    otherwise
        error('ply3D: method23 phai la ''foye'' hoac ''chamis''.');
end

if nu23 <= 0 || nu23 >= 1
    warning('ply3D: nu23 = %.3f nam ngoai khoang hop ly (0, 1).', nu23);
end

S = [ 1/E1     -nu12/E1  -nu13/E1  0      0      0;
     -nu12/E1   1/E2     -nu23/E2  0      0      0;
     -nu13/E1  -nu23/E2   1/E3     0      0      0;
      0         0         0        1/G23  0      0;
      0         0         0        0      1/G13  0;
      0         0         0        0      0      1/G12];
C = inv(S);
if any(eig((C+C')/2) <= 0)
    warning('ply3D: ma tran do cung 3D khong xac dinh duong, kiem tra lai hang so.');
end

p = struct('E1',E1,'E2',E2,'E3',E3,'G12',G12,'G13',G13,'G23',G23,...
    'nu12',nu12,'nu13',nu13,'nu23',nu23,'rho',rho,...
    'sL_tens',sL_t,'sL_compr',sL_c,'sT_tens',sT_t,'sT_compr',sT_c,'sLT',sLT,...
    'sZ_tens',sT_t,'sZ_compr',sT_c,'s13',sLT,'s23',NaN,...
    'C',C,'S',S);
end
