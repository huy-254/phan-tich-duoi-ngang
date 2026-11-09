# Phân tích kết cấu đuôi ngang UAV (composite)

Bộ script MATLAB tính kết cấu đuôi ngang composite của UAV dạng twin boom theo mô hình **dầm tương đương**. Cụm đuôi có dạng chữ U (đuôi ngang + hai đuôi đứng). Khi phân tích riêng, đuôi ngang được **ngàm chặt tại hai đầu mút** y = ±1.5 m.

1. Với từng mặt cắt dọc sải: tính đặc trưng mặt cắt (khối lượng, EI, GJ, mômen quán tính khối lượng Im, tâm cứng x_E, trọng tâm xc), nội lực và hệ số an toàn (HSAT) của từng chi tiết.
2. Ghép các mặt cắt thành dầm uốn–xoắn liên kết cho **toàn bộ đuôi ngang** (đối xứng qua y = 0). Dầm gồm uốn đứng (theo z), uốn ngang trong mặt phẳng dây cung (quanh trục z) và xoắn. Giải FEM để lấy tần số riêng, dạng dao động và độ võng tĩnh.

Project được tạo từ project cánh chính (xem `readme.txt`). Khác với cánh chính, đuôi ngang không chia thành cánh giữa (không gia cường) và cánh ngoài (có gia cường): toàn bộ sải đều có dải gia cường vỏ. Vì vậy `cross_section_analysis_DN.m` không còn cờ `reinf`, dải gia cường luôn được tính.

## Chạy chương trình

Mở MATLAB, chuyển thư mục làm việc về thư mục này rồi chạy:

```matlab
main_DN
```

Kết quả gồm:
- bảng tần số riêng in ra Command Window, cho biết mỗi dạng là đối xứng hay phản đối xứng và nhóm bậc tự do chiếm ưu thế;
- tổng khối lượng đuôi ngang;
- một figure 3D cho mỗi dạng dao động (`modeNumber_f` = 20);
- file `equivalent_beam_DN.txt` chứa thông số dầm tương đương của toàn đuôi.

Các biến kết quả khác nằm trong workspace (xem [Biến kết quả chính](#biến-kết-quả-chính)).

## Hình học và tải

| Thông số | Giá trị |
|---|---|
| Profile | NACA 0015 (`upper_point_DN.dat`, `lower_point_DN.dat`, gốc `naca0015-il.csv`) |
| Dây cung | 0.55 m, không đổi (hình chữ nhật) |
| Sải | 3.0 m (y = −1.5 … 1.5 m), tính trên nửa phải y = 0 … 1.5 m, bước `dy` = 0.02 m |
| Liên kết | Ngàm tại y = ±`fix_loc` = ±1.5 m (đầu mút, nối với đuôi đứng/boom) |
| Sườn | y = −1.5, −1.2, 0, 1.2, 1.5 m |
| Dầm trước / dầm sau | `x_spar_1` = 0.1618, `x_spar_2` = 0.6909 (phần dây cung tính từ mép trước) |
| Dải gia cường vỏ | `d_reinf_1` = 40 mm (dầm trước), `d_reinf_2` = 42 mm (dầm sau), trên toàn sải |

`aerodynamic_load.txt` chứa các **lực tập trung cho toàn đuôi ngang, đã nhân hệ số**, dạng `[y (m)  F (N)]`. `main_DN.m` chỉ lấy các lực ở y ≥ 0. Lực tại y = 0 được chia đôi cho hai nửa đuôi. Tải phân bố `F_dist` (dùng tính nén/cắt sườn) có được bằng cách rải đều mỗi lực trên vùng ảnh hưởng của nó, tức là giữa các trung điểm với điểm đặt lực lân cận.

## Nội lực của dầm ngàm hai đầu

Dầm ngàm hai đầu là bài toán siêu tĩnh. Do tải và kết cấu đối xứng, tại y = 0 lực cắt, mômen xoắn và góc nghiêng uốn đều bằng 0. `main_DN.m` vì vậy chạy vòng lặp mặt cắt **2 lượt**:

1. **Lượt 1**: chưa có phản lực (`F_react = M_react = M_fix = 0`). Lượt này lấy `m_airfoil`, `EI`, `x_E` (x_E không phụ thuộc độ lớn tải) cùng nội lực do tải phía ngoài mặt cắt. Sau đó tính phản lực tại đầu mút y = `fix_loc`:
   - `F_react = -F_shear(1)` và `M_react = -M_t(1)`, từ điều kiện lực cắt và mômen xoắn tại y = 0 bằng 0;
   - `M_fix` (mômen ngàm), từ điều kiện ∫ M_b/EI dy = 0 trên [0, `fix_loc`] (góc nghiêng tại y = 0 và tại ngàm đều bằng 0).
2. **Lượt 2**: tính lại `M_b`, `F_shear`, `M_t`, ứng suất và HSAT với các phản lực trên.

Trong `cross_section_analysis_DN.m`:

```
M_b     = (tải phía ngoài) + F_react*(fix_loc - y) + M_fix
F_shear = (tải phía ngoài) + F_react
M_t     = (tải phía ngoài) + M_react
```

## Luồng tính toán

```
main_DN.m
├── material_2D.m        tính chất lớp sợi carbon UD (gọi ply.m, laminate.m, THstrength.m)
├── PVC_Foam.m           tính chất lõi foam PVC
├── hình học, vị trí sườn, airfoil, tải khí động
├── 2 lượt × vòng lặp ii = n → 1 (đầu mút → giữa)
│   └── cross_section_analysis_DN.m      (script, dùng chung workspace)
│       ├── laminate.m                   ma trận A, D của tấm lớp
│       ├── shear_center.m, shear_flow.m dòng cắt, tâm cứng, GJ (mặt cắt 3 ngăn)
│       ├── shear_stiffness.m            độ cứng cắt ngang kGA (cho dầm Timoshenko)
│       ├── THstrength.m                 HSAT theo Tsai-Hill
│       └── vonMises.m, eq_strain.m
└── coupled_beam.m                       dầm uốn–xoắn toàn đuôi, ngàm tại ±fix_loc
    └── TimoshenkoBeam.m                 ma trận độ cứng & khối lượng (đang dùng)
        (BernoulliBeam.m: phương án Euler-Bernoulli, đang comment)
```

Vòng lặp chạy **từ đầu mút về giữa** vì lực cắt `F_shear(ii)` và mômen xoắn `M_t(ii)` tại mặt cắt `ii` được tích lũy từ tải của các mặt cắt phía ngoài (`ii+1:end`).

## Mô tả các file

### Script chính

| File | Vai trò |
|---|---|
| `main_DN.m` | Điểm vào. Khai báo hình học, vị trí sườn, tải, vị trí dầm, bề dày lõi, bề rộng side cap và dải gia cường. Chạy 2 lượt qua các mặt cắt; gọi `coupled_beam`, in tần số, vẽ dạng dao động và ghi `equivalent_beam_DN.txt`. |
| `cross_section_analysis_DN.m` | **Script** (không phải hàm) chạy cho mặt cắt `ii`. Định nghĩa xếp lớp của vỏ, vỏ gia cường, dầm trước/sau, mũ dầm, side cap và sườn. Tính khối lượng & trọng tâm, EI, EI_z, EI_xz, EA, nội lực, ứng suất/biến dạng, HSAT, ổn định vỏ và sườn, tâm cứng, GJ, kGA, Im. |
| `coupled_beam.m` | Lấy đối xứng dữ liệu nửa phải sang toàn đuôi, lắp ráp FEM, ngàm cả 5 bậc tự do tại y = ±`fix_loc`, giải trị riêng và bài toán tĩnh; phân loại mode đối xứng / phản đối xứng. |

### Phân vùng xếp lớp vỏ (trong `cross_section_analysis_DN.m`)

| Vùng | Vỏ | Vỏ gia cường |
|---|---|---|
| \|y\| < 1.45 m | 1woven/F5/1woven | 1woven/4UD/1woven |
| \|y\| ≥ 1.45 m (50 mm sát ngàm) | 4woven | 2woven/4UD/2woven |

Woven = 2 lớp UD ±45°. Dầm, mũ dầm, side cap và sườn dùng một xếp lớp cho toàn sải.

### Hàm

| File | Vai trò |
|---|---|
| `TimoshenkoBeam.m` | Ma trận độ cứng và khối lượng của phần tử dầm Timoshenko uốn đứng + uốn ngang + xoắn (Friedman & Kosmatka 1993). Biến dạng cắt chỉ kể cho uốn đứng. Với `kGA = Inf`, `rhoI = 0` thì trùng với `BernoulliBeam`. |
| `BernoulliBeam.m` | Phần tử dầm Euler-Bernoulli. Mỗi nút có 5 bậc tự do `[w, w', φ, u, u']`; có liên kết độ cứng uốn xiên `EI_xz` và liên kết quán tính uốn–xoắn qua độ lệch tâm `e` (theo dây cung) và `e_z` (theo z). |
| `laminate.m` | Ma trận A, D của tấm composite nhiều lớp (Gibson ch. 7). |
| `ply.m` | Tính chất lớp UD từ sợi + nền (cơ học vi mô, Gibson). |
| `THstrength.m` | Hệ số an toàn theo tiêu chuẩn Tsai-Hill cho từng lớp. |
| `shear_center.m` | Vị trí tâm cứng của mặt cắt kín 3 ngăn. |
| `shear_flow.m` | Dòng cắt 3 ngăn và độ cứng xoắn GJ (Megson eq. 23.10, 23.12). |
| `shear_stiffness.m` | Độ cứng cắt ngang hiệu dụng kGA của mặt cắt 3 ngăn (cân bằng năng lượng). |
| `vonMises.m`, `eq_strain.m` | Ứng suất von Mises và biến dạng tương đương. |

### Vật liệu

| File | Nội dung | Được dùng? |
|---|---|---|
| `material_2D.m` | Sợi AS4 + epoxy 3501-6 → lớp UD (`*_UD`); woven được mô hình bằng 2 lớp UD ±45° | Có |
| `PVC_Foam.m` | Lõi foam PVC (`*_core`) | Có |
| `RC200.m` | Sợi T700s + nền F201-10 | Không (phương án thay thế) |
| `material_3D.m`, `ply3D.m`, `laminate3D.m`, `test_laminate3D.m` | Phiên bản 3D | Không (chưa gắn vào luồng chính) |

Xếp lớp trong `cross_section_analysis_DN.m` được viết dạng chuỗi, ví dụ `'[par_UD*ones(1,2) par_core par_UD*ones(1,2)]'`, rồi thay `par` bằng `E1`, `E2`, `G12`, `rho`, `t`... Vì vậy tên biến vật liệu phải theo đúng mẫu `<thuộc tính>_<vật liệu>` (ví dụ `E1_UD`, `t_core`).

### Dữ liệu đầu vào

| File | Nội dung |
|---|---|
| `upper_point_DN.dat`, `lower_point_DN.dat` | Tọa độ NACA 0015 mặt trên/dưới, 3 cột `[x 0 z]` (mm, dây cung 550 mm). `main_DN.m` lấy cột 1 và 3 rồi chuẩn hóa về dây cung = 1. |
| `aerodynamic_load.txt` | Lực tập trung `[y (m)  F (N)]` cho toàn đuôi ngang, đã nhân hệ số. |

### Kết quả

`equivalent_beam_DN.txt` chứa thông số dầm tương đương cho toàn đuôi (y = −1.5 … 1.5 m), gồm các cột `y, c, x_LE, EI, GJ, EA, m, Im, x_E, x_C, EI_z, EI_xz, x_N, z_E, z_C`. x_E, x_C, x_N tính theo phần dây cung từ mép trước; z_E, z_C theo phần dây cung trong hệ tọa độ airfoil.

### Mô hình shell APDL để kiểm chứng

`gen_apdl_DN.py` sinh file `DN_shell.inp`: mô hình shell nhiều lớp (SHELL181) cho toàn đuôi ngang. Mô hình dùng cùng profile, vị trí dầm, bề rộng side cap / dải gia cường và xếp lớp như `cross_section_analysis_DN.m`, ngàm chặt tại y = ±1.5 m. Chạy:

```
py -3 gen_apdl_DN.py      (cần numpy; đọc upper/lower_point_DN.dat, aerodynamic_load.txt)
```

Script in khối lượng theo TYPE. Với `DN_shell.inp`, có thể chạy batch hoặc `/INPUT` trong MAPDL. File gồm phân tích tĩnh (tải khí động: 80% vào bụng dầm trước, 20% vào bụng dầm sau, cộng trọng lượng bản thân) và phân tích modal 12 mode. Kết quả ghi vào `DN_results.txt`. Hướng 0° của các lớp nằm dọc sải, qua hệ tọa độ `LOCAL,11`. Khi đổi xếp lớp trong MATLAB, cần sửa tương ứng các hàm `skin`, `SKR`, `cap1`, `cap2`, `side1/2`, `web1/2`, `rib` trong script.

### File thừa hưởng từ project cánh chính

- `gen_apdl_wing_cothem_option_luachonngam.py`: sinh mô hình shell APDL cho **cánh chính**.
- `APDL_code_wing_DN_shell.inp`: file APDL cũ sinh cho cánh chính; tiêu đề ghi cánh CW.

## Thông số cần chỉnh thường gặp (trong `main_DN.m`)

| Biến | Ý nghĩa | Giá trị hiện tại |
|---|---|---|
| `dy`, `y_coord` | Bước lưới và tọa độ nửa sải (m) | 0.02; 0 → 1.5 |
| `c_length`, `x_LE` | Dây cung và tọa độ mép trước | 0.55 m, không đổi |
| `y_rib` | Vị trí sườn (m) | [−1.5 −1.2 0 1.2 1.5] |
| `fix_loc` | Vị trí ngàm, đối xứng ±y (m) | 1.5 |
| `x_spar_1`, `x_spar_2` | Vị trí dầm trước/sau (phần dây cung) | 0.1618; 0.6909 |
| `core_thickness_*` | Bề dày lõi vỏ / sườn / dầm trước / dầm sau (m) | 0.005; 0.01; 0.014; 0.016 |
| `d_side_cap_*` | Bề rộng mũ mở rộng (m, trong vòng lặp chia cho `scale`) | 0.011148; 0.011225 |
| `d_reinf_*` | Bề rộng dải gia cường vỏ (m, trong vòng lặp chia cho `scale`) | 0.040; 0.042 |
| `n_load` | Hệ số tải cho trọng lượng bản thân | 1 |
| `modeNumber_f` | Số dạng dao động cần lấy | 20 |

Chọn mô hình dầm trong `coupled_beam.m`: đang dùng `TimoshenkoBeam` vì đuôi ngang có độ giãn dài nhỏ. Để dùng Euler-Bernoulli, bỏ comment lệnh gọi `BernoulliBeam`.

## Biến kết quả chính

Theo nửa phải, chỉ số `ii` ứng với `y_coord(ii)`:

| Biến | Ý nghĩa |
|---|---|
| `m_airfoil` | Khối lượng trên đơn vị dài (kg/m) |
| `EI`, `GJ`, `EA` | Độ cứng uốn đứng (quanh trục x), độ cứng xoắn, độ cứng kéo–nén |
| `EI_z`, `EI_xz` | Độ cứng uốn ngang (quanh trục z), độ cứng uốn xiên giữa hai mặt phẳng |
| `kGA`, `rhoI` | Độ cứng cắt ngang, quán tính xoay mặt cắt quanh trục uốn (dầm Timoshenko) |
| `x_N`, `z_E`, `zc_airfoil` | Trục trung hòa theo phương dây cung, trục trung hòa theo z, cao độ trọng tâm (phần dây cung) |
| `Im` | Mômen quán tính khối lượng xoắn |
| `x_E`, `xc_airfoil` | Tâm cứng, trọng tâm (phần dây cung tính từ mép trước) |
| `F_shear`, `M_b`, `M_t` | Lực cắt, mômen uốn, mômen xoắn (đã kể phản lực ngàm) |
| `F_react`, `M_react`, `M_fix` | Phản lực, mômen xoắn phản lực, mômen ngàm tại đầu mút phải |
| `f_u_skin`, `f_l_spar_1`, `f_u_cap_1`, `f_rib`, ... | HSAT Tsai-Hill theo lớp, kích thước `n × 100` (cột = số thứ tự lớp) |

Theo toàn đuôi (`coupled_beam.m`), nút trung tâm y = 0 có chỉ số `n_half`:

| Biến | Ý nghĩa |
|---|---|
| `y_full`, `c_full`, `x_E_full`, ... | Dữ liệu đã lấy đối xứng |
| `Df` | Tần số riêng (Hz), tăng dần |
| `Vf` | Dạng dao động. Nút `i` có `w = Vf(5i-4)`, `w' = Vf(5i-3)`, `φ = Vf(5i-2)`, `u = Vf(5i-1)`, `u' = Vf(5i)` (`u` theo phương x, hướng về phía trước) |
| `mode_type`, `mode_kind`, `mode_energy` | Đối xứng / phản đối xứng; dạng chiếm ưu thế (uốn đứng / xoắn / uốn ngang) và tỷ lệ động năng tương ứng |
| `deflection` | Chuyển vị tĩnh dưới tải, cùng cách đánh chỉ số |

## Lưu ý

- `cross_section_analysis_DN.m` và các file vật liệu là **script**, dùng chung workspace với `main_DN.m`. Đặt tên biến mới cẩn thận để không ghi đè biến đang dùng (ví dụ `n`, `ii`, `pass`, `scale`, `stack`).
- `coupled_beam.m` trừ `F_react`, `M_react` ra khỏi `F_shear`, `M_t` để lấy tải ngoài đặt vào nút, vì trong mô hình FEM toàn đuôi phản lực do ngàm tại ±`fix_loc` tự sinh ra.
- Các file `*.asv` là bản autosave của MATLAB, có thể bỏ qua.

## Tài liệu tham khảo dùng trong mã

- R. F. Gibson, *Principles of Composite Material Mechanics*: cơ học vi mô, tấm lớp.
- I. M. Daniel, O. Ishai, *Engineering Mechanics of Composite Materials*: số liệu vật liệu (Table A.3).
- T. H. G. Megson, *Aircraft Structures for Engineering Students*: dòng cắt, tâm cứng, dầm thuôn (ch. 20, 23).
- Chizhov: ứng suất trung bình (eq. 2.24).
- J. Friedman, J. B. Kosmatka (1993): phần tử dầm Timoshenko chính xác.
