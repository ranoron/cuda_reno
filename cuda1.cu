//including important libraries 
#include <stdio.h>
#include <stdlib.h>

// definning n4
#define N 4

__global__ void MatAdd(int A[][N], int B[][N], int C[][N]){
           int i = threadIdx.x; //creating variables (int)
           int j = threadIdx.y; //creating variables (int)

           C[i][j] = A[i][j] + B[i][j];
}


int main(){//main function

  int A[N][N] =
    {
      {1, 5, 6, 7},
      {4, 4, 8, 0},
      {2, 3, 4, 5},
      {2, 3, 4, 5}
   };

  int B[N][N] = 
    {
      {1, 5, 6, 7},
      {4, 4, 8, 0},
      {2, 3, 4, 5},
      {2, 3, 4, 5}
   };

  int C[N][N] = 
     {
      {0, 0, 0, 0},
      {0, 0, 0, 0},
      {0, 0, 0, 0},
      {0, 0, 0, 0}
   };

  int (*d_A)[N], (*d_B)[N], (*d_C)[N];

  cudaMalloc((void**)&d_A, (N*N)*sizeof(int));
  cudaMalloc((void**)&d_B, (N*N)*sizeof(int));
  cudaMalloc((void**)&d_C, (N*N)*sizeof(int));

  cudaMemcpy(d_A, A, (N*N)*sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(d_B, B, (N*N)*sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(d_C, C, (N*N)*sizeof(int), cudaMemcpyHostToDevice);

  int numBlocks = 1;
  dim3 threadsPerBlock(N,N);
  MatAdd<<<numBlocks,threadsPerBlock>>>(d_A,d_B,d_C);

  cudaMemcpy(C, d_C, (N*N)*sizeof(int), cudaMemcpyDeviceToHost);

  int i, j; printf("C = \n");
    for(i=0;i<N;i++){
        for(j=0;j<N;j++){
            printf("%d ", C[i][j]);
        }
        printf("\n");
    }

  cudaFree(d_A); 
  cudaFree(d_B); 
  cudaFree(d_C);

  printf("\n");

  return 0;
}

