clear, clc, close all

% Ejercicio 5

% Respuesta a perturbacion escalon unitario
figure(1)
numd = [0 2 4 0];
dend = [1 31 90 80];
step(numd, dend)
grid on
title('Perturbacion escalon unitario')

% Respuesta a referencia escalon unitario
figure(2)
numr = [0 20 80 80];
denr = [1 31 90 80];
step(numr, denr)
grid on
title('Referencia escalon unitario')

% Polos y ceros
[z,p] = tf2zp(numr, denr);
figure(3)
zplane(numr, denr);