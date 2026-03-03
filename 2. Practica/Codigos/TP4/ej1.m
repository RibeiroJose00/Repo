% Parametros
f = 100; % frecuencia en Hz
fs = 1000; % frecuencia de muestreo en Hz
t_start = 0; % Inicio (s)
t_end = 1; % Final (s)

% Vector de tiempo
t = t_start : 1/fs : t_end;

% Onda senoidal
y = sin(2 * pi * f * t);

% Ploteo
figure;
plot(t, y);
xlabel('Time (s)');
ylabel('Amplitude');
title('Sine Wave');
grid on;