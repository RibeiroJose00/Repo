%---------------------------------------------------
% Exercises on 3.4.2 - Driveline control
% Vehicle parameters
%---------------------------------------------------

close all; clear all; clc;

Jc=6250;                        % Chassis inertia [kgm^2]
Jf=0.625;                       % Flywheel inertia [kgm^2]
ds=1000;                        % Driveshaft damping coefficient [Nms/rad]
cs=75000;                       % Driveshaft spring coefficient [Nm/rad]
i=57;                           % Gear ratio [-]

%---------------------------------------------------
% Enter your A, B and H matrices here
%---------------------------------------------------

A = [-ds/(Jf*i^2)  ds/(Jf*i) -cs/(Jf*i);
     ds/(Jc*i)    -ds/Jc      cs/Jc;
     1/i          -1          0];
B = [1/Jf;0;0];
H = [0;-1/Jc;0];

%---------------------------------------------------
% Enter your control design here
% Hint: charpoly - could be a good  and useful function
%---------------------------------------------------

Wr = [1.6000   -0.7879  -58.5810;
      0         0.0045    0.3339;
      0         0.0281   -0.0183];
Wr_tilde = [1.0000   -0.6525  -48.5087;
            0         1.0000   -0.6525;
            0         0         1.0000];

K = 1.0e+04*[0.0037    0.1915    1.3148];

kr = 4.0033e+03;

l1 = 7.9931e+07;
l2 = 768.5475;
l3 = -2.2977e+03;

L = [l1 l2 l3]';
%---------------------------------------------------
% For simulation purposes (do not modify)
%---------------------------------------------------
B1=[B H];                       % Put the B and H matrix together as one matrix B1 (for Simulink implementation purposes) 
B2 = [B [0;0;0]];
C=eye(3);                       % Output all state variables from the model
D=zeros(3,2);                   % Corresponding D matrix
x0=[120 2 0]';                  % Initial conditions for the state variables

