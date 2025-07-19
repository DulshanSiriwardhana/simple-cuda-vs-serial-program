#include <stdio.h>
#define N 10000
#define STEPS 100

int main() {
    double A[N], A_new[N];
    for (int i = 0; i < N; i++) A[i] = i * i * 0.0001;
    for (int s = 0; s < STEPS; s++) {
        for (int i = 0; i < N; i++) A_new[i] = A[i] * 1.0000001 + 0.0000001 * (i % 3 - 1);
        for (int i = 0; i < N; i++) A[i] = A_new[i];
    }
    FILE *f = fopen("c_output.txt", "w");
    for (int i = 0; i < N; i++) fprintf(f, "%d %.20f\n", i, A[i]);
    fclose(f);
    return 0;
}