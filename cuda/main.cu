#include <stdio.h>

#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#define BLOCK_SIZE 512

// no null terminator
__device__ void int2str(int value, char *buf, int size) {
  int i = size - 1;
  do {
    buf[i--] = (value % 10) + '0';
    value = value / 10;
  } while (value > 0);
}

// return str = "1       \n2       \nFizz    \n...\n\0"
__global__ void kernel_fizzbuzz(char *str, int allign, int n) {
  int id = blockDim.x * blockIdx.x + threadIdx.x;
  int i = id + 1;
  int shift = 0;

  if (id < n)
  {
    if (i % 3 == 0) {
      str[id * allign] = 'F';
      str[id * allign + 1] = 'i';
      str[id * allign + 2] ='z';
      str[id * allign + 3] ='z';
      shift += 4;
    }
    if (i % 5 == 0) {
      str[id * allign + shift] = 'B';
      str[id * allign + shift + 1] = 'u';
      str[id * allign + shift + 2] ='z';
      str[id * allign + shift + 3] ='z';
      shift += 4;
    }
    if (!(i % 3 == 0 || i % 5 == 0)) {
      shift = floorf(log10f((float)i)) + 1;
      int2str(i, &str[id * allign], shift);
    }
    for (int s = shift; s < allign - 1; s++)
    {
      str[id * allign + s] = ' ';
    }
    str[id * allign + allign - 1] = '\n';
  }
}

int main() {
  int n = 100, allign = 9;
  char *host_str, *dev_str;
  host_str = (char *)malloc(n * allign * sizeof(char) + 1);
  cudaMalloc((void **)&dev_str, n * allign * sizeof(char) + 1);

  dim3 block(BLOCK_SIZE);
  dim3 grid(n / BLOCK_SIZE + (n % BLOCK_SIZE ? 1 : 0));

  kernel_fizzbuzz<<<grid, block>>>(dev_str, allign, n);

  cudaMemcpy(host_str, dev_str, n * allign * sizeof(char) + 1, cudaMemcpyDeviceToHost);
  puts(host_str);

  free(host_str);
  cudaFree(dev_str);

  return EXIT_SUCCESS;
}