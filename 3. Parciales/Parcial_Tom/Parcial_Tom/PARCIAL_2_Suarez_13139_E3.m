%% Ejercicio 3: Verifique la observabilidad y 
% diseñe de un observador de estado que se alimente de:
%  - sensor de posición
%  - el valor constante de la fuerza de gravedad
%  - la perturbación excepcional
%  - la acción de control
% Las perturbaciones permanentes, el valor real de 
% la posición y el valor real de la velocidad no están
% disponibles para el observador.


PARCIAL_2_Suarez_13139_E2

obsv(A, C)

...

%% 
q = 3160^2;
r = 31.6^2;
Q = Bd * q * Bd'
R = [ r ]

[L,P,E] = lqr(A',C',Q,R)

L = L'

%% Entrega: PARCIAL_2_Apellido_E3.m
