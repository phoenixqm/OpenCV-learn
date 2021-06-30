
#include <iostream>

#include <opencv2/opencv.hpp>

int main(int argc, char** argv)
{
	cv::namedWindow("ex2-3", cv::WINDOW_AUTOSIZE);
	cv::VideoCapture cap;
	cap.open(std::string(argv[1]));

	cv::Mat frame;
	while(true) {
		cap >> frame;
		if (frame.empty()) {
			break;
		}
		cv::imshow("Demo Video", frame);
		if (cv::waitKey(33) >= 0) {
			break;
		}
	}

	return 0;
}

