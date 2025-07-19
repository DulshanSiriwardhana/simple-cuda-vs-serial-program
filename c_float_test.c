#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define N 10
#define STEPS 100

int main() {
    double *A = (double*)malloc(N * sizeof(double));
    double *A_new = (double*)malloc(N * sizeof(double));
    for (int i = 0; i < N; i++) {
        A[i] = i * i * 0.0001;
    }
    for (int step = 0; step < STEPS; step++) {
        for (int i = 1; i < N - 1; i++) {
            A_new[i] = A[i] + 0.1 * (A[i - 1] - 2 * A[i] + A[i + 1]);
        }
        A_new[0] = A[0];
        A_new[N-1] = A[N-1];
        double *temp = A;
        A = A_new;
        A_new = temp;
    }
    FILE *fp = fopen("c_output.txt", "w");
    if (fp == NULL) {
        fprintf(stderr, "Failed to open output file.\n");
        return 1;
    }
    for (int i = 0; i < N; i++) {
        fprintf(fp, "%d %.20f\n", i, A[i]);
    }
    fclose(fp);
    free(A);
    free(A_new);
    return 0;
}