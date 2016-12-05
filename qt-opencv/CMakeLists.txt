cmake_minimum_required(VERSION 2.8.11)

project(test_Mat)

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

# Tell CMake to create the helloworld executable
# add_executable(helloworld hello.cpp)
add_executable(test_Mat main.cpp mainwindow.cpp)

# Use the Widgets module from Qt 5.
target_link_libraries(test_Mat Qt5::Core Qt5::Gui Qt5::Widgets)
target_link_libraries(test_Mat ${OpenCV_LIBS} )