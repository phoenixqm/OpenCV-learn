#include "siftmatch.h"
#include "ui_siftmatch.h"

#include <QtCore>
#include <QtGui>
#include <QFileDialog>

#include "imgfeatures.h"
#include "kdtree.h"
#include "minpq.h"
#include "sift.h"
#include "utils.h"
#include "xform.h"

/* the maximum number of keypoint NN candidates to check during BBF search */
#define KDTREE_BBF_MAX_NN_CHKS 200

/* threshold on squared ratio of distances between NN and 2nd NN */
#define NN_SQ_DIST_RATIO_THR 0.49

SiftMatch::SiftMatch(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::SiftMatch)
{    
    open_image_number = 0;
    m = 0;

    ui->setupUi(this);   
}

SiftMatch::~SiftMatch()
{
    delete ui;
}

void SiftMatch::on_openButton_clicked()
{
    QString img_name = QFileDialog::getOpenFileName(this, "Open Image", "..",
                                                    tr("Image Files(*.png *.jpeg *.jpg *.bmp)"));
    open_image_number++;

    if( 1 == open_image_number )
        {
            src1 = imread( img_name.toLatin1().data() );
            img1 = cvLoadImage( img_name.toLatin1().data() );

            imwrite( "../src1.jpg", src1 );
            // ui->textBrowser->setFixedSize( src1.cols, src1.rows );
            ui->textBrowser->append( "<img src=../src1.jpg>" );
         }

    else if( 2 == open_image_number )
        {
            src2 = imread( img_name.toLatin1().data() );
            img2 = cvLoadImage( img_name.toLatin1().data() );
            // img2 = &src2.operator IplImage(); not work in opencv 3
            imwrite( "../src2.jpg", src2 );
            // ui->textBrowser->setFixedSize( src2.cols+src1.cols, src2.rows+src1.rows );
            ui->textBrowser->append( "<img src=../src2.jpg>" );
        }
    else
        open_image_number = 0;

}

extern IplImage* stack_imgs( IplImage* img1, IplImage* img2 )  
{  
    IplImage* stacked = cvCreateImage( cvSize( MAX(img1->width, img2->width),  
                                        img1->height + img2->height ),  
                                        IPL_DEPTH_8U, 3 );  
  
    cvZero( stacked );  
    cvSetImageROI( stacked, cvRect( 0, 0, img1->width, img1->height ) );  
    cvAdd( img1, stacked, stacked, NULL );  
    cvSetImageROI( stacked, cvRect(0, img1->height, img2->width, img2->height) );  
    cvAdd( img2, stacked, stacked, NULL );  
    cvResetImageROI( stacked );  
  
    return stacked;  
}  


void SiftMatch::on_detectButton_clicked()
{

    stacked = stack_imgs( img1, img2 );
    ui->textBrowser->clear();

    n1 = sift_features( img1, &feat1 );
    draw_features( img1, feat1, n1 );
    // src1_c = Mat(img1);
    // imwrite("../src1_c.jpg", src1_c);
    cvSaveImage("../src1_c.jpg", img1);
    ui->textBrowser->append("<img src=../src1_c.jpg>");

    n2 = sift_features( img2, &feat2 );
    draw_features( img2, feat2, n2 );
    // src2_c = Mat(img2);
    // imwrite("../src2_c.jpg", src2_c);
    cvSaveImage("../src2_c.jpg", img2);
    ui->textBrowser->append("<img src=../src2_c.jpg>");
}

void SiftMatch::on_matchButton_clicked()
{
    kd_root = kdtree_build( feat2, n2 );
    for( i = 0; i < n1; i++ )
        {
            feat = feat1+i;
            k = kdtree_bbf_knn( kd_root, feat, 2, &nbrs, KDTREE_BBF_MAX_NN_CHKS );
            if( k == 2 )
                {
                    d0 = descr_dist_sq( feat, nbrs[0] );
                    d1 = descr_dist_sq( feat, nbrs[1] );
                    if( d0 < d1 * NN_SQ_DIST_RATIO_THR )
                        {
                            pt1 = Point( cvRound( feat->x ), cvRound( feat->y ) );
                            pt2 = Point( cvRound( nbrs[0]->x ), cvRound( nbrs[0]->y ) );
                            pt2.y += img1->height;
                            cvLine( stacked, pt1, pt2, CV_RGB(255,0,255), 1, 8, 0 );
                            m++;
                            feat1[i].fwd_match = nbrs[0];
                        }
                }
             free( nbrs );
         }
    // dst = Mat( stacked );
    // imwrite( "../dst.jpg", dst );
    cvSaveImage("../dst.jpg", stacked);
    ui->textBrowser->clear();
    // ui->textBrowser->setFixedSize( stacked->width, stacked->height );
    ui->textBrowser->append("<img src=../dst.jpg>");

}

void SiftMatch::on_closeButton_clicked()
{
    close();
}
