/*thread_param array size needs to tune if # of cores change*/
#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>
 
#define SIZE 2000   // Size by SIZE matrices
#define ITER 3
int num_thrd;   // number of threads
 
int A[SIZE][SIZE], B[SIZE][SIZE], C[SIZE][SIZE];

struct thread_param {
	int slice;
	int counter;
	char pad[128 - 2 * sizeof(int)];  
} params[32];
 
unsigned int quit = 0;

// initialize a matrix
void init_matrix(int m[SIZE][SIZE])
{
  int i, j, val = 0;
  for (i = 0; i < SIZE; i++)
    for (j = 0; j < SIZE; j++)
      m[i][j] = val++;
}
 
void print_matrix(int m[SIZE][SIZE])
{
  int i, j;
  for (i = 0; i < SIZE; i++) {
    printf("\n\t| ");
    for (j = 0; j < SIZE; j++)
      printf("%2d ", m[i][j]);
    printf("|");
  }
}
 
// thread function: taking "slice" as its argument
void* multiply(void* param)
{
  struct thread_param *myparam = (struct thread_param *) param;
  int s = myparam->slice;   // retrive the slice info
  int from = (s * SIZE)/num_thrd; // note that this 'slicing' works fine
  int to = ((s+1) * SIZE)/num_thrd; // even if SIZE is not divisible by num_thrd
  printf("to is %d\n", to);
  int i,j,k, iter;
 
  printf("comuting slice %d (from row %d to %d)\n", s, from, to-1);
  while(!quit) {
     for (i = from; i < to; i++)
     {  
        for (j = 0; j < SIZE; j++)
        {
          C[i][j] = 0;
          for ( k = 0; k < SIZE; k++)
              C[i][j] += A[i][k]*B[k][j];
        }
	myparam->counter++;
     }
  }
  printf("finished slice %d\n", s);
  return 0;
}
 
int main(int argc, char* argv[])
{
  pthread_t* thread;  // pointer to a group of threads
  int i, j;
  unsigned long last_total = 0, total = 0;
  FILE *f;
 
  f=fopen("/tmp/output","w");
  if (argc!=2 && argc != 3)
  {
    printf("Usage: %s number_of_threads\n",argv[0]);
    exit(-1);
  }
 
  num_thrd = atoi(argv[1]);
  init_matrix(A);
  init_matrix(B);
  thread = (pthread_t*) malloc(num_thrd*sizeof(pthread_t));

  // this for loop not entered if threadd number is specified as 1
  for (i = 0; i < num_thrd; i++)
  {
    params[i].slice = i;
    params[i].counter = 0;
    // creates each thread working on its own slice of i
	printf("i is %d\n", i);
    if (pthread_create (&thread[i], NULL, multiply, (void*)(params + i)) != 0 )
    {
      perror("Can't create thread");
      free(thread);
      exit(-1);
    }
  }

  for (i = 0; i < ITER; i++)
  {
	usleep(100000); //0.1 second
	if(argc==3) {
	        total = 0;
        	for(j = 0; j < num_thrd; j++)
			total = total + params[j].counter;
		printf("%d %lu\n", i, total - last_total);
		fprintf(f, "%d %lu\n", i, total - last_total);
		fflush(stdout);
		fflush(f);
		last_total = total;
	}
  }
  quit = 1;
  // main thead waiting for other thread to complete
  for (i = 0; i < num_thrd; i++)
	 pthread_join (thread[i], NULL);
 
//  printf("\n\n");
//  print_matrix(A);
//  printf("\n\n\t       * \n");
//  print_matrix(B);
//  printf("\n\n\t       = \n");
//  print_matrix(C);
//  printf("\n\n");
 
  free(thread);
  fclose(f);
 
  return 0;
 
}
