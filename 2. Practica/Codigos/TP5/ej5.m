% TP5 Ej 1
clear, clc, close all;

% Parametros
f1 = 300; % frecuencia en Hz
f2 = 600;
f3 = 50;
Fs = 10000; % frecuencia de muestreo en Hz
t_start = 0;
t_end = 1;
t = t_start : 1/Fs : t_end;

% Onda senoidal
y1 = sin(2 * pi * f1 * t);
y2 = sin(2 * pi * f2 * t);
y3 = sin(2 * pi * f3 * t);

% Señal original
signal = y1 + y2;

% Señal con ruido
signal_n = signal + y3;

% Paso a pf
signal_f = single(signal_n);

% Matlab a C
salida_c = fir_matlab_wrapper(signal_f);

figure(1)
subplot(2, 1, 1)
plot(t,y)
xlabel("t(s)")
ylabel("Magnitud")
title("Señal original")

subplot(2, 1, 2)
plot(t,yn)
xlabel("t(s)")
ylabel("Magnitud")
title("Señal con ruido")

% Filtro
[b, filter] = filter5;
