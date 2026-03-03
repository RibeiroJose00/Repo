%% Ejercicio 3: Verifique la observabilidad y 
% diseñe de un observador de estado que se alimente de:
%  - sensor de posición
%  - el valor constante de la fuerza de gravedad
%  - la perturbación excepcional
%  - la acción de control
% Las perturbaciones permanentes, el valor real de 
% la posición y el valor real de la velocidad no están
% disponibles para el observador.

PARCIAL_2_E2_script_solucion

obsv(A, C)


%Q = B * q * B'
%R = [ r ]

% Qc = B * ((3170)^2) * B' --> ruido permanente, q, RMS senal ruido
% Rc = [ (31^2) ] --> perturbacion excepcional, r, RMS en los sensores
%                   [ruido posicion o ruido velocidad]

Qc = B * 100000 * B'
Rc = 10
%Rc = [10 0
%      0 1];

L = 10*(lqr(A', C', Qc, Rc))'
%L = place(A', C', eig(A)*0.8)'  % Colocación de polos del observador


%% C doble

%C_obs = eye(2);
%obsv(A,C_obs)

%L = (lqr(A',C_obs',Qc,Rc))'

