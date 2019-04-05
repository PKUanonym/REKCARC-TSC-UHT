#include "generator.h"
#include "delaunay.h"

//set voronoi output option
int Delaunay_Triangulation::VORONOI_CASE = 0;

/**
 * [Delaunay_Triangulation::Delaunay_Triangulation description]
 * @Author   n+e
 * @DateTime 2017-04-24
 * Calculate delaunay triangulation using CGAL library.
 */
Delaunay_Triangulation::Delaunay_Triangulation(const std::vector<Simple_Point> &_raw_data): raw_data(_raw_data)
{
    TIME_BEGIN("Calculating Delaunay triangulation using CGAL")
    int cnt = 0;
    for (auto i : raw_data)
        vertex.push_back(std::make_pair(Point(i.x, i.y), cnt++));
    graph.insert(vertex.begin(), vertex.end());
    TIME_END
}
/**
 * [Delaunay_Triangulation::Save description]
 * @Author   n+e
 * @DateTime 2017-04-23
 * Output the result into $(triangulation_filename).
 * If $(voronoi_case) then save voronoi diagram into $(voronoi_filename).
 */
void Delaunay_Triangulation::Save(const std::string triangulation_filename,
                                  const std::string voronoi_filename,
                                  std::vector<Edge> &triangulation_data,
                                  std::vector<std::pair<Simple_Point, Simple_Point> > &voronoi_data)
{
    std::string str = "Saving Delaunay triangulation to file \"" + triangulation_filename + "\"";
    TIME_BEGIN(str)
    std::ofstream output_triangulation;
    output_triangulation.open(triangulation_filename.c_str());
    output_triangulation << std::fixed << std::setprecision(Generator::POINTS_PRECISION);
    //iterate every face in triangulation and output three points' index (from 0 to n-1) in each face
    for (Delaunay::Finite_faces_iterator faces_iterator = graph.finite_faces_begin();
            faces_iterator != graph.finite_faces_end(); ++faces_iterator)
        for (int i = 0; i < 3; ++i)
        {
            output_triangulation << faces_iterator->vertex(i)->info() << " \n"[i == 2];
            triangulation_data.push_back(Edge(faces_iterator->vertex(i)->info(),
                                              faces_iterator->vertex((i + 1) % 3)->info(), raw_data));
        }
    std::sort(triangulation_data.begin(), triangulation_data.end());
    triangulation_data.erase(std::unique(triangulation_data.begin(),
                                         triangulation_data.end()),
                             triangulation_data.end());
    /*
      for (int i = 0; i < 3; ++i)
        output_triangulation << PRINT_POINT(faces_iterator->vertex(i)->point());
      output_triangulation << std::endl;
     */
    output_triangulation.close();
    TIME_END
    if (VORONOI_CASE | 1)
    {
        std::string str = "Saving Voronoi diagram to file \"" + voronoi_filename + "\"";
        TIME_BEGIN(str)
        std::ofstream output_voronoi;
        if (VORONOI_CASE != 0)
        {
            output_voronoi.open(voronoi_filename.c_str());
            output_voronoi << std::fixed << std::setprecision(Generator::POINTS_PRECISION);
        }
        //iterate every *dual* edge in triangulation and output all segments & rays
        for (Delaunay::Edge_iterator edge_iterator = graph.edges_begin();
                edge_iterator != graph.edges_end(); ++edge_iterator)
        {
            CGAL::Object dual_edge = graph.dual(edge_iterator);
            if (CGAL::object_cast<K::Segment_2>(&dual_edge))
            {
                if (VORONOI_CASE != 0)
                    output_voronoi << "F " << PRINT_POINT(CGAL::object_cast<K::Segment_2>(&dual_edge)->source())
                                   << PRINT_POINT(CGAL::object_cast<K::Segment_2>(&dual_edge)->target()) << std::endl;

                voronoi_data.push_back(std::make_pair(
                                           Simple_Point(
                                               CGAL::object_cast<K::Segment_2>(&dual_edge)->source().hx(),
                                               CGAL::object_cast<K::Segment_2>(&dual_edge)->source().hy()
                                           ),
                                           Simple_Point(
                                               CGAL::object_cast<K::Segment_2>(&dual_edge)->target().hx(),
                                               CGAL::object_cast<K::Segment_2>(&dual_edge)->target().hy()
                                           )
                                       ));

            }
            else if (CGAL::object_cast<K::Ray_2>(&dual_edge))
            {
                if (VORONOI_CASE != 0)
                    output_voronoi << "I " << PRINT_POINT(CGAL::object_cast<K::Ray_2>(&dual_edge)->source())
                                   << PRINT_POINT(CGAL::object_cast<K::Ray_2>(&dual_edge)->point(1)) << std::endl;

                voronoi_data.push_back(std::make_pair(
                                           Simple_Point(
                                               CGAL::object_cast<K::Ray_2>(&dual_edge)->source().hx(),
                                               CGAL::object_cast<K::Ray_2>(&dual_edge)->source().hy()
                                           ), Simple_Point(
                                               CGAL::object_cast<K::Ray_2>(&dual_edge)->point(1).hx(),
                                               CGAL::object_cast<K::Ray_2>(&dual_edge)->point(1).hy()
                                           )
                                       ));

            }
        }
        if (VORONOI_CASE != 0)
            output_voronoi.close();
        TIME_END
    }
}