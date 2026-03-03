%% Ejercicio 2:
% Formule la planta en espacio de estados
% donde la salida sea la posición y
% donde el vector de estado sea
% x = [ p
%       v ]
% p = posición
% v = velocidad
% u = acción de control
% d = perturbaciones
% fg = fuerza de la gravedad
clc; clear; close all

%% Solución
% a = p_ddot = v_dot
% m*a = - v*c - fg + u + d

% p_dot = ...
% v_dot = ...
% 
% x1_dot = x2
% x2_dot = ...

g = 9.8;
m = 1000;
c = 100;
fg = m*g;

% velocidad terminal
%  fg = v*c / (m)
v_term = -fg / c;

A = [0 1
    0 -c/m];
  
B = [0
    1/m];
    
C = [1 0];
  
D = 0;
  

%% simulación a lazo abierto
% debe verificarse que la velocidad terminal a 
% lazo abierto sea -98 m/s
Cp = [0 1];
sis_lazo_abierto = ss(A, B, Cp, D);

t = 0:.01:100;
fg_t = -fg*ones(1, length(t));
figure
lsim(sis_lazo_abierto, fg_t, t)
title('lazo abierto')
ylim([-100 100])

  
%% Entrega: PARCIAL_2_Apellido_E2.m
