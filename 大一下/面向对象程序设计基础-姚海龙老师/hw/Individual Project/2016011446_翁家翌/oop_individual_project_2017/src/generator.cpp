#include "generator.h"

int Generator::METHOD_CASE = 0;
int Generator::TOTAL_NUMBER_OF_POINTS;
int Generator::MAX_COORDINATE;
int Generator::POINTS_PRECISION = 10;
ld Generator::MIN_DISTANCE;

/**
 * [Generator::Rand_in_coordinate_range description]
 * @Author   n+e
 * @DateTime 2017-04-23
 * @return   [a float in [0,MAX_COORDINATE) ]
 */
ld Generator::Rand_in_coordinate_range()
{
    return rand() % (MAX_COORDINATE - 1) + 1.*rand() / RAND_MAX;
}
/**
 * [Generator::Generate_points description]
 * @Author   n+e
 * @DateTime 2017-04-25
 * Add new point to the list until the size is enough.
 * Then sort the list of points.
 */
void Generator::Generate_points()
{
    while (list.size() < TOTAL_NUMBER_OF_POINTS)
    {
        Simple_Point tmp;
        switch (METHOD_CASE)
        {
        case 0://random in full square
        {
            tmp = Simple_Point(Rand_in_coordinate_range(), Rand_in_coordinate_range());
            break;
        }
        /*  case 1://random in the edge of square
            {
                int flag = rand() & 3;
                ld x = Rand_in_coordinate_range();
                if (flag == 0)tmp = Simple_Point(0, x);
                else if (flag == 1)tmp = Simple_Point(x, 0);
                else if (flag == 2)tmp = Simple_Point(MAX_COORDINATE, x);
                else tmp = Simple_Point(x, MAX_COORDINATE);
                break;
            }
            case 3://random in the edge of circle
            {
                ld x=2.*rand()/RAND_MAX*acos(-1);
                tmp=Simple_Point(MAX_COORDINATE/2+MAX_COORDINATE/2*cos(x),MAX_COORDINATE/2+MAX_COORDINATE/2*sin(x));
                break;
            }
        */
        default://random in a circle
        {
            do
            {
                tmp = Simple_Point(Rand_in_coordinate_range(), Rand_in_coordinate_range());
            }
            while (Get_distance(tmp, Simple_Point(MAX_COORDINATE / 2, MAX_COORDINATE / 2)) >= MAX_COORDINATE / 2);
            break;
        }
        }
        list.push_back(tmp);
    }
    std::sort(list.begin(), list.end());
}
/**
 * [Generator::Validate description]
 * @Author   n+e
 * @DateTime 2017-04-23
 * Check if minimum distance between each of two points is longer than $(MIN_DISTANCE).
 * If one point passes the test, then add it to the new list.
 */
bool Generator::Validate()
{
    std::vector<Simple_Point> new_list;
    for (std::vector<Simple_Point>::iterator i = list.begin(); i != list.end(); ++i)
    {
        bool preservation = 1;
        for (std::vector<Simple_Point>::iterator j = i + 1; preservation
                && j != list.end() && (*j).x - (*i).x < MIN_DISTANCE; ++j)
            if (Get_distance(*i, *j) < MIN_DISTANCE)
                preservation = 0;
        if (preservation)
            new_list.push_back(*i);
    }
    list = new_list;
    return list.size() == TOTAL_NUMBER_OF_POINTS;
}
/**
 * [Generator::Generator description]
 * @Author   n+e
 * @DateTime 2017-04-23
 * Generate $(total_number_of_points) of points.
 */
Generator::Generator()
{
    char str_tmp[100] = "";
    sprintf(str_tmp, "Generating %d points in [0, %d)", TOTAL_NUMBER_OF_POINTS, MAX_COORDINATE);
    TIME_BEGIN(str_tmp)
    srand(time(0));
    //generate points until passing the checker
    do
    {
        Generate_points();
    }
    while (Validate() == 0);
    TIME_END
}
/**
 * [Generator::Save description]
 * @Author   n+e
 * @DateTime 2017-04-24
 * Save generated points into file $(filename).
 */
std::vector<Simple_Point> Generator::Save(const std::string &filename)
{
    std::string str = "Saving data to file \"" + filename + "\"";
    TIME_BEGIN(str)
    std::ofstream output;
    output.open(filename.c_str());
    output << std::fixed << std::setprecision(POINTS_PRECISION);
    for (std::vector<Simple_Point>::iterator i = list.begin(); i != list.end(); ++i)
        output << (*i).x << " " << (*i).y << std::endl;
    output.close();
    TIME_END
    return list;
}