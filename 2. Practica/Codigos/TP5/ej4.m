clear, clc, close all;

% Cargamos el archivo
load('Tchaikovsky.mat');

% Tomamos una señal
sig = signal(:,1);

% Filtro
[b,fir] = filter4;
a = 1;
sig_f = filter(b,a,sig);

% Respuesta en frecucencia
[~, tf_sig] = my_dft(sig, Fs);
[f, tf_sig_f] = my_dft(sig_f, Fs);

f_norm = f/Fs;

% Grafico
figure(1)
plot(f_norm*pi, tf_sig, 'r')
hold on
plot(f_norm*pi, tf_sig_f, 'b')
xlabel("Freq")
ylabel("Magnitud")
title("Señal Original vs Filtrada")
grid on

% sound(sig, Fs);
% pause(15);
% 
% sound(sig_f, Fs);
% pause(15);