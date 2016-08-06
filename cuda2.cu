#include <stdio.h>
#include <stdlib.h>

#define N 22

__global__ void MatAdd(int A[][N], int B[][N], int C[][N]){
           int i = threadIdx.x; // create threds for use 1024 threads in a single block in a single dimension
           int j = threadIdx.y; // create threds for use 1024 threads in a single block in a single dimension

           C[i][j] = A[i][j] + B[i][j]; //calculation between arrays 
}

//int** randmatfunc();


void randmatfunc(int newmat[N][N]){   // genarating random genarated multidiomentional arrays
  int i, j, k; 
    for(i=0;i<N;i++){
        for(j=0;j<N;j++){
          k = rand() % 100 + 1;;
            printf("%d ", k);
            newmat[i][j] =k;      // printing those multidiomentional array list over here using for loop
        }
        printf("\n");
       
    } 
  printf("\n--------------------------------------\n");   //printing new line 
}

int main(){

int A[N][N];  
randmatfunc(A);     //inside the main function calling randumfunction (A) 
  
int B[N][N];  
randmatfunc(B);  //inside the main function calling randumfunction (B) 



  int C[N][N];

  int (*d_A)[N], (*d_B)[N], (*d_C)[N];  // calculating genarated multidiomentional arrays 

  cudaMalloc((void**)&d_A, (N*N)*sizeof(int));  // Allocates size bytes of linear memory on the device and returns in *devPtr a pointer to the allocated memory. returns cudaSuccess, cudaErrorMemoryAllocation
  cudaMalloc((void**)&d_B, (N*N)*sizeof(int));// Allocates size bytes of linear memory on the device and returns in *devPtr a pointer to the allocated memory. returns cudaSuccess, cudaErrorMemoryAllocation
  cudaMalloc((void**)&d_C, (N*N)*sizeof(int));// Allocates size bytes of linear memory on the device and returns in *devPtr a pointer to the allocated memory. returns cudaSuccess, cudaErrorMemoryAllocation

  cudaMemcpy(d_A, A, (N*N)*sizeof(int), cudaMemcpyHostToDevice); //Copies count bytes from the memory area pointed to by src to the memory area pointed to by dst, where kind is one of cudaMemcpyHostToHost, cudaMemcpyHostToDevice, 
  cudaMemcpy(d_B, B, (N*N)*sizeof(int), cudaMemcpyHostToDevice);//Copies count bytes from the memory area pointed to by src to the memory area pointed to by dst, where kind is one of cudaMemcpyHostToHost, cudaMemcpyHostToDevice, 
  cudaMemcpy(d_C, C, (N*N)*sizeof(int), cudaMemcpyHostToDevice);//Copies count bytes from the memory area pointed to by src to the memory area pointed to by dst, where kind is one of cudaMemcpyHostToHost, cudaMemcpyHostToDevice, 

  int numBlocks = 1;
  dim3 threadsPerBlock(N,N);  // is an integer struct type defined in the file
  MatAdd<<<numBlocks,threadsPerBlock>>>(d_A,d_B,d_C);

  cudaMemcpy(C, d_C, (N*N)*sizeof(int), cudaMemcpyDeviceToHost);  //CUDA memory copy types

  int i, j; printf("C = \n");
    for(i=0;i<N;i++){
        for(j=0;j<N;j++){
            printf("%d ", C[i][j]);
        }
        printf("\n");  // printing new lines (multidiomentional arrays)
    }

  cudaFree(d_A); 
  cudaFree(d_B); 
  cudaFree(d_C);

  printf("\n");

  return 0;
}

