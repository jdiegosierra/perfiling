#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#include "aps.h"

tipo ** multiply_tr(tipo **matrix1, tipo **matrix2, tipo **result, int n);
tipo ** matrix_traspuesta(tipo **matrix, tipo **result, int n);

void print_matrix(tipo **matrix1, int n)
{
  int i, j;

  for (i = 0; i < n; i++) {
    for (j = 0; j < n; j++) {
      printf(" %.3lf ", matrix1[i][j]);
    }
    printf("\n");
  }
  printf("\n");
}

tipo ** multiply_tr (tipo **matrix1, tipo **matrix2, tipo **result, int n)
{
  double temp;

  int i, j, k;

  for (i = 0; i < n; i++) {
    for (j = 0; j < n; j++) {
      for (k = 0; k < n; k++) {
          temp += matrix1[i][k]*matrix2[j][k];
      }
      result[i][j] = temp;
      temp = 0;
      // result[i][j] += matrix1[i][j]*matrix2[j][i]
    }
  }
  return result;
}

tipo ** matrix_traspuesta(tipo **matrix, tipo **result, int n){
    int i;
    int j;

    for(i=0; i<n; i++){
      for(j=0;j<n; j++){
        result[i][j]=matrix[j][i];
      }
    }
    return result;
}

int main( int argc, char *argv[])
{
  struct timeval fin, ini;
  int tam = atoi(argv[1]);
  tipo **m1 = NULL;
  tipo **m2 = NULL;
  tipo **result = generateEmptyMatrix(tam);
  tipo **result_tr = generateEmptyMatrix(tam);

  printf("Word size: %ld bits\n", 8 * sizeof(tipo));

  if ( argc != 2 ) {
    printf("Error: Numero de argumentos incorrectos\n");
    return -1;
  }

/* Creamos las dos matrices a multiplicar y una matriz vacía donde almacenaremos el resultado*/
  m1 = generateMatrix(tam);
  if ( !m1 ) {
    return -1;
  }
  m2 = generateMatrix(tam);
  if ( !m2 ) {
    return -1;
  }
  result = generateEmptyMatrix(tam);
  if ( !result ) {
    return -1;
  }

  //print_matrix(m1, tam);
  //print_matrix(m2, tam);

  gettimeofday(&ini, NULL);
  /* Main computation */
  result_tr = matrix_traspuesta(m1, result_tr, tam);
  result = multiply_tr(m1, result_tr, result, tam);
  /* End of computation */

  gettimeofday(&fin, NULL);
  printf("Execution time: %f\n", ((fin.tv_sec * 1000000 + fin.tv_usec) - (ini.tv_sec * 1000000 + ini.tv_usec)) * 1.0 / 1000000.0);
  printf("Total: 2.03\n");
  // print_matrix(result_tr, tam);
  // print_matrix(result, tam);


/*Liberamos memoria*/
  free(m1);
  free(m2);
  free(result);
  free(result_tr);
  return 0;
}
