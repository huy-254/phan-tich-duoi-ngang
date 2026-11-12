function M = mac(PhiA, PhiB)
    % B1. Kiem tra kich thuoc: hai bo mode phai co cung so bac tu do
    if size(PhiA,1) ~= size(PhiB,1)
        error('mac: PhiA co %d hang nhung PhiB co %d hang - phai cung so bac tu do.',...
            size(PhiA,1), size(PhiB,1));
    end

    % B2. Tu so: tich vo huong cua moi cap mode (i,j) cung luc
    %   (PhiA' * PhiB)(i,j) = PhiA(:,i)' * PhiB(:,j)  -> mA x mB
    %   Dung ' (chuyen vi lien hop) de dung ca khi vector la so phuc.
    num = abs(PhiA' * PhiB).^2;

    % B3. Mau so: chuan binh phuong tung cot, ghep thanh ma tran mA x mB
    %   nA(i) = PhiA(:,i)'*PhiA(:,i),  nB(j) = PhiB(:,j)'*PhiB(:,j)
    %   nA.' * nB (tich ngoai: cot x hang) cho ma tran co phan tu (i,j) = nA(i)*nB(j)
    nA = sum(abs(PhiA).^2, 1);   % 1 x mA
    nB = sum(abs(PhiB).^2, 1);   % 1 x mB
    den = nA.' * nB;             % mA x mB

    % B4. MAC
    M = num ./ den;
end
