#include <math.h>
#include <stdio.h>
void main(void)
{
char a, b, c, d, s1, s2;
a = 127;
b = 127;
c = a + b;
d = a * b;
s1 = (-8) >> 2;
s2 = (-1) >> 5;
printf("c = %d \n", c );
printf("d = %d \n", d );
printf("s1 = %d \n", s1 );
printf("s2 = %d \n", s2 );
}
/******************************************
 1.1 Los valores de c y d deberian ser
    c = 254 y d = 16129 respectivamente
    Esto se debe a que la representación del número 127
    en binario como signed char es 0b01111111, por lo que
    al sumarlos se obtiene 0b11111110 = -2
    y al multiplicarlos se obtiene
    0b01111111 * 0b01111111 = 0b00111111 00000001 = 16129
    como signed char solo admite 8 bits, el resultado trunca los
    bits más significativos y se obtiene 0b00000001 = 1

 1.2 Para que los valores de c y d sean correctos,
    se debe cambiar el tipo de dato de las variables a, b, c y d
    a short, int o long.

 1.3 Las operaciones para s1 y s2 son respectivamente:

    s1 = (-8) >> 2 = 0b11111000 >> 2 = 0b11111110 = -2
    s2 = (-1) >> 5 = 0b11111111 >> 5 = 0b11111111 = -1
    
    Como los numeros son signed char, y al tener un uno en el
    primer bit, al realizar el corrimiento a la derecha se rellena
    con el bit de signo.
    En el caso de s1, el corrimiento a la derecha de 2 posiciones
    equivale a dividir por 4, por lo que el resultado es -2
    En el caso de s2, el corrimiento a la derecha de 5 posiciones
    equivale a dividir por 32, por lo que el resultado es -0.03125
    pero como es signed char (entero), el resultado es -1
 ******************************************/