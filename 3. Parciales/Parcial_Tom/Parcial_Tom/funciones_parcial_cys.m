% Funciones para el parcial de control y sistemas.

%------------------------------------------
% Función de transferencia controlador PID.
%------------------------------------------

% kp = 1;
% ki = 1;
% kd = 1;

% C = pid(kp,ki,kd); % Devueve función de transferencia del controlador PID. 

%-----------------------------------------
% Función de transferencia a lazo cerrado.
%-----------------------------------------

% G = tf(num,den); % Función de transferencia de la planta.
% H = tf(num,den); % Función de transferencia de la realimentación.

% G_lazo_cerrado = feedback(G,H); % Devuelve función de tf a lazo cerrado.

%---------------------------------
% Función de respuesta al escalón.
%---------------------------------

% G es una función de transferencia.

% t es un vector de tiempo.

% step(G,t); % Plotea la respuesta al escalón unitario.

% step(r*G,t); % Plotea la respuesta al escalón de altitud r.

% y = step(G,t); % Devuelve la sálida a la función escalón unitario.

%------------------
% Función stepinfo.
%------------------

% G es una función de transferencia.

% stepinfo(G) % Devuelve especificaciones de diseño como overshoot y
% settling time de un sistema frente a una entrada escalón unitario.

%-----------------------------------------------------------------
% Función para buscar la matriz de ganancias según polos deseados. 
%-----------------------------------------------------------------

% p = [p1 p2 ...] % Polos deseados del sistema.

% K = place(A,B,p) % Matriz de ganancia.

% -----Alternativa Propia-----

%{ 
I = eye(3);
syms s
p_caracteristico = det(s*I-A)
C1_syms = coeffs(p_caracteristico,s); % Obtenemos los coeficientes simbólicos del polinomio característico.
C1_double = double(C1_syms); % Coeficientes formato double.
a3 = 0;
a2 = C1_double(1,1);
a1 = C1_double(1,2);
p_deseado = (s+2*zeta*wn)*(s^2 + 2*zeta*wn*s + wn^2) % Polinomio deseado.
C2_syms = coeffs(p_deseado, s); % Coeficientes simbólicos del polinomio anterior.
C2_double = double(C2_syms); % Coeficientes en formato double.
p3 = C2_double(1,1);
p2 = C2_double(1,2);
p1 = C2_double(1,3);
Wr = [B A*B A^2*B]; Matriz de alcanzabilidad.
Wr_tilde = inv([1 a1 a2;
                0 1  a1;
                0 0  1]);
K = [p1-a1 p2-a2 p3-a3]*Wr_tilde*inv(Wr)
%}

%-----Ackermann's formula Matlab-----

% K = acker(A,B,p) % Ganancia según método de ackermann.

% Recordar usar dualidad para calcular L (ganancias observador).

% pobs = [p1 p2 ...] % Polos deseados del observador.

% L = place(A',C',pobs)'; % Matriz de ganancia del observador.

% L = acker(A',C',pobs)';

%-----------------------------------------------------
% Función para armar el sistema en espacio de estados.
%-----------------------------------------------------

% sistema = ss(A,B,C,D);

%------------------------------------------------------
% Función para correr simulacion en espacio de estados.
%------------------------------------------------------

% lsim(sistema,u,t,x0) % Plotea la salida del sistema en espacio de estados
% según entrada u, tiempo t, condiciones inciales x0.

% [y,t,x] = lsim(sistema,u,t,x0) % Devuelve la salida del sistema y las
% variables de estado. Recordar que las variables vienen todas juntas.

% Recordar que puedo hacer el sistema extendido con los errores de
% estimación para encontrar las variables de estado estimadas.

% At = [ A-B*K             B*K
%        zeros(size(A))    A-L*C ];

% Bt = [    B*kr
%        zeros(size(B)) ];

% Ct = [ C    zeros(size(C)) ];

%-----------------
% Kalman's filter.
%-----------------

% [P,E,L] = care(A',C',Rv,Rw)
% [L,P,E] = lqr(A',C',Rv,Rw)

% E son los polos a lazo cerrado del observador.

%-------------
% Control LQR.
%-------------

% Qx es la matriz de penalizacion de los estados, mientras más grandes más
% se penalizan. -> Qx >= 0.
% Qu es la matriz de penalizacion de las acciones de control. -> Qu > 0.
% Puedo penalizar también la salida del sistema. -> Qx = C'QyC.

% [K,S,E] = lqr(A,B,Qx,Qu)

% E son los polos a lazo cerrado del sistema.

