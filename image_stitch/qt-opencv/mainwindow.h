#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QFileDialog>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>

using namespace cv;

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT
    
public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

     int table[256];
    
private slots:
    void on_closeButton_clicked();

    void on_actionOn_the_fly_triggered(bool checked);

    void on_actionLUT_triggered(bool checked);

    void on_actionIterator_triggered(bool checked);

    void on_actionEfficient_way_triggered(bool checked);

    void on_openButton_clicked();

    void on_scanButton_clicked();

    void on_spinBox_editingFinished();

private:
    Ui::MainWindow *ui;

    int mode_num;
    int divide_width;

    int times;
    Mat img, img_scan;
    Mat& efficient_way_scan( Mat& I, const int* const table );
    Mat& iterator_scan( Mat& I, const int* const table );
    Mat& on_the_flay_way_scan( Mat& I, const int* const table );
//    Mat& lut_way_scan( Mat& I, const unchar* const table );
};

#endif // MAINWINDOW_H
