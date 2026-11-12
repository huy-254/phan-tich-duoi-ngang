function [q, residual] = fit_section_motion(x, z, ux, uz, x_EA, z_EA)

    % Thuật toán rút gọn chuyển vị mặt cắt dầm (Beam Section Kinematics Reduction / Rigid-Section Least-Squares Fit)
    % Hàm chiếu chuyển vị 3D (từ mô hình FEM) về 3 bậc tự do của một mặt cắt cứng tại tâm đàn hồi
    % đồng thời tính toán sai số dư để đánh giá mức độ biến dạng cục bộ


    % Dua toa do ve vector cot (phong khi truyen vao vector hang)
    x = x(:);
    z = z(:);
    nN = numel(x);

    % Kiem tra kich thuoc dau vao
    if numel(z) ~= nN || size(ux,1) ~= nN || size(uz,1) ~= nN
        error('fit_section_motion: x, z, ux, uz phai cung so nut (so hang), dang co %d, %d, %d, %d.',...
            nN, numel(z), size(ux,1), size(uz,1));
    end
    if ~isequal(size(ux), size(uz))
        error('fit_section_motion: ux va uz phai cung kich thuoc (nN x nMode).');
    end
    if nN < 2
        error('fit_section_motion: can it nhat 2 nut de xac dinh 3 an [w; phi; u].');
    end

    % B1. Khoang cach tuong doi tu truc dan hoi
    dx = x - x_EA;      % > 0: nut nam phia truoc truc dan hoi
    dz = z - z_EA;      % > 0: nut nam phia tren truc dan hoi

    % B2. Ma tran he so A (2*nN x 3), an so [w; phi; u]
    %   nN hang dau: phuong trinh uz_i = w + phi*dx_i
    %   nN hang sau: phuong trinh ux_i = u - phi*dz_i
    A = [ones(nN,1)    dx  zeros(nN,1);
         zeros(nN,1)  -dz  ones(nN,1)];

    % B3. Ve phai: moi cot la 1 mode,
    % xep cung thu tu hang voi A: nN hàng đầu là uz, nN hàng sau là ux
    b = [uz; ux];       % 2*nN x nMode

    % B4. Binh phuong toi thieu cho tat ca mode cung luc
    %   A giong nhau cho moi mode -> '\' giai 1 lan cho ca ma tran b
    %   (A co 2*nN >= 3 hang nen '\' tu dung QR Decomposition, cho nghiem binh phuong toi thieu)
    q = A \ b;          % 3 x nMode

    % B5. Phan du tuong doi: phan chuyen vi khong giai thich duoc bang
    %   chuyen dong cung cua tiet dien
    r = b - A*q;
    norm_b = vecnorm(b);                % 1 x nMode
    residual = vecnorm(r) ./ norm_b;
    residual(norm_b == 0) = 0;               % mode co chuyen vi = 0 tai tram nay (tranh 0/0 = NaN)
end
