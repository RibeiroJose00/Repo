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

// 3.1 Creamos una funcion que implemente redondeo por truncamiento
int32_t truncation(int64_t X, int n){
    int32_t a;
    a = (int32_t)(X >> n);
    return a;
}

// 3.2 Creamos una funcion que implemente redondeo por redondeo
int32_t roundoff(int64_t X, int n){
    int32_t a;
    a = X + (1 << (n - 1));
    return truncation(a, n);
}

// Multiplicamos dos numeros en Q21.10
int main(void){
    double a, b;
    int64_t c;
    a = 100;
    b = 100;
    c = (int64_t)(a * b);
    // Implementamos redondeo por truncamiento
    printf("c = %d \n", truncation(c, 10));
    // Implementamos redondeo por redondeo
    printf("c = %d \n", roundoff(c, 10));
    // Comparamos con el resultado en punto flotante
    double d;
    a = fx2fp(a, 10);
    b = fx2fp(b, 10);
    d = a * b;
    printf("d = %f \n", d);
    return 0;
}