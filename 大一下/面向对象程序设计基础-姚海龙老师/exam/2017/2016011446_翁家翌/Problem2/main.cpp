#include "lcs.h"
#include "lcst.h"
#include "lcsts.h"

int main(int argc, char const *argv[])
{
    char X_[] = "AGGTAB";
    char Y_[] = "GXTXAYB";
    LCS test1;
    test1.lcs(X_, Y_);

    int XI[] = {10, 20, 30, 40, 50, 60, 70, 80, 90, 100};
    int YI[] = {20, 40, 60, 80, 101};
    LCST<int>test2;
    test2.lcs(XI, YI, 10, 5, XI, YI);

    char X[] = "AGGTACGGC";
    char Y[] = "GGCCTGCG";
    LCSTS test3;
    std::cout<<test3.lcs(X, Y, LCSTS::pred1)*1000<<"ms\n";
    std::cout<<test3.lcs(X, Y, LCSTS::pred2)*1000<<"ms\n";

    std::string ranX,ranY;
    srand(time(0));
    for(int i=1;i<=1000;++i)
    	ranX+="ATGC"[rand()&3],
    	ranY+="ATGC"[rand()&3];

    return 0;
}