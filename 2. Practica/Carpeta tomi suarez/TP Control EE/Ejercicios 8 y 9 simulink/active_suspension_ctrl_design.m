clc;
clear all;
close all;
%---------------------------------------------------
% Exercises on Section Assignment 3 - Active suspension control design
% Model parameters
%---------------------------------------------------

mc=401;                         % Quarter car mass [kg]
mw=48;                          % Wheel mass [kg]
ds=2200;                        % Suspension damping coefficient [Ns/m]
cs=23000;                       % Suspension spring coefficient [N/m]
cw=250000;                      % Wheel spring coefficient [N/m]
tau=0.001;                      % Actuator time constant [s]

%---------------------------------------------------
% The active suspension model
% A, B, C, and H matrices
%---------------------------------------------------
A=[[0 1 0 0 0];[-(cw+cs)/mw -ds/mw cs/mw ds/mw -1/mw];[0 0 0 1 0];[cs/mc ds/mc -cs/mc -ds/mc 1/mc];[0 0 0 0 -1/tau]];
B=[0 0 0 0 1/tau]';
H=[0 cw/mw 0 0 0]';

C=[[-1 0 1 0 0];[cs/mc ds/mc -cs/mc -ds/mc 1/mc]];   

%---------------------------------------------------
% Enter your control design here
%---------------------------------------------------
%%a) Controlability check
Co=ctrb(A,B);
rank(Co,1e-10)   
%%b)Get K matrix solving the lqr problem
alpha1=1;
alpha2=1;
rho=1;
y1_max=0.05;
y2_max=5;
u_max=1000;
Qy=diag([alpha1/y1_max^2 alpha2/y2_max^2]);
Qx=C'*Qy*C;
Qu=rho/u_max^2;

[K,S,CLP] = lqr(A,B,Qx,Qu,0);
K;


%---------------------------------------------------
% For simulation purposes (do not modify)
%---------------------------------------------------
load roaddist.mat
B1=[B H];                   % Put the B and H matrix together as one matrix B1 (for Simulink implementation purposes) 
C1=eye(5);                  % Output all state variables from the model
D1=zeros(5,2);              % Corresponding D matrix
