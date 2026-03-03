% Parametros
f = 100; % frecuencia en Hz
fs = 1000; % frecuencia de muestreo en Hz
t_start = 0; % Inicio (s)
t_end = 1; % Final (s)
snr = 20; % medida signal-to-noise en dB

% Vector de tiempo
t = t_start : 1/fs : t_end;

% Onda senoidal
y = sin(2 * pi * f * t);

% Agregar ruido
signal_n = my_awgn(y, snr);

% Agregar ruido con funcion awgn
% signal_n2 = awgn(y, snr);

% Plotear la original y la que tiene ruidp
figure;
subplot(3, 1, 1);
plot(t, y);
xlabel('Time (s)');
ylabel('Amplitude');
title('Original Signal');
grid on;

subplot(3, 1, 2);
plot(t, signal_n);
xlabel('Time (s)');
ylabel('Amplitude');
title('Noisy Signal');
grid on;

subplot (3, 1, 3);
plot(t, signal_n2);
xlabel('Time (s)');
ylabel('Amplitude');
title('Noisy Signal 2');
grid on;

% Definir funcion awgn
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
