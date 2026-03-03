// Version: 001
// Date:    2020/03/19
// Author:  Rodrigo Gonzalez <rodralez@frm.utn.edu.ar>

// Compile usando el siguiente comando
// compile: gcc -Wall -std=c99 ex_02.c -o ex_02 -lm -frounding-math -fsignaling-nans

#include <stdio.h>
#include <float.h>
#include <math.h>
#include <fenv.h>

void test_rounding (void)
{
  float fp1, fp2;
  double df3;

 fp1 = exp(1.1);
 printf(" exp(1.1) = %+0.8f\n", fp1);
 
 fp2 = -exp(1.1);
 
  printf("-exp(1.1) = %+0.8f\n", fp2);

 df3 = exp(1.1);
 
  printf("double exp(1.1) = %+0.8lf\n", df3);
}

void current_rounding (void)
{
	int ROUND_MODE;
	
	ROUND_MODE = fegetround();	
	
	printf("Current Round Mode = %d \n", ROUND_MODE );
}

void change_rounding (int rounding_mode)
{
	fesetround (rounding_mode);	
}

int main(void)
{	
	printf("** Floating-point single-precision constants ** \n");
	printf("FLT_MIN 	= %E \n", 		FLT_MIN );
	printf("FLT_MAX 	= %E \n", 		FLT_MAX );
	printf("FLT_EPSILON	= %E \n", 	FLT_EPSILON ); // En MATLAB: eps(single(1))
	printf("\n");
	
	printf("** Floating-point double-precision constants ** \n");
	printf("DBL_MIN 	= %E \n", 		DBL_MIN );
	printf("DBL_MAX 	= %E \n", 		DBL_MAX );
	printf("DBL_EPSILON	= %E \n", 	DBL_EPSILON ); // En MATLAB: eps(1)
	printf("\n");

	printf("** Floating point rounding modes ** \n");
	printf("Rounding Mode FE_TONEAREST	= %d \n", 	FE_TONEAREST );
	printf("Rounding Mode FE_DOWNWARD	= %d \n", 		FE_DOWNWARD );
	printf("Rounding Mode FE_UPWARD		= %d \n", 		FE_UPWARD );
	printf("Rounding Mode FE_TOWARDZERO	= %d \n", 	FE_TOWARDZERO );
	printf("\n");
	
	current_rounding();
	test_rounding();
	printf("\n");
	
	change_rounding(FE_DOWNWARD);
	current_rounding();
	test_rounding();
	printf("\n");
	
	change_rounding(FE_UPWARD);
	current_rounding();
	test_rounding();
	printf("\n");

	change_rounding(FE_TOWARDZERO);
	current_rounding();
	test_rounding();
	printf("\n");
	return 0;
}

/**************************
1. Las funciones fegetround() y fesetround() permiten obtener y cambiar el modo de redondeo.

2. El programa empieza con el modo de redondeo FE_TONEAREST.

3. Se observa que el valor de exp(1.1) es el mismo en los tres modos de redondeo.

4. En el modo FE_DOWNWARD, exp(1.1) es ligeramente menor que en los otros modos,
porque está redondeado hacia abajo. Por el contrario, -exp(1.1) es lo mismo que en el modo FE_TONEAREST,
porque redondear hacia el infinito negativo para un número negativo es lo mismo que redondear al número más cercano.

En el modo FE_UPWARD, exp(1.1) es lo mismo que en el modo FE_TONEAREST,
porque redondear hacia el infinito positivo para un número positivo es lo mismo que redondear al número más cercano.
Por el contrario, -exp(1.1) es ligeramente mayor que en los otros modos,
porque está redondeado hacia abajo (hacia el infinito positivo).

En el modo FE_TOWARDZERO, tanto exp(1.1) como -exp(1.1) se redondean hacia cero,
por lo que ambos tienen una magnitud ligeramente menor que en los otros modos.

Los resultados double son los mismos en todos los modos porque el doble tiene mayor precisión que float,
por lo que el resultado exacto de exp(1.1) se puede representar con mayor precisión y el modo de redondeo tiene menos efecto.
*/