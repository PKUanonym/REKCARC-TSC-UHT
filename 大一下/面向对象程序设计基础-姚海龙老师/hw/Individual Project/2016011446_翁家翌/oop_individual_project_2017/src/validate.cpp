#include "validate.h"
/**
 * [My_Delaunay::Is_in_circle description]
 * @Author   n+e
 * @DateTime 2017-04-24
 * @return              [if x is in circle made up of point a,b,c]
 */
bool My_Delaunay::Is_in_circle(const Simple_Point &a, const Simple_Point &b,
                               const Simple_Point &c, const Simple_Point &x)
{
    Point3 aa(a), bb(b), cc(c), xx(x);
    if (Check(a, b, c) < 0) std::swap(bb, cc);
    return (Check(aa, bb, cc) | (xx - aa)) < 0;
}
/**
 * [My_Delaunay::Add_edge description]
 * @Author   n+e
 * @DateTime 2017-04-24
 * link x and y and save into the DCEL
 */
void My_Delaunay::Add_edge(int x, int y)
{
    ++total_edge;
    edge.push_back(DCEL(y, last[x]));
    edge[last[x]].right = total_edge;
    last[x] = total_edge;
    ++total_edge;
    edge.push_back(DCEL(x, last[y]));
    edge[last[y]].right = total_edge;
    last[y] = total_edge;
}
/**
 * [My_Delaunay::Delete_edge description]
 * @Author   n+e
 * @DateTime 2017-04-24
 * @param    x          [index of the DCEL]
 * remove edge[x] virtually
 */
void My_Delaunay::Delete_edge(int x)
{
    edge[edge[x].right].left = edge[x].left;
    edge[edge[x].left].right = edge[x].right;
    if (last[edge[x ^ 1].to] == x)
        last[edge[x ^ 1].to] = edge[x].left;
}
/**
 * [My_Delaunay::Triangulation description]
 * @Author   n+e
 * @DateTime 2017-04-24
 * Generating delaunay triangulation by divide and conquer algorithm.
 */
void My_Delaunay::Triangulation(int l, int r)
{
    //1~3 point -> link all of them
    if (r - l <= 2)
    {
        for (int i = l; i < r; ++i)
            for (int j = i + 1; j <= r; ++j)
                Add_edge(i, j);
        return;
    }
    int mid = l + r >> 1;
    Triangulation(l, mid);
    Triangulation(mid + 1, r);
    //calculate the lower convex hull
    std::vector<int>que;
    for (int i = l; i <= r; que.push_back(i++))
        while (que.size() > 1 && Check(points[que[que.size() - 2]], points[que[que.size() - 1]], points[i]) < 0)
            que.pop_back();
    int ld = 0, rd = 0;
    for (int i = 0; i < que.size() - 1 && !ld; ++i)
        if (que[i] <= mid && mid < que[i + 1])
            ld = que[i], rd = que[i + 1];
    //calculate the triangulation to merge answer
    //op = -1 : link left  (id~ld)
    //op =  1 : link right (id~rd)
    //op =  0 : nothing to do, all points are linked
    for (; Add_edge(ld, rd), 1;)
    {
        int id = 0, opt = 0;
        for (int i = last[ld]; i; i = edge[i].left)
            if (Check(points[ld], points[rd], points[edge[i].to]) > 0
                    && (id == 0 || Is_in_circle(points[ld], points[rd], points[id], points[edge[i].to])))
                opt = -1, id = edge[i].to;
        for (int i = last[rd]; i; i = edge[i].left)
            if (Check(points[rd], points[ld], points[edge[i].to]) < 0
                    && (id == 0 || Is_in_circle(points[ld], points[rd], points[id], points[edge[i].to])))
                opt = 1, id = edge[i].to;
        if (opt == 0)break;
        if (opt == -1)
        {
            for (int i = last[ld]; i; i = edge[i].left)
                if (Cross(points[rd], points[id], points[ld], points[edge[i].to]))
                {
                    Delete_edge(i);
                    Delete_edge(i ^ 1);
                    i = edge[i].right;
                }
            ld = id;
        }
        else
        {
            for (int i = last[rd]; i; i = edge[i].left)
                if (Cross(points[ld], points[id], points[rd], points[edge[i].to]))
                {
                    Delete_edge(i);
                    Delete_edge(i ^ 1);
                    i = edge[i].right;
                }
            rd = id;
        }
    }
}
My_Delaunay::My_Delaunay(std::vector<Simple_Point>data)
{
    TIME_BEGIN("Using my own delaunay for validation")
    //initialize from raw data
    total_edge = 1;
    edge.push_back(DCEL(0, 0));
    edge.push_back(DCEL(0, 0));
    points.push_back(Simple_Point());
    original_points.push_back(Point3());
    last.push_back(0);
    for (int i = 0; i < data.size(); ++i)
    {
        last.push_back(0);
        points.push_back(data[i]);
        original_points.push_back(Point3(data[i].x, data[i].y, i));
    }
    //calculate delaunay triangulation
    Triangulation(1, data.size());
    TIME_END
    std::vector<Edge>mst_edge;
    //calculate mst
    for (int i = 1; i <= data.size(); ++i)
        for (int j = last[i]; j; j = edge[j].left)
            mst_edge.push_back(Edge(original_points[i].z, original_points[edge[j].to].z, data));

    mst_edge.erase(std::unique(mst_edge.begin(), mst_edge.end()), mst_edge.end());
    MST val_mst(mst_edge);
}