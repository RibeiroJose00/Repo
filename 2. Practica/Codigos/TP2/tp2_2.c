#include <math.h>
#include <stdio.h>
#include <stdint.h>

// 2.1 La función fx2fp convierte un número en punto fijo a punto flotante
double fx2fp(int32_t X, int n){
    double x;
    x = (double)(X)/(1 << n);
    return x;
}

// 2.2 La función fp2fx convierte un número en punto flotante a punto fijo
int32_t fp2fx(double x, int n){
    int32_t X;
    X = (int32_t)round(x * (1 << n));
    return X;
}

// 2.3 La función main prueba las funciones fx2fp y fp2fx
int main(void){
    double b;
    b = fx2fp(fp2fx(2.4515, 8),8);
    printf("b = %f \n", b);
    b = fx2fp(fp2fx(2.4515, 10),10);
    printf("b = %f \n", b);
    return 0;
}
// 2.4 Comparamos a con Q23.8 y Q21.10 ??
