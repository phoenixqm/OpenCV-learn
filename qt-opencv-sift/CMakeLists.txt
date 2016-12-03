cmake_minimum_required(VERSION 2.8.11)

project(testproject)

# Find includes in corresponding build directories
set(CMAKE_INCLUDE_CURRENT_DIR ON)
# Instruct CMake to run moc automatically when needed.
set(CMAKE_AUTOMOC ON)

# Find the QtWidgets library
find_package(Qt5Core)
find_package(Qt5Gui)
find_package(Qt5Widgets)

find_package( OpenCV )
include_directories( ${OpenCV_INCLUDE_DIRS} )

# Tell CMake to create the helloworld executable
add_executable(helloworld main.cpp)

# Use the Widgets module from Qt 5.
target_link_libraries(helloworld Qt5::Core Qt5::Gui Qt5::Widgets)
target_link_libraries(helloworld ${OpenCV_LIBS} )