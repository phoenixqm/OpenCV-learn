#ifndef SIFTMATCH_H
#define SIFTMATCH_H

#include <QDialog>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

using namespace cv;

namespace Ui {
class SiftMatch;
}

class SiftMatch : public QDialog
{
    Q_OBJECT
    
public:
    explicit SiftMatch(QWidget *parent = 0);
    ~SiftMatch();
    
private slots:
    void on_openButton_clicked();

    void on_detectButton_clicked();

    void on_matchButton_clicked();

    void on_closeButton_clicked();

private:
    Ui::SiftMatch *ui;
    Mat src1, src2, src1_c, src2_c, dst;
    IplImage *img1, *img2, *img3, *stacked;
    Point pt1, pt2;
    double d0, d1;
    struct feature *feat1, *feat2, *feat;
    struct feature **nbrs;
    struct kd_node *kd_root;
    int open_image_number;
    int n1, n2, k, i, m;
};

#endif // SIFTMATCH_H
