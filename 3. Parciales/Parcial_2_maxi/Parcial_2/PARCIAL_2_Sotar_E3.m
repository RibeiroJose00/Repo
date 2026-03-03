%% Ejercicio 3: Verifique la observabilidad y 
% diseñe de un observador de estado que se alimente de:
%  - sensor de posición
%  - el valor constante de la fuerza de gravedad (-9800)
%  - la perturbación excepcional (20000)
%  - la acción de control
% Las perturbaciones permanentes, el valor real de 
% la posición y el valor real de la velocidad no están
% disponibles para el observador.


PARCIAL_2_E2_script_2p

%Verificación de si la matriz es observable
Wr = obsv(A, C)
if det(Wr) ~= 0
    disp(["it is observable with C = " num2str(C)])
end
...


q = [0 0]
r = 1
Q = B * q' * B'
R = [ r ]

L = ...
% Cálculo del ganancia del observador
L = lqr(A', C', Q, R)';
%% Entrega: PARCIAL_2_Apellido_E3.m
