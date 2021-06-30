
#include <iostream>

#include <opencv2/opencv.hpp>

int main(int argc, char** argv)
{
	cv::Mat img = cv::imread(argv[1], -1);
	if (img.empty()) {
		return -1;
	}
	cv::namedWindow("ex2-1", cv::WINDOW_AUTOSIZE);
	cv::imshow("Demo Image", img);
	cv::waitKey(0);
	cv::destroyWindow("ex2-1");
	return 0;
}

