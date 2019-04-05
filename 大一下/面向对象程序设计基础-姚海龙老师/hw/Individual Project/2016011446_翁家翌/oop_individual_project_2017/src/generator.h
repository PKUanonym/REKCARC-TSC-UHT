#ifndef __GENERATOR_H__
#define __GENERATOR_H__

#include "conf.h"

class Generator
{
    std::vector<Simple_Point> list;

    //generate a float in [0,MAX_COORDINATE)
    ld Rand_in_coordinate_range();

    //Add new point to the list until the size is enough. Then sort the list of points.
    void Generate_points();

    //Check if minimum distance between each of two points is longer than $(MIN_DISTANCE).
    bool Validate();

public:
    //set the precision in saving data
    static int POINTS_PRECISION;

    //set the number of points to calculate
    static int TOTAL_NUMBER_OF_POINTS;

    //generate points in [0,MAX_COORDINATE)
    static int MAX_COORDINATE;

    //set the minimum distance between these points
    static ld MIN_DISTANCE;

    //set generate method
    static int METHOD_CASE;

    //Generate $(total_number_of_points) of points.
    Generator();

    //Save generated points into file $(filename) and return the vector of points.
    std::vector<Simple_Point> Save(const std::string &filename);
};

#endif