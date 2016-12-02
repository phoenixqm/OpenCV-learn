#include <opencv2/core.hpp>
#include <opencv2/features2d.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/opencv.hpp>
#include <opencv2/stitching.hpp>
#include <iostream>

using namespace cv;  
using namespace std;


int main()  
{
	vector< Mat > vImg;
	
	vector< vector< Rect > > vvRect;
	Mat rImg;

	// vImg.push_back( imread("shanghai01.jpg") );	
	// vImg.push_back( imread("shanghai02.jpg") );
	// vImg.push_back( imread("shanghai03.jpg") );	

    // vImg.push_back( imread("S1.jpg"));
    // vImg.push_back( imread("S2.jpg"));
    // vImg.push_back( imread("S3.jpg"));
    // vImg.push_back( imread("S4.jpg"));
    // vImg.push_back( imread("S5.jpg"));
    // vImg.push_back( imread("S6.jpg"));
    
    vImg.push_back( imread("stitching_img/m1.jpg"));
    vImg.push_back( imread("stitching_img/m2.jpg"));
    vImg.push_back( imread("stitching_img/m3.jpg"));
    vImg.push_back( imread("stitching_img/m4.jpg"));
    vImg.push_back( imread("stitching_img/m5.jpg"));
    vImg.push_back( imread("stitching_img/m6.jpg"));
    vImg.push_back( imread("stitching_img/m7.jpg"));
    vImg.push_back( imread("stitching_img/m8.jpg"));
    vImg.push_back( imread("stitching_img/m9.jpg"));
    vImg.push_back( imread("stitching_img/m10.jpg"));
    vImg.push_back( imread("stitching_img/m11.jpg"));
    vImg.push_back( imread("stitching_img/m12.jpg"));
    vImg.push_back( imread("stitching_img/m13.jpg"));


	Stitcher stitcher = Stitcher::createDefault(1);


	unsigned long AAtime=0, BBtime=0;
	AAtime = getTickCount();

	//stitcher.stitch(vImg, vvRect, rImg);
	Stitcher::Status status = stitcher.stitch(vImg, rImg);

	BBtime = getTickCount();	
	printf("ProcessingTime %.2lf sec \n",  (BBtime - AAtime)/getTickFrequency() );

    if (Stitcher::OK == status) {
        cout << "Stitching Successful." << endl;
    } else {
        cout << "Stitching Failed." << endl;
    }


	imshow("Stitching Result", rImg);

	waitKey(0);

	imwrite("output.jpg", rImg);

    return 0;
}
	




