clear,clc,close all

%% Sistema mecanico

g = 9.80665;              % m/s^2

m = 1.12;                 % kg
m_unc = 0.16;             % kg (incertidumbre)

l_cm = 0.125;             % m
J_cm = 6.085e-3;          % kg*m^2

l_l = 0.25;               % m

m_l = [0 1.5];            % kg (rango de carga)

J_l = (m*l_cm^2 + J_cm) + m_l*l_l^2;   % kg*m^2

omega_0 = 821;            % rad/s
n_0 = 7840;               % rpm

K_t = 21.7e-3;            % Nm/A

I_0 = 0.448;              % A

J_m = 2.3e-6;             % kg*m^2

b_m = (K_t*I_0)/omega_0;  % Nm/(rad/s)

r = 156;                  % relacion de transmision

b_l = b_m*r^2;            % friccion equivalente en articulacion

k_l = m*g*l_cm+m_l*g*l_l; % constante de carga gravitacional

J_eq = J_l*(1/r)^2+J_m;   % Inercia equivalente del lado motor

b_eq = b_l*(1/r)^2+b_m;   % friccion equivalente del lado motor

%% Sistema electromagnetico

I_0 = 0.448;              % A

R_s = 0.196;              % Ohm
L_s = 0.113e-3;           % H

K_e = 0.0217;             % V/(rad/s)

p = 7;                  % pares de polos

psi_m = K_e/(1.5*p);    % Wb



%% Ubicacion de polos

% Funcion de transferencia en vacio (T_L=0)
num_Gu = [K_t];
den_Gu = [L_s*J_eq (R_s*J_eq+L_s*b_eq) (R_s*b_eq+K_e*K_t)];

G_u = tf(num_Gu,den_Gu);

num_Gtl = [0 0 -(1/r)*(Lq) -(1/r)*Rs_ref];
den_G = [Jeq*Lq (Lq*beq+Rs_ref*Jeq) (Rs_ref*beq+(3/2)*(Pp*lambda_m)^2) 0];

G_orig = tf(num_Gtl,den_G);

% Rs_step = (max(Rs)-min(Rs))/10;
% Rs_range = zeros(1,10);
% Rs_range(1) = min(Rs);
% for i = 2:11
%     Rs_range(i) = Rs_range(i-1) + Rs_step;
%     num_Gtl = [0 0 -(1/r)*(Lq) -(1/r)*Rs_range(i)];
%     den_G = [Jeq*Lq (Lq*beq+Rs_range(i)*Jeq) (Rs_range(i)*beq+(3/2)*(Pp*lambda_m)^2) 0];
%     % polos = roots(den_G)
%     % G_orig = tf(num_Gtl,den_G);
%     % figure(2)
%     % pzmap(G_orig)
%     % hold on
% end
% % grid on
% % xlim([-250,0])
% % ylim([-250,250])
% % xlabel('Eje Real')
% % ylabel('Eje Imaginario')
% % title('Diagrama de polos y ceros a lazo abierto para barrido de parámetros RS')
% 
% % Para Jeq_min, beq_min y Rs_min
% den_G = [Jeq*Lq (Lq*beq_min+Rs_range(1)*Jeq) (Rs_range(1)*beq_min+(3/2)*(Pp*lambda_m)^2) 0];
% r11 = roots(den_G);
% z11 = roots(num_Gtl);
% Gmin1 = tf(num_Gtl,den_G);
% 
% % Para Jeq_max, beq_min y Rs_min
% den_G = [Jeq_max*Lq (Lq*beq_min+Rs_range(1)*Jeq_max) (Rs_range(1)*beq_min+(3/2)*(Pp*lambda_m)^2) 0];
% r21 = roots(den_G);
% z21 = roots(num_Gtl);
% Gmin2 = tf(num_Gtl,den_G);
% 
% % Para Jeq_min, beq_max y Rs_min
% den_G = [Jeq*Lq (Lq*beq_max+Rs_range(1)*Jeq) (Rs_range(1)*beq_max+(3/2)*(Pp*lambda_m)^2) 0];
% r12 = roots(den_G);
% z12 = roots(num_Gtl);
% Gmax1 = tf(num_Gtl,den_G);
% 
% % Para Jeq_max, beq_max y Rs_min
% den_G = [Jeq_max*Lq (Lq*beq_max+Rs_range(1)*Jeq_max) (Rs_range(1)*beq_max+(3/2)*(Pp*lambda_m)^2) 0];
% r22 = roots(den_G);
% z22 = roots(num_Gtl);
% Gmax2 = tf(num_Gtl,den_G);
% 
% % figure(1)
% % hold
% % pzmap(Gmin1)
% % pzmap(Gmin2)
% % pzmap(Gmax1)
% % pzmap(Gmax2)
% % legend('Jeq_min, beq_min', ...
% %     'Jeq_max, beq_min', ...
% %     'Jeq_min, beq_max', ...
% %     'Jeq_max, beq_max')
% % grid on
% % title('Detalle Rs = 1.02 ohm')
% % xlim([-70,-68])
% 
% % Para Jeq_min, beq_min y Rs_max
% den_G = [Jeq*Lq (Lq*beq_min+Rs_range(11)*Jeq) (Rs_range(11)*beq_min+(3/2)*(Pp*lambda_m)^2) 0];
% r11 = roots(den_G);
% z11 = roots(num_Gtl);
% Gmin1 = tf(num_Gtl,den_G);
% 
% % Para Jeq_max, beq_min y Rs_max
% den_G = [Jeq_max*Lq (Lq*beq_min+Rs_range(11)*Jeq_max) (Rs_range(11)*beq_min+(3/2)*(Pp*lambda_m)^2) 0];
% r21 = roots(den_G);
% z21 = roots(num_Gtl);
% Gmin2 = tf(num_Gtl,den_G);
% 
% % Para Jeq_min, beq_max y Rs_max
% den_G = [Jeq*Lq (Lq*beq_max+Rs_range(11)*Jeq) (Rs_range(11)*beq_max+(3/2)*(Pp*lambda_m)^2) 0];
% r12 = roots(den_G);
% z12 = roots(num_Gtl);
% Gmax1 = tf(num_Gtl,den_G);
% 
% % Para Jeq_max, beq_max y Rs_max
% den_G = [Jeq_max*Lq (Lq*beq_max+Rs_range(11)*Jeq_max) (Rs_range(11)*beq_max+(3/2)*(Pp*lambda_m)^2) 0];
% r22 = roots(den_G);
% z22 = roots(num_Gtl);
% Gmax2 = tf(num_Gtl,den_G);
% % 
% % figure(2)
% % hold
% % pzmap(Gmin1)
% % pzmap(Gmin2)
% % pzmap(Gmax1)
% % pzmap(Gmax2)
% % legend('Jeq_min, beq_min', ...
% %     'Jeq_max, beq_min', ...
% %     'Jeq_min, beq_max', ...
% %     'Jeq_max, beq_max')
% % grid on
% % title('Detalle Rs = 1.32 ohm')
% % xlim([-115,-113])


%% Valor de frecuencia y amortiguacion relativa
% Primeros dos
wn = sqrt((Rs_ref*beq + 1.5*Pp^2*lambda_m^2)/Jeq*Lq);
xita = (Lq*beq+Rs_ref*Jeq)/Jeq*Lq*2*wn;

% Para Jeq_min, beq_min y Rs_min
wn11 = sqrt((Rs_ref*beq_min + 1.5*Pp^2*lambda_m^2)/Jeq*Lq);
xita11 = (Lq*beq_min+Rs_ref*Jeq)/Jeq*Lq*2*wn11;

% Para Jeq_max, beq_min y Rs_min
wn12 = sqrt((Rs_ref*beq_min + 1.5*Pp^2*lambda_m^2)/Jeq_max*Lq);
xita12 = (Lq*beq_min+Rs_ref*Jeq_max)/Jeq_max*Lq*2*wn12;

% Para Jeq_min, beq_max y Rs_min
wn21 = sqrt((Rs_ref*beq_max + 1.5*Pp^2*lambda_m^2)/Jeq*Lq);
xita21 = (Lq*beq_max+Rs_ref*Jeq)/Jeq*Lq*2*wn21;

% Para Jeq_max, beq_max y Rs_min
wn22 = sqrt((Rs_ref*beq_max + 1.5*Pp^2*lambda_m^2)/Jeq_max*Lq);
xita22 = (Lq*beq_max+Rs_ref*Jeq_max)/Jeq_max*Lq*2*wn22;


%% Lazo de corriente
p = -5000;
tau = -1/p;
G_i = tf(1,[tau 1]);
%% Controlador PID Jeq nominal

n = 2.5;
w_pos = 800;

ba = Jeq*n*w_pos;
Ksa = Jeq*n*w_pos^2;
Ksia = Jeq*w_pos^3;

num_PID = [0 ba Ksa Ksia];
den_PID = [Jeq ba Ksa Ksia];
G_PID = tf(num_PID,den_PID)
roots(den_PID);

%% Controlador PID Jeq max

num_PID = [0 ba Ksa Ksia];
den_PID = [Jeq_max ba Ksa Ksia];
G_PID_max = tf(num_PID,den_PID);
roots(den_PID);

figure(1)
h = pzplot(G_orig, G_i, G_PID, G_PID_max);
grid on

%% Constantes del observador
A = [0 1
     0 0];

Bc = [0
      1/Jeq];

Bd = -r*Bc;

C = [1 0];

D = [0];
sist = ss(A,Bc,C,D);
H_sist = tf(sist)

syms Ktita Komega s
K = [Ktita
    Komega];

A_prima = A - K*C;

I = eye(2);

p_obs = expand(det(s*I-A_prima))

p_des = expand((s+3200)^2)

Ke_tita = 6400;
Ke_w = 10240000;

%% Simulacion Sistema Completo
% Define time parameters
t_start = 0;
t_ramp_up = 5;
t_constant = 10;
t_end = 15;
t_step = 0.01;

% Create time vector
t = t_start:t_step:(t_end-t_step);


% Create ramp up, constant, and ramp down vectors
ramp_up = linspace(0, 2*pi, round((t_ramp_up-t_start)/t_step));
constant = 2*pi*ones(1, round((t_constant-t_ramp_up)/t_step));
ramp_down = linspace(2*pi, 0, round((t_end-t_constant)/t_step));

% Concatenate vectors to create the final function
q = [ramp_up constant ramp_down];


% % Plot the function
% plot(t, q);
% xlabel('Time (s)');
% ylabel('Function Value');
% title('Ramp-Constant-Ramp Function');
% 
q = timeseries(q,t);

%% Nueva consigna

% Primera parte
t1_start = 0;
t1_ramp_up = 0.1;
t1_end = 5;
t1_step = 0.01;
t1 = t1_start:t1_step:(t1_end-t1_step);

ramp_up1 = linspace(0, 2*pi/5, round((t1_ramp_up-t1_start)/t1_step));
constant1 = 2*pi/5*ones(1, round((t1_end-t1_ramp_up)/t1_step));

q1 = [ramp_up1 constant1];


% Segunda parte
t2_start = 5;
t2_ramp_down = 5.1;
t2_end = 10;
t2_step = 0.01;
t2 = t2_start:t2_step:(t2_end-t2_step);

ramp_down2 = linspace(2*pi/5, 0, round((t2_ramp_down-t2_start)/t2_step));
constant2 = zeros(1, round((t2_end-t2_ramp_down)/t2_step));

q2 = [ramp_down2 constant2];

% Tercera parte
t3_start = 10;
t3_ramp_down = 10.1;
t3_ramp_up = 14.9;
t3_constant = 15;
t3_end = 20;
t3_step = 0.01;
t3 = t3_start:t3_step:(t3_end-t3_step);

ramp_down3 = linspace(0, -2*pi/5, round((t3_ramp_down-t3_start)/t3_step));
constant3 = -2*pi/5*ones(1, round((t3_ramp_up-t3_ramp_down)/t3_step));
ramp_up3 = linspace(-2*pi/5, 0, round((t3_constant-t3_ramp_up)/t3_step));
constant4 = zeros(1, round((t3_end-t3_constant)/t3_step));

q3 = [ramp_down3 constant3 ramp_up3 constant4];

% Final
t4_start = 15.01;


t_new = [t1 t2 t3];
q_vel = [q1 q2 q3];

% % Plot the function
% plot(t_new, q_vel);
% xlabel('Time (s)');
% ylabel('Function Value');
% title('Ramp-Constant-Ramp Function');

q_vel = timeseries(q_vel,t_new);

%% Mejora del Observador

syms Ktita Komega Kint s

A_aug = [0 1 0
         0 0 1
         0 0 0];
B_aug = [0
         1/Jeq
         0];

C_aug = [1 0 0];

K = [Ktita
    Komega
    Kint];

A_int = A_aug - K*C_aug;

I = eye(3);

p_obs = expand(det(s*I-A_int))

p_des = expand((s+3200)^3)

ke_tita = 9600;
ke_w = 30720000;
ke_int = 32768000000;

K = [9600
    30720000
    32768000000];
A_int = A_aug - K*C_aug;

G_obs = C_aug*((s*I-A_int)^-1)*B_aug
G_obs = tf([0 0 6946721411010179/137438953472 0],[1 ke_tita ke_w ke_int])

%% Prueba Térmica
% q_ter = [q_vel q_vel q_vel q_vel q_vel q_vel q_vel q_vel q_vel q_vel q_vel q_vel q_vel q_vel q_vel q_vel q_vel q_vel q_vel q_vel];
% t_ter = 0:0.01:(300-0.01);
% 
% q_ter = timeseries(q_ter,t_ter);

%% Sensores no ideales
frec_tita = 5000; 
xita_tita = 1;

A_tita = [0 -1; frec_tita^2 -2*frec_tita*xita_tita];
B_tita = [1 ; 0];
C_tita = [0 1];
D_tita = [0];

frec_iabc = 10000; 
xita_iabc = 1;

A_iabc = [0 -1; frec_iabc^2 -2*frec_iabc*xita_iabc];
B_iabc = [1 ; 0];
C_iabc = [0 1];
D_iabc = [0];

tau = 1;

A_temp = [-1/tau];
B_temp = [1];
C_temp = [1/tau];
D_temp = [0];

%% Modulador de Tension no ideal
frec_vmod = 6000*5;
xita_vmod = 1;

A_vmod = [0 -1; frec_vmod^2 -2*frec_vmod*xita_vmod];
B_vmod = [1 ; 0];
C_vmod = [0 1];
D_vmod = 0;

Vsl = 24;
Vsat = sqrt(2/3)*Vsl;

%% Controlador Discreto
Ts = 2*pi/(3200*10);
% 
% G_PID_z = c2d(G_PID,Ts,'tustin')
% [num_z,den_z] = tfdata(G_PID_z,'v')
% 
% b0 = num_z(1);
% b1 = num_z(2);
% b2 = num_z(3);
% b3 = num_z(4);
% a0 = den_z(1);
% a1 = den_z(2);
% a2 = den_z(3);
% a3 = den_z(4);
% 
% % figure(1)
% % step(G_PID,'--',G_PID_z,'-')
% % figure(2)
% % pzmap(G_PID_z)
% 
% G_obs_z = c2d(G_obs,Ts,'tustin')
% 
% syms Kp Ki Kd real
% eq1 = b0 == Kp + (Ki * Ts / 2) + (2 * Kd / Ts);
% eq2 = b1 == -Kp + (Ki * Ts / 2) - (2 * Kd / Ts);
% 
% sol = solve([eq1, eq2], [Kp, Ki, Kd]);
% Kp_discrete = double(sol.Kp)
% Ki_discrete = double(sol.Ki)
% Kd_discrete = double(sol.Kd)

% stepinfo(G_orig,'SettlingTimeThreshold',0.01)
