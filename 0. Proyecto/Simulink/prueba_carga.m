%% =========================================================
%  Rotacion simbolica de gravedad con Roll-Pitch-Yaw
%  Producto cruz r x g  +  Plot 3D completo
% =========================================================
clc; clear; close all;

%% --- 1. VARIABLES SIMBOLICAS ---
syms phi theta psi real       % Roll, Pitch, Yaw
syms g real                   % magnitud gravedad
syms l alpha real             % longitud y angulo de r

%% --- 2. MATRICES DE ROTACION ---
Rx = [1,         0,          0;
      0,  cos(phi), -sin(phi);
      0,  sin(phi),  cos(phi)];

Ry = [ cos(theta), 0, sin(theta);
                0, 1,          0;
      -sin(theta), 0, cos(theta)];

Rz = [cos(psi), -sin(psi), 0;
      sin(psi),  cos(psi), 0;
             0,          0, 1];

R = Rz * Ry * Rx;
R = simplify(R);

disp('=== Matriz de rotacion R = Rz*Ry*Rx ===');
disp(R);

%% --- 3. VECTOR GRAVEDAD ROTADO ---
g_inertial = [0; 0; -g];
g_body = simplify(R' * g_inertial);

disp('=== Gravedad en marco cuerpo ===');
fprintf('gx = '); disp(g_body(1));
fprintf('gy = '); disp(g_body(2));
fprintf('gz = '); disp(g_body(3));

%% --- 4. VECTOR r y PRODUCTO CRUZ ---
% r definido en marco cuerpo
r_body = [l*cos(alpha); l*sin(alpha); 0];

% Rotar r al marco inercial: r_inertial = R * r_body
r_inertial = simplify(R * r_body);

% Producto cruz consistente: ambos en marco cuerpo
tau = simplify(cross(r_body, g_body));

disp('=== r en marco cuerpo ===');
disp(r_body);

disp('=== Torque tau = r_body x g_body ===');
fprintf('tau_x = '); disp(tau(1));
fprintf('tau_y = '); disp(tau(2));
fprintf('tau_z = '); disp(tau(3));

%% --- 5. SUSTITUCION NUMERICA ---
phi_val   = deg2rad(10);
theta_val = deg2rad(40);
psi_val   = deg2rad(50);
g_val     = 9.81;
l_val     = 1;
alpha_val = deg2rad(30);

subs_vals = [phi, theta, psi, g, l, alpha];
num_vals  = [phi_val, theta_val, psi_val, g_val, l_val, alpha_val];

g_body_num  = double(subs(g_body, subs_vals, num_vals));
r_body_num = [l_val*cos(alpha_val); l_val*sin(alpha_val); 0];
R_num       = double(subs(R,      subs_vals, num_vals));
r_inertial_num  = R_num * r_body_num;   % <-- rotacion aplicada
tau_num     = cross(r_body_num, g_body_num);
tau_inertial_num = R_num * tau_num;
g_body_inertial_num = R_num * g_body_num;

fprintf('\n=== Resultados numericos ===\n');
fprintf('g_body = [%7.4f, %7.4f, %7.4f] m/s^2\n', g_body_num);
fprintf('r      = [%7.4f, %7.4f, %7.4f] m\n',      r_body_num);
fprintf('tau    = [%7.4f, %7.4f, %7.4f] N·m\n',    tau_num);
fprintf('|g|    = %.4f m/s^2\n', norm(g_body_num));

%% --- 6. PLOT 3D ---
figure('Color','white','Position',[100 100 900 750]);
ax = axes('Position',[0.05 0.05 0.90 0.90]);
hold on; grid on; axis equal;
view(35, 25);

scale = 1.0;

% Ejes inerciales
colores_I = {'r','g','b'};
labels_I  = {'X_I','Y_I','Z_I'};
ejes_I    = eye(3);
for k = 1:3
    quiver3(0,0,0, ejes_I(1,k),ejes_I(2,k),ejes_I(3,k), scale, ...
        'Color',colores_I{k}, 'LineWidth',2.5, 'MaxHeadSize',0.5, 'AutoScale','off');
    text(ejes_I(1,k)*1.12, ejes_I(2,k)*1.12, ejes_I(3,k)*1.12, ...
        labels_I{k}, 'FontSize',12, 'FontWeight','bold', 'Color',colores_I{k});
end

% Ejes del cuerpo (rotados)
colores_B = {[1 .5 .5],[.3 .8 .3],[.4 .6 1]};
labels_B  = {'X_B','Y_B','Z_B'};
ejes_B    = R_num * eye(3);
for k = 1:3
    quiver3(0,0,0, ejes_B(1,k),ejes_B(2,k),ejes_B(3,k), scale, ...
        'Color',colores_B{k}, 'LineWidth',1.8, 'MaxHeadSize',0.5, ...
        'LineStyle','--', 'AutoScale','off');
    text(ejes_B(1,k)*1.12, ejes_B(2,k)*1.12, ejes_B(3,k)*1.12, ...
        labels_B{k}, 'FontSize',11, 'Color',colores_B{k});
end

% Vector g inercial
g_n = [0;0;-1] * scale;
quiver3(0,0,0, g_n(1),g_n(2),g_n(3), 1, ...
    'Color',[.3 .3 .3], 'LineWidth',2, 'MaxHeadSize',0.6, 'AutoScale','off');
text(g_n(1)*1.15, g_n(2)*1.15, g_n(3)*1.15, 'g_{I}', ...
    'FontSize',11, 'Color',[.3 .3 .3]);

% Vector g en cuerpo
g_bn = g_body_inertial_num / g_val * scale;
quiver3(0,0,0, g_bn(1),g_bn(2),g_bn(3), 1, ...
    'Color',[.85 .45 0], 'LineWidth',2.5, 'MaxHeadSize',0.6, 'AutoScale','off');
text(g_bn(1)*1.15, g_bn(2)*1.15, g_bn(3)*1.15, 'g_{B}', ...
    'FontSize',11, 'FontWeight','bold', 'Color',[.85 .45 0]);

% Vector r
quiver3(0,0,0, r_inertial_num(1),r_inertial_num(2),r_inertial_num(3), 1, ...
    'Color',[.7 0 .7], 'LineWidth',2.5, 'MaxHeadSize',0.6, 'AutoScale','off');
text(r_inertial_num(1)*1.1, r_inertial_num(2)*1.1, r_inertial_num(3)*1.1+0.05, 'r', ...
    'FontSize',13, 'FontWeight','bold', 'Color',[.7 0 .7]);

% Vector tau (escalado a longitud 1 para visualizacion)
tau_plot = tau_inertial_num / norm(tau_inertial_num) * scale;
quiver3(0,0,0, tau_plot(1),tau_plot(2),tau_plot(3), 1, ...
    'Color',[0 .6 .7], 'LineWidth',2.5, 'MaxHeadSize',0.6, 'AutoScale','off');
text(tau_plot(1)*1.1, tau_plot(2)*1.1, tau_plot(3)*1.1+0.05, '\tau = r \times g', ...
    'FontSize',11, 'FontWeight','bold', 'Color',[0 .6 .7]);

% Plano XY del sistema cuerpo (semitransparente)
n_pts = 6;
[uu,vv] = meshgrid(linspace(-.8,.8,n_pts), linspace(-.8,.8,n_pts));
pts = R_num * [uu(:)'; vv(:)'; zeros(1,numel(uu))];
surf(reshape(pts(1,:),n_pts,n_pts), ...
     reshape(pts(2,:),n_pts,n_pts), ...
     reshape(pts(3,:),n_pts,n_pts), ...
    'FaceAlpha',0.08, 'FaceColor',[.4 .6 1], ...
    'EdgeColor',[.4 .6 1], 'EdgeAlpha',0.2, 'LineWidth',0.5);

% Titulo y leyenda
title(sprintf('\\phi=%.0f°  \\theta=%.0f°  \\psi=%.0f°  |  l=%.1f  \\alpha=%.0f°', ...
    rad2deg(phi_val), rad2deg(theta_val), rad2deg(psi_val), l_val, rad2deg(alpha_val)), ...
    'FontSize',12);
xlabel('X'); ylabel('Y'); zlabel('Z');

h = [quiver3(NaN,NaN,NaN,NaN,NaN,NaN,'r','LineWidth',2.5), ...
     quiver3(NaN,NaN,NaN,NaN,NaN,NaN,'Color',[1 .5 .5],'LineWidth',1.8,'LineStyle','--'), ...
     quiver3(NaN,NaN,NaN,NaN,NaN,NaN,'Color',[.3 .3 .3],'LineWidth',2), ...
     quiver3(NaN,NaN,NaN,NaN,NaN,NaN,'Color',[.85 .45 0],'LineWidth',2.5), ...
     quiver3(NaN,NaN,NaN,NaN,NaN,NaN,'Color',[.7 0 .7],'LineWidth',2.5), ...
     quiver3(NaN,NaN,NaN,NaN,NaN,NaN,'Color',[0 .6 .7],'LineWidth',2.5)];
legend(h, {'Sistema inercial (X_I,Y_I,Z_I)', 'Sistema cuerpo (X_B,Y_B,Z_B)', ...
           'g inercial', 'g en cuerpo', 'r', '\tau = r \times g'}, ...
    'Location','northeast', 'FontSize',10);

rotate3d on;
hold off;