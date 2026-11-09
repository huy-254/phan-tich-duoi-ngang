%................................................................
function [stiffness,mass] = ...
    TimoshenkoBeam(GDof,numberElements,LElem,EI,rhoA,GIp,Im,e,EIz,EIxz,ez,kGA,rhoI)
% Dam Timoshenko uon - xoan (cung cach dung voi BernoulliBeam)
%   Bac tu do moi nut: [w theta phi u psi] (nhu BernoulliBeam)
%   EI, rhoA, GIp, Im, e, EIz, EIxz, ez : nhu BernoulliBeam (gia tri tren tung phan tu)
%   kGA  : do cung cat ngang hieu dung kappa*G*A (N), Inf -> bo qua bien dang cat
%   rhoI : quan tinh xoay cua mat cat quanh truc uon (kg.m), = sum(rho*z^2*dA)
%
%   Phan tu dung ham dang "chinh xac" cua dam Timoshenko (Friedman & Kosmatka,
%   1993): khong bi khoa cat (shear locking), cho chuyen vi tinh chinh xac tai nut.
%   Voi kGA = Inf va rhoI = 0, ma tran trung khop BernoulliBeam.
%   Ky hieu Phi = 12*EI/(kGA*L^2).
%   Bien dang cat chi ke cho uon dung; uon ngang theo Euler-Bernoulli (ham dang
%   Hermite). So hang uon xien int(EIxz*theta'*u''): theta' lay tu ham dang
%   Timoshenko (khong phai w'' Hermite, vi theta khong bang w' khi co bien dang cat).

if nargin < 12 || isempty(kGA)
    kGA = Inf(size(EI));
end
if nargin < 13 || isempty(rhoI)
    rhoI = zeros(size(EI));
end
if isscalar(kGA),  kGA  = kGA*ones(size(EI));  end
if isscalar(rhoI), rhoI = rhoI*ones(size(EI)); end

mass = zeros(GDof);
stiffness = zeros(GDof);
L = LElem;
for j = 1:numberElements
    % elementDof: element degrees of freedom (Dof)
    elementDof = (j*5-4:(j+1)*5);
    iw = elementDof([1 2 6 7]);  % w, theta
    ip = elementDof([3 8]);      % phi
    iu = elementDof([4 5 9 10]); % u, psi
    p = 12*EI(j)/(kGA(j)*L^2);   % Phi = 0 khi kGA = Inf

    % Do cung uon + cat
    k1 = EI(j)/((1+p)*L^3)*[12      6*L          -12     6*L;
                            6*L     (4+p)*L^2    -6*L    (2-p)*L^2;
                            -12     -6*L         12      -6*L;
                            6*L     (2-p)*L^2    -6*L    (4+p)*L^2];
    % Do cung xoan
    k2 = GIp(j)/L*[1 -1; -1 1];

    % Khoi luong tinh tien (rhoA)
    a1 = 70*p^2 + 147*p + 78;
    a2 = (35*p^2 + 77*p + 44)*L/4;
    a3 = 35*p^2 + 63*p + 27;
    a4 = (35*p^2 + 63*p + 26)*L/4;
    a5 = (7*p^2 + 14*p + 8)*L^2/4;
    a6 = (7*p^2 + 14*p + 6)*L^2/4;
    m1 = rhoA(j)*L/(210*(1+p)^2)*[a1   a2   a3  -a4;
                                  a2   a5   a4  -a6;
                                  a3   a4   a1  -a2;
                                 -a4  -a6  -a2   a5];
    % Quan tinh xoay cua mat cat (rhoI)
    b1 = (15*p - 3)*L;
    b2 = (10*p^2 + 5*p + 4)*L^2;
    b3 = (5*p^2 - 5*p - 1)*L^2;
    m1 = m1 + rhoI(j)/(30*(1+p)^2*L)*[ 36  -b1  -36  -b1;
                                      -b1   b2   b1   b3;
                                      -36   b1   36   b1;
                                      -b1   b3   b1   b2];
    % Quan tinh xoan
    m2 = Im(j)*L*[1/3 1/6; 1/6 1/3];
    % Lien ket quan tinh uon - xoan (do lech tam e), tich phan N_w^T * N_phi
    m3 = -rhoA(j)*e(j)*L/(1+p)*[(20*p+21)/60       (10*p+9)/60;
                                (5*p+6)*L/120      (5*p+4)*L/120;
                                (10*p+9)/60        (20*p+21)/60;
                                -(5*p+4)*L/120     -(5*p+6)*L/120];

    % Uon ngang (Euler-Bernoulli) va uon xien
    H = 1/L^3*[12   6*L    -12  6*L;
               6*L  4*L^2  -6*L 2*L^2;
               -12  -6*L   12   -6*L;
               6*L  2*L^2  -6*L 4*L^2];
    k3 = EIz(j)*H;
    % theta' = (N_herm'' + p*[0 -1 0 1]/L)/(1+p) theo [w1 theta1 w2 theta2]
    % => int(theta'^T*u'') = (H + p*G0)/(1+p), G0 chi lien ket 2 goc xoay
    G0 = 1/L*[0  0  0  0;
              0  1  0 -1;
              0  0  0  0;
              0 -1  0  1];
    k4 = EIxz(j)/(1+p)*(H + p*G0);
    m4 = rhoA(j)*L/420*[156    22*L    54     -13*L;
                        22*L   4*L^2   13*L   -3*L^2;
                        54     13*L    156    -22*L;
                        -13*L  -3*L^2  -22*L  4*L^2];
    % Lien ket quan tinh uon ngang - xoan (do lech tam ez)
    m5 = -rhoA(j)*ez(j)*L*[7/20    3/20;
                           L/20    L/30;
                           3/20    7/20;
                           -L/30   -L/20];

    % stiffness and mass matrices
    stiffness(iw,iw) = stiffness(iw,iw) + k1;
    stiffness(ip,ip) = stiffness(ip,ip) + k2;
    stiffness(iu,iu) = stiffness(iu,iu) + k3;
    stiffness(iw,iu) = stiffness(iw,iu) + k4;
    stiffness(iu,iw) = stiffness(iu,iw) + k4;
    mass(iw,iw) = mass(iw,iw) + m1;
    mass(ip,ip) = mass(ip,ip) + m2;
    mass(iu,iu) = mass(iu,iu) + m4;
    mass(iw,ip) = mass(iw,ip) + m3;
    mass(ip,iw) = mass(ip,iw) + m3';
    mass(iu,ip) = mass(iu,ip) + m5;
    mass(ip,iu) = mass(ip,iu) + m5';
end
