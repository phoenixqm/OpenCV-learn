cmake_minimum_required(VERSION 2.8.11)

project(sift_stitch)

# Find includes in corresponding build directories
set(CMAKE_INCLUDE_CURRENT_DIR ON)
# Instruct CMake to run moc automatically when needed.
set(CMAKE_AUTOMOC ON)

set(CMAKE_AUTOUIC ON)

# Find the QtWidgets library
find_package(Qt5Core)
find_package(Qt5Gui)
find_package(Qt5Widgets)

find_package( OpenCV )
include_directories( ${OpenCV_INCLUDE_DIRS} )

# Tell CMake to create the executable
add_executable(sift_stitch main.cpp siftmatch.cpp utils.c sift.c imgfeatures.c kdtree.c minpq.c xform.c)

# Use the Widgets module from Qt 5.
target_link_libraries(sift_stitch Qt5::Core Qt5::Gui Qt5::Widgets)
target_link_libraries(sift_stitch ${OpenCV_LIBS} )
