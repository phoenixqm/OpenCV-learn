#include <QApplication>
#include "siftmatch.h"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    SiftMatch w;
    w.show();
    
    return a.exec();
}
