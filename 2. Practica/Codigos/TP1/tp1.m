%----------- Trabajo Practico 1 ---------%
clear
close all
clc
%% Ejercicio 1
syms n z

u1 = heaviside(n);
a1 = (1/3)^n;
x1 = a1*u1;

figure(1)
hold on
fplot(x1, [-2, 2])

r1 = ztrans(x1)
poles = [1/3];
zeros = [0];

[num, den] = zp2tf(zeros, poles, 1);

figure(2)
zp1 = zplane(zeros, poles);
hold on
figure(3)
freqz(num, den)

%% Ejercicio 2
syms n z
u2 = heaviside(-n-1);

a2 = -(1/2)^n;
x2 = a2 * u2;

figure(1)
hold on
fplot(x2, [-2, 2])

r2 = ztrans(x2, n, z)
poles = [1/2];
zeros = [0];

[num, den] = zp2tf(zeros, poles, 1);

figure(2)
zp2 = zplane(zeros, poles);
figure(3)
freqz(num, den)

%% Ejercicio 3
syms n z
u1 = heaviside(n);
u2 = heaviside(-n-1);
a3 = (1/2)^n;
a4 = -(2)^n;
x3 = a3 * u1 + a4 * u2;

figure(1)
hold on
fplot(x3, [-2, 2])

r3 = ztrans(x3, n, z);
zeros = [0; 5/4];
poles = [1/2; 2];

[num, den] = zp2tf(zeros, poles, 1);

figure(2)
zp3 = zplane(zeros, poles);

figure(3)
freqz(num, den)

%% Ejercicio 4
syms n z
u1 = heaviside(n);
u2 = heaviside(-n-1);
a2 = -(1/2)^n;
x4 = a2*u1+a2*u2;

figure(1)
hold on
fplot(x4, [-2, 2])

r4 = ztrans(x4, n, z);
zeros = [0];
poles = [0];

[num, den] = zp2tf(zeros, poles, 1);

figure(2)
zp4 = zplane(zeros, poles);
figure(3)
freqz(num, den)


