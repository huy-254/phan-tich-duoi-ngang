function [w, phi, u] = beam_mode_at_stations(V, y_nodes, ys)
% BEAM_MODE_AT_STATIONS - Lay [w, phi, u] cua mode dam tai cac tram y bat ky
%
%   V       : GDof x nMode, vector rieng dam (Vf), 5 DOF/nut [w theta phi u psi]
%   y_nodes : toa do y cac nut dam, tang dan (y_full)
%   ys      : toa do y cac tram can lay (nS diem)
%   w, phi, u : nS x nMode
%
% Hàm này lấy chính xác [w, phi, u] từ mô hình dầm EB
% tại cùng các vị trí trạm ys đó để đối chiếu với FEM
% (Do các mặt cắt bên FEM có thể không trùng với các mặt cắt bên lý thuyết dầm)

    y_nodes = y_nodes(:);
    ys = ys(:);
    nNode = numel(y_nodes);

    if size(V,1) ~= 5*nNode
        error('beam_mode_at_stations: V co %d hang, can 5*%d = %d (5 DOF/nut).',...
            size(V,1), nNode, 5*nNode);
    end
    if any(ys < y_nodes(1) | ys > y_nodes(end))
        error('beam_mode_at_stations: co tram nam ngoai [%g, %g].', y_nodes(1), y_nodes(end));
    end

    % Tach DOF theo nut: moi ma tran nNode x nMode
    W     = V(1:5:end,:);
    THETA = V(2:5:end,:);
    PHI   = V(3:5:end,:);
    U     = V(4:5:end,:);
    PSI   = V(5:5:end,:);

    % Phan tu chua tung tram (nut trai e, nut phai e+1) va toa do cuc bo xi in [0, 1]
    e  = discretize(ys, y_nodes);        % tram o nut cuoi -> phan tu cuoi (xi = 1)
    L  = y_nodes(e+1) - y_nodes(e);
    xi = (ys - y_nodes(e)) ./ L;         % nS x 1

    % Ham dang Hermite (nS x 1)
    N1 = 1 - 3*xi.^2 + 2*xi.^3;
    N2 = L.*(xi - 2*xi.^2 + xi.^3);
    N3 = 3*xi.^2 - 2*xi.^3;
    N4 = L.*(-xi.^2 + xi.^3);

    % Noi suy (cot nS x 1 nhan ma tran nS x nMode -> tu mo rong theo cot)
    w   = N1.*W(e,:) + N2.*THETA(e,:) + N3.*W(e+1,:) + N4.*THETA(e+1,:);
    u   = N1.*U(e,:) + N2.*PSI(e,:)   + N3.*U(e+1,:) + N4.*PSI(e+1,:);
    phi = (1 - xi).*PHI(e,:) + xi.*PHI(e+1,:);
end
