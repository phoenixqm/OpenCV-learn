#ifndef SIFTDETECT_H
#define SIFTDETECT_H

#include <QDialog>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
//#include <opencv/cxcore.h>
//#include <opencv/highgui.h>
//#include <opencv/imgproc.h>
#include <stdio.h>
#include <stdio.h>
#include "sift.h"
#include "imgfeatures.h"
#include "utils.h"


using namespace cv;

namespace Ui {
class SiftDetect;
}

class SiftDetect : public QDialog
{
    Q_OBJECT
    
public:
    explicit SiftDetect(QWidget *parent = 0);
    ~SiftDetect();
    
private slots:


    void on_openButton_clicked();

    void on_detectButton_clicked();

    void on_closeButton_clicked();

private:
    Ui::SiftDetect *ui;

    Mat src, dst;
    IplImage* img;
    struct  feature* features;
    int n;
    int display;
    int intvls;
    double sigma;
    double contr_thr;
    int curv_thr;
    int img_dbl;
    int descr_width;
    int descr_hist_bins;
};

#endif // SIFTDETECT_H
