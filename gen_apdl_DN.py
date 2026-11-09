# -*- coding: utf-8 -*-
"""
Sinh file APDL (ANSYS 2023) mo hinh shell nhieu lop cho toan bo duoi ngang DN,
dung truc tiep du lieu va xep lop trong main_DN.m / cross_section_analysis_DN.m.
Duoi ngang ngam chat tai hai dau y = +-FIX_Y (cum duoi chu UD, twin boom).
Chay:  py -3 gen_apdl_DN.py   -> tao DN_shell.inp
"""
import numpy as np

# ---------------------------------------------------------------- tham so
OUT        = 'DN_shell.inp'
RES        = 'DN_results'      # file ket qua APDL ghi ra (DN_results.txt)
DY_MAX     = 0.025         # buoc luoi doc sai lon nhat (m)
N_LE, N_MID, N_AFT = 12, 16, 10   # so phan tu: mep truoc->dai gia cuong truoc, giua 2 dam, dam sau->mep sau
N_FOAM     = 4             # so phan tu trong vung foam cua bung dam (them 4 phan tu: 2 vung vo + 2 vung mu)
NL         = N_FOAM + 4    # tong so phan tu theo chieu cao bung dam / rib
FIX_Y      = 1.5           # vi tri ngam hai dau (m), nhu fix_loc trong main_DN.m
NMODE      = 12
CHORD      = 0.55          # day cung (m), khong doi
XI1, XI2   = 0.1618, 0.6909                # vi tri tam dam (phan day cung tu mep truoc)
RIBS       = [0, 1200, 1500]               # vi tri suon (mm), lay doi xung
Y_TIPZ     = 1.45          # |y| >= Y_TIPZ: vung xep lop sat ngam
W_REINF1, W_REINF2 = 0.040, 0.042          # be rong dai vo gia cuong dam truoc / sau (m)
S1, S2     = 0.011148, 0.011225            # be rong side cap dam truoc / sau (m)
CORE_SKIN, CORE_RIB, CORE_SP1, CORE_SP2 = 0.005, 0.010, 0.014, 0.016
FRONT_SHARE = 0.8          # ty le tai dat vao dam truoc (nhu M_t trong cross_section_analysis_DN.m)
G_ACC      = 9.81          # trong luong ban than (n_load = 1)

# vat lieu (giong material_2D.m / ply.m / ply3D.m 'foye')
E1f, E2f, G12f, nu12f, rhof, vf = 235e9, 15e9, 27e9, 0.2, 1810.0, 0.63
Em, G12m, num, rhom = 4.3e9, 1.6e9, 0.35, 1270.0
nu23f = 0.4
sv = np.sqrt(vf)
E1 = E1f*vf + Em*(1-vf)
E2 = Em*((1-sv) + sv/(1-sv*(1-Em/E2f)))
G12 = G12m*((1-sv) + sv/(1-sv*(1-G12m/G12f)))
nu12 = nu12f*vf + num*(1-vf)
nu23 = vf*nu23f + (1-vf)*(2*num - nu12*E2/E1)
G23 = E2/(2*(1+nu23))
RHO_UD = rhof*vf + rhom*(1-vf)
T_UD = 0.3/rhof/vf
E_F, NU_F, RHO_F = 70e6, 0.3, 60.0     # PVC_Foam.m

# ---------------------------------------------------------------- hinh hoc
# NACA 0015, file 3 cot [x 0 zoneID] (mm), chuan hoa theo day cung (nhu main_DN.m)
def load_af(fn):
    a = np.loadtxt(fn)[:, [0, 2]]
    a = a[np.argsort(a[:, 0])]
    return a/a[:, 0].max()
up_raw = load_af('upper_point_DN.dat')
lo_raw = load_af('lower_point_DN.dat')
def zu(xi): return np.interp(xi, up_raw[:, 0], up_raw[:, 1])
def zl(xi): return np.interp(xi, lo_raw[:, 0], lo_raw[:, 1])

def chord(y): return CHORD
def xle(y):   return CHORD
def zone(ya):           # 1 = phan giua, 2 = vung sat ngam (theo |y| cua tam phan tu)
    return 1 if ya < Y_TIPZ else 2

# Tai khi dong: luc tap trung [y F] cho toan duoi ngang, da nhan he so
LOADS = np.atleast_2d(np.loadtxt('aerodynamic_load.txt'))

# be rong (m): hop dam = chieu day sandwich bung dam; side cap mot ben, huong vao trong
def widths(zoneID):
    w1 = 16*T_UD + CORE_SP1
    w2 = 16*T_UD + CORE_SP2
    return w1, w2, S1, S2

def xi_list(y, zoneID):
    c = chord(y); w1, w2, s1, s2 = widths(zoneID)
    c1a, c1b = XI1 - w1/2/c, XI1 + w1/2/c
    s1b = c1b + s1/c
    s2a = XI2 - w2/2/c - s2/c
    c2a, c2b = XI2 - w2/2/c, XI2 + w2/2/c
    # dai gia cuong dat doi xung tren (mu + side cap), nhu x_reinf trong MATLAB
    m1, m2 = (c1a+s1b)/2, (s2a+c2b)/2
    r1a, r1b = m1 - W_REINF1/2/c, m1 + W_REINF1/2/c
    r2a, r2b = m2 - W_REINF2/2/c, m2 + W_REINF2/2/c
    br = [0, r1a, c1a, XI1, c1b, s1b, r1b, r2a, s2a, c2a, XI2, c2b, r2b, 1.0]
    assert all(np.diff(br) > 0), (y, br)
    xs = [0.0]
    # S0: cum cosine ve mep truoc
    s = np.linspace(0, 1, N_LE+1)[1:]
    xs += list(r1a*(1-np.cos(np.pi*s/2)))
    for a, b in zip(br[1:6], br[2:7]): xs.append(b)          # S1..S5 (1 phan tu moi doan)
    xs += list(np.linspace(r1b, r2a, N_MID+1)[1:])           # S6
    for a, b in zip(br[7:12], br[8:13]): xs.append(b)        # S7..S11
    xs += list(np.linspace(r2b, 1.0, N_AFT+1)[1:])           # S12
    return np.array(xs)

# phan doan (segment) cua phan tu k (giua xi_k va xi_k+1)
SEG = [0]*N_LE + [1, 2, 3, 4, 5] + [6]*N_MID + [7, 8, 9, 10, 11] + [12]*N_AFT
M = len(SEG)
K1 = N_LE + 2           # chi so xi cua tam dam truoc
K2 = N_LE + 5 + N_MID + 3
REGION = {0:'plain', 6:'plain', 12:'plain', 1:'reinf', 5:'reinf', 7:'reinf', 11:'reinf',
          2:'cap1', 3:'cap1', 4:'side1', 8:'side2', 9:'cap2', 10:'cap2'}

# ---------------------------------------------------------------- xep lop (cross_section_analysis_DN.m)
P45, M45 = 45.0, -45.0
def W(n=1): return [('UD', T_UD, P45), ('UD', T_UD, M45)]*n     # woven = 2 lop UD +-45
def UD(n=1): return [('UD', T_UD, 0.0)]*n
def F(t):   return [('F', t, 0.0)]
def skin(zoneID):                # ngoai -> trong
    if zoneID == 1: return W() + F(CORE_SKIN) + W()                   # 1woven/F5/1woven
    return W(4)                                                  # 4woven
def SKR(zoneID):                 # vo gia cuong
    if zoneID == 1: return W() + UD(4) + W()                           # 1woven/4UD/1woven
    return W(2) + UD(4) + W(2)                                    # 2woven/4UD/2woven
def cap(nrep): return (W() + UD(4))*nrep + W()
def cap1(zoneID, upper): return cap(3)                                # 3(CDB400/4CU300)/CDB400
def cap2(zoneID, upper): return cap(2)                                # 2(CDB400/4CU300)/CDB400
def side1(zoneID): return W(4)
def side2(zoneID): return W(4)
def skin_lam(zoneID, region, upper):
    if region == 'plain': return skin(zoneID)
    base = SKR(zoneID)           # dai gia cuong phu ca vung mu dam va side cap
    if region == 'reinf': return base
    if region == 'cap1':  return base + cap1(zoneID, upper)
    if region == 'cap2':  return base + cap2(zoneID, upper)
    if region == 'side1': return base + side1(zoneID)
    if region == 'side2': return base + side2(zoneID)
def web1(zoneID): return W(4) + F(CORE_SP1) + W(4)                    # 4CDB400/foam/4CDB400
def web2(zoneID): return W(4) + F(CORE_SP2) + W(4)
def rib(zoneID):  return W(2) + F(CORE_RIB) + W(2)                    # 2woven/foam10/2woven

RHO = {'UD': RHO_UD, 'F': RHO_F, 'UD0': 0.0, 'F0': 0.0}
MATID = {'UD': 1, 'F': 2, 'UD0': 3, 'F0': 4}
def areal(lam): return sum(RHO[m]*t for m, t, _ in lam)
def massless(lam): return [(m + '0', t, th) for m, t, th in lam]

SECS = {}      # (tuple lam, offset) -> id
def secid(lam, off):
    key = (tuple(lam), off)
    if key not in SECS: SECS[key] = len(SECS) + 1
    return SECS[key]

def lam_t(lam): return sum(t for _, t, _ in lam)
def web_fracs(y, zoneID, w, zU, zL):
    # cao do cac muc nut tren bung dam: OML duoi, mat trong vo, mat trong mu, ...foam..., mat trong mu, mat trong vo, OML tren
    tsk = lam_t(SKR(zoneID))
    if w == 0: tcu, tcl = lam_t(cap1(zoneID, True)), lam_t(cap1(zoneID, False))
    else:      tcu, tcl = lam_t(cap2(zoneID, True)), lam_t(cap2(zoneID, False))
    H = zU - zL
    lv = [0.0, tsk, tsk+tcl] + list(np.linspace(tsk+tcl, H-tsk-tcu, N_FOAM+1)[1:-1]) + [H-tsk-tcu, H-tsk, H]
    f = np.array(lv)/H
    assert np.all(np.diff(f) > 0), (y, w, f)
    return f
def walls(w, zoneID): return W(4) + W(4)   # 2 thanh, khong foam

# ---------------------------------------------------------------- tram doc sai
yh = sorted(set([0.0, Y_TIPZ, FIX_Y] + [r/1000 for r in RIBS] + [abs(v) for v in LOADS[:, 0]]))
st = [yh[0]]
for a, b in zip(yh[:-1], yh[1:]):
    n = int(np.ceil((b-a)/DY_MAX - 1e-9))
    st += list(np.linspace(a, b, n+1)[1:])
st = np.array(st)
Y = np.concatenate([-st[:0:-1], st])
NS = len(Y)
NC = 2*M + 1           # so nut tren duong bao moi tram (vong kin)

nodes = {}             # id -> (x,y,zoneID)
def nid_c(j, i): return j*NC + i + 1                     # nut duong bao
# j: chi so mat cat doc sai
# i: chi so nut tren duong bao mat cat
# NC: so nut tren duong bao cua mot mat cat
NBASE_W = NS*NC
def nid_w(j, w, k):                                       # nut trong bung dam, k = 1..NL-1
    return NBASE_W + (j*2 + w)*(NL-1) + k
NBASE_R = NBASE_W + NS*2*(NL-1)

def contour(j):
    y = Y[j]; c = chord(y); xl = xle(y)
    zoneID = zone(abs(y))   # zone cua tram (dung cho vi tri nut)
    xs = xi_list(y, zoneID)
    pts = []
    for k in range(M, 0, -1): pts.append((xl - xs[k]*c, y, zu(xs[k])*c))   # tren: mep sau -> mep truoc
    pts.append((xl, y, 0.0))                                               # mep truoc
    for k in range(1, M+1):  pts.append((xl - xs[k]*c, y, zl(xs[k])*c))   # duoi: mep truoc -> mep sau
    return pts, xs

FR = {}
for j in range(NS):
    pts, xs = contour(j)
    for i, p in enumerate(pts): nodes[nid_c(j, i)] = p
    for w, K in enumerate([K1, K2]):
        pu = np.array(nodes[nid_c(j, M-K)]); pl = np.array(nodes[nid_c(j, M+K)])
        FR[j, w] = web_fracs(Y[j], zone(abs(Y[j])), w, pu[2], pl[2])
        for k in range(1, NL):
            nodes[nid_w(j, w, k)] = tuple(pl + (pu-pl)*FR[j, w][k])

def web_node(j, w, k):         # k = 0 (duoi) .. NL (tren)
    K = K1 if w == 0 else K2
    if k == 0: return nid_c(j, M+K)
    if k == NL: return nid_c(j, M-K)
    return nid_w(j, w, k)

# ---------------------------------------------------------------- phan tu
elems = []     # (type, sec, esys, n1..n4)
for j in range(NS-1):
    ya = abs((Y[j]+Y[j+1])/2); zoneID = zone(ya)
    for i in range(NC):
        n1, n2 = nid_c(j, i), nid_c(j, (i+1) % NC)
        n3, n4 = nid_c(j+1, (i+1) % NC), nid_c(j+1, i)
        if i == NC-1:                       # dai khep mep sau
            reg, upper = 'plain', True
        elif i < M:                         # mat tren: giua xi_(M-i) va xi_(M-i-1)
            reg, upper = REGION[SEG[M-i-1]], True
        else:                               # mat duoi: giua xi_(i-M) va xi_(i-M+1)
            reg, upper = REGION[SEG[i-M]], False
        lam = skin_lam(zoneID, reg, upper)
        etype = {'plain':1, 'reinf':4, 'cap1':2, 'cap2':2, 'side1':3, 'side2':3}[reg]
        elems.append((etype, secid(lam, 'TOP'), 11, n1, n2, n3, n4))
    for w in (0, 1):
        for k in range(NL):
            if 2 <= k < NL-2: lam = web1(zoneID) if w == 0 else web2(zoneID)   # vung foam
            elif k in (1, NL-2): lam = walls(w, zoneID)                   # vung mu: chi 2 thanh
            else: lam = massless(walls(w, zoneID))                        # trung voi chieu day vo: chi giu lien ket, khong khoi luong
            elems.append((5+w, secid(lam, 'MID'), 11, web_node(j, w, k), web_node(j, w, k+1),
                          web_node(j+1, w, k+1), web_node(j+1, w, k)))

# rib: mat phang y = hang so, chi giua tam hai dam
rib_y = sorted(set([r/1000 for r in RIBS] + [-r/1000 for r in RIBS]))
nr = NBASE_R
links = []     # (nut bung dam, nut mep rib) -> MPC184 rigid beam
for yr in rib_y:
    j = int(np.argmin(abs(Y - yr))); assert abs(Y[j]-yr) < 1e-9
    zoneID = zone(abs(yr))
    # phap tuyen rib huong +y: rib dau mut dat nut o mat ngoai (TOP tai +FIX_Y, BOT tai -FIX_Y)
    # de ca chieu day nam phia trong, khong lo ra ngoai dau mut vo
    roff = 'MID' if abs(abs(yr) - FIX_Y) > 1e-9 else ('TOP' if yr > 0 else 'BOT')
    sid = secid(rib(zoneID), roff)
    # rib chi chay giua hai dam: tu thanh sau dam truoc (xi = XI1 + w1/2, cot Ka)
    # den thanh truoc dam sau (xi = XI2 - w2/2, cot Kb)
    Ka, Kb = K1 + 1, K2 - 1
    grid = {}
    for K in range(Ka, Kb+1):
        pu = np.array(nodes[nid_c(j, M-K)]); pl = np.array(nodes[nid_c(j, M+K)])
        fr = FR[j, 0] + (FR[j, 1]-FR[j, 0])*(K-Ka)/(Kb-Ka)
        for k in range(NL+1):
            if k == 0: grid[K, k] = nid_c(j, M+K)
            elif k == NL: grid[K, k] = nid_c(j, M-K)
            else:
                nr += 1; nodes[nr] = tuple(pl + (pu-pl)*fr[k]); grid[K, k] = nr
    sid0 = secid(massless(rib(zoneID)), roff)
    for K in range(Ka, Kb):
        for k in range(NL):
            elems.append((7, sid0 if k in (0, NL-1) else sid, 0, grid[K, k], grid[K+1, k], grid[K+1, k+1], grid[K, k+1]))
    # noi mep rib voi nut bung dam (mat giua) bang dam cung MPC184; mep tren/duoi (k = 0, NL)
    # da chung nut voi vo. Rib dau mut: moi nut deu bi ngam nen khong can noi
    if roff == 'MID':
        for k in range(1, NL):
            links.append((web_node(j, 0, k), grid[Ka, k]))
            links.append((web_node(j, 1, k), grid[Kb, k]))

# ---------------------------------------------------------------- kiem tra trong Python
P = {n: np.array(p) for n, p in nodes.items()}
def quad_area_normal(e):
    a, b, c_, d = (P[n] for n in e[3:7])
    nv = np.cross(c_-a, d-b)/2
    return np.linalg.norm(nv), nv
inv_sec = {v: k for k, v in SECS.items()}
mass_type = {}
bad = 0
for e in elems:
    A, nv = quad_area_normal(e)
    assert A > 1e-8, e
    mass_type[e[0]] = mass_type.get(e[0], 0) + A*areal(inv_sec[e[1]][0])
    if e[0] <= 4:   # phap tuyen vo phai huong ra ngoai
        jy = P[e[3]][1]; j = int(np.argmin(abs(Y-jy)))
        cen = np.mean([P[nid_c(j, i)] for i in range(NC)], axis=0)
        ec = np.mean([P[n] for n in e[3:7]], axis=0)
        r = ec - cen; r[1] = 0
        if np.dot(nv, r) <= 0: bad += 1
assert bad == 0, f'{bad} phan tu vo co phap tuyen huong vao trong'
split = {'skin': 0.0, 'cap1': 0.0, 'cap2': 0.0, 'side': 0.0}
for e in elems:
    if e[0] in (2, 3):
        A, _ = quad_area_normal(e)
        lam = inv_sec[e[1]][0]
        zc = abs(np.mean([P[n][1] for n in e[3:7]])); zoneID = zone(zc)
        base = SKR(zoneID)
        split['skin'] += A*areal(base)
        xc = np.mean([P[n][0] for n in e[3:7]]); xi = (xle(zc) - xc)/chord(zc)
        key = 'side' if e[0] == 3 else ('cap1' if xi < 0.5 else 'cap2')
        split[key] += A*(areal(lam) - areal(base))
    elif e[0] in (1, 4):
        A, _ = quad_area_normal(e); split['skin'] += A*areal(inv_sec[e[1]][0])
TYPE_NAME = {1:'Vo thuong', 2:'Vo gia cuong + mu dam (truoc & sau)', 3:'Vo gia cuong + side cap',
             4:'Vo gia cuong (ngoai mu/side cap)', 5:'Bung dam truoc', 6:'Bung dam sau', 7:'Rib'}

# nut bung dam (dam truoc w = 0, dam sau w = 1) tai tram gan yt nhat
def station_web_nodes(yt, w):
    j = int(np.argmin(abs(Y - yt)))
    return Y[j], [web_node(j, w, k) for k in range(NL+1)]

# ---------------------------------------------------------------- ghi APDL
L = []
w = L.append
w('! =====================================================================')
w('! Mo hinh shell nhieu lop toan bo duoi ngang DN - sinh tu gen_apdl_DN.py')
w('! Du lieu: main_DN.m, cross_section_analysis_DN.m, material_2D.m, ply.m')
w('! NACA 0015, day cung 550 mm, sai -1.5..1.5 m, ngam chat tai hai dau y = +-1.5 m')
w('! Don vi SI (m, kg, N, Pa).  x: huong ve phia truoc, y: doc sai, zoneID: len')
w('! Nut vo dat tai OML, cac lop dap vao trong (SECOFFSET,TOP, phap tuyen huong ra ngoai)')
w('! Mu dam / side cap: ghep vao laminate vo gia cuong, xep tiep sau cac lop vo')
w('! Bung dam (thanh truoc + foam + thanh sau) va rib: shell sandwich dat tai mat giua')
w('! Huong 0 do cua lop: doc sai (truc y tong the), qua he toa do LOCAL 11')
w('! SHELL181 KEYOPT(3)=2, KEYOPT(8)=2')
w('! =====================================================================')
w('FINISH')
w('/CLEAR,NOSTART')
w('/TITLE,DN horizontal tail - layered shell model from MATLAB data')
w('/PREP7')
w('/NERR,200,10000')
for t in range(1, 8):
    w(f'ET,{t},SHELL181')
    w(f'KEYOPT,{t},3,2')
    w(f'KEYOPT,{t},8,2')
w('ET,8,MPC184')
w('KEYOPT,8,1,1            ! rigid beam')
for t, nm in TYPE_NAME.items(): w(f'! TYPE {t}: {nm}')
w('! TYPE 8: Dam cung noi mep rib (thanh dam) voi bung dam (mat giua)')
w('!')
w('! --- Vat lieu 1: lop UD AS4/3501-6 (vi co nhu ply.m; nu23, G23 theo Foye nhu ply3D.m)')
w(f'MP,EX,1,{E1:.6e}'); w(f'MP,EY,1,{E2:.6e}'); w(f'MP,EZ,1,{E2:.6e}')
w(f'MP,PRXY,1,{nu12:.6f}'); w(f'MP,PRYZ,1,{nu23:.6f}'); w(f'MP,PRXZ,1,{nu12:.6f}')
w(f'MP,GXY,1,{G12:.6e}'); w(f'MP,GYZ,1,{G23:.6e}'); w(f'MP,GXZ,1,{G12:.6e}')
w(f'MP,DENS,1,{RHO_UD:.4f}')
w('! --- Vat lieu 2: PVC foam (PVC_Foam.m)')
w(f'MP,EX,2,{E_F:.6e}'); w(f'MP,PRXY,2,{NU_F}'); w(f'MP,DENS,2,{RHO_F}')
w('! --- Vat lieu 3, 4: nhu 1, 2 nhung khong khoi luong (doan bung dam / rib trung voi chieu day vo)')
w('MPCOPY,,1,3'); w('MP,DENS,3,1e-6')
w('MPCOPY,,2,4'); w('MP,DENS,4,1e-6')
w(f'! Chieu day 1 lop UD = {T_UD*1e3:.5f} mm; woven = 2 lop UD +-45 (nhu code MATLAB)')
w('!')
w('! --- He toa do dinh huong: truc x cuc bo // truc y tong the (0 do doc sai)')
w('LOCAL,11,0,0,0,0,90')
w('CSYS,0')
w('!')
w('! --- Section (SECDATA liet ke tu lop trong cung -> lop ngoai cung)')
for (lam, off), sid in sorted(SECS.items(), key=lambda kv: kv[1]):
    w(f'SECTYPE,{sid},SHELL')
    for m, t, th in reversed(lam):
        w(f'SECDATA,{t:.8f},{MATID[m]},{th:.1f},3')
    w(f'SECOFFSET,{off}')
w('!')
w('! --- Nut')
for n in sorted(nodes):
    x, y, zc = nodes[n]
    w(f'N,{n},{x:.7f},{y:.7f},{zc:.7f}')
w('!')
w('! --- Phan tu')
cur = (None, None, None)
for e in sorted(elems, key=lambda e: (e[0], e[1], e[2])):
    if e[:3] != cur:
        w(f'TYPE,{e[0]}'); w(f'SECNUM,{e[1]}'); w(f'ESYS,{e[2]}')
        cur = e[:3]
    w(f'E,{e[3]},{e[4]},{e[5]},{e[6]}')
w('ESYS,0')
w('TYPE,8')
w('MAT,3                   ! MPC184 rigid beam tinh khoi luong theo DENS -> dung vat lieu khong khoi luong')
for na, nb in links: w(f'E,{na},{nb}')
w('MAT,1')
w('! Lenh isoparametric view cho bai toan')
w('/VUP,1,zoneID')
w('/VIEW,1,-1,-1,1')
w('/AUTO,1')
w('/REPLOT')
w('EPLOT')
w('FINISH')
w('!')
w('! =================== 1. Phan tich tinh: tai khi dong + trong luong ===================')
w('/SOLU')
w('ANTYPE,STATIC')
w('IRLF,-1                 ! in "PRECISE MASS SUMMARY" va khoi luong theo TYPE trong output')
w(f'NSEL,S,LOC,Y,{FIX_Y-1e-5},{FIX_Y+1e-5}')
w(f'NSEL,A,LOC,Y,{-FIX_Y-1e-5},{-FIX_Y+1e-5}')
w('D,ALL,ALL')
w('NSEL,ALL')
w(f'ACEL,0,0,{G_ACC}            ! trong luong ban than theo -zoneID')
w(f'! Luc tap trung tu aerodynamic_load.txt: {FRONT_SHARE:.0%} vao bung dam truoc, phan con lai vao bung dam sau')
for yl, Fl in LOADS:
    for wb, share in ((0, FRONT_SHARE), (1, 1-FRONT_SHARE)):
        _, ns = station_web_nodes(yl, wb)
        for n in ns: w(f'F,{n},FZ,{Fl*share/len(ns):.6f}')
w('SOLVE')
w('*GET,MTOT,ELEM,0,MTOT,X  ! tong khoi luong mo hinh (can IRLF,-1 truoc SOLVE)')
w('FINISH')
w('/POST1')
w('SET,LAST')
w(f'*CFOPEN,{RES},txt')
w('*VWRITE,MTOT')
w("('Tong khoi luong duoi ngang: ',F10.3,' kg')")
w("*VWRITE")
w("('Do vong UZ trung binh tai bung dam truoc / dam sau (mm)')")
for yy in [-1.5, -1.2, -0.9, -0.6, -0.3, 0.0, 0.3, 0.6, 0.9, 1.2, 1.5]:
    for wb in (0, 1):
        ya, ns = station_web_nodes(yy, wb)
        w('UZS=0')
        for n in ns:
            w(f'*GET,UZN,NODE,{n},UD,zoneID')
            w('UZS=UZS+UZN')
        w(f'UZ{wb}=UZS/{len(ns)}*1000')
    w(f'YST={ya:.4f}')
    w('*VWRITE,YST,UZ0,UZ1')
    w("('  y = ',F8.3,' m   UZ dam truoc = ',F10.4,' mm   UZ dam sau = ',F10.4,' mm')")
w('*CFCLOS')
w('FINISH')
w('!')
w('! =================== 2. Phan tich dao dong rieng ===================')
w('/SOLU')
w('ANTYPE,MODAL,NEW')
w('FDELE,ALL,ALL')
w('ACEL,0,0,0')
w(f'NSEL,S,LOC,Y,{FIX_Y-1e-5},{FIX_Y+1e-5}')
w(f'NSEL,A,LOC,Y,{-FIX_Y-1e-5},{-FIX_Y+1e-5}')
w('D,ALL,ALL')
w('NSEL,ALL')
w(f'MODOPT,LANB,{NMODE}')
w(f'MXPAND,{NMODE}')
w('SOLVE')
w('FINISH')
w('/POST1')
w('SET,LIST')
w(f'*CFOPEN,{RES},txt,,APPEND')
w("*VWRITE")
w("('Tan so rieng (Hz)')")
w(f'*DO,II,1,{NMODE}')
w('*GET,FRQ,MODE,II,FREQ')
w('*VWRITE,II,FRQ')
w("('  Mode ',F4.0,'   f = ',F10.4,' Hz')")
w('*ENDDO')
w('*CFCLOS')
w('SET,1,1')
w('! Lenh isoparametric view cho bai toan')
w('/VUP,1,zoneID')
w('/VIEW,1,-1,-1,1')
w('/AUTO,1')
w('/REPLOT')
w('PLDISP,1')
w('! Xem cac mode khac: SET,1,<mode>  roi  PLNSOL,UD,SUM')

open(OUT, 'w', encoding='ascii', errors='replace').write('\n'.join(L) + '\n')

# ---------------------------------------------------------------- tom tat
print(f'Tram doc sai: {NS}, nut: {len(nodes)}, phan tu: {len(elems)} shell + {len(links)} MPC184, section: {len(SECS)}')
tot = 0
for t in sorted(mass_type):
    print(f'  TYPE {t} {TYPE_NAME[t]:40s} {mass_type[t]:8.3f} kg'); tot += mass_type[t]
print(f'  Tong khoi luong duoi ngang: {tot:.3f} kg')
print('  Tach: ' + ', '.join(f'{k} {v:.2f} kg' for k, v in split.items()))
print(f'UD: E1={E1/1e9:.3f} E2={E2/1e9:.3f} G12={G12/1e9:.3f} G23={G23/1e9:.3f} GPa nu12={nu12:.4f} nu23={nu23:.4f} rho={RHO_UD:.1f} t={T_UD*1e3:.5f} mm')
