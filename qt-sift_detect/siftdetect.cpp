
#include <cstdio>

#include <QtGui>
#include <QtCore>
#include <QFileDialog>

#include "opencv2/imgproc/imgproc_c.h"
#include "opencv2/videoio/videoio_c.h"
#include "opencv2/highgui/highgui_c.h"
#include "opencv2/core/utility.hpp"
#include <opencv2/core/types_c.h>

#include "siftdetect.h"
#include "ui_siftdetect.h"
#include "sift.h"
#include "imgfeatures.h"
#include "utils.h"


SiftDetect::SiftDetect(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::SiftDetect)
{
    ui->setupUi(this);

    n = 0;
    display = 1;
    intvls = SIFT_INTVLS;
    sigma = SIFT_SIGMA;
    contr_thr = SIFT_CONTR_THR;
    curv_thr = SIFT_CURV_THR;
    img_dbl = SIFT_IMG_DBL;
    descr_width = SIFT_DESCR_WIDTH;
    descr_hist_bins = SIFT_DESCR_HIST_BINS;
}

SiftDetect::~SiftDetect()
{
    cvReleaseImage( &img );
    
    delete ui;
}



void SiftDetect::on_openButton_clicked()
{
    // QStringList files = QFileDialog::getOpenFileNames(
    //                     this,
    //                     "Select one or more files to open",
    //                     "/home",
    //                     "Images (*.png *.xpm *.jpg)");

    QString img_name = QFileDialog::getOpenFileName(this, "Open Image", QDir::homePath(),
                                                    tr("Image Files(*.png *.jpeg *.jpg *.bmp)"));


    printf("%s\n", img_name.toLatin1().data());    fclose (stdout);

    // src = imread( img_name.toLatin1().data() );
    img = cvLoadImage(img_name.toLatin1().data(), 1);


    cvSaveImage( "../src.jpg", img );
    // imwrite( "../src.jpg", src );
    ui->textBrowser->clear();
    ui->textBrowser->setFixedSize( img->width, img->height );
    ui->textBrowser->append( "<img src=../src.jpg>" );

}

void SiftDetect::on_detectButton_clicked()
{

    n = _sift_features( img, &features, intvls, sigma, contr_thr, curv_thr, img_dbl, descr_width, descr_hist_bins );
    if ( display )
    {
        draw_features( img, features, n );
        ui->textBrowser->clear();

        cvSaveImage( "../dst.jpg", img );
        ui->textBrowser->append( "<img src=../dst.jpg>" );
    }
}

void SiftDetect::on_closeButton_clicked()
{
    close();
}


