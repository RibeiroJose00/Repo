clear,clc,close all

% Eiercicio 5

t = 0:0.01:4; % Vector de tiempo
l = 0; % Para guardar
b = zeros(30);
K = zeros(100);
table = zeros(3000,4);
for i = 1:30
    b(i) = 0 + i*0.1; % Recorremos b entre 0.1 y 3
    for k = 1:100
        K(k) = 20 + k*0.2; % Recorremos K entre 20.02 y 40

        num = [0 2*b(i)*K(k) (2*K(k)+4*b(i)*K(k)) 4*K(k)];
        den = [1 (2*b(i)*K(k)+11) (2*K(k)+4*b(i)*K(k)+10) 4*K(k)];

        out = step(num,den,t);
        out_max = max(out);
        p = 401;

        while(out(p) > 0.98 && out(p) < 1.02)
            p = p-1;
        end
        Ts = (p-1)*0.01;

        if (out_max < 1.2 && Ts < 2)
            l = l+1;
            table(l,:) = [b(i) K(k) out_max Ts];
        end 
    end
end

sort = sortrows(table,3);
sort
fprintf('\nLa opcion seleccionada es: b = 0.7000; K = 20.8000; max = 1.0028; Ts = 1.0800\n');

% Grafico

numr_sel = [0 2*0.7*20.8 (2*20.8+4*0.7*20.8) 4*20.8];
denr_sel = [1 (2*0.7*20.8+11) (2*20.8+4*0.7*20.8+10) 4*20.8];

figure(1)
step(numr_sel,denr_sel,t);
grid on
title('Referencia escalon unitario')


numd_sel = [0 2 4 0];
dend_sel = [1 (2*0.7*20.8+11) (2*20.8+4*0.7*20.8+10) 4*20.8];

figure(2)
step(numd_sel,dend_sel,t);
grid on
title('Perturbacion escalon unitario')

% Polos y ceros
[z,p] = tf2zp(numr_sel, denr_sel);
figure(3)
zplane(numr_sel, denr_sel);