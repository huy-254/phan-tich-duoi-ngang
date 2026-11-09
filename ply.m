function [E1c, E2c, G12c, nju12_c, sLc_tens, sLc_compr, sTc_tens, sTc_compr, sLTc, rho_c] = ...
    ply(E1f,E2f,G12f,Em,G12m,vf,sLf_tens,sLm_tens,phi,sLm_compr,sLTm,...
    rho_f,rho_m,nju12_f,nju12_m)
%% Modulus
E1c = E1f*vf + Em*(1-vf); % Gibson eq. 3.23
E2c = Em*((1-sqrt(vf))+sqrt(vf)/(1-sqrt(vf)*(1-Em/E2f))); % Gibson eq. 3.50
G12c = G12m*((1-sqrt(vf))+sqrt(vf)/(1-sqrt(vf)*(1-G12m/G12f))); % Gibson eq. 3.50
nju12_c = nju12_f*vf + nju12_m*(1-vf); % Gibson eq. 3.41
%% Strength
% Longitudinal tensile strength
eLf_tens = sLf_tens/E1f;
eLm_tens = sLm_tens/Em;
if eLf_tens<eLm_tens % Gibson Fig. 4.9
    sLc_tens = eLf_tens*E1c;
    if vf < (sLm_tens-eLf_tens*Em)/(sLf_tens-eLf_tens*Em) % Gibson Eq. 4.22
        sLc_tens = sLm_tens*(1-vf); % Gibson Eq. 4.23
    end
else
    sLc_tens = eLm_tens*E1c;
end
% Transverse strength
d_s_ratio = sqrt(vf*4/pi);
F = (d_s_ratio*(Em/E2f-1)+1)^-1; % Gibson Eq. 4.38
sTc_tens = E2c*sLm_tens/Em/F; % Gibson Eq. 4.35
sTc_compr = E2c*sLm_compr/Em/F; % Gibson Eq. 4.35
% Longitudinal compressive strength
sLc_compr_ext = 2*vf*sqrt(vf*Em*E1f/3/(1-vf)); % Gibson Eq. 4.29
sLc_compr_shear = sLTm/(sLTm/(G12m/(1-vf))+phi); % Gibson Eq. 4.30; Daniel Eq. 5.28
eT_tens = eLm_tens/F; % Gibson Eq. 4.34
sLc_compr_rupture = E1c*eT_tens/nju12_c; % Gibson Eq. 4.32
sLc_compr = min([sLc_compr_ext sLc_compr_shear sLc_compr_rupture]);
% Shear strength
F = (d_s_ratio*(G12m/G12f-1)+1)^-1; % Gibson Eq. 4.41
sLTc = G12c*sLTm/G12m/F; % Gibson Eq. 4.35
%% Density
rho_c = rho_f*vf+rho_m*(1-vf);
