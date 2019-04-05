#include <cmath>
#include <iostream>
#include <cstring>
using namespace std;

#define LEN 50
struct polynomial {
    double a[LEN];

    polynomial()
    {
        for (int i = 0; i < LEN; i++)
            a[i] = 0;
    }

    polynomial(double x) {
        for (int i = 0; i < LEN; i++)
            a[i] = 0;
        a[0] = x;
    }

    polynomial(double x0, double x1) {
        for (int i = 0; i < LEN; i++)
            a[i] = 0;
        a[0] = x0;
        a[1] = x1;
    }

    polynomial(double *array, int n) {
        for (int i = 0; i < LEN; i++)
            a[i] = 0;
        for (int i = 0; i < n; i++)
            a[i] = array[i];
    }

    polynomial operator+(const polynomial &b) {
        polynomial result;
        for (int i = 0; i < LEN; i++) {
            result.a[i] = a[i] + b.a[i];
        }
        return result;
    }

    polynomial operator*(const polynomial &b) {
        polynomial result;
        for (int i = 0; i < LEN / 2; i++)
            for (int j = 0; j < LEN / 2; j++)
                result.a[i + j] += a[i] * b.a[j];
        return result;
    }

    void report() {
        bool f = true;
        cout.precision(6);
        for (int i = LEN - 1; i >= 0; i--) {
            if (f && (abs(a[i] - 0) > 1e-10)) {
                f = false;
                cout << a[i];
                printf("*x^%d", i);
            }
            else if (!f) {
                printf("+");
                cout << a[i];
                printf("*x^%d", i);
            }
        }
        printf("\n");
    }
};


double f(double x)
{
    return 1.0 / (1 + 16 * x * x);
}

double df(double x)
{
    return -32 * x / ((1 + 16 * x * x) * (1 + 16 * x * x));
}

double n_difference(double *array, int n) {
    if (n == 0) {
        return f(array[0]);
    }
    double *array_left = new double[n];
    memcpy(array_left, array, sizeof(double) * (n - 1));
    array_left[n - 1] = array[n];
    double ret = (n_difference(array_left, n - 1) - n_difference(array, n - 1)) / (array[n] - array[n-1]);
    delete[] array_left;
    return ret;
}


double Lagrange(int n, double x)
{
    double h = 10.0 / n;
    double *array = new double[n + 1];
    for (int i = 0; i <= n; i++)
    {
        array[i] = -5 + i * h;
    }
    double L = 0;
    for (int i = 0; i <= n; i++)
    {
        double Li = f(array[i]);
        for (int j = 0; j <= n; j++)
        {
            if (j == i)
            {
                continue;
            }
            Li *= (x - array[j]) / (array[i] - array[j]);
        }
        L += Li;
    }
    delete[] array;
    return L;
}

void get_mu(double *h, double *mu, int n) {
    for (int i = 1; i < n; i++){
        mu[i] = h[i - 1] / (h[i - 1] + h[i]);
    }
    mu[n] = 1.0;
}

void get_lambda(double *h, double *lambda, int n) {
    lambda[0] = 1;
    for (int i = 1; i < n; i++) {
        lambda[i] =  h[i] / (h[i - 1] + h[i]);
    }
}

void get_d(double *array, double *h, double *d, int n) {
    double x[3] = {array[0], array[1], array[2]};
    d[0] = 6 * (n_difference(x, 1) - df(array[0])) / h[0];
    for (int i = 1; i < n; i++) {
        for (int j = 0; j < 3; j++) {
            x[j] = array[i + j - 1];
        }
        d[i] = 6 * n_difference(x, 2);
    }
    x[0] = array[n - 1];
    x[1] = array[n];
    d[n] = 6 * (df(array[n]) - n_difference(x, 1)) / h[n - 1];
}

void solve_tridiagonal_matrix(double *mu, double *lambda, double *d, double *M, int n) {
    double *r = new double[n + 1];
    double *g = new double[n + 1];
    double p = 2;
    g[0] = d[0] / p;
    r[0] = lambda[0] / p;
    for (int i = 1; i <= n; i++) {
        p = 2 - mu[i] * r[i - 1];
        if(i != n) {
            r[i] = lambda[i] / p;
        }
        g[i] = (d[i] - mu[i] * g[i - 1]) / p;
    }
    M[n] = g[n];
    for (int i = n - 1; i >= 0; i--) {
        M[i] = g[i] - r[i] * M[i + 1];
    }
    delete[] r;
    delete[] g;
}

int find_interval(double *array, double x, int n) {
    for (int i = 0; i <= n; i++) {
        if(array[i] > x) {
            return (i - 1);
        }
    }
    return -1;
}

double get_S(double *array, double x, double *M, double *h, int id, int n) {
    double S = M[id] * (array[id + 1] - x) * (array[id + 1] - x) * (array[id + 1] - x) / 6 / h[id];
    S += M[id + 1] * (x - array[id]) * (x - array[id]) * (x - array[id]) / 6 / h[id];
    S += (f(array[id]) - M[id] * h[id] * h[id] / 6) * (array[id + 1] - x) / h[id];
    S += (f(array[id + 1]) - M[id + 1] * h[id] * h[id] / 6) * (x - array[id]) / h[id];
    return S;
}

double Spline(int n, double x) {
    double h = 10.0 / n;
    double *array = new double[n + 1];
    for (int i = 0; i <= n; i++)
    {
        array[i] = -5 + i * h;
    }
    double *h_array = new double[n];
    for (int i = 0; i < n; i++) {
        h_array[i] = array[i + 1] - array[i];
    }
    double *mu = new double[n + 1];
    double *lambda = new double[n + 1];
    double *d = new double[n + 1];
    double *M = new double[n + 1];
    get_mu(h_array, mu, n);
    get_lambda(h_array, lambda, n);
    get_d(array, h_array, d, n);
    solve_tridiagonal_matrix(mu, lambda, d, M, n);
    int index = find_interval(array, x, n);
    double S = get_S(array, x, M, h_array, index, n);
    delete[] h_array;
    delete[] mu;
    delete[] lambda;
    delete[] d;
    delete[] M;
    delete[] array;
    return S;
}

void print_langrange(int n)
{
    double h = 10.0 / n;
    double *array = new double[n + 1];
    for (int i = 0; i <= n; i++)
    {
        array[i] = -5 + i * h;
    }
    polynomial L;
    for (int i = 0; i <= n; i++)
    {
        polynomial Li(f(array[i]));
        for (int j = 0; j <= n; j++)
        {
            if (j == i)
            {
                continue;
            }
            Li = Li * polynomial(-array[j], 1) * polynomial(1.0 / (array[i] - array[j]));
        }
        L = L + Li;
    }
    L.report();
    delete[] array;
}

#include <fstream>

int main()
{
    cout << "4.8, 10: "
         << "Lagrange: " << Lagrange(10, 4.8) << ", Spline: " << Spline(10, 4.8) << endl;
    return 0;
}