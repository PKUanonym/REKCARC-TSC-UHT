#include "generator.h"
#include "visualization.h"

int Visualization::IMAGE_SIZE;

/**
 * [Visualization::Draw_point description]
 * @Author   n+e
 * @DateTime 2017-04-26
 * @param    pic        [draw point in this container]
 * @param    p          [point's location]
 * @param    col        [point's color]
 */
void Visualization::Draw_point(cv::Mat &pic, Simple_Point p, cv::Scalar col)
{
    cv::Point tmp(p.x * scale, p.y * scale);
    cv::circle(pic, tmp, std::max(1, int(6 - log(data.size()) / log(10))), col, CV_FILLED);
}
/**
 * [Visualization::Draw_line description]
 * @Author   n+e
 * @DateTime 2017-04-26
 * @param    pic        [draw line in this container]
 * @param    p0,p1      [two ends of the segment]
 * @param    col        [segment's color]
 */
void Visualization::Draw_line(cv::Mat &pic, Simple_Point p0, Simple_Point p1, cv::Scalar col)
{
    if (data.size() > 100 && Get_distance(p0, p1) > Generator::MAX_COORDINATE * 5)
        return;
    cv::Point tmp0(p0.x * scale, p0.y * scale);
    cv::Point tmp1(p1.x * scale, p1.y * scale);
    cv::line(pic, tmp0, tmp1, col, 2);
}
/**
 * [Visualization::Save_points_image description]
 * @Author   n+e
 * @DateTime 2017-04-26
 * draw points in point_m,graph_m and voronoi_m
 */
void Visualization::Save_points_image(const std::vector<Simple_Point> &raw_data)
{
    cv::Scalar col(200, 0, 0);
    for (auto i : raw_data)
    {
        Draw_point(point_m, i, col);
        Draw_point(graph_m, i, col);
        Draw_point(voronoi_m, i, col);
        Draw_point(mst_m, i, col);
    }
}
/**
 * [Visualization::Save_delaunay_image description]
 * @Author   n+e
 * @DateTime 2017-04-26
 * draw the triangulation in delaunay_m and graph_m
 */
void Visualization::Save_delaunay_image(const std::vector<Simple_Point> &raw_data, const std::vector<Edge> &triangulation_data)
{
    cv::Scalar col(200, 200, 0);
    for (auto i : triangulation_data)
    {
        Draw_line(delaunay_m, raw_data[i.x], raw_data[i.y], col);
        Draw_line(graph_m, raw_data[i.x], raw_data[i.y], col);
        //      Draw_line(mst_m, raw_data[i.x], raw_data[i.y], col);
    }
}
/**
 * [Visualization::Save_voronoi_image description]
 * @Author   n+e
 * @DateTime 2017-04-26
 * draw voronoi diagram in voronoi_m and graph_m
 */
void Visualization::Save_voronoi_image(const std::vector<std::pair<Simple_Point, Simple_Point> > &voronoi_data)
{
    cv::Scalar col(0, 200, 0);
    for (auto i : voronoi_data)
    {
        Draw_line(voronoi_m, i.first, i.second, col);
        Draw_line(graph_m, i.first, i.second, col);
    }
}
/**
 * [Visualization::Save_mst_image description]
 * @Author   n+e
 * @DateTime 2017-04-26
 * draw mst in mst_m
 */
void Visualization::Save_mst_image(const std::vector<Simple_Point> &raw_data, const std::vector<Edge> &mst_data)
{
    cv::Scalar col(200, 200, 0);
    for (auto i : mst_data)
    {
        Draw_line(mst_m, raw_data[i.x], raw_data[i.y], col);
    }
}
/**
 * [Visualization::Visualization description]
 * @Author   n+e
 * @DateTime 2017-04-26
 * draw all of images and save them
 */
Visualization::Visualization(int show_case,
                             const std::string &prefix,
                             const std::string &suffix,
                             const std::vector<Simple_Point> &raw_data,
                             const std::vector<Edge> &triangulation_data,
                             const std::vector<std::pair<Simple_Point, Simple_Point> > &voronoi_data,
                             const std::vector<Edge> &mst_data): data(raw_data),
    point_m(IMAGE_SIZE, IMAGE_SIZE, CV_8UC3, cv::Scalar(255, 255, 255)),
    graph_m(IMAGE_SIZE, IMAGE_SIZE, CV_8UC3, cv::Scalar(255, 255, 255)),
    mst_m(IMAGE_SIZE, IMAGE_SIZE, CV_8UC3, cv::Scalar(255, 255, 255)),
    delaunay_m(IMAGE_SIZE, IMAGE_SIZE, CV_8UC3, cv::Scalar(255, 255, 255)),
    voronoi_m(IMAGE_SIZE, IMAGE_SIZE, CV_8UC3, cv::Scalar(255, 255, 255))
{
    TIME_BEGIN("Generating pictures")
    scale = 1.*IMAGE_SIZE / Generator::MAX_COORDINATE;
    Save_points_image(raw_data);
    Save_delaunay_image(raw_data, triangulation_data);
    Save_voronoi_image(voronoi_data);
    Save_mst_image(raw_data, mst_data);
    if (data.size() >= 10000)
    {
        std::cerr << "Points' number is too large to generate images!" << std::endl;
    }
    else
    {
        cv::imwrite(prefix + "point." + suffix, point_m);
        cv::imwrite(prefix + "graph." + suffix, graph_m);
        cv::imwrite(prefix + "delaunay." + suffix, delaunay_m);
        cv::imwrite(prefix + "voronoi." + suffix, voronoi_m);
        cv::imwrite(prefix + "mst." + suffix, mst_m);
        TIME_END
    }
    if (show_case)
    {
        cv::resize(mst_m, mst_small_m, cv::Size(666, 666), 0, 0, CV_INTER_LINEAR);
        cv::namedWindow("MST", CV_WINDOW_AUTOSIZE);
        cv::imshow("MST", mst_small_m);
        cv::waitKey(0);
    }
}