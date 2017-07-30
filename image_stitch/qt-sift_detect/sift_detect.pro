#-------------------------------------------------
#
# Project created by QtCreator 2012-08-16T16:32:35
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = sift_detect
TEMPLATE = app


SOURCES += \
    utils.c \
    imgfeatures.c \
    sift.c \
    main.cpp \
    siftdetect.cpp

HEADERS  += \
    imgfeatures.h \
    sift.h \
    siftdetect.h \
    utils.h

FORMS    += siftdetect.ui

INCLUDEPATH +=  C:\Qt\opencv2.4.2\build\include \
                C:\Qt\opencv2.4.2\build\include\opencv \
                C:\Qt\opencv2.4.2\build\include\opencv2

LIBS += C:\Qt\opencv2.4.2\build\x86\vc10\lib\opencv_core242d.lib    \
        C:\Qt\opencv2.4.2\build\x86\vc10\lib\opencv_highgui242d.lib  \
        C:\Qt\opencv2.4.2\build\x86\vc10\lib\opencv_imgproc242d.lib   \
        C:\Qt\opencv2.4.2\build\x86\vc10\lib\opencv_legacy242.lib     \
        C:\Qt\opencv2.4.2\build\x86\vc10\lib\opencv_flann242d.lib      \
        C:\Qt\opencv2.4.2\build\x86\vc10\lib\opencv_features2d242d.lib
