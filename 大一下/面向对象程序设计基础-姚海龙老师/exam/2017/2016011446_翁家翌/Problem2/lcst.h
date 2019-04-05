#ifndef __LCST_H__
#define __LCST_H__

#include <iostream>
#include <cstring>
#include <cstdlib>

template<class T=char>
class LCST
{
public:
    void lcs(T *X, T *Y, int m, int n, T *x, T *y)
    {
        int L[m + 1][n + 1];

        /* Following steps build L[m+1][n+1] in bottom up fashion. Note
           that L[i][j] contains length of LCS of X[0..i-1] and Y[0..j-1] */
        for (int i = 0; i <= m; i++)
        {
            for (int j = 0; j <= n; j++)
            {
                if (i == 0 || j == 0)
                    L[i][j] = 0;
                else if (X[i - 1] == Y[j - 1])
                    L[i][j] = L[i - 1][j - 1] + 1;
                else
                    L[i][j] = std::max(L[i - 1][j], L[i][j - 1]);
            }
        }

        // Following code is used to print LCS
        int index = L[m][n];

        // Create a character array to store the lcs string
        T lcs[index + 1];
        lcs[index] = -1; // Set the terminating character

        // Start from the right-most-bottom-most corner and
        // one by one store characters in lcs[]
        int i = m, j = n;
        while (i > 0 && j > 0)
        {
            // If current character in X[] and Y are same, then
            // current character is part of LCS
            if (X[i - 1] == Y[j - 1])
            {
                lcs[index - 1] = x[i - 1]; // Put current character in result
                i--;
                j--;
                index--;     // reduce values of i, j and index
            }

            // If not same, then find the larger of two and
            // go in the direction of larger value
            else if (L[i - 1][j] > L[i][j - 1])
                i--;
            else
                j--;
        }

        // Print the lcs
        std::cout << "array x: ";
        for(int i = 0; i < m; ++i)
            std::cout << x[i] << " ";
        std::cout << std::endl;
        std::cout << "array y: ";
        for(int i = 0; i < n; ++i)
            std::cout << y[i] << " ";
        std::cout << std::endl;
        std::cout << "lcs: ";
        for(int i = 0; i < L[m][n]; ++i)
            std::cout << lcs[i] << " ";
        std::cout << std::endl;
    }

};

#endif