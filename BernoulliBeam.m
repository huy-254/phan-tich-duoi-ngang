%................................................................
function[stiffness,mass]=...
    BernoulliBeam(GDof,numberElements,LElem,EI,rhoA,GIp,Im,e,EIz,EIxz,ez)
% Dam Euler-Bernoulli uon dung + uon ngang + xoan
%   Bac tu do moi nut: [w theta phi u psi]
%       w, theta = dw/dy : do vong theo z va goc xoay uon dung
%       phi              : goc xoan
%       u, psi = du/dy   : chuyen vi theo x (huong ve phia truoc) va goc xoay uon ngang
%   EI, GIp : do cung uon dung, do cung xoan
%   rhoA, Im: khoi luong tren don vi dai, mo men quan tinh khoi luong xoan
%   e       : do lech tam theo day cung tu truc dan hoi toi trong tam (m), > 0 khi trong tam o sau
%   EIz     : do cung uon ngang (quanh truc z)
%   EIxz    : do cung uon xien, U = 1/2*int(EI*w''^2 + 2*EIxz*w''*u'' + EIz*u''^2)
%   ez      : do lech theo z tu truc dan hoi toi trong tam (m), > 0 khi trong tam o tren
%   (chuyen vi trong tam: w - e*phi, u - ez*phi)
%   Tat ca la gia tri tren tung phan tu.
mass=zeros(GDof);
stiffness=zeros(GDof);
% calculation of the system stiffness matrix and mass
for j=1:numberElements
    % elementDof:element degrees of freedom(Dof)
    elementDof=(j*5-4:(j+1)*5);
    iw=elementDof([1 2 6 7]);  % w, theta
    ip=elementDof([3 8]);      % phi
    iu=elementDof([4 5 9 10]); % u, psi

    H=1/(LElem)^3*[12 6*LElem -12 6*LElem;
        6*LElem 4*LElem^2 -6*LElem 2*LElem^2;
        -12 -6*LElem 12 -6*LElem;
        6*LElem 2*LElem^2 -6*LElem 4*LElem^2];
    k1=EI(j)*H;   % uon dung
    k2=GIp(j)/LElem*[1 -1; -1 1];
    k3=EIz(j)*H;  % uon ngang
    k4=EIxz(j)*H; % uon xien

    Mh=LElem/420*[156 22*LElem 54 -13*LElem;
        22*LElem 4*LElem^2 13*LElem -3*LElem^2;
        54 13*LElem 156 -22*LElem;
        -13*LElem -3*LElem^2 -22*LElem 4*LElem^2];
    Nc=LElem*[7/20 3/20;
        1/20*LElem 1/30*LElem;
        3/20 7/20;
        -1/30*LElem -1/20*LElem]; % tich phan N_w^T*N_phi
    m1=rhoA(j)*Mh;
    m2=Im(j)*LElem*[1/3 1/6; 1/6 1/3];
    m3=-rhoA(j)*e(j)*Nc;  % lien ket uon dung - xoan
    m4=-rhoA(j)*ez(j)*Nc; % lien ket uon ngang - xoan

    % stiffnes and mass matrices
    stiffness(iw,iw)=stiffness(iw,iw)+k1;
    stiffness(ip,ip)=stiffness(ip,ip)+k2;
    stiffness(iu,iu)=stiffness(iu,iu)+k3;
    stiffness(iw,iu)=stiffness(iw,iu)+k4;
    stiffness(iu,iw)=stiffness(iu,iw)+k4;
    mass(iw,iw)=mass(iw,iw)+m1;
    mass(ip,ip)=mass(ip,ip)+m2;
    mass(iu,iu)=mass(iu,iu)+m1;
    mass(iw,ip)=mass(iw,ip)+m3;
    mass(ip,iw)=mass(ip,iw)+m3';
    mass(iu,ip)=mass(iu,ip)+m4;
    mass(ip,iu)=mass(ip,iu)+m4';
end
