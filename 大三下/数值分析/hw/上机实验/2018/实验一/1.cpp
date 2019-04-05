#include <cmath>
#include <iostream>
using namespace std;

double ln2 = 0.693147190546;
double epsilon = 5e-5;

void compute_float_x() {
    float x = 0;
    int n = 0;
    while (abs(x - ln2) > epsilon)
    {
        n += 1;
        x += (float)pow(-1, n - 1) / (float)n;
    }
    cout.precision(12);
    cout << "float x, result n: " << n << endl;
}

void compute_float_x_precisely() {
    float x = 0;
    int n = 0;
    bool is_precise[5] = {false, false, false, false, false};
    while (!(is_precise[0] && is_precise[1] && is_precise[2] && is_precise[3] && is_precise[4]))
    {
        n += 1;
        x += (float)pow(-1, n - 1) / (float)n;
        if (abs(x - ln2) > epsilon) {
            is_precise[0] = is_precise[1] = is_precise[2] = is_precise[3] = is_precise[4] = false;
        }
        else {
            if(is_precise[4]) break;
            else if(is_precise[3]) is_precise[4] = true;
            else if(is_precise[2]) is_precise[3] = true;
            else if(is_precise[1]) is_precise[2] = true;
            else if(is_precise[0]) is_precise[1] = true;
            else is_precise[0] = true;
        }
    }
    n -= 6;
    cout.precision(12);
    cout << "float x, more precise result n: " << n << endl;
}

void compute_double_x() {
    double x = 0;
    int n = 0;
    while (abs(x - ln2) > epsilon)
    {
        n += 1;
        x += (double)pow(-1, n - 1) / (double)n;
    }
    cout.precision(12);
    cout << "double x, result n: " << n << endl;
}

void compute_double_x_precisely() {
    double x = 0;
    int n = 0;
    bool is_precise[5] = {false, false, false, false, false};
    while (!(is_precise[0] && is_precise[1] && is_precise[2] && is_precise[3] && is_precise[4]))
    {
        n += 1;
        x += (double)pow(-1, n - 1) / (double)n;
        if (abs(x - ln2) > epsilon) {
            is_precise[0] = is_precise[1] = is_precise[2] = is_precise[3] = is_precise[4] = false;
        }
        else {
            if(is_precise[4]) break;
            else if(is_precise[3]) is_precise[4] = true;
            else if(is_precise[2]) is_precise[3] = true;
            else if(is_precise[1]) is_precise[2] = true;
            else if(is_precise[0]) is_precise[1] = true;
            else is_precise[0] = true;
        }
    }
    n -= 6;
    cout.precision(12);
    cout << "double x, more precise result n: " << n << endl;
}

int main()
{
    compute_float_x();
    compute_float_x_precisely();
    compute_double_x();
    compute_double_x_precisely();
    return 0;
}