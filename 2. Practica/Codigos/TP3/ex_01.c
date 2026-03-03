// Version: 002
// Date:    2022/04/05
// Author:  Rodrigo Gonzalez <rodralez@frm.utn.edu.ar>

// Compile usando el siguiente comando
// compile: gcc -Wall -std=c99 ex_01.c -o ex_01

#include <stdio.h>
#include <float.h>
#include <math.h>
#include <fenv.h>

typedef long int int64_t;

int main(void)
{	
	float a, b, c, f1, f2;
	double d1;

	a = 1000000000.0;	// mil millones
	b =   20000000.0;	// 20 millones
	c =   20000000.0;
	
	f1 = (a * b) * c;
	f2 = a * (b * c);

	d1 = (double) (a) * (double) (b) * (double) (c);

	printf("f1 = %lf \n", f1 );
	printf("f2 = %lf \n", f2 );
	printf("d1 = %lf \n", d1 );
	
	printf("Error en f1 = %10e \n", f1 - 400000000000000000000000.0 );
	printf("Error en f2 = %10e \n", f2 - 400000000000000000000000.0 );
	printf("Error en d1 = %20e \n", d1 - 400000000000000000000000.0 );
	
	double acum_1, acum_2;
	
	acum_1 = 0.0;
	for (int64_t i = 0; i < 10000000; i++){ acum_1 += 0.01; } 

	acum_2 = 0.0;
	b = 0.333;
	for (int64_t i = 0; i < 10000000; i++){ acum_2 += b / b; }
	
	printf("acum_1 = %f \n", acum_1 );
	printf("acum_2 = %f \n", acum_2 );
	
	printf("Error en acum_1 = %10e \n", acum_1 - (100000.0));
	printf("Error en acum_2 = %10e \n", acum_2 - (10000000.0));
	
	return 0;
}


/************************************
Este codigo demuestra la precision de los calculos en punto flotante.
Se observa que la precision de los calculos en punto flotante es limitada.
1. EL producto f1 y f2 es el mismo y su resultado no cambia, debido a que,
al menos en mi compilador, el tipo float es de 32 bits y el tipo double es de 64 bits,
por lo que, tanto el producto (a * b) como (b * c) caben en la precision del tipo de dato.

2. El error en f1 y f2 es diferente respecto a d1, porque el tipo float no tiene la 
misma precision que el tipo double, por lo que el error en f1 y f2 es mayor que en d1.

3. El error en acum_1 ocurre porque el tipo float no puede representar exactamente
el valor 0.01, por lo que hay un error acumulado en cada iteracion.

4. En el caso de acum_2, no hay error acumulado, ya que el valor de b/b es exactamente 1,
porque tanto float como double representan correctamente el valor de la division.
*************************************/