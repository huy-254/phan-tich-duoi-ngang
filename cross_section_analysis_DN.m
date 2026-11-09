%% Vo canh
if y_coord(ii) > -1.450 && y_coord(ii) < 1.450
    % 1woven/F5/1woven
    stack = '[par_UD*ones(1,2) par_core par_UD*ones(1,2)]';
    theta_layer_skin = [[pi/4,-pi/4] 0 [pi/4,-pi/4]];

    t_core = core_thickness_skin;
    E1_layer_skin = eval(strrep(stack,'par','E1')); 
    E2_layer_skin = eval(strrep(stack,'par','E2')); 
    G12_layer_skin = eval(strrep(stack,'par','G12'));  
    nju_layer_skin = eval(strrep(stack,'par','nju12')); 
    rho_skin = eval(strrep(stack,'par','rho')); 
    E1_tens_layer_strength_skin = eval(strrep(stack,'par','sL_tens')); 
    E1_compr_layer_strength_skin = eval(strrep(stack,'par','sL_compr')); 
    E2_tens_layer_strength_skin = eval(strrep(stack,'par','sT_tens')); 
    E2_compr_layer_strength_skin = eval(strrep(stack,'par','sT_compr')); 
    G12_layer_strength_skin = eval(strrep(stack,'par','sLT')); 
    t_layer_skin = eval(strrep(stack,'par','t')); 
    t_skin = sum(t_layer_skin)/scale; % skin thickness (fraction of chord length)

else
    % 4woven
    stack = '[par_UD*ones(1,8)]';
    theta_layer_skin = repmat([pi/4,-pi/4],1,4);

    t_core = core_thickness_skin;
    E1_layer_skin = eval(strrep(stack,'par','E1')); 
    E2_layer_skin = eval(strrep(stack,'par','E2')); 
    G12_layer_skin = eval(strrep(stack,'par','G12'));  
    nju_layer_skin = eval(strrep(stack,'par','nju12')); 
    rho_skin = eval(strrep(stack,'par','rho')); 
    E1_tens_layer_strength_skin = eval(strrep(stack,'par','sL_tens')); 
    E1_compr_layer_strength_skin = eval(strrep(stack,'par','sL_compr')); 
    E2_tens_layer_strength_skin = eval(strrep(stack,'par','sT_tens')); 
    E2_compr_layer_strength_skin = eval(strrep(stack,'par','sT_compr')); 
    G12_layer_strength_skin = eval(strrep(stack,'par','sLT')); 
    t_layer_skin = eval(strrep(stack,'par','t')); 
    t_skin = sum(t_layer_skin)/scale; % skin thickness (fraction of chord length)
end

% Reinforced skin
if y_coord(ii)>-1.450 && y_coord(ii)<1.450
    %1woven/4UD/1woven
    stack = '[par_UD*ones(1,2) par_UD*ones(1,4) par_UD*ones(1,2)]';
    theta_layer_skin_reinf = [pi/4,-pi/4,0,0,0,0,pi/4,-pi/4];

    E1_layer_skin_reinf = eval(strrep(stack,'par','E1'));
    E2_layer_skin_reinf = eval(strrep(stack,'par','E2'));
    G12_layer_skin_reinf = eval(strrep(stack,'par','G12'));
    nju_layer_skin_reinf = eval(strrep(stack,'par','nju12'));
    rho_skin_reinf = eval(strrep(stack,'par','rho'));
    E1_tens_layer_strength_skin_reinf = eval(strrep(stack,'par','sL_tens'));
    E1_compr_layer_strength_skin_reinf = eval(strrep(stack,'par','sL_compr'));
    E2_tens_layer_strength_skin_reinf = eval(strrep(stack,'par','sT_tens'));
    E2_compr_layer_strength_skin_reinf = eval(strrep(stack,'par','sT_compr'));
    G12_layer_strength_skin_reinf = eval(strrep(stack,'par','sLT'));
    t_layer_skin_reinf = eval(strrep(stack,'par','t'));
    t_skin_reinf = sum(t_layer_skin_reinf)/scale; % skin thickness (fraction of chord length)

else
    %2woven/4UD/2woven
    stack = '[par_UD*ones(1,4) par_UD*ones(1,4) par_UD*ones(1,4)]';
    theta_layer_skin_reinf = [repmat([pi/4,-pi/4],1,2),0,0,0,0,repmat([pi/4,-pi/4],1,2)];

    E1_layer_skin_reinf = eval(strrep(stack,'par','E1'));
    E2_layer_skin_reinf = eval(strrep(stack,'par','E2'));
    G12_layer_skin_reinf = eval(strrep(stack,'par','G12'));
    nju_layer_skin_reinf = eval(strrep(stack,'par','nju12'));
    rho_skin_reinf = eval(strrep(stack,'par','rho'));
    E1_tens_layer_strength_skin_reinf = eval(strrep(stack,'par','sL_tens'));
    E1_compr_layer_strength_skin_reinf = eval(strrep(stack,'par','sL_compr'));
    E2_tens_layer_strength_skin_reinf = eval(strrep(stack,'par','sT_tens'));
    E2_compr_layer_strength_skin_reinf = eval(strrep(stack,'par','sT_compr'));
    G12_layer_strength_skin_reinf = eval(strrep(stack,'par','sLT'));
    t_layer_skin_reinf = eval(strrep(stack,'par','t'));
    t_skin_reinf = sum(t_layer_skin_reinf)/scale; % skin thickness (fraction of chord length)
end

%% Spar 1
% 4CDB400/foam15/4CDB400
stack = '[par_UD*ones(1,8)  par_core  par_UD*ones(1,8)]'; 
theta_layer_spar_1 = [repmat([pi/4,-pi/4],1,4) 0 repmat([pi/4,-pi/4],1,4)];

t_core = core_thickness_spar_1;
E1_layer_spar_1 = eval(strrep(stack,'par','E1'));
E2_layer_spar_1 = eval(strrep(stack,'par','E2'));
G12_layer_spar_1 = eval(strrep(stack,'par','G12'));
nju_layer_spar_1 = eval(strrep(stack,'par','nju12'));
rho_spar_1 = eval(strrep(stack,'par','rho'));
E1_tens_layer_strength_spar_1 = eval(strrep(stack,'par','sL_tens'));
E1_compr_layer_strength_spar_1 = eval(strrep(stack,'par','sL_compr'));
E2_tens_layer_strength_spar_1 = eval(strrep(stack,'par','sT_tens'));
E2_compr_layer_strength_spar_1 = eval(strrep(stack,'par','sT_compr'));
G12_layer_strength_spar_1 = eval(strrep(stack,'par','sLT'));
t_layer_spar_1 = eval(strrep(stack,'par','t'));
t_spar_1 = sum(t_layer_spar_1)/scale; % front spar thickness (fraction of chord length)
d_cap_1 = t_spar_1; % front cap width (fraction of chord length)

%% Upper cap 1 
% 3(CDB400/4CU300)/CDB400
stack = '[repmat([par_UD*ones(1,2) par_UD*ones(1,4)],1,3) par_UD*ones(1,2)]';
theta_layer_cap_1_u = [repmat([pi/4,-pi/4,0,0,0,0],1,3) [pi/4,-pi/4]];

E1_layer_cap_1_u = eval(strrep(stack,'par','E1'));
E2_layer_cap_1_u = eval(strrep(stack,'par','E2'));
G12_layer_cap_1_u = eval(strrep(stack,'par','G12'));
nju_layer_cap_1_u = eval(strrep(stack,'par','nju12'));
rho_cap_1_u = eval(strrep(stack,'par','rho'));
E1_tens_layer_strength_cap_1_u = eval(strrep(stack,'par','sL_tens'));
E1_compr_layer_strength_cap_1_u = eval(strrep(stack,'par','sL_compr'));
E2_tens_layer_strength_cap_1_u = eval(strrep(stack,'par','sT_tens'));
E2_compr_layer_strength_cap_1_u = eval(strrep(stack,'par','sT_compr'));
G12_layer_strength_cap_1_u = eval(strrep(stack,'par','sLT'));
t_layer_cap_1_u = eval(strrep(stack,'par','t'));
t_cap_1_u = sum(t_layer_cap_1_u)/scale; % front spar cap thickness (fraction of chord length)

%% Lower cap 1
% 3(CDB400/4CU300)/CDB400
stack = '[repmat([par_UD*ones(1,2) par_UD*ones(1,4)],1,3) par_UD*ones(1,2)]';
theta_layer_cap_1_l = [repmat([pi/4,-pi/4,0,0,0,0],1,3) [pi/4,-pi/4]];

E1_layer_cap_1_l = eval(strrep(stack,'par','E1'));
E2_layer_cap_1_l = eval(strrep(stack,'par','E2'));
G12_layer_cap_1_l = eval(strrep(stack,'par','G12'));
nju_layer_cap_1_l = eval(strrep(stack,'par','nju12'));
rho_cap_1_l = eval(strrep(stack,'par','rho'));
E1_tens_layer_strength_cap_1_l = eval(strrep(stack,'par','sL_tens'));
E1_compr_layer_strength_cap_1_l = eval(strrep(stack,'par','sL_compr'));
E2_tens_layer_strength_cap_1_l = eval(strrep(stack,'par','sT_tens'));
E2_compr_layer_strength_cap_1_l = eval(strrep(stack,'par','sT_compr'));
G12_layer_strength_cap_1_l = eval(strrep(stack,'par','sLT'));
t_layer_cap_1_l = eval(strrep(stack,'par','t'));
t_cap_1_l = sum(t_layer_cap_1_l)/scale; % front spar cap thickness (fraction of chord length)

%% Side cap 1 (mở rộng mũ dầm chính)
% 4woven
stack = '[par_UD*ones(1,8)]'; 
theta_layer_side_cap_1 = [repmat([pi/4,-pi/4],1,4)];

E1_layer_side_cap_1 = eval(strrep(stack,'par','E1'));
E2_layer_side_cap_1 = eval(strrep(stack,'par','E2'));
G12_layer_side_cap_1 = eval(strrep(stack,'par','G12'));
nju_layer_side_cap_1 = eval(strrep(stack,'par','nju12'));
rho_side_cap_1 = eval(strrep(stack,'par','rho'));
E1_tens_layer_strength_side_cap_1 = eval(strrep(stack,'par','sL_tens'));
E1_compr_layer_strength_side_cap_1 = eval(strrep(stack,'par','sL_compr'));
E2_tens_layer_strength_side_cap_1 = eval(strrep(stack,'par','sT_tens'));
E2_compr_layer_strength_side_cap_1 = eval(strrep(stack,'par','sT_compr'));
G12_layer_strength_side_cap_1 = eval(strrep(stack,'par','sLT'));
t_layer_side_cap_1 = eval(strrep(stack,'par','t'));
t_side_cap_1 = sum(t_layer_side_cap_1)/scale; % front side cap thickness (fraction of chord length)

%% Spar 2
% 4CDB400/foam25/4CDB400
stack = '[par_UD*ones(1,8)  par_core  par_UD*ones(1,8)]';
theta_layer_spar_2 = [repmat([pi/4,-pi/4],1,4) 0 repmat([pi/4,-pi/4],1,4)];

t_core = core_thickness_spar_2; %#ok<*NASGU>
E1_layer_spar_2 = eval(strrep(stack,'par','E1'));
E2_layer_spar_2 = eval(strrep(stack,'par','E2'));
G12_layer_spar_2 = eval(strrep(stack,'par','G12'));
nju_layer_spar_2 = eval(strrep(stack,'par','nju12'));
rho_spar_2 = eval(strrep(stack,'par','rho'));
E1_tens_layer_strength_spar_2 = eval(strrep(stack,'par','sL_tens'));
E1_compr_layer_strength_spar_2 = eval(strrep(stack,'par','sL_compr'));
E2_tens_layer_strength_spar_2 = eval(strrep(stack,'par','sT_tens'));
E2_compr_layer_strength_spar_2 = eval(strrep(stack,'par','sT_compr'));
G12_layer_strength_spar_2 = eval(strrep(stack,'par','sLT'));
t_layer_spar_2 = eval(strrep(stack,'par','t'));
t_spar_2 = sum(t_layer_spar_2)/scale; % front spar thickness (fraction of chord length)
d_cap_2 = t_spar_2; % aft cap width (fraction of chord length)

%% Upper cap 2 
% 2(CDB400/4CU300)/CDB400
stack = '[repmat([par_UD*ones(1,2) par_UD*ones(1,4)],1,2) par_UD*ones(1,2) ]';
theta_layer_cap_2_u = [repmat([pi/4,-pi/4,0,0,0,0],1,2) [pi/4,-pi/4]];

E1_layer_cap_2_u = eval(strrep(stack,'par','E1'));
E2_layer_cap_2_u = eval(strrep(stack,'par','E2'));
G12_layer_cap_2_u = eval(strrep(stack,'par','G12'));
nju_layer_cap_2_u = eval(strrep(stack,'par','nju12'));
rho_cap_2_u = eval(strrep(stack,'par','rho'));
E1_tens_layer_strength_cap_2_u = eval(strrep(stack,'par','sL_tens'));
E1_compr_layer_strength_cap_2_u = eval(strrep(stack,'par','sL_compr'));
E2_tens_layer_strength_cap_2_u = eval(strrep(stack,'par','sT_tens'));
E2_compr_layer_strength_cap_2_u = eval(strrep(stack,'par','sT_compr'));
G12_layer_strength_cap_2_u = eval(strrep(stack,'par','sLT'));
t_layer_cap_2_u = eval(strrep(stack,'par','t'));
t_cap_2_u = sum(t_layer_cap_2_u)/scale; % aft spar cap thickness (fraction of chord length)

%% Lower cap 2 
% 2(CDB400/4CU300)/CDB400
stack = '[repmat([par_UD*ones(1,2) par_UD*ones(1,4)],1,2) par_UD*ones(1,2) ]';
theta_layer_cap_2_l = [repmat([pi/4,-pi/4,0,0,0,0],1,2) [pi/4,-pi/4]];

E1_layer_cap_2_l = eval(strrep(stack,'par','E1'));
E2_layer_cap_2_l = eval(strrep(stack,'par','E2'));
G12_layer_cap_2_l = eval(strrep(stack,'par','G12'));
nju_layer_cap_2_l = eval(strrep(stack,'par','nju12'));
rho_cap_2_l = eval(strrep(stack,'par','rho'));
E1_tens_layer_strength_cap_2_l = eval(strrep(stack,'par','sL_tens'));
E1_compr_layer_strength_cap_2_l = eval(strrep(stack,'par','sL_compr'));
E2_tens_layer_strength_cap_2_l = eval(strrep(stack,'par','sT_tens'));
E2_compr_layer_strength_cap_2_l = eval(strrep(stack,'par','sT_compr'));
G12_layer_strength_cap_2_l = eval(strrep(stack,'par','sLT'));
t_layer_cap_2_l = eval(strrep(stack,'par','t'));
t_cap_2_l = sum(t_layer_cap_2_l)/scale; % aft spar cap thickness (fraction of chord length)

%% Side cap 2 (mở rộng mũ dầm phụ)
% 4woven
stack = '[par_UD*ones(1,8)]'; 
theta_layer_side_cap_2 = [repmat([pi/4,-pi/4],1,4)];

E1_layer_side_cap_2 = eval(strrep(stack,'par','E1'));
E2_layer_side_cap_2 = eval(strrep(stack,'par','E2'));
G12_layer_side_cap_2 = eval(strrep(stack,'par','G12'));
nju_layer_side_cap_2 = eval(strrep(stack,'par','nju12'));
rho_side_cap_2 = eval(strrep(stack,'par','rho'));
E1_tens_layer_strength_side_cap_2 = eval(strrep(stack,'par','sL_tens'));
E1_compr_layer_strength_side_cap_2 = eval(strrep(stack,'par','sL_compr'));
E2_tens_layer_strength_side_cap_2 = eval(strrep(stack,'par','sT_tens'));
E2_compr_layer_strength_side_cap_2 = eval(strrep(stack,'par','sT_compr'));
G12_layer_strength_side_cap_2 = eval(strrep(stack,'par','sLT'));
t_layer_side_cap_2 = eval(strrep(stack,'par','t'));
t_side_cap_2 = sum(t_layer_side_cap_2)/scale; % aft side cap thickness (fraction of chord length)

%% Ribs 

%2woven/foam10/2woven
stack = '[par_UD*ones(1,4)  par_core  par_UD*ones(1,4)]';
theta_layer_rib = [repmat([pi/4,-pi/4],1,2) 0 repmat([pi/4,-pi/4],1,2)];

t_core = core_thickness_rib;
E1_layer_rib = eval(strrep(stack,'par','E1'));
E2_layer_rib = eval(strrep(stack,'par','E2'));
G12_layer_rib = eval(strrep(stack,'par','G12'));
nju_layer_rib = eval(strrep(stack,'par','nju12'));
rho_rib = eval(strrep(stack,'par','rho'));
E1_tens_layer_strength_rib = eval(strrep(stack,'par','sL_tens'));
E1_compr_layer_strength_rib = eval(strrep(stack,'par','sL_compr'));
E2_tens_layer_strength_rib = eval(strrep(stack,'par','sT_tens'));
E2_compr_layer_strength_rib = eval(strrep(stack,'par','sT_compr'));
G12_layer_strength_rib = eval(strrep(stack,'par','sLT'));
t_layer_rib = eval(strrep(stack,'par','t'));
t_rib = sum(t_layer_rib)/scale; % rib thickness (fraction of chord length)

%% Mass analysis
% Skin
up = interp1(upper_point(:,1),upper_point(:,2),0:.01:1); % upper-point interpolation
lp = interp1(lower_point(:,1),lower_point(:,2),0:.01:1); % lower-point interpolation
elem_length_u = sqrt((up(2:end)-up(1:end-1)).^2+.01^2); % length of upper elements
elem_length_l = sqrt((lp(2:end)-lp(1:end-1)).^2+.01^2); % length of lower elements

% Front spar
slope_u_1 = atan((up(round(x_spar_1/.01)+1)-up(round(x_spar_1/.01)))/.01); % slope of the airfoil's upper surface
slope_l_1 = atan((lp(round(x_spar_1/.01)+1)-lp(round(x_spar_1/.01)))/.01); % slope of the airfoil's lower surface
z_airfoil_u_1 = interp1(0:.01:1,up,x_spar_1);
z_airfoil_l_1 = interp1(0:.01:1,lp,x_spar_1);
spar_1_up = z_airfoil_u_1-t_skin_reinf/cos(slope_u_1); % upper end of the front spar (z location)
spar_1_low = z_airfoil_l_1+t_skin_reinf/cos(slope_l_1); % lower end of the front spar (z location)

foam_1_up = z_airfoil_u_1-t_cap_1_u/cos(slope_u_1)-t_skin_reinf/cos(slope_u_1); % upper end of the front foam (z location)
foam_1_low = z_airfoil_l_1+t_cap_1_l/cos(slope_l_1)+t_skin_reinf/cos(slope_l_1); % lower end of the front foam (z location)

h_spar_1 = spar_1_up-spar_1_low; % front spar height
h_foam_1 = foam_1_up-foam_1_low; % front spar foam height

% Aft spar
slope_u_2 = atan((up(round(x_spar_2/.01)+1)-up(round(x_spar_2/.01)))/.01); % slope of the airfoil's upper surface
slope_l_2 = atan((lp(round(x_spar_2/.01)+1)-lp(round(x_spar_2/.01)))/.01); % slope of the airfoil's lower surface
z_airfoil_u_2 = interp1(0:.01:1,up,x_spar_2);
z_airfoil_l_2 = interp1(0:.01:1,lp,x_spar_2);
spar_2_up = z_airfoil_u_2 - t_skin_reinf/cos(slope_u_2); % upper end of the aft spar (z location)
spar_2_low = z_airfoil_l_2 + t_skin_reinf/cos(slope_l_2); % lower end of the aft spar (z location)

foam_2_up = z_airfoil_u_2 - t_cap_2_u/cos(slope_u_2)-t_skin_reinf/cos(slope_u_2);
foam_2_low = z_airfoil_l_2 + t_cap_2_l/cos(slope_l_2)+t_skin_reinf/cos(slope_l_2);

h_spar_2 = spar_2_up-spar_2_low; % aft spar height
h_foam_2 = foam_2_up-foam_2_low; % aft spar foam height

% mass per unit length (kg/m)
n_rib = 1/(rib_spacing*scale);

m_airfoil(ii) = (sum(rho_skin.*t_layer_skin)*(sum(elem_length_u)+sum(elem_length_l)) +... 
    sum(rho_spar_1.*t_layer_spar_1)*h_spar_1 - rho_core*core_thickness_spar_1*(h_spar_1-h_foam_1) +...
    sum(rho_spar_2.*t_layer_spar_2)*h_spar_2 - rho_core*core_thickness_spar_2*(h_spar_2-h_foam_2) +...
    sum(rho_rib.*t_layer_rib)*(h_spar_1+h_spar_2)/2*(x_spar_2-x_spar_1)*scale*n_rib +...
    sum(rho_cap_1_u.*t_layer_cap_1_u)*d_cap_1+...
    sum(rho_cap_1_l.*t_layer_cap_1_l)*d_cap_1+...
    sum(rho_cap_2_u.*t_layer_cap_2_u)*d_cap_2+...
    sum(rho_cap_2_l.*t_layer_cap_2_l)*d_cap_2+...
    sum(rho_side_cap_1.*t_layer_side_cap_1)*d_side_cap_1*2+...
    sum(rho_side_cap_2.*t_layer_side_cap_2)*d_side_cap_2*2)*scale;

% dai gia cuong thay the vo thuong cung be rong
m_airfoil(ii) = m_airfoil(ii)-sum(rho_skin.*t_layer_skin)/sum(t_layer_skin)*t_skin*(2*d_reinf_1+2*d_reinf_2)*scale^2+...
    sum(rho_skin_reinf.*t_layer_skin_reinf)/sum(t_layer_skin_reinf)*t_skin_reinf*(2*d_reinf_1+2*d_reinf_2)*scale^2;

xc_skin = (sum(rho_skin.*t_layer_skin)*...
    (sum(elem_length_u.*(.005:.01:.995))+sum(elem_length_l.*(.005:.01:.995))))*scale/m_airfoil(ii); 
    
xc_spar_1 = (sum(rho_spar_1.*t_layer_spar_1)*h_spar_1 - rho_core*core_thickness_spar_1*(h_spar_1-h_foam_1))*x_spar_1*scale/m_airfoil(ii); 
    
xc_spar_2 = (sum(rho_spar_2.*t_layer_spar_2)*h_spar_2 - rho_core*core_thickness_spar_2*(h_spar_2-h_foam_2))*x_spar_2*scale/m_airfoil(ii); 
    
xc_rib = (sum(rho_rib.*t_layer_rib)/sum(t_layer_rib)*t_rib*(h_spar_1+h_spar_2)/2*(x_spar_2-x_spar_1)*(x_spar_1+x_spar_2)/2*scale*n_rib)*scale^2/m_airfoil(ii); 
    
xc_cap_1_u = (sum(rho_cap_1_u.*t_layer_cap_1_u)/sum(t_layer_cap_1_u)*t_cap_1_u*d_cap_1*x_spar_1)*scale^2/m_airfoil(ii); 
    
xc_cap_1_l = (sum(rho_cap_1_l.*t_layer_cap_1_l)/sum(t_layer_cap_1_l)*t_cap_1_l*d_cap_1*x_spar_1)*scale^2/m_airfoil(ii); 
        
xc_cap_2_u = (sum(rho_cap_2_u.*t_layer_cap_2_u)/sum(t_layer_cap_2_u)*t_cap_2_u*d_cap_2*x_spar_2)*scale^2/m_airfoil(ii); 

xc_cap_2_l = (sum(rho_cap_2_l.*t_layer_cap_2_l)/sum(t_layer_cap_2_l)*t_cap_2_l*d_cap_2*x_spar_2)*scale^2/m_airfoil(ii); 
    
xc_side_cap = (sum(rho_side_cap_1.*t_layer_side_cap_1)/scale*d_side_cap_1*2*x_spar_1 +... 
    sum(rho_side_cap_2.*t_layer_side_cap_2)/scale*d_side_cap_2*2*x_spar_2)*scale^2/m_airfoil(ii); 

xc_airfoil(ii) = xc_skin + xc_spar_1 + xc_spar_2 + xc_rib + xc_cap_1_u + xc_cap_1_l + xc_cap_2_u + xc_cap_2_l + xc_side_cap;

xc_airfoil(ii) = xc_airfoil(ii)-sum(rho_skin.*t_layer_skin)*(2*d_reinf_1*x_spar_1+2*d_reinf_2*x_spar_2)*scale/m_airfoil(ii)+...
    sum(rho_skin_reinf.*t_layer_skin_reinf)*(2*d_reinf_1*x_spar_1+2*d_reinf_2*x_spar_2)*scale/m_airfoil(ii);

%% Composite properties (Gibson Chap. 7)
% Front spar
[A_lam_spar_1, ~] = laminate(E1_layer_spar_1,E2_layer_spar_1,theta_layer_spar_1,t_layer_spar_1,...
    G12_layer_spar_1,nju_layer_spar_1,0); 
Q_lam_spar_1 = A_lam_spar_1/(t_spar_1*scale);
S_lam_spar_1 = inv(Q_lam_spar_1);
Ex_spar_1 = 1/S_lam_spar_1(1,1); % Gibson Eq. 2.25
Ez_spar_1 = 1/S_lam_spar_1(2,2);
G_spar_1 = 1/S_lam_spar_1(3,3);

% Aft spar
[A_lam_spar_2, ~] = laminate(E1_layer_spar_2,E2_layer_spar_2,theta_layer_spar_2,t_layer_spar_2,...
    G12_layer_spar_2,nju_layer_spar_2,0); 
Q_lam_spar_2 = A_lam_spar_2/(t_spar_2*scale);
S_lam_spar_2 = inv(Q_lam_spar_2);
Ex_spar_2 = 1/S_lam_spar_2(1,1); % Gibson Eq. 2.25
Ez_spar_2 = 1/S_lam_spar_2(2,2);
G_spar_2 = 1/S_lam_spar_2(3,3);

% Skin
[A_lam_skin, D_lam_skin] = laminate(E1_layer_skin,E2_layer_skin,theta_layer_skin,t_layer_skin,...
    G12_layer_skin,nju_layer_skin,0); 
Q_lam_skin = A_lam_skin/(t_skin*scale);
S_lam_skin = inv(Q_lam_skin);
Ex_skin = 1/S_lam_skin(1,1); % Gibson Eq. 2.25
Ey_skin = 1/S_lam_skin(2,2);
G_skin = 1/S_lam_skin(3,3);

% Reinforced skin
[A_lam_skin_reinf, ~] = laminate(E1_layer_skin_reinf,E2_layer_skin_reinf,theta_layer_skin_reinf,t_layer_skin_reinf,...
    G12_layer_skin_reinf,nju_layer_skin_reinf,0);
Q_lam_skin_reinf = A_lam_skin_reinf/(t_skin_reinf*scale);
S_lam_skin_reinf = inv(Q_lam_skin_reinf);
Ex_skin_reinf = 1/S_lam_skin_reinf(1,1); % Gibson Eq. 2.25
Ey_skin_reinf = 1/S_lam_skin_reinf(2,2);
G_skin_reinf = 1/S_lam_skin_reinf(3,3);

% Ribs
[A_lam_rib, D_lam_rib] = laminate(E1_layer_rib, E2_layer_rib, theta_layer_rib, t_layer_rib,...
    G12_layer_rib,nju_layer_rib,0); 
Q_lam_rib = A_lam_rib/(t_rib*scale);
S_lam_rib = inv(Q_lam_rib);
Ey_rib = 1/S_lam_rib(1,1); % Gibson Eq. 2.25
Ez_rib = 1/S_lam_rib(2,2);
G_rib = 1/S_lam_rib(3,3);

% Spar cap 1
[A_lam_cap_1_u, ~] = laminate(E1_layer_cap_1_u,E2_layer_cap_1_u,theta_layer_cap_1_u,t_layer_cap_1_u,...
    G12_layer_cap_1_u,nju_layer_cap_1_u,0); 
Q_lam_cap_1_u = A_lam_cap_1_u/(t_cap_1_u*scale);
S_lam_cap_1_u = inv(Q_lam_cap_1_u);
Ex_cap_1_u = 1/S_lam_cap_1_u(1,1); % Gibson Eq. 2.25
% Ey_cap_1_u = 1/S_lam_cap_1_u(2,2);
G_cap_1_u = 1/S_lam_cap_1_u(3,3);

[A_lam_cap_1_l, ~] = laminate(E1_layer_cap_1_l,E2_layer_cap_1_l,theta_layer_cap_1_l,t_layer_cap_1_l,...
    G12_layer_cap_1_l,nju_layer_cap_1_l,0); 
Q_lam_cap_1_l = A_lam_cap_1_l/(t_cap_1_l*scale);
S_lam_cap_1_l = inv(Q_lam_cap_1_l);
Ex_cap_1_l = 1/S_lam_cap_1_l(1,1); % Gibson Eq. 2.25
% Ey_cap_1_l = 1/S_lam_cap_1_l(2,2);
G_cap_1_l = 1/S_lam_cap_1_l(3,3);

% Spar cap 2
[A_lam_cap_2_u, ~] = laminate(E1_layer_cap_2_u,E2_layer_cap_2_u,theta_layer_cap_2_u,t_layer_cap_2_u,...
    G12_layer_cap_2_u,nju_layer_cap_2_u,0); 
Q_lam_cap_2_u = A_lam_cap_2_u/(t_cap_2_u*scale);
S_lam_cap_2_u = inv(Q_lam_cap_2_u);
Ex_cap_2_u = 1/S_lam_cap_2_u(1,1); % Gibson Eq. 2.25
% Ey_cap_2_u = 1/S_lam_cap_2_u(2,2);
G_cap_2_u = 1/S_lam_cap_2_u(3,3);

[A_lam_cap_2_l, ~] = laminate(E1_layer_cap_2_l,E2_layer_cap_2_l,theta_layer_cap_2_l,t_layer_cap_2_l,...
    G12_layer_cap_2_l,nju_layer_cap_2_l,0); 
Q_lam_cap_2_l = A_lam_cap_2_l/(t_cap_2_l*scale);
S_lam_cap_2_l = inv(Q_lam_cap_2_l);
Ex_cap_2_l = 1/S_lam_cap_2_l(1,1); % Gibson Eq. 2.25
% Ey_cap_2_l = 1/S_lam_cap_2_l(2,2);
G_cap_2_l = 1/S_lam_cap_2_l(3,3);

% Spar side_cap 1
[A_lam_side_cap_1, D_lam_side_cap_1] = laminate(E1_layer_side_cap_1,E2_layer_side_cap_1,theta_layer_side_cap_1,t_layer_side_cap_1,...
    G12_layer_side_cap_1,nju_layer_side_cap_1,0); 
Q_lam_side_cap_1 = A_lam_side_cap_1/(t_side_cap_1*scale);
S_lam_side_cap_1 = inv(Q_lam_side_cap_1);
Ex_side_cap_1 = 1/S_lam_side_cap_1(1,1); % Gibson Eq. 2.25
Ey_side_cap_1 = 1/S_lam_side_cap_1(2,2);
G_side_cap_1 = 1/S_lam_side_cap_1(3,3);

% Spar side_cap 2
[A_lam_side_cap_2, D_lam_side_cap_2] = laminate(E1_layer_side_cap_2,E2_layer_side_cap_2,theta_layer_side_cap_2,t_layer_side_cap_2,...
    G12_layer_side_cap_2,nju_layer_side_cap_2,0); 
Q_lam_side_cap_2 = A_lam_side_cap_2/(t_side_cap_2*scale);
S_lam_side_cap_2 = inv(Q_lam_side_cap_2);
Ex_side_cap_2 = 1/S_lam_side_cap_2(1,1); % Gibson Eq. 2.25
Ey_side_cap_2 = 1/S_lam_side_cap_2(2,2);
G_side_cap_2 = 1/S_lam_side_cap_2(3,3);

%% Bending
% caps
z_cap_1_u = spar_1_up  - t_cap_1_u/2/cos(slope_u_1);
z_cap_1_l = spar_1_low + t_cap_1_l/2/cos(slope_l_1);
z_cap_2_u = spar_2_up  - t_cap_2_u/2/cos(slope_u_2);
z_cap_2_l = spar_2_low + t_cap_2_l/2/cos(slope_l_2);

% z-coordinate of truc trung hoa
% z_E(ii) = (z_cap_1_u*Ex_cap_1_u*d_cap_1*t_cap_1_u + z_cap_1_l*Ex_cap_1_l*d_cap_1*t_cap_1_l +...
%     z_cap_2_u*Ex_cap_2_u*d_cap_2*t_cap_2_u + z_cap_2_l*Ex_cap_2_l*d_cap_2*t_cap_2_l)/...
%     (Ex_cap_1_u*d_cap_1*t_cap_1_u + Ex_cap_1_l*d_cap_1*t_cap_1_l+...
%     Ex_cap_2_u*d_cap_2*t_cap_2_u + Ex_cap_2_l*d_cap_2*t_cap_2_l);

% update lai cach tinh truc trung hoa (18/10/2026)
% Truc trung hoa: trong tam co trong so Ex*A cua TOAN BO mat cat
% Mat giua vo: lui vao trong t_skin/2 theo phap tuyen (elem_length/.01 = 1/cos(slope))
z_skin_u = (up(2:end)+up(1:end-1))/2 - t_skin/2*elem_length_u/.01;
z_skin_l = (lp(2:end)+lp(1:end-1))/2 + t_skin/2*elem_length_l/.01;
% Side cap: nam ngay duoi vo, cung muc voi mat tham chieu cua cap
z_side_cap_1_u = spar_1_up  - t_side_cap_1/2/cos(slope_u_1);
z_side_cap_1_l = spar_1_low + t_side_cap_1/2/cos(slope_l_1);
z_side_cap_2_u = spar_2_up  - t_side_cap_2/2/cos(slope_u_2);
z_side_cap_2_l = spar_2_low + t_side_cap_2/2/cos(slope_l_2);

EAz = (z_cap_1_u*Ex_cap_1_u*t_cap_1_u + z_cap_1_l*Ex_cap_1_l*t_cap_1_l)*d_cap_1 + ...
      (z_cap_2_u*Ex_cap_2_u*t_cap_2_u + z_cap_2_l*Ex_cap_2_l*t_cap_2_l)*d_cap_2 + ...
      Ex_spar_1*t_spar_1*h_spar_1*(spar_1_low + h_spar_1/2) + ...
      Ex_spar_2*t_spar_2*h_spar_2*(spar_2_low + h_spar_2/2) + ...
      Ex_side_cap_1*t_side_cap_1*d_side_cap_1*(z_side_cap_1_u + z_side_cap_1_l) + ...
      Ex_side_cap_2*t_side_cap_2*d_side_cap_2*(z_side_cap_2_u + z_side_cap_2_l) + ...
      Ex_skin*t_skin*(sum(elem_length_u.*z_skin_u) + sum(elem_length_l.*z_skin_l));
EAs = (Ex_cap_1_u*t_cap_1_u + Ex_cap_1_l*t_cap_1_l)*d_cap_1 + ...
      (Ex_cap_2_u*t_cap_2_u + Ex_cap_2_l*t_cap_2_l)*d_cap_2 + ...
      Ex_spar_1*t_spar_1*h_spar_1 + Ex_spar_2*t_spar_2*h_spar_2 + ...
      2*Ex_side_cap_1*t_side_cap_1*d_side_cap_1 + 2*Ex_side_cap_2*t_side_cap_2*d_side_cap_2 + ...
      Ex_skin*t_skin*(sum(elem_length_u) + sum(elem_length_l));
% Dai gia cuong rong d_reinf tren MOI mat (giong m_airfoil, EA, delta_1..3)
z_reinf_u_1 = z_airfoil_u_1 - t_skin_reinf/2/cos(slope_u_1);
z_reinf_l_1 = z_airfoil_l_1 + t_skin_reinf/2/cos(slope_l_1);
z_reinf_u_2 = z_airfoil_u_2 - t_skin_reinf/2/cos(slope_u_2);
z_reinf_l_2 = z_airfoil_l_2 + t_skin_reinf/2/cos(slope_l_2);
z_sk_u_1 = z_airfoil_u_1 - t_skin/2/cos(slope_u_1);   % phan vo thuong bi thay the
z_sk_l_1 = z_airfoil_l_1 + t_skin/2/cos(slope_l_1);
z_sk_u_2 = z_airfoil_u_2 - t_skin/2/cos(slope_u_2);
z_sk_l_2 = z_airfoil_l_2 + t_skin/2/cos(slope_l_2);
EAz = EAz + d_reinf_1*(Ex_skin_reinf*t_skin_reinf*(z_reinf_u_1+z_reinf_l_1) - Ex_skin*t_skin*(z_sk_u_1+z_sk_l_1)) + ...
            d_reinf_2*(Ex_skin_reinf*t_skin_reinf*(z_reinf_u_2+z_reinf_l_2) - Ex_skin*t_skin*(z_sk_u_2+z_sk_l_2));
EAs = EAs + 2*d_reinf_1*(Ex_skin_reinf*t_skin_reinf - Ex_skin*t_skin) + ...
            2*d_reinf_2*(Ex_skin_reinf*t_skin_reinf - Ex_skin*t_skin);
z_E(ii) = EAz/EAs;

h1_u = z_cap_1_u - z_E(ii);
h1_l = z_E(ii) - z_cap_1_l;

h2_u = z_cap_2_u - z_E(ii);
h2_l = z_E(ii) - z_cap_2_l;

I_cap_1_u = t_cap_1_u*d_cap_1*h1_u^2;
I_cap_1_l = t_cap_1_l*d_cap_1*h1_l^2;
I_cap_2_u = t_cap_2_u*d_cap_2*h2_u^2;
I_cap_2_l = t_cap_2_l*d_cap_2*h2_l^2;


%% Tinh moment quan tinh
I_spar_1 = t_spar_1*h_spar_1^3/12 + t_spar_1*h_spar_1*(spar_1_up - h_spar_1/2 - z_E(ii))^2; % area moment of inertia Front spar
I_spar_2 = t_spar_2*h_spar_2^3/12 + t_spar_2*h_spar_2*(spar_2_up - h_spar_2/2 - z_E(ii))^2; % area moment of inertia Aft spar

% Skin
I_skin = sum((elem_length_u*t_skin).*(z_skin_u-z_E(ii)).^2)+...
    sum((elem_length_l*t_skin).*(z_skin_l-z_E(ii)).^2);
I_skin = I_skin - t_skin*(d_reinf_1*((z_sk_u_1-z_E(ii))^2+(z_sk_l_1-z_E(ii))^2) + ...
                          d_reinf_2*((z_sk_u_2-z_E(ii))^2+(z_sk_l_2-z_E(ii))^2));
I_skin_reinf = t_skin_reinf*(d_reinf_1*((z_reinf_u_1-z_E(ii))^2+(z_reinf_l_1-z_E(ii))^2) + ...
                             d_reinf_2*((z_reinf_u_2-z_E(ii))^2+(z_reinf_l_2-z_E(ii))^2));
I_side_cap_1_u = t_side_cap_1*d_side_cap_1*(z_side_cap_1_u-z_E(ii))^2;
I_side_cap_1_l = t_side_cap_1*d_side_cap_1*(z_side_cap_1_l-z_E(ii))^2;
I_side_cap_2_u = t_side_cap_2*d_side_cap_2*(z_side_cap_2_u-z_E(ii))^2;
I_side_cap_2_l = t_side_cap_2*d_side_cap_2*(z_side_cap_2_l-z_E(ii))^2;

[~, D_lam_cap_1_u] = laminate(E1_layer_cap_1_u,E2_layer_cap_1_u,theta_layer_cap_1_u,t_layer_cap_1_u,...
    G12_layer_cap_1_u,nju_layer_cap_1_u,(z_airfoil_u_1-z_E(ii)-(t_skin_reinf+t_cap_1_u/2)/cos(slope_u_1))*scale);
[~, D_lam_cap_1_l] = laminate(E1_layer_cap_1_l,E2_layer_cap_1_l,theta_layer_cap_1_l,t_layer_cap_1_l,...
    G12_layer_cap_1_l,nju_layer_cap_1_l,(z_E(ii)-z_airfoil_l_1-(t_skin_reinf+t_cap_1_l/2)/cos(slope_l_1))*scale);

M_mat = D_lam_cap_1_u\[1;0;0]; % Gibson Eq. 7.41
EI_cap_1_u = 1/M_mat(1)*d_cap_1*scale;

M_mat = D_lam_cap_1_l\[1;0;0]; % Gibson Eq. 7.41
EI_cap_1_l = 1/M_mat(1)*d_cap_1*scale;

% Spar cap 2 (bending rigidity)
[~, D_lam_cap_2_u] = laminate(E1_layer_cap_2_u,E2_layer_cap_2_u,theta_layer_cap_2_u,t_layer_cap_2_u,...
    G12_layer_cap_2_u,nju_layer_cap_2_u,(z_airfoil_u_2-z_E(ii)-(t_skin_reinf+t_cap_2_u/2)/cos(slope_u_2))*scale);
[~, D_lam_cap_2_l] = laminate(E1_layer_cap_2_l,E2_layer_cap_2_l,theta_layer_cap_2_l,t_layer_cap_2_l,...
    G12_layer_cap_2_l,nju_layer_cap_2_l,(z_E(ii)-z_airfoil_l_2-(t_skin_reinf+t_cap_2_l/2)/cos(slope_l_2))*scale);

M_mat = D_lam_cap_2_u\[1;0;0]; % Gibson Eq. 7.41
EI_cap_2_u = 1/M_mat(1)*d_cap_2*scale;

M_mat = D_lam_cap_2_l\[1;0;0]; % Gibson Eq. 7.41
EI_cap_2_l = 1/M_mat(1)*d_cap_2*scale;


% Bending moment
if ii == length(y_coord)
    M_b(ii) = 0;
else
    M_b(ii) = sum(F_point.*max(0, (y_point-y_coord(ii)))) -...
        sum(n_load*9.81*0.5*(m_airfoil(ii+1:end)+m_airfoil(ii:end-1)).*(y_coord(ii+1:end)-y_coord(ii)-dy/2))*dy;
end

% Phan luc va mo men ngam tai dau mut y = fix_loc (tinh trong main_DN.m)
M_b(ii) = M_b(ii)+F_react*(fix_loc - y_coord(ii))+M_fix;

%% Mean stress (Chizhov eq. 2.24)
EI(ii) = (Ex_spar_1*I_spar_1+EI_cap_1_u/scale^4+EI_cap_1_l/scale^4+Ex_side_cap_1*(I_side_cap_1_u+I_side_cap_1_l)+...
    Ex_spar_2*I_spar_2+EI_cap_2_u/scale^4+EI_cap_2_l/scale^4+Ex_side_cap_2*(I_side_cap_2_u+I_side_cap_2_l)+...
    Ex_skin*I_skin+Ex_skin_reinf*I_skin_reinf)*scale^4; % bending rigidity

% Do cung keo-nen doc truc: tong Ei*Si cua cac chi tiet chiu luc doc truc
% (dien tich lay giong phan tinh khoi luong, khong ke suon)
EA(ii) = (Ex_spar_1*t_spar_1*h_spar_1+Ex_spar_2*t_spar_2*h_spar_2+...
    Ex_cap_1_u*t_cap_1_u*d_cap_1+Ex_cap_1_l*t_cap_1_l*d_cap_1+...
    Ex_cap_2_u*t_cap_2_u*d_cap_2+Ex_cap_2_l*t_cap_2_l*d_cap_2+...
    Ex_side_cap_1*t_side_cap_1*d_side_cap_1*2+Ex_side_cap_2*t_side_cap_2*d_side_cap_2*2+...
    Ex_skin*t_skin*(sum(elem_length_u)+sum(elem_length_l))+...
    (Ex_skin_reinf*t_skin_reinf-Ex_skin*t_skin)*(2*d_reinf_1+2*d_reinf_2))*scale^2;

%% Uon ngang trong mat phang day cung (quanh truc z)
% Cung cac chi tiet nhu EAs. Moi dong cua sec_z: [Ex*A, x, z, Ex*I_rieng quanh truc
% thang dung], x tinh tu mep truoc ve sau, z huong len (phan day cung).
% Side cap nam mot ben, huong vao trong hop dam; dai gia cuong dat giua mu + side cap
% (giong gen_apdl_wing.py).
x_skin = .005:.01:.995;
x_side_cap_1 = x_spar_1 + d_cap_1/2 + d_side_cap_1/2;
x_side_cap_2 = x_spar_2 - d_cap_2/2 - d_side_cap_2/2;
sec_z = [Ex_cap_1_u*t_cap_1_u*d_cap_1, x_spar_1, z_cap_1_u, Ex_cap_1_u*t_cap_1_u*d_cap_1^3/12;
    Ex_cap_1_l*t_cap_1_l*d_cap_1, x_spar_1, z_cap_1_l, Ex_cap_1_l*t_cap_1_l*d_cap_1^3/12;
    Ex_cap_2_u*t_cap_2_u*d_cap_2, x_spar_2, z_cap_2_u, Ex_cap_2_u*t_cap_2_u*d_cap_2^3/12;
    Ex_cap_2_l*t_cap_2_l*d_cap_2, x_spar_2, z_cap_2_l, Ex_cap_2_l*t_cap_2_l*d_cap_2^3/12;
    Ex_spar_1*t_spar_1*h_spar_1, x_spar_1, spar_1_low + h_spar_1/2, Ex_spar_1*h_spar_1*t_spar_1^3/12;
    Ex_spar_2*t_spar_2*h_spar_2, x_spar_2, spar_2_low + h_spar_2/2, Ex_spar_2*h_spar_2*t_spar_2^3/12;
    Ex_side_cap_1*t_side_cap_1*d_side_cap_1, x_side_cap_1, z_side_cap_1_u, Ex_side_cap_1*t_side_cap_1*d_side_cap_1^3/12;
    Ex_side_cap_1*t_side_cap_1*d_side_cap_1, x_side_cap_1, z_side_cap_1_l, Ex_side_cap_1*t_side_cap_1*d_side_cap_1^3/12;
    Ex_side_cap_2*t_side_cap_2*d_side_cap_2, x_side_cap_2, z_side_cap_2_u, Ex_side_cap_2*t_side_cap_2*d_side_cap_2^3/12;
    Ex_side_cap_2*t_side_cap_2*d_side_cap_2, x_side_cap_2, z_side_cap_2_l, Ex_side_cap_2*t_side_cap_2*d_side_cap_2^3/12;
    Ex_skin*t_skin*[elem_length_u elem_length_l]', [x_skin x_skin]', [z_skin_u z_skin_l]', zeros(200,1)];
x_reinf_1 = x_spar_1 + d_side_cap_1/2;
x_reinf_2 = x_spar_2 - d_side_cap_2/2;
EA_r = Ex_skin_reinf*t_skin_reinf; % dai gia cuong thay the vo thuong cung be rong
EA_s = Ex_skin*t_skin;
sec_z = [sec_z;
    EA_r*d_reinf_1, x_reinf_1, z_reinf_u_1, EA_r*d_reinf_1^3/12;
    EA_r*d_reinf_1, x_reinf_1, z_reinf_l_1, EA_r*d_reinf_1^3/12;
    EA_r*d_reinf_2, x_reinf_2, z_reinf_u_2, EA_r*d_reinf_2^3/12;
    EA_r*d_reinf_2, x_reinf_2, z_reinf_l_2, EA_r*d_reinf_2^3/12;
    -EA_s*d_reinf_1, x_reinf_1, z_sk_u_1, -EA_s*d_reinf_1^3/12;
    -EA_s*d_reinf_1, x_reinf_1, z_sk_l_1, -EA_s*d_reinf_1^3/12;
    -EA_s*d_reinf_2, x_reinf_2, z_sk_u_2, -EA_s*d_reinf_2^3/12;
    -EA_s*d_reinf_2, x_reinf_2, z_sk_l_2, -EA_s*d_reinf_2^3/12];
% Truc trung hoa theo phuong day cung (phan day cung tu mep truoc)
x_N(ii) = sum(sec_z(:,1).*sec_z(:,2))/sum(sec_z(:,1));
% Do cung uon ngang EI_z = sum(Ex*X^2*dA) va do cung uon xien EI_xz = sum(Ex*X*Z*dA)
% quanh tam (x_N, z_E), voi X = -(x-x_N)*c huong ve phia truoc, Z = (z-z_E)*c
EI_z(ii) = sum(sec_z(:,1).*(sec_z(:,2)-x_N(ii)).^2 + sec_z(:,4))*scale^4;
EI_xz(ii) = -sum(sec_z(:,1).*(sec_z(:,2)-x_N(ii)).*(sec_z(:,3)-z_E(ii)))*scale^4;

bending_curvature = -M_b(ii)/EI(ii); % bending curvature
max_sigma_u_skin = bending_curvature*Ex_skin*max(up-z_E(ii))*scale; % maximum upper skin stress
max_sigma_l_skin = bending_curvature*Ex_skin*min(lp-z_E(ii))*scale; % maximum lower stress

max_sigma_u_skin_reinf = bending_curvature*Ex_skin_reinf*max([z_airfoil_u_1 z_airfoil_u_2]-z_E(ii))*scale; % maximum upper skin stress
max_sigma_l_skin_reinf = bending_curvature*Ex_skin_reinf*min([z_airfoil_l_1 z_airfoil_l_2]-z_E(ii))*scale; % maximum lower stress


sigma_u_spar_1 = bending_curvature*Ex_spar_1*(spar_1_up-z_E(ii))*scale; % stress at upper end of spar 1
sigma_l_spar_1 = bending_curvature*Ex_spar_1*(spar_1_low-z_E(ii))*scale; % stress at lower end of spar 1
sigma_u_spar_2 = bending_curvature*Ex_spar_2*(spar_2_up-z_E(ii))*scale; % stress at upper end of spar 2
sigma_l_spar_2 = bending_curvature*Ex_spar_2*(spar_2_low-z_E(ii))*scale; % stress at lower end of spar 2

sigma_cap_1_u = bending_curvature*Ex_cap_1_u*(z_airfoil_u_1-z_E(ii)-t_skin_reinf/cos(slope_u_1))*scale; % stress at upper cap 1
sigma_cap_1_l = bending_curvature*Ex_cap_1_l*(z_airfoil_l_1-z_E(ii)+t_skin_reinf/cos(slope_l_1))*scale; % stress at lower cap 1
sigma_cap_2_u = bending_curvature*Ex_cap_2_u*(z_airfoil_u_2-z_E(ii)-t_skin_reinf/cos(slope_u_2))*scale; % stress at upper cap 2
sigma_cap_2_l = bending_curvature*Ex_cap_2_l*(z_airfoil_l_2-z_E(ii)+t_skin_reinf/cos(slope_l_2))*scale; % stress at lower cap 2

sigma_u_side_cap_1 = bending_curvature*Ex_side_cap_1*(spar_1_up-z_E(ii))*scale;
sigma_l_side_cap_1 = bending_curvature*Ex_side_cap_1*(spar_1_low-z_E(ii))*scale;
sigma_u_side_cap_2 = bending_curvature*Ex_side_cap_2*(spar_2_up-z_E(ii))*scale;
sigma_l_side_cap_2 = bending_curvature*Ex_side_cap_2*(spar_2_low-z_E(ii))*scale;

M_b_spar_1(ii) = bending_curvature*(Ex_spar_1*I_spar_1+EI_cap_1_u/scale^4+EI_cap_1_l/scale^4+Ex_side_cap_1*(I_side_cap_1_u+I_side_cap_1_l))*scale^4;
M_b_spar_2(ii) = bending_curvature*(Ex_spar_2*I_spar_2+EI_cap_2_u/scale^4+EI_cap_2_l/scale^4+Ex_side_cap_2*(I_side_cap_2_u+I_side_cap_2_l))*scale^4;
M_b_skin(ii) = bending_curvature*(Ex_skin*I_skin+Ex_skin_reinf*I_skin_reinf)*scale^4;

%% Additional load due to taper (Megson 23.6) Revised 14/10/2024
x_spar_1_0(ii) = x_spar_1;
x_spar_2_0(ii) = x_spar_2;
spar_1_up_0(ii) = spar_1_up;
spar_1_low_0(ii) = spar_1_low;
spar_2_up_0(ii) = spar_2_up;
spar_2_low_0(ii) = spar_2_low;
if ii<length(y_coord)
    % bo /2 duoi mau
    dz_dy_1_u = (-spar_1_up_0(ii+1)*c_length(ii+1)+spar_1_up_0(ii)*c_length(ii))/dy;
    dz_dy_1_l = (-spar_1_low_0(ii+1)*c_length(ii+1)+spar_1_low_0(ii)*c_length(ii))/dy;
    dz_dy_2_u = (-spar_2_up_0(ii+1)*c_length(ii+1)+spar_2_up_0(ii)*c_length(ii))/dy;
    dz_dy_2_l = (-spar_2_low_0(ii+1)*c_length(ii+1)+spar_2_low_0(ii)*c_length(ii))/dy;
     % hoanh do tuyet doi cua dam: x_LE - x_spar*c (truc x huong ve phia truoc)
    dx_dy_1 = (-x_LE(ii+1)+x_spar_1_0(ii+1)*c_length(ii+1)+x_LE(ii)-x_spar_1_0(ii)*c_length(ii))/dy;
    dx_dy_2 = (-x_LE(ii+1)+x_spar_2_0(ii+1)*c_length(ii+1)+x_LE(ii)-x_spar_2_0(ii)*c_length(ii))/dy;
    
    delta_F_shear = (-(sigma_cap_1_u*d_cap_1*t_cap_1_u + sigma_u_side_cap_1*d_side_cap_1*t_side_cap_1)*dz_dy_1_u-...
        (sigma_cap_1_l*d_cap_1*t_cap_1_l + sigma_l_side_cap_1*d_side_cap_1*t_side_cap_1)*dz_dy_1_l-...
        (sigma_cap_2_u*d_cap_2*t_cap_2_u + sigma_u_side_cap_2*d_side_cap_2*t_side_cap_2)*dz_dy_2_u-...
        (sigma_cap_2_l*d_cap_2*t_cap_2_l + sigma_l_side_cap_2*d_side_cap_2*t_side_cap_2)*dz_dy_2_l)*scale^2;
    
    delta_M = (-(sigma_cap_1_u*d_cap_1*t_cap_1_u + sigma_u_side_cap_1*d_side_cap_1*t_side_cap_1)*dx_dy_1*(spar_1_up-z_E(ii))-...
        (sigma_cap_1_l*d_cap_1*t_cap_1_l + sigma_l_side_cap_1*d_side_cap_1*t_side_cap_1)*dx_dy_1*(spar_1_low-z_E(ii))-...
        (sigma_cap_2_u*d_cap_2*t_cap_2_u + sigma_u_side_cap_2*d_side_cap_2*t_side_cap_2)*dx_dy_2*(spar_2_up-z_E(ii))-...
        (sigma_cap_2_l*d_cap_2*t_cap_2_l + sigma_l_side_cap_2*d_side_cap_2*t_side_cap_2)*dx_dy_2*(spar_2_low-z_E(ii)))*scale^3;
    
    delta_F_shear = delta_F_shear-(max_sigma_u_skin_reinf*t_skin_reinf*d_reinf_1*dz_dy_1_u+...
        max_sigma_l_skin_reinf*t_skin_reinf*d_reinf_1*dz_dy_1_l+...
        max_sigma_u_skin_reinf*t_skin_reinf*d_reinf_2*dz_dy_2_u+...
        max_sigma_l_skin_reinf*t_skin_reinf*d_reinf_2*dz_dy_2_l)*scale^2;

    delta_M = delta_M-(max_sigma_u_skin_reinf*t_skin_reinf*d_reinf_1*dx_dy_1*(spar_1_up-z_E(ii))+...
        max_sigma_l_skin_reinf*t_skin_reinf*d_reinf_1*dx_dy_1*(spar_1_low-z_E(ii))+...
        max_sigma_u_skin_reinf*t_skin_reinf*d_reinf_2*dx_dy_2*(spar_2_up-z_E(ii))+...
        max_sigma_l_skin_reinf*t_skin_reinf*d_reinf_2*dx_dy_2*(spar_2_low-z_E(ii)))*scale^3;
else
    delta_F_shear = 0;
    delta_M = 0;
end

%% Torsion and shear center (Revised 12/10/2024) (Megson 20.3.2; 20.2; 23.4; 23.5)
% Shear force
F0 = F_point.*(y_point >= y_coord(ii));
if ii == length(y_coord)
    F_shear(ii) = 0;
else
    F_shear(ii) = (sum(F0)-sum(n_load*9.81*0.5*(m_airfoil(ii+1:end)+m_airfoil(ii:end-1)))*dy);
end

F_shear(ii) = F_shear(ii)+F_react;

% Luc cat co tinh vat: F_shear (ngoai luc) + hieu chinh do taper (Megson 23.6)
% F_shear giu nguyen la luc cat ngoai vi coupled_beam dung no de tinh tai nut
F_shear_incl_taper = F_shear(ii)+delta_F_shear;

if F_shear_incl_taper==0
    F_shear_incl_taper =.01;
end
% Duong dong cat cua vo (Revised 20/10/2026)
% Dong cat chay tai tam do cung cat cua laminate tai cho, khong phai tren OML.
% Laminate tai cho = lop nen (vo thuong hoac dai gia cuong) + mu dam / side cap
% xep tu OML vao trong (giong gen_apdl_wing.py); cac lop ±45 cua mu dam va side
% cap cung chiu cat. Tinh tren luoi min 1000 diem theo day cung, gop ve 100 phan
% tu vo (.005:.01:.995):
%   Gt_u, Gt_l : do cung cat G*t cua phan tu (t theo phan day cung), gop noi tiep
%   dq_u, dq_l : do sau tam dong cat tinh tu OML (phan day cung)
xs = .0005:.001:.9995;
in_x = @(a,b) xs > a & xs < b;
Gt0 = G_skin*t_skin*ones(size(xs));
t0 = t_skin*ones(size(xs));
in_r = in_x(x_reinf_1-d_reinf_1/2, x_reinf_1+d_reinf_1/2) | in_x(x_reinf_2-d_reinf_2/2, x_reinf_2+d_reinf_2/2);
Gt0(in_r) = G_skin_reinf*t_skin_reinf;
t0(in_r) = t_skin_reinf;
in_c1 = in_x(x_spar_1-d_cap_1/2, x_spar_1+d_cap_1/2);
in_c2 = in_x(x_spar_2-d_cap_2/2, x_spar_2+d_cap_2/2);
in_s1 = in_x(x_spar_1+d_cap_1/2, x_spar_1+d_cap_1/2+d_side_cap_1);
in_s2 = in_x(x_spar_2-d_cap_2/2-d_side_cap_2, x_spar_2-d_cap_2/2);
Gt_s = G_side_cap_1*t_side_cap_1*in_s1 + G_side_cap_2*t_side_cap_2*in_s2;
t_s = t_side_cap_1*in_s1 + t_side_cap_2*in_s2;
Gt_add = Gt_s + G_cap_1_u*t_cap_1_u*in_c1 + G_cap_2_u*t_cap_2_u*in_c2; % mat tren
t_add = t_s + t_cap_1_u*in_c1 + t_cap_2_u*in_c2;
Gt_u = 1./mean(reshape(1./(Gt0+Gt_add),10,100));
dq_u = mean(reshape((Gt0.*t0/2 + Gt_add.*(t0+t_add/2))./(Gt0+Gt_add),10,100));
Gt_add = Gt_s + G_cap_1_l*t_cap_1_l*in_c1 + G_cap_2_l*t_cap_2_l*in_c2; % mat duoi
t_add = t_s + t_cap_1_l*in_c1 + t_cap_2_l*in_c2;
Gt_l = 1./mean(reshape(1./(Gt0+Gt_add),10,100));
dq_l = mean(reshape((Gt0.*t0/2 + Gt_add.*(t0+t_add/2))./(Gt0+Gt_add),10,100));
% z cua duong dong cat (lui vao trong dq theo phap tuyen, elem_length/.01 = 1/cos(slope))
z_q_u = (up(2:end)+up(1:end-1))/2 - dq_u.*elem_length_u/.01;
z_q_l = (lp(2:end)+lp(1:end-1))/2 + dq_l.*elem_length_l/.01;

% Cell areas (ben trong duong dong cat)
index1 = round(x_spar_1/.01);
index2 = round(x_spar_2/.01);
A1 = sum((z_q_u(1:index1-1)-z_q_l(1:index1-1))*.01);
A2 = sum((z_q_u(index1:index2-1)-z_q_l(index1:index2-1))*.01);
A3 = sum((z_q_u(index2:end)-z_q_l(index2:end))*.01);
% open beam shear flow 
q_b1 = F_shear_incl_taper/EI(ii)*...
    ((Ex_cap_1_u+Ex_cap_1_l)/2*d_cap_1*(t_cap_1_u+t_cap_1_l)/2+Ex_side_cap_1*d_side_cap_1*t_side_cap_1+...
    Ex_spar_1*h_spar_1*t_spar_1/6*(2-1)+Ex_skin*(sum(elem_length_u(index1:index2-1))+sum(elem_length_l(index1:index2-1)))/2*t_skin/6*(2+1)+...
    Ex_skin*(sum(elem_length_u(1:index1-1))+sum(elem_length_l(1:index1-1)))/2*t_skin/6*(2+0))*h_spar_1/2*scale^3;
q_b2 = F_shear_incl_taper/EI(ii)*...
    ((Ex_cap_2_u+Ex_cap_2_l)/2*d_cap_2*(t_cap_2_u+t_cap_2_l)/2+Ex_side_cap_2*d_side_cap_2*t_side_cap_2+...
    Ex_spar_2*h_spar_2*t_spar_2/6*(2-1)+Ex_skin*(sum(elem_length_u(index1:index2-1))+sum(elem_length_l(index1:index2-1)))/2*t_skin/6*(2+1)+...
    Ex_skin*(sum(elem_length_u(index2:end))+sum(elem_length_l(index2:end)))/2*t_skin/6*(2+0))*h_spar_2/2*scale^3;
q_b1 = q_b1+F_shear_incl_taper/EI(ii)*Ex_skin_reinf*t_skin_reinf*d_reinf_1*h_spar_1/2*scale^3;
q_b2 = q_b2+F_shear_incl_taper/EI(ii)*Ex_skin_reinf*t_skin_reinf*d_reinf_2*h_spar_2/2*scale^3;

% tich phan ds/(G*t) cua vo tung khoang
c_u = elem_length_u./Gt_u;
c_l = elem_length_l./Gt_l;
delta_1 = sum(c_u(1:index1-1))+sum(c_l(1:index1-1));
delta_2 = sum(c_u(index1:index2-1))+sum(c_l(index1:index2-1));
delta_3 = sum(c_u(index2:end))+sum(c_l(index2:end));
% Bung dam: chieu cao giua hai duong dong cat cua vo tai vi tri dam
x_el = .005:.01:.995;
h_q_1 = interp1(x_el,z_q_u,x_spar_1)-interp1(x_el,z_q_l,x_spar_1);
h_q_2 = interp1(x_el,z_q_u,x_spar_2)-interp1(x_el,z_q_l,x_spar_2);
delta_1_2 = h_q_1/G_spar_1/t_spar_1;
delta_2_3 = h_q_2/G_spar_2/t_spar_2;

% Shear center 
x_E(ii) = shear_center(q_b1,q_b2,A1,A2,A3,delta_1,delta_2,delta_3,delta_1_2,delta_2_3,x_spar_1,x_spar_2,h_spar_1,h_spar_2);

% Torsion moment
M_t(ii) = -(sum(0.8*F0.*(x_spar_1-x_E(ii))*scale+0.2*F0.*(x_spar_2-x_E(ii))*scale) -...
    sum(n_load*9.81*.5*(m_airfoil(ii+1:end)+m_airfoil(ii:end-1)).*(0.5*(xc_airfoil(ii+1:end)+xc_airfoil(ii:end-1))-x_E(ii))*scale)*dy);
M_t(ii) = M_t(ii)+M_react;

% Mo men xoan co tinh vat: M_t (ngoai luc) + phan hieu chinh do vat (Megson 23.6)
% M_t giu nguyen la mo men xoan ngoai vi coupled_beam dung no de tinh tai nut
M_t_incl_taper = M_t(ii)-delta_M;

if M_t_incl_taper == 0
   M_t_incl_taper = .1;
end
% Shear flow

[q1, q2, q3, GJ(ii)] = shear_flow(q_b1, q_b2, A1*scale^2, A2*scale^2, A3*scale^2,...
    delta_1, delta_2, delta_3, delta_1_2, delta_2_3, x_spar_1*scale, x_spar_2*scale, ...
    h_spar_1*scale, h_spar_2*scale, x_E(ii)*scale, M_t_incl_taper);

% Transverse shear stiffness for Timoshenko beam theory
kGA(ii) = shear_stiffness(q_b1,q_b2,delta_1,delta_2,delta_3,delta_1_2,delta_2_3,h_spar_1,h_spar_2,scale);

% Mean shear stress
Q = [q1/(t_skin*scale),q2/(t_skin*scale),q3/(t_skin*scale)];
[~,I] = max(abs(Q)); % shear stress on skin
max_shear_skin = Q(I);
shear_cap_1_u = max_shear_skin*t_skin/t_cap_1_u; % shear stress on cap 1
shear_cap_1_l = max_shear_skin*t_skin/t_cap_1_l; % shear stress on cap 1
shear_cap_2_u = max_shear_skin*t_skin/t_cap_2_u; % shear stress on cap 2
shear_cap_2_l = max_shear_skin*t_skin/t_cap_2_l; % shear stress on cap 2
max_shear_skin_reinf = max_shear_skin*t_skin/t_skin_reinf; % shear stress on reinforced skin
shear_side_cap_1 = max_shear_skin*t_skin/t_side_cap_1; % shear stress on side cap 1
shear_side_cap_2 = max_shear_skin*t_skin/t_side_cap_2; % shear stress on side cap 2
shear_spar_1 = (q_b1+q1-q2)/(t_spar_1*scale); % shear stress on front spar
shear_spar_2 = (q_b2+q2-q3)/(t_spar_2*scale); % shear stress on aft spar

%% Im calculation
% Front spar
I1_y = t_spar_1*h_spar_1*(x_E(ii)-x_spar_1)^2; % area moment of inertia
% Aft spar
I2_y = t_spar_2*h_spar_2*(x_E(ii)-x_spar_2)^2; % area moment of inertia
% caps
I_cap_1_u_y = t_cap_1_u*d_cap_1*(x_E(ii)-x_spar_1)^2;
I_cap_1_l_y = t_cap_1_l*d_cap_1*(x_E(ii)-x_spar_1)^2;
I_cap_2_u_y = t_cap_2_u*d_cap_2*(x_E(ii)-x_spar_2)^2;
I_cap_2_l_y = t_cap_2_l*d_cap_2*(x_E(ii)-x_spar_2)^2;
% side caps
I_side_cap_1_y = 2*t_side_cap_1*d_side_cap_1*(x_E(ii)-x_spar_1)^2;
I_side_cap_2_y = 2*t_side_cap_2*d_side_cap_2*(x_E(ii)-x_spar_2)^2;
% Skin
I_skin_y = sum((elem_length_u*t_skin).*((0.005:0.01:0.995)-x_E(ii)).^2)+...
    sum((elem_length_l*t_skin).*((0.005:0.01:0.995)-x_E(ii)).^2);

%% Revise 26/9/2024
I_skin_y = I_skin_y-...
    2*(x_spar_1-x_E(ii))^2*d_reinf_1*t_skin-...
    2*(x_spar_2-x_E(ii))^2*d_reinf_2*t_skin;
I_skin_y_reinf = 2*(x_spar_1-x_E(ii))^2*d_reinf_1*t_skin_reinf+...
    2*(x_spar_2-x_E(ii))^2*d_reinf_2*t_skin_reinf;

%% Moment quan tinh khoi luong (26/9/2024)
% Rib: trong tam (phan cua day cung) va khoang cach toi truc dan hoi (x_E, z_E)
x_rib = (x_spar_1+x_spar_2)/2;
z_rib = (spar_1_up+spar_1_low+spar_2_up+spar_2_low)/4;
d_rib_sq = (x_rib-x_E(ii))^2+(z_rib-z_E(ii))^2; % binh phuong khoang cach chuyen truc
Im(ii) = ((I_spar_1+I1_y)*sum(rho_spar_1.*t_layer_spar_1)/sum(t_layer_spar_1)+...
    (I_spar_2+I2_y)*sum(rho_spar_2.*t_layer_spar_2)/sum(t_layer_spar_2)+...
    (I_cap_1_u+I_cap_1_u_y)*sum(rho_cap_1_u.*t_layer_cap_1_u)/sum(t_layer_cap_1_u)+...
    (I_cap_1_l+I_cap_1_l_y)*sum(rho_cap_1_l.*t_layer_cap_1_l)/sum(t_layer_cap_1_l)+...
    (I_cap_2_u+I_cap_2_u_y)*sum(rho_cap_2_u.*t_layer_cap_2_u)/sum(t_layer_cap_2_u)+...
    (I_cap_2_l+I_cap_2_l_y)*sum(rho_cap_2_l.*t_layer_cap_2_l)/sum(t_layer_cap_2_l)+...
    (I_side_cap_1_u+I_side_cap_1_l+I_side_cap_1_y)*sum(rho_side_cap_1.*t_layer_side_cap_1)/sum(t_layer_side_cap_1)+...
    (I_side_cap_2_u+I_side_cap_2_l+I_side_cap_2_y)*sum(rho_side_cap_2.*t_layer_side_cap_2)/sum(t_layer_side_cap_2)+...
    (I_skin+I_skin_y)*sum(rho_skin.*t_layer_skin)/sum(t_layer_skin))*scale^4+...
    sum(rho_rib.*t_layer_rib)/sum(t_layer_rib)*t_rib*(h_spar_1+h_spar_2)/2*(x_spar_2-x_spar_1)*(((h_spar_1+h_spar_2)^2/4+(x_spar_2-x_spar_1)^2)/12+d_rib_sq)*n_rib*scale^5;
Im(ii) = Im(ii)+(I_skin_reinf+I_skin_y_reinf)*sum(rho_skin_reinf.*t_layer_skin_reinf)/sum(t_layer_skin_reinf)*scale^4;

%% Toa do z cua trong tam (phan day cung), cung cac thanh phan khoi luong nhu m_airfoil
% Bung dam: tru phan foam bi mu dam thay the o dau tren va dau duoi
zc_airfoil(ii) = (sum(rho_skin.*t_layer_skin)*(sum(elem_length_u.*z_skin_u)+sum(elem_length_l.*z_skin_l)) +...
    sum(rho_spar_1.*t_layer_spar_1)*h_spar_1*(spar_1_low+h_spar_1/2) -...
    rho_core*core_thickness_spar_1*((spar_1_up-foam_1_up)*(spar_1_up+foam_1_up)/2+(foam_1_low-spar_1_low)*(foam_1_low+spar_1_low)/2) +...
    sum(rho_spar_2.*t_layer_spar_2)*h_spar_2*(spar_2_low+h_spar_2/2) -...
    rho_core*core_thickness_spar_2*((spar_2_up-foam_2_up)*(spar_2_up+foam_2_up)/2+(foam_2_low-spar_2_low)*(foam_2_low+spar_2_low)/2) +...
    sum(rho_rib.*t_layer_rib)*(h_spar_1+h_spar_2)/2*(x_spar_2-x_spar_1)*scale*n_rib*z_rib +...
    sum(rho_cap_1_u.*t_layer_cap_1_u)*d_cap_1*z_cap_1_u + sum(rho_cap_1_l.*t_layer_cap_1_l)*d_cap_1*z_cap_1_l +...
    sum(rho_cap_2_u.*t_layer_cap_2_u)*d_cap_2*z_cap_2_u + sum(rho_cap_2_l.*t_layer_cap_2_l)*d_cap_2*z_cap_2_l +...
    sum(rho_side_cap_1.*t_layer_side_cap_1)*d_side_cap_1*(z_side_cap_1_u+z_side_cap_1_l) +...
    sum(rho_side_cap_2.*t_layer_side_cap_2)*d_side_cap_2*(z_side_cap_2_u+z_side_cap_2_l))*scale/m_airfoil(ii);
zc_airfoil(ii) = zc_airfoil(ii)+(sum(rho_skin_reinf.*t_layer_skin_reinf)*...
    (d_reinf_1*(z_reinf_u_1+z_reinf_l_1)+d_reinf_2*(z_reinf_u_2+z_reinf_l_2)) -...
    sum(rho_skin.*t_layer_skin)*(d_reinf_1*(z_sk_u_1+z_sk_l_1)+d_reinf_2*(z_sk_u_2+z_sk_l_2)))*scale/m_airfoil(ii);

%% Moment quan tinh xoay cua mat cat quanh truc uon
rhoI(ii) = (I_spar_1*sum(rho_spar_1.*t_layer_spar_1)/sum(t_layer_spar_1)+...
    I_spar_2*sum(rho_spar_2.*t_layer_spar_2)/sum(t_layer_spar_2)+...
    I_cap_1_u*sum(rho_cap_1_u.*t_layer_cap_1_u)/sum(t_layer_cap_1_u)+...
    I_cap_1_l*sum(rho_cap_1_l.*t_layer_cap_1_l)/sum(t_layer_cap_1_l)+...
    I_cap_2_u*sum(rho_cap_2_u.*t_layer_cap_2_u)/sum(t_layer_cap_2_u)+...
    I_cap_2_l*sum(rho_cap_2_l.*t_layer_cap_2_l)/sum(t_layer_cap_2_l)+...
    (I_side_cap_1_u+I_side_cap_1_l)*sum(rho_side_cap_1.*t_layer_side_cap_1)/sum(t_layer_side_cap_1)+...
    (I_side_cap_2_u+I_side_cap_2_l)*sum(rho_side_cap_2.*t_layer_side_cap_2)/sum(t_layer_side_cap_2)+...
    I_skin*sum(rho_skin.*t_layer_skin)/sum(t_layer_skin))*scale^4+...
    sum(rho_rib.*t_layer_rib)/sum(t_layer_rib)*t_rib*(h_spar_1+h_spar_2)/2*(x_spar_2-x_spar_1)*...
    ((h_spar_1+h_spar_2)^2/48+(z_rib-z_E(ii))^2)*n_rib*scale^5;
rhoI(ii) = rhoI(ii)+I_skin_reinf*sum(rho_skin_reinf.*t_layer_skin_reinf)/sum(t_layer_skin_reinf)*scale^4;

%% Rib and spar compression
a = rib_spacing*scale;
S_rib = (x_spar_2-x_spar_1)*t_rib*scale^2;
S_spar_1 = t_spar_1*scale;
S_spar_2 = t_spar_2*scale;
if ii == length(y_coord)
    compr_strain = 0;
else
    compr_strain = (F_dist(ii)-n_load*9.81*m_airfoil(ii))/(S_rib*Ez_rib*n_rib+S_spar_1*Ez_spar_1+S_spar_2*Ez_spar_2);
end

%% Rib shear
S_rib_shear = min([h_spar_1,h_spar_2])*t_rib*scale^2;
rib_shear_front = a*(F_dist(ii)-n_load*9.81*m_airfoil(ii))/2/S_rib_shear;
rib_shear_rear = a*(F_dist(ii)-n_load*9.81*m_airfoil(ii))/2/S_rib_shear;

%% Strain analysis
% Skin
strain_xy_u_skin = S_lam_skin*[max_sigma_u_skin; 0; max_shear_skin]; %#ok<*MINV> % Upper skin strain
strain_xy_l_skin = S_lam_skin*[max_sigma_l_skin; 0; max_shear_skin]; % Lower skin strain

%% Revised 26/9/2024
strain_xy_u_skin_reinf = S_lam_skin_reinf*[max_sigma_u_skin_reinf; 0; max_shear_skin_reinf]; % Upper reinforced skin strain
strain_xy_l_skin_reinf = S_lam_skin_reinf*[max_sigma_l_skin_reinf; 0; max_shear_skin_reinf]; % Lower reinforced skin strain
%%
% Front spar
strain_xz_u_spar_1 = S_lam_spar_1*[sigma_u_spar_1; -compr_strain*Ez_spar_1; shear_spar_1]; % Upper end
strain_xz_l_spar_1 = S_lam_spar_1*[sigma_l_spar_1; -compr_strain*Ez_spar_1; shear_spar_1]; % Lower end
% Aft spar
strain_xz_u_spar_2 = S_lam_spar_2*[sigma_u_spar_2; -compr_strain*Ez_spar_2; shear_spar_2]; % Upper end
strain_xz_l_spar_2 = S_lam_spar_2*[sigma_l_spar_2; -compr_strain*Ez_spar_2; shear_spar_2]; % Lower end
% Cap 1
strain_xy_u_cap_1 = S_lam_cap_1_u*[sigma_cap_1_u; 0; shear_cap_1_u]; % Upper end
strain_xy_l_cap_1 = S_lam_cap_1_l*[sigma_cap_1_l; 0; shear_cap_1_l]; % Lower end
% Cap 2
strain_xy_u_cap_2 = S_lam_cap_2_u*[sigma_cap_2_u; 0; shear_cap_2_u]; % Upper end
strain_xy_l_cap_2 = S_lam_cap_2_l*[sigma_cap_2_l; 0; shear_cap_2_l]; % Lower end
% side_cap 1
strain_xy_u_side_cap_1 = S_lam_side_cap_1*[sigma_u_side_cap_1; 0; shear_side_cap_1]; % Upper end
strain_xy_l_side_cap_1 = S_lam_side_cap_1*[sigma_l_side_cap_1; 0; shear_side_cap_1]; % Lower end
% side_cap 2
strain_xy_u_side_cap_2 = S_lam_side_cap_2*[sigma_u_side_cap_2; 0; shear_side_cap_2]; % Upper end
strain_xy_l_side_cap_2 = S_lam_side_cap_2*[sigma_l_side_cap_2; 0; shear_side_cap_2]; % Lower end

%% Revised 30/9/2024
strain_yz_front_rib = S_lam_rib*[0; -compr_strain*Ez_rib; rib_shear_front]; % Front edge of rib
strain_yz_rear_rib = S_lam_rib*[0; -compr_strain*Ez_rib; rib_shear_rear]; % rear edge of rib

%% Strength analysis (Tsai-Hill)
% Skin
f_u_skin(ii,1:length(E1_layer_skin)) = THstrength(E1_layer_skin,E2_layer_skin,theta_layer_skin,G12_layer_skin,nju_layer_skin,...
    E1_tens_layer_strength_skin,E2_tens_layer_strength_skin,E1_compr_layer_strength_skin,...
    E2_compr_layer_strength_skin,G12_layer_strength_skin,strain_xy_u_skin); % Upper skin
f_l_skin(ii,1:length(E1_layer_skin)) = THstrength(E1_layer_skin,E2_layer_skin,theta_layer_skin,G12_layer_skin,nju_layer_skin,...
    E1_tens_layer_strength_skin,E2_tens_layer_strength_skin,E1_compr_layer_strength_skin,...
    E2_compr_layer_strength_skin,G12_layer_strength_skin,strain_xy_l_skin); % Lower skin

%% Revised 26/9/2024
% Reinfoced skin
f_u_skin_reinf(ii,1:length(E1_layer_skin_reinf)) = THstrength(E1_layer_skin_reinf,E2_layer_skin_reinf,theta_layer_skin_reinf,G12_layer_skin_reinf,nju_layer_skin_reinf,...
    E1_tens_layer_strength_skin_reinf,E2_tens_layer_strength_skin_reinf,E1_compr_layer_strength_skin_reinf,...
    E2_compr_layer_strength_skin_reinf,G12_layer_strength_skin_reinf,strain_xy_u_skin_reinf); % Upper skin
f_l_skin_reinf(ii,1:length(E1_layer_skin_reinf)) = THstrength(E1_layer_skin_reinf,E2_layer_skin_reinf,theta_layer_skin_reinf,G12_layer_skin_reinf,nju_layer_skin_reinf,...
    E1_tens_layer_strength_skin_reinf,E2_tens_layer_strength_skin_reinf,E1_compr_layer_strength_skin_reinf,...
    E2_compr_layer_strength_skin_reinf,G12_layer_strength_skin_reinf,strain_xy_l_skin_reinf); % Lower skin

% Front spar
f_u_spar_1(ii,1:length(E1_layer_spar_1)) = THstrength(E1_layer_spar_1,E2_layer_spar_1,theta_layer_spar_1,G12_layer_spar_1,nju_layer_spar_1,...
    E1_tens_layer_strength_spar_1,E2_tens_layer_strength_spar_1,E1_compr_layer_strength_spar_1,...
    E2_compr_layer_strength_spar_1,G12_layer_strength_spar_1,strain_xz_u_spar_1); % Upper end 
f_l_spar_1(ii,1:length(E1_layer_spar_1)) = THstrength(E1_layer_spar_1,E2_layer_spar_1,theta_layer_spar_1,G12_layer_spar_1,nju_layer_spar_1,...
    E1_tens_layer_strength_spar_1,E2_tens_layer_strength_spar_1,E1_compr_layer_strength_spar_1,...
    E2_compr_layer_strength_spar_1,G12_layer_strength_spar_1,strain_xz_l_spar_1); % Lower end 

% Aft spar
f_u_spar_2(ii,1:length(E1_layer_spar_2)) = THstrength(E1_layer_spar_2,E2_layer_spar_2,theta_layer_spar_2,G12_layer_spar_2,nju_layer_spar_2,...
    E1_tens_layer_strength_spar_2,E2_tens_layer_strength_spar_2,E1_compr_layer_strength_spar_2,...
    E2_compr_layer_strength_spar_2,G12_layer_strength_spar_2,strain_xz_u_spar_2); % Upper end 
f_l_spar_2(ii,1:length(E1_layer_spar_2)) = THstrength(E1_layer_spar_2,E2_layer_spar_2,theta_layer_spar_2,G12_layer_spar_2,nju_layer_spar_2,...
    E1_tens_layer_strength_spar_2,E2_tens_layer_strength_spar_2,E1_compr_layer_strength_spar_2,...
    E2_compr_layer_strength_spar_2,G12_layer_strength_spar_2,strain_xz_l_spar_2); % Lower end 

% cap 1
f_u_cap_1(ii,1:length(E1_layer_cap_1_u)) = THstrength(E1_layer_cap_1_u,E2_layer_cap_1_u,theta_layer_cap_1_u,G12_layer_cap_1_u,nju_layer_cap_1_u,...
    E1_tens_layer_strength_cap_1_u,E2_tens_layer_strength_cap_1_u,E1_compr_layer_strength_cap_1_u,...
    E2_compr_layer_strength_cap_1_u,G12_layer_strength_cap_1_u,strain_xy_u_cap_1); % Upper end 
f_l_cap_1(ii,1:length(E1_layer_cap_1_l)) = THstrength(E1_layer_cap_1_l,E2_layer_cap_1_l,theta_layer_cap_1_l,G12_layer_cap_1_l,nju_layer_cap_1_l,...
    E1_tens_layer_strength_cap_1_l,E2_tens_layer_strength_cap_1_l,E1_compr_layer_strength_cap_1_l,...
    E2_compr_layer_strength_cap_1_l,G12_layer_strength_cap_1_l,strain_xy_l_cap_1); % Lower end 

% cap 2
f_u_cap_2(ii,1:length(E1_layer_cap_2_u)) = THstrength(E1_layer_cap_2_u,E2_layer_cap_2_u,theta_layer_cap_2_u,G12_layer_cap_2_u,nju_layer_cap_2_u,...
    E1_tens_layer_strength_cap_2_u,E2_tens_layer_strength_cap_2_u,E1_compr_layer_strength_cap_2_u,...
    E2_compr_layer_strength_cap_2_u,G12_layer_strength_cap_2_u,strain_xy_u_cap_2); % Upper end 
f_l_cap_2(ii,1:length(E1_layer_cap_2_l)) = THstrength(E1_layer_cap_2_l,E2_layer_cap_2_l,theta_layer_cap_2_l,G12_layer_cap_2_l,nju_layer_cap_2_l,...
    E1_tens_layer_strength_cap_2_l,E2_tens_layer_strength_cap_2_l,E1_compr_layer_strength_cap_2_l,...
    E2_compr_layer_strength_cap_2_l,G12_layer_strength_cap_2_l,strain_xy_l_cap_2); % Lower end 

    % Ribs
f_front_rib(ii,1:length(E1_layer_rib)) = THstrength(E1_layer_rib,E2_layer_rib,theta_layer_rib,G12_layer_rib,nju_layer_rib,...
    E1_tens_layer_strength_rib,E2_tens_layer_strength_rib,E1_compr_layer_strength_rib,...
    E2_compr_layer_strength_rib,G12_layer_strength_rib,strain_yz_front_rib); % Upper end 
f_rear_rib(ii,1:length(E1_layer_rib)) = THstrength(E1_layer_rib,E2_layer_rib,theta_layer_rib,G12_layer_rib,nju_layer_rib,...
    E1_tens_layer_strength_rib,E2_tens_layer_strength_rib,E1_compr_layer_strength_rib,...
    E2_compr_layer_strength_rib,G12_layer_strength_rib,strain_yz_rear_rib); % Lower end 

% side_cap 1
f_u_side_cap_1(ii,1:length(E1_layer_side_cap_1)) = THstrength(E1_layer_side_cap_1,E2_layer_side_cap_1,theta_layer_side_cap_1,G12_layer_side_cap_1,nju_layer_side_cap_1,...
    E1_tens_layer_strength_side_cap_1,E2_tens_layer_strength_side_cap_1,E1_compr_layer_strength_side_cap_1,...
    E2_compr_layer_strength_side_cap_1,G12_layer_strength_side_cap_1,strain_xy_u_side_cap_1); % Upper end 
f_l_side_cap_1(ii,1:length(E1_layer_side_cap_1)) = THstrength(E1_layer_side_cap_1,E2_layer_side_cap_1,theta_layer_side_cap_1,G12_layer_side_cap_1,nju_layer_side_cap_1,...
    E1_tens_layer_strength_side_cap_1,E2_tens_layer_strength_side_cap_1,E1_compr_layer_strength_side_cap_1,...
    E2_compr_layer_strength_side_cap_1,G12_layer_strength_side_cap_1,strain_xy_l_side_cap_1); % Lower end 

    % side_cap 2
f_u_side_cap_2(ii,1:length(E1_layer_side_cap_2)) = THstrength(E1_layer_side_cap_2,E2_layer_side_cap_2,theta_layer_side_cap_2,G12_layer_side_cap_2,nju_layer_side_cap_2,...
    E1_tens_layer_strength_side_cap_2,E2_tens_layer_strength_side_cap_2,E1_compr_layer_strength_side_cap_2,...
    E2_compr_layer_strength_side_cap_2,G12_layer_strength_side_cap_2,strain_xy_u_side_cap_2); % Upper end 
f_l_side_cap_2(ii,1:length(E1_layer_side_cap_2)) = THstrength(E1_layer_side_cap_2,E2_layer_side_cap_2,theta_layer_side_cap_2,G12_layer_side_cap_2,nju_layer_side_cap_2,...
    E1_tens_layer_strength_side_cap_2,E2_tens_layer_strength_side_cap_2,E1_compr_layer_strength_side_cap_2,...
    E2_compr_layer_strength_side_cap_2,G12_layer_strength_side_cap_2,strain_xy_l_side_cap_2); % Lower end 

%% Skin buckling analysis
% Gibson eq. 7.147
sigma_compr = abs(min([max_sigma_u_skin max_sigma_l_skin]));
N_compr = sigma_compr*t_skin*scale;
nn = 1;
m_array = 1:20;
D11 = D_lam_skin(1,1);
D12 = D_lam_skin(1,2);
D22 = D_lam_skin(2,2);
D66 = D_lam_skin(3,3);
b = (x_spar_2-x_spar_1)*scale;
R = a/b;
N_ratio_min_skin(ii) = 1e6;
for i=1:length(m_array)
    mm = m_array(i);
    N_cr = (pi^2/mm^2/a^2)*(D11*mm^4+2*(D12+2*D66)*(mm*nn*R)^2+D22*(nn*R)^4);
    if N_cr/N_compr<N_ratio_min_skin(ii)
        N_ratio_min_skin(ii) = N_cr/N_compr; % ratio of N force to critical N force
    end
end
f_buckling_skin = 1./N_ratio_min_skin;

%% Skin bending deflection
% Gibson eq. 7.139
% #Đề xuất bỏ cả khối
q0 = 0/a/b;
w_skin = 0;
for mm=1:2:15
    for nn=1:2:15
        q_mn = 16*q0/pi^2/mm/nn;
        w_skin = w_skin+a^4*q_mn/pi^4/(D11*mm^4+2*(D12+2*D66)*(mm*nn*R)^2+D22*(nn*R)^4);
    end
end
skin_defl_ratio(ii) = w_skin/scale*100; % Maximum skin bending deflection ratio

%% Rib buckling analysis
% Gibson eq. 7.147
sigma_compr = compr_strain*Ez_rib;
N_compr = sigma_compr*t_rib*scale;
nn = 1;
m_array = 1:10;
D11 = D_lam_rib(1,1);
D12 = D_lam_rib(1,2);
D22 = D_lam_rib(2,2);
D66 = D_lam_rib(3,3);
b = (x_spar_2-x_spar_1)*scale;
a_rib = (h_spar_1+h_spar_2)/2*scale;
R = a_rib/b;
N_ratio_min_rib(ii) = 1e6;
for i=1:length(m_array)
    mm = m_array(i);
    N_cr = (pi^2/mm^2/a_rib^2)*(D11*mm^4+2*(D12+2*D66)*(mm*nn*R)^2+D22*(nn*R)^4);
    if N_cr/N_compr<N_ratio_min_rib(ii)
        N_ratio_min_rib(ii) = N_cr/N_compr; % ratio of N force to critical N force
    end
end
f_buckling_rib = 1./N_ratio_min_rib;

%% von Mises stress
v_stress_u_skin(ii) = vonMises([max_sigma_u_skin; 0; max_shear_skin])*t_skin*scale/(t_skin*scale-core_thickness_skin);
v_stress_l_skin(ii) = vonMises([max_sigma_l_skin; 0; max_shear_skin])*t_skin*scale/(t_skin*scale-core_thickness_skin);
v_stress_u_skin_reinf(ii) = vonMises([max_sigma_u_skin_reinf; 0; max_shear_skin_reinf]);
v_stress_l_skin_reinf(ii) = vonMises([max_sigma_l_skin_reinf; 0; max_shear_skin_reinf]);
v_stress_u_cap_1(ii) = vonMises([sigma_cap_1_u; 0; shear_cap_1_u]);
v_stress_u_cap_2(ii) = vonMises([sigma_cap_2_u; 0; shear_cap_2_u]);
v_stress_l_cap_1(ii) = vonMises([sigma_cap_1_l; 0; shear_cap_1_l]);
v_stress_l_cap_2(ii) = vonMises([sigma_cap_2_l; 0; shear_cap_2_l]);
%rib
v_stress_front_rib(ii) = vonMises([0; -compr_strain*Ez_rib; rib_shear_front]);
v_stress_rear_rib(ii) = vonMises([0; -compr_strain*Ez_rib; rib_shear_rear]);

%% equivalent strain
eq_strain_u_skin(ii) = eq_strain(strain_xy_u_skin);
eq_strain_l_skin(ii) = eq_strain(strain_xy_l_skin);
eq_strain_u_skin_reinf(ii) = eq_strain(strain_xy_u_skin_reinf);
eq_strain_l_skin_reinf(ii) = eq_strain(strain_xy_l_skin_reinf);
eq_strain_u_cap_1(ii) = eq_strain(strain_xy_u_cap_1);
eq_strain_u_cap_2(ii) = eq_strain(strain_xy_u_cap_2);
eq_strain_l_cap_1(ii) = eq_strain(strain_xy_l_cap_1);
eq_strain_l_cap_2(ii) = eq_strain(strain_xy_l_cap_2);
eq_strain_front_rib(ii) = eq_strain(strain_yz_front_rib);
eq_strain_rear_rib(ii) = eq_strain(strain_yz_rear_rib);