#include <bits/stdc++.h>
using namespace std;

const double eps = 1e-8;

int task;
inline double f(double x) {
	if (task == 1)
		return x * (x * x - 1.0) - 1.0;
	else
		return x * (- x * x + 5.0);
}
inline double f_grad(double x) {
	if (task == 1)
		return 3.0 * x * x - 1.0;
	else
		return - 3.0 * x * x + 5.0;
}
int main() {
	scanf("%d", &task);
	double x0, lambda;
	if (task == 1)
		x0 = 0.6;
	else
		x0 = 1.35;
	int k = 0;
	while (1) {
		double s = f(x0) / f_grad(x0);
		double x1 = x0 - s;
		lambda = 1.0;
		while (fabs(f(x1)) >= fabs(f(x0))) {
			x1 = x0 - lambda * s;
			lambda /= 2.0;
		}
		k++;
		printf("lambda = %.6lf x = %.6lf\n", lambda, x1);
		if ((fabs(f(x1)) < eps) || (fabs(x0 - x1) < eps)) {
			printf("root = %.6lf\n", x1);
			break;
		}
		x0 = x1;
	}
	return 0;
}
