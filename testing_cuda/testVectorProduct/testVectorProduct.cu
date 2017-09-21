
// System includes
#include <stdio.h>
#include <assert.h>
#include <stdlib.h> // For rand(), RAND_MAX


// CUDA runtime
#include <cuda_runtime.h>

typedef float DATATYPE;

const int n = 4096;
const int threadnum = 1024;

__global__ void vector_dot_prod(DATATYPE *a, DATATYPE *b, DATATYPE *c, int n) {
	if (threadIdx.x == 0 && blockIdx.x == 0) {
		c[0] = 0.0;
	}
	
	__shared__ DATATYPE tmp[threadnum];
	const int tidx = threadIdx.x;
	const int bidx =  blockIdx.x;
	const int t_n = blockDim.x * gridDim.x;
	int tid = bidx * blockDim.x + tidx;
	double temp = 0.0;
	while (tid < n) {
		temp += a[tid]*b[tid];
		tid += t_n;
	}
	tmp[tidx] = temp;

	__syncthreads();

	int i = blockDim.x/2;
	while (i != 0) {
		if (tidx < i) {
			tmp[tidx] += tmp[tidx+i];
		}

		__syncthreads();

		i /= 2;
	}

	if (tidx == 0) {
		atomicAdd(c, tmp[0]);
	}
}


int calc_doct_prod(DATATYPE *a, DATATYPE *b, DATATYPE *c) {

	DATATYPE *d_a;
	DATATYPE *d_b;
	DATATYPE *d_c;

	// GPU memory alloc
	cudaMalloc((void**)&d_a, sizeof(DATATYPE)*n);
	cudaMalloc((void**)&d_b, sizeof(DATATYPE)*n);
	cudaMalloc((void**)&d_c, sizeof(DATATYPE)*n);

	// GPU data transfer
	cudaMemcpy(d_a, a, sizeof(DATATYPE)*n, cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, b, sizeof(DATATYPE)*n, cudaMemcpyHostToDevice);

	// call the GPU kernel
	vector_dot_prod<<<(int)ceil(n/threadnum),threadnum>>>(d_a, d_b, d_c, n);

	// result copy back to CPU
	cudaMemcpy(c, d_c, sizeof(DATATYPE)*n, cudaMemcpyDeviceToHost);

	// GPU memory free
	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);

	return 0;
}



int calc_doct_prod_CPU(DATATYPE *a, DATATYPE *b, DATATYPE *c) {

    DATATYPE s = 0.0;

	for (int i = 0; i < n; i++) {
		s += a[i] * b[i];
	}
    c[0] = s;

	return 0;
}

int main(){

    srand(time(0));

	DATATYPE *a;
	DATATYPE *b;
	DATATYPE *c;

	a = (DATATYPE *)malloc(sizeof(DATATYPE)*n);
	b = (DATATYPE *)malloc(sizeof(DATATYPE)*n);
	c = (DATATYPE *)malloc(sizeof(DATATYPE)*n);

	for (int i = 0; i < n; i++) {
		a[i] = (DATATYPE)rand()/RAND_MAX;
		b[i] = (DATATYPE)rand()/RAND_MAX;
	}

	calc_doct_prod(a, b, c);
	// calc_doct_prod_CPU(a, b, c);
	
	printf("%f", c[0]);


	free(a);
	free(b);
	free(c);

	return 0;
}
