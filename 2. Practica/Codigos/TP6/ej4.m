% TP6 ej 4
clc,clear,close all

% Filtro pasabajos Chebyshev I
[z,p,k] = cheb1ap(10,3);

% Pasamos a funcion de transferencia
[b_low,a_low] = zp2tf(z,p,k);

% Pasamos a filtro pasabanda
flow = 1891.035;
fhigh = 38933.748;

Wo = sqrt(fhigh*flow);
Bw = (fhigh-flow);

[b_band, a_band] = lp2bp(b_low,a_low,Wo,Bw);
% Graficamos respuesta en frecuencia
figure(1)
freqs(b_band,a_band,2001)

% Creamos un objeto filtro pasabanda
H = tf(b_band,a_band);

% Pasamos a filtro digital
Hd = c2d(H, 1/9600, 'tustin');

b_dig = Hd.Numerator{1};
a_dig = Hd.Denominator{1};

% Graficamos respuesta en frecuencia
figure(2)
freqz(b_dig,a_dig,2001,9600)


% Diseñamos un filtro digital para verificar
Hd_iir = iir_chebyshev1_3400_44100;

% % Analisis de Magnitud(dB)
% hfvt = fvtool(Hd_iir, Analysis='Magnitude');
% legend(hfvt,'IIR Chebyshev')
