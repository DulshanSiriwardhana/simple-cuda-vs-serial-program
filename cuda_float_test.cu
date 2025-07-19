#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define N 10
#define STEPS 100

__global__ void update(double *A, double *A_new) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i > 0 && i < N - 1) {
        A_new[i] = A[i] + 0.1 * (A[i - 1] - 2 * A[i] + A[i + 1]);
    }
}

int main() {
    double *A, *A_new;
    double *d_A, *d_A_new;
    A = (double*)malloc(N * sizeof(double));
    A_new = (double*)malloc(N * sizeof(double));
    for (int i = 0; i < N; i++) {
        A[i] = i * i * 0.0001;
    }
    cudaMalloc(&d_A, N * sizeof(double));
    cudaMalloc(&d_A_new, N * sizeof(double));
    cudaMemcpy(d_A, A, N * sizeof(double), cudaMemcpyHostToDevice);
    int threads = 256;
    int blocks = (N + threads - 1) / threads;
    for (int step = 0; step < STEPS; step++) {
        cudaDeviceSynchronize();
        update<<<blocks, threads>>>(d_A, d_A_new);
        cudaDeviceSynchronize();
        double *temp = d_A;
        d_A = d_A_new;
        d_A_new = temp;
        cudaDeviceSynchronize();
    }
    cudaMemcpy(A, d_A, N * sizeof(double), cudaMemcpyDeviceToHost);
    FILE *fp = fopen("cuda_output.txt", "w");
    if (fp == NULL) {
        fprintf(stderr, "Failed to open output file.\n");
        return 1;
    }
    for (int i = 0; i < N; i++) {
        fprintf(fp, "%d %.20f\n", i, A[i]);
    }
    fclose(fp);
    cudaFree(d_A);
    cudaFree(d_A_new);
    free(A);
    free(A_new);
    return 0;
} 