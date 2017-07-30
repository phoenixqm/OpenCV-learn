#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <iostream>

using namespace std;

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    mode_num = 1;
    times = 100;
    divide_width = 50;
    ui->textBrowser->setStyleSheet( QString::fromUtf8("background-color:black") );
    ui->textBrowser->setTextColor( Qt::green );
    ui->textBrowser->setFont( QFont("Times New Roman", 11) );
    ui->textBrowser->append( "Scan Mode-----Efficient_way......" );

    for( int i = 0; i <256; ++i )
    {
        table[i] = (i/divide_width)*divide_width;
    }

}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_closeButton_clicked()
{
    close();
}


void MainWindow::on_actionLUT_triggered(bool checked)
{
    ui->textBrowser->clear();
    mode_num = 4;
    if( checked )
    {
        ui->textBrowser->append( "Scan Mode-----LUT......" );
        ui->actionIterator->setChecked( 0 );
        ui->actionOn_the_fly->setChecked( 0 );
        ui->actionEfficient_way->setChecked( 0 );
    }
    else
        ui->textBrowser->append( "0" );
}

void MainWindow::on_actionOn_the_fly_triggered(bool checked)
{
    ui->textBrowser->clear();
    mode_num = 3;
    if( checked )
    {
        ui->textBrowser->append( "Scan Mode-----On_the_fly......" );
        ui->actionEfficient_way->setChecked( 0 );
        ui->actionIterator->setChecked( 0 );
        ui->actionLUT->setChecked( 0 );
    }
    else
        ui->textBrowser->append( "0" );
}

void MainWindow::on_actionIterator_triggered(bool checked)
{
    ui->textBrowser->clear();
    mode_num = 2;
    if( checked )
    {
        ui->textBrowser->append( "Scan Mode-----Iterator......" );
        ui->actionEfficient_way->setChecked( 0 );
        ui->actionOn_the_fly->setChecked( 0 );
        ui->actionLUT->setChecked( 0 );
    }
    else
        ui->textBrowser->append( "0" );
}

void MainWindow::on_actionEfficient_way_triggered(bool checked)
{
    ui->textBrowser->clear();
    mode_num = 1;
    if( checked )
    {
        ui->textBrowser->append( "Scan Mode-----Efficient_way......" );
        ui->actionIterator->setChecked( 0 );
        ui->actionOn_the_fly->setChecked( 0 );
        ui->actionLUT->setChecked( 0 );
    }
    else
        ui->textBrowser->append( "0" );
}

void MainWindow::on_openButton_clicked()
{
    //tr函数是用来实现国际化的，即软件以后翻译成其它语言时，会自动翻译成中文，这里其实是没有必要的
    QString img_mame = QFileDialog::getOpenFileName( this, "Open img", "../scan_img", tr("Image Files(*.png *.jpg *.bmp *.jpeg)") );
    img = imread( img_mame.toLatin1().data() );
    cvtColor( img, img, CV_BGR2RGB );
    QImage qimg = QImage( (const unsigned char*)(img.data), img.cols, img.rows, QImage::Format_RGB888 );
    ui->label->setPixmap( QPixmap::fromImage( qimg ) );
    cvtColor( img, img, CV_RGB2BGR );
}

void MainWindow::on_scanButton_clicked()
{
    ui->label->clear();//该句可以不用，因为下面的图片显示会自动覆盖

    //连续内存处理模式
    if( 1 == mode_num )
    {
        double t = (double)getTickCount();
        for( int i = 0; i < times; i++ )
        {
            Mat clone_I = img.clone();
            img_scan = MainWindow::efficient_way_scan( clone_I, table );
        }
        t = (double)(((getTickCount()-t)/getTickFrequency())*1000/times);//计算times次的平均时间
        ui->textBrowser->append( tr("the average time of scanning the image is : %1ms").arg( t ) );

        //显示像素压缩后图像
        cvtColor( img_scan, img_scan, CV_BGR2RGB );
        QImage qimg = QImage( (const unsigned char*)(img_scan.data), img_scan.cols, img_scan.rows, QImage::Format_RGB888 );
        ui->label->setPixmap( QPixmap::fromImage( qimg ) );
        cvtColor( img_scan, img_scan, CV_RGB2BGR );
    }

    //迭代器模式
    else if( 2 == mode_num )
    {
        double t = (double)getTickCount();
        for( int i = 0; i < times; i++ )
        {
            Mat clone_I = img.clone();
            img_scan = MainWindow::iterator_scan( clone_I, table );
        }
        t = (double)(((getTickCount()-t)/getTickFrequency())*1000/times);//计算times次的平均时间
        ui->textBrowser->append( tr("the average time of scanning the image is : %1ms").arg( t ) );

        //显示像素压缩后图像
        cvtColor( img_scan, img_scan, CV_BGR2RGB );
        QImage qimg = QImage( (const unsigned char*)(img_scan.data), img_scan.cols, img_scan.rows, QImage::Format_RGB888 );
        ui->label->setPixmap( QPixmap::fromImage( qimg ) );
        cvtColor( img_scan, img_scan, CV_RGB2BGR );
    }

    //单独扫描模式
    else if( 3 == mode_num )
    {
        double t = (double)getTickCount();
        for( int i = 0; i < times; i++ )
        {
            Mat clone_I = img.clone();
            img_scan = MainWindow::on_the_flay_way_scan( clone_I, table );
        }
        t = (double)(((getTickCount()-t)/getTickFrequency())*1000/times);//计算times次的平均时间
        ui->textBrowser->append( tr("the average time of scanning the image is : %1ms").arg( t ) );

        //显示像素压缩后图像
        cvtColor( img_scan, img_scan, CV_BGR2RGB );
        QImage qimg = QImage( (const unsigned char*)(img_scan.data), img_scan.cols, img_scan.rows, QImage::Format_RGB888 );
        ui->label->setPixmap( QPixmap::fromImage( qimg ) );
        cvtColor( img_scan, img_scan, CV_RGB2BGR );
    }

    //LUT模式
    else if( 4 == mode_num )
    {
        Mat lookup_table( 1, 256, CV_8U );
        uchar *p = lookup_table.data;//即使没有初始化也是有首地址的
        for( int i = 0; i < 256 ; i++ )
            {
                p[i] = table[i];
            }

        double t = (double)getTickCount();
        for( int j = 0; j < times; j++ )
            {
                LUT( img, lookup_table, img_scan );
            }
        t = (double)(((getTickCount()-t)/getTickFrequency())*1000/times);//计算times次的平均时间
        ui->textBrowser->append( tr("the average time of scanning the image is : %1ms").arg( t ) );

        //显示像素压缩后图像
        cvtColor( img_scan, img_scan, CV_BGR2RGB );
        QImage qimg = QImage( (const unsigned char*)(img_scan.data), img_scan.cols, img_scan.rows, QImage::Format_RGB888 );
        ui->label->setPixmap( QPixmap::fromImage( qimg ) );
        cvtColor( img_scan, img_scan, CV_RGB2BGR );
    }

}

void MainWindow::on_spinBox_editingFinished()
{
    divide_width = ui->spinBox->value();//获取spinBox里更改过的值
    for( int i = 0; i <256; ++i )
    {
        table[i] = (i/divide_width)*divide_width;//像素压缩过程
    }

}

//转换成一个长行后进行扫描，效率较高
 Mat& MainWindow::efficient_way_scan( Mat& I, const int* const table )
 {
     CV_Assert( I.depth() != sizeof( uchar ) );
     int channels = I.channels();
     int nRows = I.rows*channels;
     int nCols = I.cols;

     if( I.isContinuous() )
     {
        nCols *=nRows;//注意先后顺序
        nRows = 1;

     }

     uchar *p;
     for( int i = 0; i < nRows; ++i )
     {
        p =  I.ptr<uchar>(i);
        for( int j = 0; j < nCols; ++j )
            {
              p[j] = (uchar)table[p[j]];//像素压缩后
            }
     }

     return I;
 }

 //用迭代器进行扫描，比较安全
 Mat& MainWindow:: iterator_scan( Mat& I, const int* const table )
 {
     CV_Assert( I.depth() != sizeof(uchar) );
     int channels = I.channels();
     if ( 1 == channels )
         {
            MatIterator_<uchar> it = I.begin<uchar>(), end = I.end<uchar>();
            for( ; it != end; ++it )
                {
                    *it = table[*it];
                }
         }
     else if( 3 == channels )
         {
            MatIterator_<Vec3b>it = I.begin<Vec3b>(), end = I.end<Vec3b>();
            for( ; it != end; ++it )
                {
                    //3个通道时需分开进行，否则会自动跳过
                    //虽然实际的列数为其3倍(内存中的),但Mat实际上的cols并没有改变
                    (*it)[0] = table[(*it)[0]];
                    (*it)[1] = table[(*it)[1]];
                    (*it)[2] = table[(*it)[2]];
                }
         }
     return I;
 }


 //每个点进行访问，速度最慢
Mat& MainWindow:: on_the_flay_way_scan( Mat& I, const int* const table )
{
    CV_Assert( I.depth() != sizeof(uchar) );
    int cols = I.cols;
    int rows = I.rows;
    int channels = I.channels();

    switch( channels )
        {
            case 1:
            {
                for( int i = 0; i < rows; i++ )
                    for( int j = 0; j < cols; j++)
                    {
                          I.at<uchar>(i, j) = table[I.at<uchar>(i, j)];
                    }
                break;
            }
            case 3:
            {
                Mat_<Vec3b> _I = I;//下面的取元素操作可以少输入一些关键字
                for( int i = 0; i < rows; i++ )
                    for( int j = 0; j < cols; j++ )
                    {
                          _I(i, j)[0] = table[_I(i, j)[0]];
                          _I(i, j)[1] = table[_I(i, j)[1]];
                          _I(i, j)[2] = table[_I(i, j)[2]];
                    }
        break;
            }
            break;
        }

    return I;

}
