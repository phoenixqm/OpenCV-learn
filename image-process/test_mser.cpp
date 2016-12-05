#include <opencv2/core.hpp>
#include <opencv2/features2d.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/opencv.hpp>
#include <opencv2/text.hpp>

using namespace std;
using namespace cv;

int main(int argc, char** argv)
{
    Mat inImg = imread(argv[1]);
    namedWindow("origin");
    imshow("origin", inImg);
    Mat textImg;
    cvtColor(inImg, textImg, CV_BGR2GRAY);

    //Extract MSER
    vector<vector<Point> > contours;
    vector<Rect> bboxes;
    Ptr<MSER> mser = MSER::create(21,
        (int)(0.00002 * textImg.cols * textImg.rows),
        (int)(0.05 * textImg.cols * textImg.rows),
        1, 0.7);

    mser->detectRegions(textImg, contours, bboxes);

    for (int i = 0; i < bboxes.size(); i++) {
        rectangle(inImg, bboxes[i], CV_RGB(0, 255, 0));
        // ellipse(inImg, bboxes[i], CV_RGB(0, 255, 0));
    }

    namedWindow("result");
    imshow("result", inImg);
    waitKey(0);
    return 0;
}