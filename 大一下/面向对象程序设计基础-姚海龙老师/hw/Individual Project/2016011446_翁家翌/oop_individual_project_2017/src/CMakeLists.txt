project( src_ )

cmake_minimum_required(VERSION 2.8.11)

if(CMAKE_COMPILER_IS_GNUCXX)
    add_definitions(-std=c++11)
    add_definitions(-O2)
endif()

find_package(OpenCV REQUIRED)
include_directories(${OpenCV_INCLUDE_DIRS})

find_package( Boost COMPONENTS program_options REQUIRED )
include_directories( ${Boost_INCLUDE_DIRS} )

find_package(CGAL QUIET COMPONENTS Core )
include( ${CGAL_USE_FILE} )

add_executable( main  main.cpp visualization.cpp conf.cpp delaunay.cpp generator.cpp minimum_spanning_tree.cpp union_find_set.cpp validate.cpp)

target_link_libraries(main ${OpenCV_LIBS})
#target_link_libraries(main ${CGAL_LIBRARIES} ${CGAL_3RD_PARTY_LIBRARIES} )
target_link_libraries( main ${Boost_LIBRARIES} )
