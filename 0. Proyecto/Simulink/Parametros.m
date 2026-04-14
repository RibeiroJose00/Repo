clear,clc,close all

%% Sistema mecanico

g = 9.80665;              % m/s^2

m = 1.12;                 % kg

l_cm = 0.125;             % m
J_cm = 6.085e-3;          % kg*m^2

l_l = 0.25;               % m

% m_l = [0 1.5];                  % [0 1.5] kg (rango de carga)
m_l = 1.5;

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

% k_l_nom = 0.5*(k_l(1)+k_l(2)); 

J_eq = J_l*(1/r)^2+J_m;   % Inercia equivalente del lado motor

% J_eq_max =( ( m*l_cm^2 + J_cm ) + 1.5*l_l^2 )*(1/r)^2+J_m;
% 
% J_eq_min = (m*l_cm^2 + J_cm)*(1/r)^2+J_m;

b_eq = b_l*(1/r)^2+b_m;   % friccion equivalente del lado motor

roll = deg2rad(0);

pitch = deg2rad(0);

yaw = deg2rad(-0);         % Ángulos de rotación

s_pitch = sin(pitch);

c_pitch = cos(pitch);

s_roll = sin(roll);

%% Sistema electromagnetico

I_0 = 0.448;              % A

R_s = 0.196;              % Ohm
L_s = 0.113e-3;           % H

K_e = 0.0217;             % V/(rad/s)

p = 7;                  % pares de polos

psi_m = K_e/(1.5*p);    % Wb

U_d = 18;               %V

%% Ubicacion de polos

% % Funcion de transferencia en vacio (T_L=0)
% num_Gu = [0 0 K_t 0];
% den_Gu = [L_s*J_eq(1) (R_s*J_eq(1)+L_s*b_eq) (L_s*k_l*s_pitch+R_s*b_eq+K_e*K_t) R_s*k_l*s_pitch];
% 
% G_u = tf(num_Gu,den_Gu);
% 
% % Funcion de transferencia sin alimentacion y con carga (U_d=0; T_p~=0)
% num_GL = [0 L_s/r R_s/r 0];
% den_GL = [L_s*J_eq(1) (R_s*J_eq(1)+L_s*b_eq) (L_s*k_l*s_pitch+R_s*b_eq+K_e*K_t) R_s*k_l*s_pitch];
% 
% G_orig = tf(num_GL,den_GL);
% 
% % figure(1)
% % pzmap(G_u)
% % grid on
% % xlabel('Eje Real')
% % ylabel('Eje Imaginario')
% % xlim([-2000,0])
% % ylim([-100,100])
% % title('Diagrama de polos y ceros a lazo abierto')


%% Valor de frecuencia y amortiguacion relativa
% % wn = sqrt((R_s*b_eq + K_e^2)/(J_eq_nom*L_s));   
% % xita = (L_s*b_eq+R_s*J_eq_nom)/(J_eq_nom*L_s*2*wn);
% % 
% % s = pole(G_L);
% 
% 
% Jeq_step = (max(J_eq)-min(J_eq))/9;
% k_l_step = (max(k_l)-min(k_l))/9;
% Jeq_range = zeros(1,9);
% Jeq_range(1) = min(J_eq);
% k_l_range = zeros(1,9);
% k_l_range(1) = min(k_l);
% num_Gu = [0 0 K_t 0];
% den_Gu = [L_s*J_eq(1) (R_s*J_eq(1)+L_s*b_eq) (L_s*k_l(1)*s_pitch+R_s*b_eq+K_e*K_t) R_s*k_l(1)*s_pitch];
% polos = roots(den_Gu)
% G_L = tf(num_Gu,den_Gu);
% figure(1)
% pzmap(G_L,'r')
% hold on
% for i = 2:10
%     Jeq_range(i) = Jeq_range(i-1) + Jeq_step;
%     k_l_range(i) = k_l_range(i-1) + k_l_step;
%     num_Gu = [0 0 L_s R_s];
%     den_Gu = [L_s*Jeq_range(i) (R_s*Jeq_range(i)+L_s*b_eq) (L_s*k_l_range(i)*s_pitch+R_s*b_eq+K_e*K_t) R_s*k_l_range(i)*s_pitch];
%     polos = roots(den_Gu)
%     G_L = tf(num_Gu,den_Gu);
%     pzmap(G_L,'r')
%     hold on
% end
% grid on
% xlim([-250,0])
% ylim([-250,250])
% xlabel('Eje Real')
% ylabel('Eje Imaginario')
% title('Diagrama de polos y ceros a lazo abierto para barrido de parámetros J_{eq}')
% Jeq_range
% k_l_range

%% Lazo de corriente
p_i = -3200;
tau = -1/p_i;
G_i = tf(1,[tau 1]);


%% Controlador PID Jeq nominal

n = 2.5;
w_pos = 800;

Kd_m = J_eq*n*w_pos;
Kp_m = J_eq*n*w_pos^2;
Ki_m = J_eq*w_pos^3;

num_Gu = [0 0 0 K_t];
den_Gu = [L_s*J_eq (R_s*J_eq+L_s*b_eq) (L_s*k_l*s_pitch+R_s*b_eq+K_e*K_t) R_s*k_l*s_pitch];
G_u = tf(num_Gu,den_Gu);


num_PID = [0 Kd_m Kp_m Ki_m];
den_PID = [J_eq Kd_m Kp_m Ki_m];
G_PID = tf(num_PID,den_PID);


figure(1)
h = pzplot( G_i, 'c', G_u, 'b', G_PID, 'r');
title('Diagrama de polos y ceros a lazo cerrado comparativo')
grid on


%% Observador
w_obs = 5000;
ke_tita = w_obs*3;
ke_w = 3*w_obs^2;
ke_int = w_obs^3;

%% Simulacion Sistema Completo
% Nueva consigna

% Primera parte
t1_start = 0;
t1_ramp_up = 0.1;
t1_end = 5;
t1_step = 0.01;
t1 = t1_start:t1_step:(t1_end-t1_step);

ramp_up1 = linspace(0, pi/5, round((t1_ramp_up-t1_start)/t1_step));
constant1 = pi/5*ones(1, round((t1_end-t1_ramp_up)/t1_step));

q1 = [ramp_up1 constant1];


% Segunda parte
t2_start = 5;
t2_ramp_down = 5.1;
t2_end = 10;
t2_step = 0.01;
t2 = t2_start:t2_step:(t2_end-t2_step);

ramp_down2 = linspace(pi/5, 0, round((t2_ramp_down-t2_start)/t2_step));
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

ramp_down3 = linspace(0, -pi/5, round((t3_ramp_down-t3_start)/t3_step));
constant3 = -pi/5*ones(1, round((t3_ramp_up-t3_ramp_down)/t3_step));
ramp_up3 = linspace(-pi/5, 0, round((t3_constant-t3_ramp_up)/t3_step));
constant4 = zeros(1, round((t3_end-t3_constant)/t3_step));

q3 = [ramp_down3 constant3 ramp_up3 constant4];

% Final
t4_start = 15.01;


t_new = [t1/5 t2/5 t3/5];
q_vel = [2.5*q1 2.5*q2 2.5*q3];

% Plot the function
% figure(2)
% plot(t_new, q_vel);
% xlabel('Time (s)');
% ylabel('Function Value');
% title('Ramp-Constant-Ramp Function');

q_vel = timeseries(q_vel,t_new);


% %% Sensores no ideales
frec_iabc = 400;
Ts = 1e-4;
xita_iabc = 1;



A_iabc = [0 -1; frec_iabc^2 -2*frec_iabc*xita_iabc];
B_iabc = [1 ; 0];
C_iabc = [0 1];
D_iabc = [0];
% 
