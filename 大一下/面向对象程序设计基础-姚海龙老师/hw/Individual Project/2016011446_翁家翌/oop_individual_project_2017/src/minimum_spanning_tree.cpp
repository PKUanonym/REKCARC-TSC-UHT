#include "generator.h"
#include "minimum_spanning_tree.h"

int MST::MST_PRECISION = 10;

/**
 * [MST::MST description]
 * @Author   n+e
 * @DateTime 2017-04-24
 * Using Kruskal algorithm to calculate minimum spanning tree.
 */
MST::MST(const std::vector<Edge> &_edge): edge(_edge)
{
    TIME_BEGIN("Calculating minimum spanning tree")
    std::sort(edge.begin(), edge.end());
    mst.clear();
    ld sum = 0;
    for (std::vector<Edge>::iterator i = edge.begin(); i != edge.end(); ++i)
        if (ufs.Is_linked((*i).x, (*i).y) == 0)
        {
            mst.push_back(*i);
            ufs.Link((*i).x, (*i).y);
            sum += (*i).v;
        }
    TIME_END
    std::cerr << "Total length of the MST edge:" << std::right << std::setw(23) << std::fixed << std::setprecision(MST_PRECISION) << sum << std::endl;
}
/**
 * [MST::Save description]
 * @Author   n+e
 * @DateTime 2017-04-24
 * Saving minimum spanning tree's infomation into file $(filename).
 */
std::vector<Edge> MST::Save(const std::string &filename)
{
    std::string str = "Saving minimum spanning tree's infomation into file \"" + filename + "\"";
    TIME_BEGIN(str)
    std::ofstream output;
    output.open(filename.c_str());
    for (std::vector<Edge>::iterator i = mst.begin(); i != mst.end(); ++i)
        output << (*i).x << " " << (*i).y << std::endl;
    output.close();
    TIME_END
    return mst;
}
/**
 * [Prim::Prim description]
 * @Author   n+e
 * @DateTime 2017-04-24
 * Using Prim algorithm to calculate minimum spanning tree.
 */
Prim::Prim(std::vector<Simple_Point>data)
{
    TIME_BEGIN("Using Prim algorithm for validation");
    if (data.size() > 20000)
    {
        std::cerr << "Points' number is too large to calculate!" << std::endl;
        return;
    }
    left.push_back(data.size());
    right.push_back(2);
    dist.push_back(0);
    for (int i = 1; i <= data.size(); i++)
    {
        left.push_back(i - 1);
        right.push_back(i + 1);
    }
    right[data.size()] = left[2] = 0;
    for (int i = 1; i <= data.size(); i++)
        dist.push_back(Edge(0, i - 1, data).v);
    for (int i = 2; i <= data.size(); i++)
    {
        int target = 0;
        ld now = Generator::MAX_COORDINATE * 100;
        for (int j = right[0]; j; j = right[j])
            if (dist[j] < now)
                now = dist[target = j];
        right[left[target]] = right[target];
        left[right[target]] = left[target];
        for (int j = right[0]; j; j = right[j])
            if (dist[j] > Edge(target - 1, j - 1, data).v)
                dist[j] = Edge(target - 1, j - 1, data).v;
    }
    ld sum = 0;
    for (int i = 1; i <= data.size(); i++)
        sum += dist[i];
    TIME_END
    std::cerr << "Total length of the MST edge:" << std::right << std::setw(23) << std::fixed << std::setprecision(MST::MST_PRECISION) << sum << std::endl;
}
