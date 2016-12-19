#include "mex.h"
#include<omp.h>
#include <math.h>
#include <string.h>

/*
 * This code is used for computing filter responses.  It computes the
 * response of a set of filters with a feature map.  
 *
 * Basic version, relatively slow but very compatible.
 */

struct thread_data {
  float *A;
  float *B;
  float *C;
  mxArray *mxC;
  const mwSize *A_dims;
  const mwSize *B_dims;
  int B_dimNum;
  mwSize C_dims[3];
};

// convolve A and B
void process(void *thread_arg) {
  thread_data *args = (thread_data *)thread_arg;
  float *A = args->A;
  float *B = args->B;
  float *C = args->C;
  const mwSize *A_dims = args->A_dims;
  const mwSize *B_dims = args->B_dims;
  const mwSize *C_dims = args->C_dims;
  const int C_size=C_dims[1]* C_dims[0];
  int num_patches = args->A_dims[2];
//  printf("A_dims: %d, %d, %d, B_dims: %d, %d, %d, C_dims: %d, %d, %d\n", A_dims[0], A_dims[1], A_dims[2], B_dims[0], B_dims[1], B_dims[2], C_dims[0], C_dims[1], C_dims[2]);
//  printf("num_patches: %d, C_size: %d\n", num_patches, C_size);

	int coreNum = omp_get_num_procs();
	int threadNum=coreNum*4;//coreNum;
	if (threadNum>10)
		threadNum = 10;
	
    
  omp_set_num_threads(threadNum);
  #pragma omp parallel for
  for (int f = 0; f < num_patches; f++) {
    for (int k = 0; k < C_size; k++) {
  	  int x = k / C_dims[0];
  	  int y = k % C_dims[0];
		    float *A_src = A + f*A_dims[0]*A_dims[1];      
		    float *B_src = B;
//		    float *B_src = B + f*B_dims[0]*B_dims[1];
				float val = 0;
				for (int xp = 0; xp < B_dims[1]; xp++) {
				  float *A_off = A_src + (x+xp)*A_dims[0] + y;
				  float *B_off = B_src + xp*B_dims[0];
				  switch(B_dims[0]) {
				  case 20: val += A_off[19] * B_off[19];
				  case 19: val += A_off[18] * B_off[18];
				  case 18: val += A_off[17] * B_off[17];
				  case 17: val += A_off[16] * B_off[16];
				  case 16: val += A_off[15] * B_off[15];
				  case 15: val += A_off[14] * B_off[14];
				  case 14: val += A_off[13] * B_off[13];
				  case 13: val += A_off[12] * B_off[12];
				  case 12: val += A_off[11] * B_off[11];
				  case 11: val += A_off[10] * B_off[10];
				  case 10: val += A_off[9] * B_off[9];
				  case 9: val += A_off[8] * B_off[8];
				  case 8: val += A_off[7] * B_off[7];
				  case 7: val += A_off[6] * B_off[6];
				  case 6: val += A_off[5] * B_off[5];
				  case 5: val += A_off[4] * B_off[4];
				  case 4: val += A_off[3] * B_off[3];
				  case 3: val += A_off[2] * B_off[2];
				  case 2: val += A_off[1] * B_off[1];
				  case 1: val += A_off[0] * B_off[0];
				    break;
				  default:	    	      
				    for (int yp = 0; yp < B_dims[0]; yp++) {
				      val += *(A_off++) * *(B_off++);
				    }
				  }
				}
				C[k+f*C_size] = val;
      }
//      C = C + C_size;
  }
}

void process2(void *thread_arg) {
  thread_data *args = (thread_data *)thread_arg;
  float *A = args->A;
  float *B = args->B;
  float *C = args->C;
  const mwSize *A_dims = args->A_dims;
  const mwSize *B_dims = args->B_dims;
  const mwSize *C_dims = args->C_dims;
  const int C_size=C_dims[1]* C_dims[0];
  int num_features = args->A_dims[2];

	int coreNum = omp_get_num_procs();
	int threadNum=coreNum*4;//coreNum;
	if (threadNum>10)
		threadNum = 10;
		
    
  omp_set_num_threads(threadNum);
  #pragma omp parallel for
  for (int k = 0; k < C_size; k++) {
  	int x = k / C_dims[0];
  	int y = k % C_dims[0];
		  for (int f = 0; f < num_features; f++) {
		    float *A_src = A + f*A_dims[0]*A_dims[1];      
		    float *B_src = B + f*B_dims[0]*B_dims[1];
				float val = 0;
				for (int xp = 0; xp < B_dims[1]; xp++) {
				  float *A_off = A_src + (x+xp)*A_dims[0] + y;
				  float *B_off = B_src + xp*B_dims[0];
				  switch(B_dims[0]) {
				  case 20: val += A_off[19] * B_off[19];
				  case 19: val += A_off[18] * B_off[18];
				  case 18: val += A_off[17] * B_off[17];
				  case 17: val += A_off[16] * B_off[16];
				  case 16: val += A_off[15] * B_off[15];
				  case 15: val += A_off[14] * B_off[14];
				  case 14: val += A_off[13] * B_off[13];
				  case 13: val += A_off[12] * B_off[12];
				  case 12: val += A_off[11] * B_off[11];
				  case 11: val += A_off[10] * B_off[10];
				  case 10: val += A_off[9] * B_off[9];
				  case 9: val += A_off[8] * B_off[8];
				  case 8: val += A_off[7] * B_off[7];
				  case 7: val += A_off[6] * B_off[6];
				  case 6: val += A_off[5] * B_off[5];
				  case 5: val += A_off[4] * B_off[4];
				  case 4: val += A_off[3] * B_off[3];
				  case 3: val += A_off[2] * B_off[2];
				  case 2: val += A_off[1] * B_off[1];
				  case 1: val += A_off[0] * B_off[0];
				    break;
				  default:	    	      
				    for (int yp = 0; yp < B_dims[0]; yp++) {
				      val += *(A_off++) * *(B_off++);
				    }
				  }
				}
				C[k] += val;
      }
  }
}

// matlab entry point
// C = fconv(A, cell of B, start, end);
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) { 
  if (nrhs != 2)
    mexErrMsgTxt("Wrong number of inputs"); 
  if (nlhs != 1)
    mexErrMsgTxt("Wrong number of outputs");

  // get A
  const mxArray *mxA = prhs[0];
  if (mxGetNumberOfDimensions(mxA) != 3 || 
      mxGetClassID(mxA) != mxSINGLE_CLASS)
    mexErrMsgTxt("Invalid input: A");

  // get B and start/end
  const mxArray *mxB = prhs[1];
  int len = 1;
/*  mwSize num_bs = mxGetNumberOfElements(cellB);  
  int start = (int)mxGetScalar(prhs[2]) - 1;
  int end = (int)mxGetScalar(prhs[3]) - 1;
  if (start < 0 || end >= num_bs || start > end)
    mexErrMsgTxt("Invalid input: start/end");
  int len = end-start+1;
*/
  // output cell

  // do convolutions
  thread_data td;
  const mwSize *A_dims = mxGetDimensions(mxA);
  float *A = (float *)mxGetPr(mxA);
//  for (int i = 0; i < len; i++) {
//    const mxArray *mxB = mxGetCell(cellB, i+start);
    td.A_dims = A_dims;
    td.A = A;
    td.B_dims = mxGetDimensions(mxB);
    td.B = (float *)mxGetPr(mxB);
  int B_dimNum = mxGetNumberOfDimensions(mxB);
  if ((B_dimNum != 2)&& (B_dimNum != 3) || 
      mxGetClassID(mxB) != mxSINGLE_CLASS)
/*    if (mxGetNumberOfDimensions(mxB) != 3 ||
        mxGetClassID(mxB) != mxDOUBLE_CLASS ||
        td.A_dims[2] != td.B_dims[2])*/
      mexErrMsgTxt("Invalid input: B");

    // compute size of output
    int height = td.A_dims[0] - td.B_dims[0] + 1;
    int width = td.A_dims[1] - td.B_dims[1] + 1;
    if (height < 1 || width < 1)
      mexErrMsgTxt("Invalid input: B should be smaller than A");
    td.C_dims[0] = height;
    td.C_dims[1] = width;
    if (B_dimNum==2)
    	    td.C_dims[2] = td.A_dims[2];
    else
    	    td.C_dims[2] = 1;
    td.B_dimNum = B_dimNum;
    plhs[0] = mxCreateNumericArray(3, td.C_dims, mxSINGLE_CLASS, mxREAL);
    td.mxC = plhs[0];
    td.C = (float *)mxGetPr(plhs[0]);
    
    
    // **************************
    if (B_dimNum==2)
    	    process((void *)&td);
    else
    	    process2((void *)&td);
    // **************************
    
    
//    mxSetCell(plhs[0], i, td.mxC);
//  }
}


