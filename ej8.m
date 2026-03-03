% Control y Sistemas
% TP PID

% Ejercicio 8

clear; close all; clc;

t = 0:0.01:15;
ramp = t;
parab = t.^2;


% k=0;
% solution = ones(1, 5);
% for kp = 1:0.5:10
%     for kd = 10:1:100
%         for ki = 1:0.5:10
%             num = [(15+2*kd) 2*kp 2*ki];
%             den = [1 8 (15+2*kd) 2*kp 2*ki];
%             y = step(num,den,t);
%             s = 801;
%             while y(s)>0.98 && y(s)<1.02 
%                 s = s - 1;
%             end
%             ts = (s-1)*0.01; % ts = settling time;
%             m = max(y);
%             if m<1.20 && m>1.00 
%                 if ts<2.00
%                 k = k+1;
%                 solution(k,:) = [kp kd ki m ts];
%                 end
%             end
%         end
%     end
% end
% solution

%% Con filtro
syms Kp Ki Kd A(s) s;

kd = 27;
ki = 1.4;
kp = 4;

H_yr = tf([(15+2*kd) 2*kp 2*ki],[1 8 (15+2*kd) 2*kp 2*ki])
H_yd = tf([2 2 0],[1 8 (15+2*kd) 2*kp 2*ki])

y_step = step(H_yr ,t);
y_stepd = step(H_yd ,t);
[y_ramp, t, x] = lsim(H_yr, ramp, t);
[y_parab, t, x] = lsim(H_yr, parab, t);

figure;
plot(t, y_step);
title("Respuesta del sistema al escalon en la entrada")
xlabel('Tiempo (s)')
ylabel('Salida')
grid on;

figure;
plot(t, y_stepd);
title("Respuesta del sistema a la perturbación escalon")
xlabel('Tiempo (s)')
ylabel('Salida')
grid on;

figure;
plot(t, ramp);
hold on;
plot(t, y_ramp)
title('Respuesta del sistema a una entrada de rampa')
xlabel('Tiempo (s)')
ylabel('Salida')
grid on
legend('Entrada', 'Respuesta del sistema')
hold off;

figure;
plot(t, parab)
hold on;
plot(t, y_parab)
title('Respuesta del sistema a una entrada de parábola')
xlabel('Tiempo (s)')
ylabel('Salida')
grid on
legend('Entrada', 'Respuesta del sistema')
hold off;

%% Sin filtro
% G_c = K(a + s)(b + s) / s

P = tf([2 2],[1 8 15 0])

% i = 0;
% solution = ones(1, 5);
% for K = 68:0.5:70
%     for a = 3:0.5:4
%         G_c = tf([K K*2*a K*a^2],[1]);
%         G_ydsf = P / (1 + G_c*P)
%         y = step(G_ydsf,t);
%         s = 801;
%         while y(s)<0.02 
%             s = s - 1;
%         end
%         ts = (s-1)*0.01; % ts = settling time;
%         m = max(y);
%         if m<1.0 
%             if ts<2.00
%             i = i+1;
%             solution(k,:) = [K a m ts];
%             end
%         end
%     end
% end
% solution

K = 70;
a = 4.00;
G_c = tf([K K*2*a K*a^2],[1 0])
G_ydsf = minreal(P / (1 + G_c*P))
y = step(G_ydsf,t);

G_c1 = tf([1275 3360 2240], [2 2 0])
G_yrsf = minreal((G_c1*P)/(1 + G_c*P))
G_c2 = G_c - G_c1

y2 = step(G_yrsf, t);
[y_r2, t, x] = lsim(G_yrsf, ramp, t);
[y_p2, t, x] = lsim(G_yrsf, parab, t);


figure;
plot(t, y);
title("Respuesta del sistema a la perturbación escalon")
xlabel('Tiempo (s)')
ylabel('Salida')
grid on;

figure;
plot(t, y2);
title("Respuesta del sistema al escalon")
xlabel('Tiempo (s)')
ylabel('Salida')
grid on;

figure;
plot(t, ramp);
hold on;
plot(t, y_r2)
title('Respuesta del sistema a una entrada de rampa')
xlabel('Tiempo (s)')
ylabel('Salida')
grid on
legend('Entrada', 'Respuesta del sistema')
hold off;

figure;
plot(t, parab)
hold on;
plot(t, y_p2)
title('Respuesta del sistema a una entrada de parábola')
xlabel('Tiempo (s)')
ylabel('Salida')
grid on
legend('Entrada', 'Respuesta del sistema')
hold off;

