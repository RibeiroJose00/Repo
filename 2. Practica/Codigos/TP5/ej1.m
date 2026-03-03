% TP5 Ej 1
clear, clc, close all;

% Parametros
fn = 100; % frecuencia en Hz
Fs = 1000; % frecuencia de muestreo en Hz
fco = 2*fn; % frecuencia de corte
Fco = fco/Fs;
snr = 15;
t_start = 0;
t_end = 1;
t = t_start : 1/Fs : t_end;

% Onda senoidal
y = sin(2 * pi * fn * t);

%Señal con ruido Gaussiano
y_n = my_awgn(y, snr);

% Calculo el orden del filtro
N_max = round(1/(2*Fco));

N = N_max;
%N = round(N_max*10);

disp("Valor de N:")
disp(N);

% Parametros del filtro
b = ones(1, N)/N;
a = 1;

% Aplicamos el filtro
y_f = filter(b,a,y_n);

% Graficamos la magnitud y fase del filtro
n = 2047;
figure(1)
freqz(b,a,n);

% Graficamos
%  Señal original
figure(2)
subplot(3, 1, 1)
plot(t, y)
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal Original')
grid on;

subplot(3, 1, 2);
plot(t, y_n);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal con Ruido');
grid on;

subplot (3, 1, 3);
plot(t, y_f);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal filtrada');
grid on;


% Calculamos la respuesta en frecuencia
[~, tdf_y] = my_dft(y,Fs);
[f, tdf_y_f] = my_dft(y_f,Fs);

f_norm = f/Fs;

% Graficamos
%  Señal original
figure(3)
subplot(2, 1, 1)
plot(f_norm, tdf_y)
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal Original')
grid on;

subplot (2, 1, 2);
plot(f_norm, tdf_y_f);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal filtrada');
grid on;

function signal_n = my_awgn(signal, snr)
    % Calcular potencia de señal
    signal_power = var(signal);

    % Calcular potencia de ruido
    noise_power = signal_power / (10^(snr / 10));

    % Generar ruido
    noise = sqrt(noise_power) * randn(size(signal));

    % Agregar el ruido
    signal_n = signal + noise;
end