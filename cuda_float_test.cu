#include <stdio.h>
#include <stdlib.h>
#define N 10000
#define STEPS 100

__global__ void update(double *A, double *A_new) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < N) A_new[i] = A[i] * 1.0000001 + 0.0000001 * (i % 3 - 1);
}

int main() {
    double A[N], A_new[N];
    double *d_A, *d_A_new;
    for (int i = 0; i < N; i++) A[i] = i * i * 0.0001;
    cudaMalloc(&d_A, N * sizeof(double));
    cudaMalloc(&d_A_new, N * sizeof(double));
    cudaMemcpy(d_A, A, N * sizeof(double), cudaMemcpyHostToDevice);
    int threads = N, blocks = 1;
    for (int s = 0; s < STEPS; s++) {
        update<<<blocks, threads>>>(d_A, d_A_new);
        double *tmp = d_A; d_A = d_A_new; d_A_new = tmp;
    }
    cudaMemcpy(A, d_A, N * sizeof(double), cudaMemcpyDeviceToHost);
    FILE *f = fopen("cuda_output.txt", "w");
    for (int i = 0; i < N; i++) fprintf(f, "%d %.20f\n", i, A[i]);
    fclose(f);
    cudaFree(d_A); cudaFree(d_A_new);
    return 0;
}