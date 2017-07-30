#ifndef SIFTMATCH_H
#define SIFTMATCH_H

#include <QDialog>
// #include <opencv/cv.h>
// #include <opencv/cxcore.h>
// #include <opencv/highgui.h>
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

    void CalcFourCorner();  //计算图2的四个角经过矩阵H变换后的坐标
    
private slots:
    void on_openButton_clicked();

    void on_detectButton_clicked();

    void on_matchButton_clicked();

    void on_restartButton_clicked();

    void on_mosaicButton_clicked();

private:
    Ui::SiftMatch *ui;

    int open_image_number;          //打开图片的个数
    QString name1,name2;            //打开图片的文件名
    IplImage *img1, *img2;          //IplImage格式的原图
    IplImage *img1_Feat, *img2_Feat;//画上特征之后的图

    bool verticalStackFlag;         //显示结果的时候是否纵向排列
    IplImage *stacked;              //经过距离比值筛选后的匹配结果
    IplImage *stacked_ransac;       //经RANSAC算法筛选之后的结果

    struct feature *feat1, *feat2;  //特征点数组
    int n1, n2;                     //特征点个数
    struct feature *feat;           //特征点的指针
    struct kd_node *kd_root;        //kdtree的哏
    struct feature **nbrs;          //当前点最近邻数组

    CvMat * H;                      //RANSAC算法求出的变换矩阵
    struct feature **inliers;       //经RANSAC算法筛选之后的内点数组
    int n_inliers;                  //经RANSAC算法筛选之后的内点个数

    IplImage *xformed;              //临时拼接图，只将图2变换后的图
    IplImage *xformed_simple;       //简易拼接图
    IplImage *xformed_proc;         //处理后的拼接图

//    int img1LeftBound;            //匹配点外接举行的左右边界
//    int img1RightBound;           //
//    int img2LeftBound;            //
//    int img2RightBound;           //

    //图2的四个角经过矩阵H变换后的坐标
    CvPoint leftTop,leftBottom,rightTop,rightBottom;


};

#endif // SIFTMATCH_H
