#include <stdio.h>
#include <stdlib.h>

#define N 600

__global__ void MatAdd(int A[][N], int B[][N], int C[][N]){
           int i = blockIdx.x;// genarating random genarated multidiomentional arrays
           int j = blockIdx.y;

           C[i][j] = A[i][j] + B[i][j];  // genarating random genarated multidiomentional arrays
}

//int** randmatfunc();


void randmatfunc(int newmat[N][N]){
  int i, j, k; 
    for(i=0;i<N;i++){
        for(j=0;j<N;j++){
          k = rand() % 100 + 1;;        // printing those multidiomentional array list over here using for loop
            printf("%d ", k);
            newmat[i][j] =k;
        }
        printf("\n");
       
    } 
  printf("\n--------------------------------------\n");    //printing new line (multidiomentional arrays)
}

int main(){

int A[N][N];  
randmatfunc(A);   //inside the main function calling randumfunction (A) 
  
int B[N][N];  
randmatfunc(B);    //inside the main function calling randumfunction (B) 



  int C[N][N];

  int (*d_A)[N], (*d_B)[N], (*d_C)[N];   // calculating genaratedarrays 

  cudaMalloc((void**)&d_A, (N*N)*sizeof(int));  // Allocates size bytes of linear memory on the device and returns in *devPtr a pointer to the allocated memory. returns cudaSuccess, cudaErrorMemoryAllocation
  cudaMalloc((void**)&d_B, (N*N)*sizeof(int));  // Allocates size bytes of linear memory on the device and returns in *devPtr a pointer to the allocated memory. returns cudaSuccess, cudaErrorMemoryAllocation
  cudaMalloc((void**)&d_C, (N*N)*sizeof(int));  // Allocates size bytes of linear memory on the device and returns in *devPtr a pointer to the allocated memory. returns cudaSuccess, cudaErrorMemoryAllocation

  cudaMemcpy(d_A, A, (N*N)*sizeof(int), cudaMemcpyHostToDevice);  //Copies count bytes from the memory area pointed to by src to the memory area pointed to by dst, where kind is one of cudaMemcpyHostToHost, cudaMemcpyHostToDevice, 
  cudaMemcpy(d_B, B, (N*N)*sizeof(int), cudaMemcpyHostToDevice);  //Copies count bytes from the memory area pointed to by src to the memory area pointed to by dst, where kind is one of cudaMemcpyHostToHost, cudaMemcpyHostToDevice, 
  cudaMemcpy(d_C, C, (N*N)*sizeof(int), cudaMemcpyHostToDevice);  //Copies count bytes from the memory area pointed to by src to the memory area pointed to by dst, where kind is one of cudaMemcpyHostToHost, cudaMemcpyHostToDevice, 

  int numThreads = 1;
  dim3 numBlocks(N,N);
  MatAdd<<<numBlocks,numThreads>>>(d_A,d_B,d_C);

  cudaMemcpy(C, d_C, (N*N)*sizeof(int), cudaMemcpyDeviceToHost);   //CUDA memory copy types

  int i, j; printf("C = \n");
    for(i=0;i<N;i++){
        for(j=0;j<N;j++){
            printf("%d ", C[i][j]);    // printing new lines with printed data (multidiomentional array)
        }
        printf("\n");
    }

  cudaFree(d_A); 
  cudaFree(d_B); 
  cudaFree(d_C);

  printf("\n");

  return 0;
}

