#ifndef __DELAUNAY_H__
#define __DELAUNAY_H__

#include "conf.h"
#include <CGAL/Exact_predicates_inexact_constructions_kernel.h>
#include <CGAL/Projection_traits_xy_3.h>
#include <CGAL/Delaunay_triangulation_2.h>
#include <CGAL/Triangulation_vertex_base_with_info_2.h>

typedef CGAL::Exact_predicates_inexact_constructions_kernel         K;
typedef CGAL::Triangulation_vertex_base_with_info_2<unsigned, K>    Vb;
typedef CGAL::Triangulation_data_structure_2<Vb>                    Tds;
typedef CGAL::Delaunay_triangulation_2<K, Tds>                      Delaunay;
typedef Delaunay::Point                                             Point;

#define PRINT_POINT(info) "(" << info.hx() << "," << info.hy() << ")\t"

class Delaunay_Triangulation
{
    //add label to all of these points in 'unsigned'
    std::vector<std::pair<Point, unsigned> >vertex;
    Delaunay graph;
    std::vector<Simple_Point>raw_data;
public:
    //set voronoi output option
    static int VORONOI_CASE;

    //Calculate delaunay triangulation using CGAL library
    Delaunay_Triangulation(const std::vector<Simple_Point> &raw_data);

    //Output the result into $(triangulation_filename)
    void Save(const std::string triangulation_filename,
              const std::string voronoi_filename,
              std::vector<Edge> &triangulation_data,
              std::vector<std::pair<Simple_Point, Simple_Point> > &voronoi_data);
};

#endif