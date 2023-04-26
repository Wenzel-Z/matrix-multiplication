#include <iostream>
#include <string>
#include <random>
#include <omp.h>
#include <cstdio>

using namespace std;

__global__ void mul_vec_gpu(double* a, double* b, double* c, int size)
{
	int index = blockDim.x * blockIdx.x + threadIdx.x;

	if (index < size)
		c[index] = a[index] * b[index];
}

int main(int argc, char** argv)
{
    int N;
    int block_size = 128;
    bool exit = false;
    const int seed = 1;
    if (argc == 1) {
        cout << "Please enter either one or two arguments.\n";
        exit = true;
    }
    else if (argc == 2) {
        N = std::stoi(argv[1]);
    } 
    if (!exit)
    {
        size_t NO_BYTES = N * sizeof(double); //bytes needed
        double *h_a, *h_b, *gpu_result; // host pointers

        // Allocate
        h_a = (double *)malloc(NO_BYTES);
        h_b = (double *)malloc(NO_BYTES);
        gpu_result = (double *)malloc(NO_BYTES);

        // Initialize vectors
        std::mt19937 engine(seed);
        std::uniform_int_distribution<double> dist(-5, 5);

        for (size_t i = 0; i < N; i++) 
        {
            #ifdef TEST
                h_a[i] = 1.0;
            #else
                h_a[i] = dist(engine);
            #endif
        }

        for (size_t i = 0; i < N; i++) 
        {
            #ifdef TEST
                h_b[i] = 1.0;
            #else
                h_b[i] = dist(engine);
            #endif
        }

        memset(gpu_result, 0, NO_BYTES)

        // Cuda Pointers
        double *d_a, *d_b, *d_c;
        cudaMalloc((double **)&d_a, NO_BYTES);
        cudaMalloc((double **)&d_b, NO_BYTES);
        cudaMalloc((double **)&d_c, NO_BYTES);

        
        // Copy from host to device
        cudaMemcpy(d_a, h_a, NO_BYTES, cudaMemcpyHostToDevice);
	    cudaMemcpy(d_b, h_b, NO_BYTES, cudaMemcpyHostToDevice);

        dim3 block(N);
        dim3 grid((N/ block.x) + 1);

        double gpu_start = omp.get_time();
        mul_vec_gpu <<<grid, block>>> (d_a, d_b, d_c, N);
        cudaDeviceSynchronize();
        double gpu_end = omp.get_time();
        total_time = gpu_end - gpu_start;
        printf(total_time);

        double total = 0;
        for (int i = 0; i < N; i++) {
            total = total + c[i];
        }

        printf("%li", total);

        cudaFree(d_c);
        cudaFree(d_b);
        cudaFree(d_a);

        free(gpu_result);
        free(h_a);
        free(h_b);

        cudaDeviceReset();
    }
    return 0;
}
