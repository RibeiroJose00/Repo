% TP5 Ej 2
clear, clc, close all;

% Cargamos archivo
load('Tchaikovsky.mat');

% Parametros 
fco = 22050;
Fco = fco/Fs;
snr = 15;
t_start = 0;
t_end = (length(signal(:,2)) - 1)/Fs;
t = t_start : 1/Fs : t_end;

% Tomamos uno de los dos canales
signal1 = signal(:,2);

%Señal con ruido Gaussiano
signal1_n = my_awgn(signal1, snr);

% Calculo el orden del filtro
N_max = round(1/(2*Fco));

% Hacemos un filtro de media movil
disp("Opcion 1: N = N_max");
disp("Opcion 2: N = N_max * 2");
disp("Opcion 3: N = N_max * 10");
option = input("Ingrese la opcion: ");

if option == 1
    N = N_max;
elseif option == 2
    N = round(N_max*2);
elseif option == 3
    N = N_max * 10;
end
disp(N);
b = ones(1, N)/N;
a = 1;

% Aplicamos el filtro
signal1_f = filter(b,a,signal1_n);

% Graficamos
%  Señal original
figure(1)
subplot(3, 1, 1)
plot(t, signal1)
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal Original')
grid on;

subplot(3, 1, 2);
plot(t, signal1_n);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal con Ruido');
grid on;

subplot (3, 1, 3);
plot(t, signal1_f);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal filtrada');
grid on;


% Calculamos la respuesta en frecuencia
[~, tdf_signal1] = my_dft(signal1,Fs);
[~, tdf_signal1_n] = my_dft(signal1_n,Fs);
[f, tdf_signal1_f] = my_dft(signal1_f,Fs);

f_norm = f/Fs;

% Graficamos
%  Señal original
figure(2)
subplot(3, 1, 1)
plot(f_norm, tdf_signal1)
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal Original')
grid on;

subplot(3, 1, 2);
plot(f_norm, tdf_signal1_n);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal con Ruido');
grid on;

subplot (3, 1, 3);
plot(f_norm, tdf_signal1_f);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal filtrada');
grid on;

% % Vector error
% err = signal1 - signal1_n;
% 
% figure(3)
% plot(t, err)
% xlabel('Tiempo (s)');
% ylabel('Amplitud');
% title('Error entre señal original y con ruido');
% grid on;
% 
% % Vector diferencia
% dif = signal1 - signal1_f;
% figure(4)
% plot(t, dif)
% xlabel('Tiempo (s)');
% ylabel('Amplitud');
% title('Diferencia entre señal original y filtrada');
% grid on;

% % Hacemos sonar las señales
% sound(signal1, Fs);
% pause(15);
% 
% sound(signal1_n, Fs);
% pause(15);
% 
% sound(signal1_f, Fs);
% pause(15);

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