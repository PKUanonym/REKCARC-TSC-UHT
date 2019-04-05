#ifndef __VIS_H__
#define __VIS_H__

#include "conf.h"
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

class Visualization
{
    cv::Mat point_m, voronoi_m, delaunay_m, graph_m, mst_m, mst_small_m;
    double scale;
    std::vector<Simple_Point> data;

    //draw point in pic
    void Draw_point(cv::Mat &pic, Simple_Point p, cv::Scalar col);

    //draw line in pic
    void Draw_line(cv::Mat &pic, Simple_Point p0, Simple_Point p1, cv::Scalar col);

    //draw points in point_m,graph_m and voronoi_m
    void Save_points_image(const std::vector<Simple_Point> &raw_data);

    //draw the triangulation in delaunay_m and graph_m
    void Save_delaunay_image(const std::vector<Simple_Point> &raw_data, const std::vector<Edge> &triangulation_data);

    //draw voronoi diagram in voronoi_m and graph_m
    void Save_voronoi_image(const std::vector<std::pair<Simple_Point, Simple_Point> > &voronoi_data);

    //draw mst in mst_m
    void Save_mst_image(const std::vector<Simple_Point> &raw_data, const std::vector<Edge> &mst_data);
public:
    //set the output image size
    static int IMAGE_SIZE;

    //draw all of images and save them
    Visualization(int show_case,
                  const std::string &prefix,
                  const std::string &suffix,
                  const std::vector<Simple_Point> &raw_data,
                  const std::vector<Edge> &triangulation_data,
                  const std::vector<std::pair<Simple_Point, Simple_Point> > &voronoi_data,
                  const std::vector<Edge> &mst_data);
};

#endif