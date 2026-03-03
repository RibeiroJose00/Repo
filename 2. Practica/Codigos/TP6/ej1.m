% TP6 Ej 1
clear, clc, close all;

% Parametros
fn = 100; % frecuencia en Hz
Fs = 1000; % frecuencia de muestreo en Hz
lambda = 0.45;
snr = 15;
t_start = 0;
t_end = 1;
t = t_start : 1/Fs : t_end;

% Onda senoidal
y = sin(2 * pi * fn * t);

%Señal con ruido Gaussiano
y_n = my_awgn(y, snr);

% Diseño filtro leaking integrator
b = (1-lambda);
a = [1,-lambda];

n = 2047;
figure(1)
freqz(b,a,n)

% Cero y polo
figure(2)
zplane(b,a)

% Filtramos la señal con ruido
y_f = filter(b,a,y_n);

% Grafico las tres señales
figure(3)
plot(t,y,'r')
hold on
plot(t,y_n,'b')
hold on
plot(t,y_f,'g')
legend('original','con ruido','filtrada')
xlabel('tiempo')
ylabel('Amplitud')

% Respuesta en frecuencia
[~,yf] = my_dft(y,Fs);
[~,yf_n]= my_dft(y_n,Fs);
[f,yf_f]= my_dft(y_f,Fs);

f_n = f/Fs;

figure(4)
plot(f_n,yf,'r')
hold on
plot(f_n,yf_n,'b')
hold on
plot(f_n,yf_f,'g')
legend('original','con ruido','filtrada')
xlabel('Frecuencia Normalizada')
ylabel('Amplitud')



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