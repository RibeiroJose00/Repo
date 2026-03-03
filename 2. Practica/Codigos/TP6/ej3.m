% TP6 ej 3
clc, clear, close all

% Filtro FIR Kaiser
Hd_fir = fir_kaiser_3400_44100;

% Filtro IIR Eliptico   
Hd_iir = iir_elliptic_3400_44100;

% Analisis de Magnitud(dB)
hfvt = fvtool(Hd_iir, Hd_fir, Analysis='Magnitude');
legend(hfvt,'IIR Elliptic', 'FIR Kaiser')

% % Analisis de Fase
% hfvt2 = fvtool(Hd_iir, Hd_fir, Analysis='Phase');
% legend(hfvt2,'IIR Elliptic', 'FIR Kaiser')

% Dimensiones   
fir_dim = size(Hd_fir.Numerator);
iir_dim = size(Hd_iir.sosMatrix);

fprintf ('FIR filter dimension is [%d %d]\n', fir_dim(1), fir_dim(2))
% % FIR filter dimension is [1 1600]
% % Esto significa que el orden del filtro es M = 1600

fprintf ('IIR filter dimension is [%d %d]\n', iir_dim(1), iir_dim(2))
% % IIR filter dimension is [5 6]

% Conclusiones

% Respuesta en frecuencia
% 
% % Si el FIR tiene una transición más estrecha,
% % esto podría ser beneficioso en situaciones
% % donde necesitas una separación clara entre
% % bandas de frecuencia cercanas y prefieres
% % una transición definida sin mucho ripple.
% % Sin embargo, estos resultados pueden requerir
% % una longitud de filtro más grande y podrían
% % aumentar la latencia.
% 
% % Para el filtro IIR, la diferencia en la transición
% % puede deberse a un orden más bajo o a una
% % configuración de ripple y atenuación que produce
% % una transición más suave.
% % Esto podría ser preferible en contextos donde
% % la eficiencia y la compacidad son importantes,
% % pero sin la misma precisión en la transición.

% Respuesta de fase
% 
% % Los filtros FIR son generalmente diseñados
% % para tener una respuesta de fase lineal.
% % Esto significa que todas las frecuencias
% % son retrasadas por la misma cantidad de tiempo,
% % evitando la distorsión de fase.
% % La fase lineal es importante para aplicaciones donde
% % la preservación de la forma de la señal es crítica,
% % como en audio y señales de datos sensibles.
% 
% % Los filtros IIR, debido a su estructura
% % con retroalimentación, generalmente tienen
% % una respuesta de fase no lineal.
% % Esto significa que diferentes frecuencias pueden
% % ser retrasadas por diferentes cantidades de tiempo,
% % lo que puede causar distorsión de fase.

% Estrucura de los filtros
% 
% Filtro FIR
% % Este número tan alto de coeficientes implica que
% % el filtro tiene una gran longitud, lo cual puede ser
% % necesario para lograr transiciones precisas y
% % una respuesta de fase lineal.
% % Sin embargo, esto también significa que el filtro
% % requerirá más memoria y tiempo de procesamiento.
% % 
% Filtro IIR
% % La primera dimensión, 5, indica que el filtro tiene
% % cinco secciones de segundo orden.
% % Cada sección es un filtro IIR individual.
% % 
% % La segunda dimensión, 6, muestra que cada sección
% % de segundo orden tiene seis coeficientes:
% % tres para el numerador y tres para el denominador.
% % 
% % Los filtros IIR se definen por estos coeficientes
% % en el numerador y denominador, permitiendo
% % la retroalimentación interna, lo que les da
% % su característica de respuesta infinita al impulso.