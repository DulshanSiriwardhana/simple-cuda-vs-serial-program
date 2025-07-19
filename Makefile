CC=gcc
NVCC=nvcc
CFLAGS=-O2 -lm -ffloat-store -fexcess-precision=standard -std=c99

all: cuda_float_test c_float_test outputs compare plot clean

cuda_float_test: cuda_float_test.cu
	$(NVCC) $(NVCCFLAGS) -o cuda_float_test cuda_float_test.cu

c_float_test: c_float_test.c
	$(CC) $(CFLAGS) -o c_float_test c_float_test.c

outputs: cuda_float_test c_float_test
	./cuda_float_test
	./c_float_test

compare: outputs compare_outputs.py
	python3 compare_outputs.py

plot: outputs plot_differences.py
	python3 plot_differences.py

clean:
	rm -f cuda_float_test c_float_test cuda_output.txt c_output.txt differences_plot.png 