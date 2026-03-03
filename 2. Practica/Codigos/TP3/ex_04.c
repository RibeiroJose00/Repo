// Version: 002
// Date:    2022/04/05
// Author:  Rodrigo Gonzalez <rodralez@frm.utn.edu.ar>

#include <stdio.h>
#include <float.h>
#include <math.h>
#include <signal.h>
#include <stdlib.h>

// Compile usando el siguiente comando
// compile: gcc -Wall -O3 -std=c99 ex_04.c -o ex_04 -lm -march=corei7 -frounding-math -fsignaling-nans

#define _GNU_SOURCE 1
#define _ISOC99_SOURCE
#include <fenv.h>

void show_fe_exceptions(void)
{
    printf("current exceptions raised: ");
    if(fetestexcept(FE_DIVBYZERO))     printf(" FE_DIVBYZERO");
    if(fetestexcept(FE_INEXACT))       printf(" FE_INEXACT");
    if(fetestexcept(FE_INVALID))       printf(" FE_INVALID");
    if(fetestexcept(FE_OVERFLOW))      printf(" FE_OVERFLOW");
    if(fetestexcept(FE_UNDERFLOW))     printf(" FE_UNDERFLOW");
    if(fetestexcept(FE_ALL_EXCEPT)==0) printf(" none");
    printf("\n");
}
     
int main(void)
{	
  float a, b;

  int ROUND_MODE;
	
  ROUND_MODE = fegetround();		
  printf("Current Round Mode = %d \n", ROUND_MODE );
		
  show_fe_exceptions();
      
  /* Temporarily raise other exceptions */
  feclearexcept(FE_ALL_EXCEPT);
  feraiseexcept(FE_INEXACT);
  show_fe_exceptions();
    
  feclearexcept(FE_ALL_EXCEPT);
  feraiseexcept(FE_INVALID);
  show_fe_exceptions();

  feclearexcept(FE_ALL_EXCEPT);    
  feraiseexcept(FE_DIVBYZERO);
  show_fe_exceptions();

  feclearexcept(FE_ALL_EXCEPT);
  feraiseexcept(FE_OVERFLOW);
  show_fe_exceptions();

  feclearexcept(FE_ALL_EXCEPT);
  feraiseexcept(FE_UNDERFLOW);
  show_fe_exceptions();
  
  feclearexcept(FE_ALL_EXCEPT);
  feraiseexcept(FE_OVERFLOW | FE_INEXACT);
  show_fe_exceptions();

  printf("\nTest NaN");
  feclearexcept(FE_ALL_EXCEPT);
  a = 0./0;
  printf("\nOperacion: 0./0 = %f", a);
  printf("\n");
  show_fe_exceptions();

  printf("\nTest Inexactitud");
  feclearexcept(FE_ALL_EXCEPT);
  a = 1 + 1e10;
  printf("\nOperacion: 1 + 1e10 = %f", a);
  printf("\n");
  show_fe_exceptions();

  printf("\nTest Infinito (+)");
  feclearexcept(FE_ALL_EXCEPT);
  a = 1./0;
  printf("\nOperacion: 1./0 = %f", a);
  printf("\n");
  show_fe_exceptions();

  printf("\nTest Infinito (-)");
  feclearexcept(FE_ALL_EXCEPT);
  a = -1./0;
  printf("\nOperacion: -1./0 = %f", a);
  printf("\n");
  show_fe_exceptions();

  printf("\nTest Overflow");
  feclearexcept(FE_ALL_EXCEPT);
  b = 1.00001;
  a = FLT_MAX + b;
  printf("\nOperacion: %f + %f = %f", FLT_MAX, b, a);
  printf("\n");
  show_fe_exceptions();

  printf("\nTest");
  feclearexcept(FE_ALL_EXCEPT);
  b = 1.00001;
  a = FLT_MAX * b;
  printf("\nOperacion: %f * %f = %f", FLT_MAX, b, a);
  printf("\n");
  show_fe_exceptions();

  printf("\nTest");
  feclearexcept(FE_ALL_EXCEPT);
  b = 2.;
  a = FLT_MIN / b;
  printf("\nOperacion: %f / %f = %.40f", FLT_MAX, b, a);
  printf("\n");
  show_fe_exceptions();
  
  printf("\nTest");
  feclearexcept(FE_ALL_EXCEPT);
  b = 2.1;
  a = FLT_MIN - b;
  printf("\nOperacion: %f / %f = %.40f", FLT_MAX, b, a);
  printf("\n");
  show_fe_exceptions();

	return 0;	

}

/*************************************
Este codigo demuestra el manejo de excepciones en punto flotante.
1. Se observa que las excepciones se pueden levantar y limpiar con las funciones feraiseexcept() y feclearexcept().
La funcion fetestexcept() permite verificar si una excepcion fue levantada.
2. Probamos levantar las excepciones FE_INEXACT, FE_INVALID, FE_DIVBYZERO, FE_OVERFLOW y FE_UNDERFLOW.
*************************************/