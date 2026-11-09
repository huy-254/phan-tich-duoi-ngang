function [A, D, L] = laminate3D(E1,E2,E3,G12,G13,G23,nu12,nu13,nu23,theta,t,h0,opts)
%LAMINATE3D  Do cung laminate theo CLT mo rong (ABD + cat ngoai mat phang)
%            va hang so dan hoi 3D tuong duong cua laminate.
%
%   [A, D, L] = laminate3D(E1,E2,E3,G12,G13,G23,nu12,nu13,nu23,theta,t,h0,opts)
%
%   Dau vao (vector theo tung lop, hoac so vo huong neu moi lop giong nhau):
%     E1..nu23 : hang so 3D cua lop trong he truc vat lieu (xem ply3D)
%     theta    : goc lop (rad), quay quanh truc z
%     t        : chieu day lop (m)
%     h0       : khoang cach tu mat tham chieu den mat giua laminate (m),
%                cung y nghia voi tham so h0 cua laminate.m (mac dinh 0)
%     opts     : struct tuy chon
%       .coupling     true (mac dinh): hang so ky thuat tinh tu nghich dao cua
%                     ca ma tran ABD (laminate tu do cong), nhu mac dinh cua ACP.
%                     false: nghich dao rieng A va D.
%       .first_ply    'top' (mac dinh, giong laminate.m: lop 1 o tren cung) hoac
%                     'bottom' (giong ACP: lop 1 nam tai mat tham chieu, xep len
%                     theo huong orientation)
%       .polar_angles goc (do) de tinh polar properties, mac dinh 0:5:180
%
%   Dau ra:
%     A, D : giong laminate.m (D lay quanh mat tham chieu, co ke h0), de co the
%            thay truc tiep [A_lam, D_lam] = laminate(...)
%     L    : struct
%       .A .B .D .ABD     ma tran quanh mat tham chieu (co ke h0)
%       .B0 .D0           ma tran quanh mat giua laminate
%       .Cs               ma tran cat ngoai mat phang 2x2, thu tu [yz xz]
%       .K8               ma tran 8x8 [ABD 0; 0 Cs] (ACP Theory 5.4.2.1)
%       .norm             ma tran chuan hoa A*, B*, D*, Cs*, a*, d* (5.4.2.2)
%       .Ex .Ey .Gxy .nuxy           hang so trong mat phang (5.4.2.3)
%       .Exf .Eyf .Gxyf .nuxyf       hang so uon (flexural)
%       .k44 .k55 .Gyz .Gxz          he so hieu chinh cat va module cat
%                                    ngoai mat phang (5.4.2.4)
%       .C3D .S3D .E3D               do cung/do mem 6x6 va hang so 3D tuong duong
%                                    (Ex Ey Ez Gyz Gxz Gxy nuxy nuxz nuyz)
%       .polar                       .angle .E1 .E2 .G12 (5.4.2.5)
%       .T .z_top .z_bot             tong chieu day, toa do mat lop (so voi
%                                    mat tham chieu)
%
%   Ghi chu:
%   - Hang so ky thuat (in-plane, flexural) duoc tinh quanh mat giua laminate,
%     tuong ung tuy chon offset_is_middle cua ACP, vi offset h0 lon lam B lon va
%     hang so "tu do cong" mat y nghia vat ly.
%   - He so hieu chinh cat k44, k55 tinh theo phuong phap can bang nang luong
%     bien dang (phan bo ung suat cat tu ly thuyet dam phan lop). ACP dung ly
%     thuyet cua Isaksson nen ket qua co the khac, nhat la voi sandwich.
%   - C3D: dong nhat hoa 3D voi gia thiet bien dang trong mat phang va ung suat
%     ngoai mat phang khong doi qua chieu day (khong ke anh huong uon).
%   - Thu tu Voigt noi bo [11 22 33 23 13 12].

if nargin < 12 || isempty(h0)
    h0 = 0;
end
if nargin < 13 || isempty(opts)
    opts = struct();
end
if ~isfield(opts,'coupling'),     opts.coupling = true;        end
if ~isfield(opts,'first_ply'),    opts.first_ply = 'top';      end
if ~isfield(opts,'polar_angles'), opts.polar_angles = 0:5:180; end

n = numel(theta);
theta = theta(:)';
t = t(:)'.*ones(1,n);
E1 = E1(:)'.*ones(1,n);   E2 = E2(:)'.*ones(1,n);   E3 = E3(:)'.*ones(1,n);
G12 = G12(:)'.*ones(1,n); G13 = G13(:)'.*ones(1,n); G23 = G23(:)'.*ones(1,n);
nu12 = nu12(:)'.*ones(1,n); nu13 = nu13(:)'.*ones(1,n); nu23 = nu23(:)'.*ones(1,n);

T = sum(t);
cs = [0 cumsum(t(1:end-1))];
switch lower(opts.first_ply)
    case 'top'
        z_top = T/2 - cs;
        z_bot = z_top - t;
    case 'bottom'
        z_bot = -T/2 + cs;
        z_top = z_bot + t;
    otherwise
        error('laminate3D: opts.first_ply phai la ''top'' hoac ''bottom''.');
end

ia = [1 2 6];   % thanh phan trong mat phang  (11 22 12)
ib = [3 4 5];   % thanh phan ngoai mat phang  (33 23 13)

Cbar = zeros(6,6,n);
Qbar = zeros(3,3,n);
A  = zeros(3);
B0 = zeros(3);
D0 = zeros(3);
Cs = zeros(2);
for i = 1:n
    S = [ 1/E1(i)        -nu12(i)/E1(i)  -nu13(i)/E1(i)  0         0         0;
         -nu12(i)/E1(i)   1/E2(i)        -nu23(i)/E2(i)  0         0         0;
         -nu13(i)/E1(i)  -nu23(i)/E2(i)   1/E3(i)        0         0         0;
          0               0               0              1/G23(i)  0         0;
          0               0               0              0         1/G13(i)  0;
          0               0               0              0         0         1/G12(i)];
    Ti = inv(Tsig(theta(i)));
    Cg = Ti*inv(S)*Ti';            % do cung 3D trong he truc laminate
    Cg = (Cg + Cg')/2;
    Sg = inv(Cg);
    Q = inv(Sg(ia,ia));            % do cung rut gon ung suat phang
    Cbar(:,:,i) = Cg;
    Qbar(:,:,i) = Q;
    A  = A  + Q*t(i);
    B0 = B0 + Q*(z_top(i)^2 - z_bot(i)^2)/2;
    D0 = D0 + Q*(z_top(i)^3 - z_bot(i)^3)/3;
    Cs = Cs + Cg([4 5],[4 5])*t(i);
end

% Doi mat tham chieu mot doan h0 (z' = z + h0)
B = B0 + A*h0;
D = D0 + 2*B0*h0 + A*h0^2;

L = struct();
L.A = A; L.B = B; L.D = D; L.ABD = [A B; B D];
L.B0 = B0; L.D0 = D0; L.Cs = Cs;
L.K8 = blkdiag(L.ABD, Cs);
L.T = T; L.z_top = z_top + h0; L.z_bot = z_bot + h0;

% Ma tran chuan hoa (quanh mat giua)
if opts.coupling
    abd = inv([A B0; B0 D0]);
    a = abd(1:3,1:3);
    d = abd(4:6,4:6);
else
    a = inv(A);
    d = inv(D0);
end
an = a*T;
dn = d*T^3/12;
L.norm = struct('A',A/T,'B',2*B0/T^2,'D',12*D0/T^3,'Cs',Cs/T,'a',an,'d',dn);

% Hang so ky thuat trong mat phang va uon
L.Ex   = 1/an(1,1);
L.Ey   = 1/an(2,2);
L.Gxy  = 1/an(3,3);
L.nuxy = -an(1,2)/an(1,1);
L.Exf   = 1/dn(1,1);
L.Eyf   = 1/dn(2,2);
L.Gxyf  = 1/dn(3,3);
L.nuxyf = -dn(1,2)/dn(1,1);

% Cat ngoai mat phang co he so hieu chinh
Q11 = reshape(Qbar(1,1,:),1,n);
Q22 = reshape(Qbar(2,2,:),1,n);
G44 = reshape(Cbar(4,4,:),1,n);
G55 = reshape(Cbar(5,5,:),1,n);
L.k55 = shear_k(Q11, G55, z_top, z_bot, t);
L.k44 = shear_k(Q22, G44, z_top, z_bot, t);
L.Gxz = L.k55*Cs(2,2)/T;
L.Gyz = L.k44*Cs(1,1)/T;

% Dong nhat hoa 3D
v = t/T;
Pm = zeros(3); CabP = zeros(3); PCba = zeros(3); Caa = zeros(3);
for i = 1:n
    Cg  = Cbar(:,:,i);
    Pk  = inv(Cg(ib,ib));
    Cab = Cg(ia,ib);
    Cba = Cg(ib,ia);
    Pm   = Pm   + v(i)*Pk;
    CabP = CabP + v(i)*Cab*Pk;
    PCba = PCba + v(i)*Pk*Cba;
    Caa  = Caa  + v(i)*(Cg(ia,ia) - Cab*Pk*Cba);
end
Pinv = inv(Pm);
C3D = zeros(6);
C3D(ia,ia) = Caa + CabP*Pinv*PCba;
C3D(ia,ib) = CabP*Pinv;
C3D(ib,ia) = Pinv*PCba;
C3D(ib,ib) = Pinv;
C3D = (C3D + C3D')/2;
S3D = inv(C3D);
L.C3D = C3D;
L.S3D = S3D;
L.E3D = struct('Ex',1/S3D(1,1),'Ey',1/S3D(2,2),'Ez',1/S3D(3,3),...
    'Gyz',1/S3D(4,4),'Gxz',1/S3D(5,5),'Gxy',1/S3D(6,6),...
    'nuxy',-S3D(1,2)/S3D(1,1),'nuxz',-S3D(1,3)/S3D(1,1),'nuyz',-S3D(2,3)/S3D(2,2));

% Polar properties: hang so trong mat phang theo huong quay phi
ang = opts.polar_angles(:)';
Qeff = inv(an);
E1p = zeros(size(ang)); E2p = E1p; G12p = E1p;
for j = 1:numel(ang)
    T2 = Tsig2(ang(j)*pi/180);
    Sr = inv(T2*Qeff*T2');
    E1p(j)  = 1/Sr(1,1);
    E2p(j)  = 1/Sr(2,2);
    G12p(j) = 1/Sr(3,3);
end
L.polar = struct('angle',ang,'E1',E1p,'E2',E2p,'G12',G12p);
end

% ------------------------------------------------------------------------
function Ts = Tsig(th)
% Ma tran bien doi ung suat 6x6 (quay quanh z), sigma_lop = Ts*sigma_laminate
m = cos(th); s = sin(th);
Ts = [ m^2   s^2  0  0   0   2*m*s;
       s^2   m^2  0  0   0  -2*m*s;
       0     0    1  0   0   0;
       0     0    0  m  -s   0;
       0     0    0  s   m   0;
      -m*s   m*s  0  0   0   m^2-s^2];
end

function T2 = Tsig2(th)
% Ma tran bien doi ung suat phang 3x3 (Gibson eq. 2.32)
c = cos(th); s = sin(th);
T2 = [c^2 s^2 2*c*s; s^2 c^2 -2*c*s; -c*s c*s c^2-s^2];
end

function k = shear_k(Qv, Gv, z_top, z_bot, t)
% He so hieu chinh cat theo can bang nang luong:
% tau(z) = Q*g(z)/Dn, g(z) = tich phan tu mat duoi Q(z)*(z - zn) dz
zn = sum(Qv.*(z_top.^2 - z_bot.^2)/2)/sum(Qv.*t);
Dn = sum(Qv.*((z_top - zn).^3 - (z_bot - zn).^3)/3);
[~, order] = sort(z_bot);
g = 0;
I = 0;
for i = order
    ua = z_bot(i) - zn;
    ub = z_top(i) - zn;
    al = g - Qv(i)*ua^2/2;
    be = Qv(i)/2;
    I = I + (al^2*(ub - ua) + 2*al*be*(ub^3 - ua^3)/3 + be^2*(ub^5 - ua^5)/5)/Gv(i);
    g = al + be*ub^2;
end
k = Dn^2/(sum(Gv.*t)*I);
end
