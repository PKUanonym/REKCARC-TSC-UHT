#include "generator.h"
#include "delaunay.h"
#include "minimum_spanning_tree.h"
#include "validate.h"
#include "visualization.h"
#include <boost/program_options.hpp>

using namespace boost::program_options;

int main(int argc, char *argv[])
{
    //set generate option
    int GENERATE_CASE = 1;

    //set the filename to save these points' & graph's data
    std::string PREFIX, SUFFIX;
    std::string POINTS_FILENAME;
    std::string TRIANGULATION_FILENAME;
    std::string VORONOI_FILENAME;
    std::string MST_FILENAME;

    //save points into this container
    std::vector<Simple_Point> raw_data;

    //save trangulation information into this container
    std::vector<Edge> triangulation_data;

    //save voronoi diagram infomation into this container
    std::vector<std::pair<Simple_Point, Simple_Point> >voronoi_data;

    //save mst infomation into this container
    std::vector<Edge> mst_data;

    //read from command line
    try
    {
        options_description desc("Options");
        desc.add_options()
        ("help,h", "display this help and exit")
        ("number,n", value<int>(&Generator::TOTAL_NUMBER_OF_POINTS)->default_value(10000), "number of points")
        ("circle,c", "reset generation method to random in a circle, default: random in full square")
        ("test,t", value<std::string>(&PREFIX)->default_value("../../testcase/test/"), "test mode & set file path & read data from data.txt")
        ("range,r", value<int>(&Generator::MAX_COORDINATE)->default_value(10000), "coordinate range [0, number)")
        ("distance,d", value<ld>(&Generator::MIN_DISTANCE)->default_value(1e-3), "minimum distance between each pair of points")
        ("img-size,i", value<int>(&Visualization::IMAGE_SIZE)->default_value(2000), "size of image")
        ("suffix,s", value<std::string>(&SUFFIX)->default_value("png"), "set the suffix of output image")
        ("window,w", "display the window")
        ("voronoi,v", "output voronoi diagram infomation");

        variables_map vm;
        store(parse_command_line(argc, argv, desc), vm);
        notify(vm);

        if (vm.count("help"))
        {
            std::cout << "Delaunay triangulation for calculating Euclidean distance minimum spanning tree" << std::endl;
            std::cout << "Made by n+e\t2017-04" << std::endl;
            std::cout << std::endl;
            std::cout << desc << std::endl;
            std::cout << "Examples:" << std::endl;
            std::cout << "Generate new testcase in default file path, 10 points in [0,10), save in jpg file, and show window:" << std::endl;
            std::cout << "\t./main -n 10 -r 10 -s jpg -w" << std::endl;
            std::cout << "Use circle-shape testcase in file \"../../testcase/circle_100000/\" and output voronoi message:" << std::endl;
            std::cout << "\t./main -t ../../testcase/circle_100000/ -v" << std::endl << std::endl;
            return 0;
        }
        if (Generator::TOTAL_NUMBER_OF_POINTS <= 0 || Generator::TOTAL_NUMBER_OF_POINTS >= 5000000)
        {
            std::cerr << "Number of points is invalid!" << std::endl;
            return 1;
        }
        if (Visualization::IMAGE_SIZE <= 0 || Visualization::IMAGE_SIZE > 5000)
        {
            std::cerr << "Size of image is invalid!" << std::endl;
            return 1;
        }
        if (Generator::MAX_COORDINATE <= 1)
        {
            std::cerr << "max coordinate is invalid!" << std::endl;
            return 1;
        }
        if (Generator::MIN_DISTANCE <= 0)
        {
            std::cerr << "min distance is invalid!" << std::endl;
            return 1;
        }
        if (vm.count("circle"))
            Generator::METHOD_CASE = 1;
        if (vm.count("voronoi"))
            Delaunay_Triangulation::VORONOI_CASE = 1;
        if (PREFIX != "../../testcase/test/")
        {
            GENERATE_CASE = 0;
            if (PREFIX[PREFIX.length() - 1] != '/')
                PREFIX += '/';
        }
        POINTS_FILENAME = PREFIX + "data.txt";
        TRIANGULATION_FILENAME = PREFIX + "triangulation.txt";
        VORONOI_FILENAME = PREFIX + "voronoi.txt";
        MST_FILENAME = PREFIX + "mst.txt";

        //generate data
        if (GENERATE_CASE != 0)
            raw_data = Generator().Save(POINTS_FILENAME);
        else
        {
            TIME_BEGIN("Read data from data.txt")
            std::ifstream in;
            in.open(POINTS_FILENAME.c_str());
            ld x, y;
            Generator::MAX_COORDINATE = 0;
            while (in >> x >> y)
            {
                raw_data.push_back(Simple_Point(x, y));
                if (Generator::MAX_COORDINATE < x)Generator::MAX_COORDINATE = x;
                if (Generator::MAX_COORDINATE < y)Generator::MAX_COORDINATE = y;
            }
            std::sort(raw_data.begin(), raw_data.end());
            Generator::TOTAL_NUMBER_OF_POINTS = raw_data.size();
            in.close();
            TIME_END
        }
        //calculate triangulation using CGAL library
        Delaunay_Triangulation cgal_dt(raw_data);
        cgal_dt.Save(TRIANGULATION_FILENAME, VORONOI_FILENAME, triangulation_data, voronoi_data);
        //calculate mst with kruskal
        MST mymst(triangulation_data);
        mst_data = mymst.Save(MST_FILENAME);
        //check delaunay triangulation
        My_Delaunay myd(raw_data);
        //check mst with prim
        Prim prim(raw_data);
        //visualize the result
        Visualization visual(vm.count("window"), PREFIX, SUFFIX, raw_data, triangulation_data, voronoi_data, mst_data);
    }
    catch (const error &e)
    {
        std::cerr << e.what() << std::endl;
        return 1;
    }
    return 0;
}
