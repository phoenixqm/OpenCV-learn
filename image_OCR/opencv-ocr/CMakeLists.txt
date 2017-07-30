cmake_minimum_required(VERSION 2.8)
project( segmented_word_recognition )


find_package( OpenCV REQUIRED )

#set(OpenCV_LIBS_DIR "/Users/qiming/Visualization/opencv/staticlib/lib")
#link_directories(${OpenCV_LIBS_DIR})

add_executable(character_recognition character_recognition.cpp )
add_executable(cropped_word_recognition cropped_word_recognition.cpp )
add_executable(end_to_end_recognition end_to_end_recognition.cpp )
add_executable(segmented_word_recognition segmented_word_recognition.cpp )
add_executable(textdetection textdetection.cpp )
add_executable(webcam_demo webcam_demo.cpp )

#set(OpenCV_LIBS opencv_core opencv_imgproc opencv_text opencv_highgui opencv_objdetect )

target_link_libraries(  character_recognition ${OpenCV_LIBS} )
target_link_libraries( cropped_word_recognition ${OpenCV_LIBS} )
target_link_libraries( end_to_end_recognition ${OpenCV_LIBS} )
target_link_libraries( textdetection ${OpenCV_LIBS} )
target_link_libraries( segmented_word_recognition ${OpenCV_LIBS} )
target_link_libraries( webcam_demo ${OpenCV_LIBS} )
