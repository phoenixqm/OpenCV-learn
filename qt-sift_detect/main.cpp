

#include <QApplication>
#include "siftdetect.h"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    SiftDetect w;
    w.show();
    
    return a.exec();
}
