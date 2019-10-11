#include <bits/stdc++.h>
using namespace std;

const int n = 100, iter_num = 50000;
const double omega = 0.5;
double eps, h = 0.01, a = 0.5;
double A[n + 5][n + 5], b[n + 5], x[n + 5], x1[n + 5];

inline void init() {
	for (int i = 1; i <= n; i++) b[i] = a * h * h;
	for (int i = 1; i <= n; i++) {
		A[i][i] = - eps - eps - h;
		if (i >= 2) A[i][i - 1] = eps;
		if (i < n) A[i][i + 1] = eps + h;
	}
}

inline bool converge(double A[n + 5][n + 5], double b[], double x[], double x1[]) {
	double norm = 0, norm1 = 0;
	for (int i = 1; i <= n; i++) {
		norm1 += x1[i] * x1[i];
		norm += (x[i] - x1[i]) * (x[i] - x1[i]);
	}
	if (sqrt(norm) / sqrt(norm1) < 1e-7) return true;
	double b_prime[n + 5];
	for (int i = 1; i <= n; i++)
		for (int j = 1; j <= n; j++)
			b_prime[j] += A[i][j] * x[j];
	norm = norm1 = 0;
	for (int i = 1; i <= n; i++) {
		norm1 += b_prime[i] * b_prime[i];
		norm += (b[i] - b_prime[i]) * (b[i] - b_prime[i]);
	}
	if (sqrt(norm) / sqrt(norm1) < 1e-7) return true;
	return false;
}

inline void Jacobi() {
	memset(x, 0, sizeof(x));
	for (int it = 0; it < iter_num; it++) {
		memset(x1, 0, sizeof(x1));
		for (int i = 1; i <= n; i++) {
			double s = 0;
			for (int j = 1; j <= n; j++)
				if (j != i) s += A[i][j] * x[j];
			x1[i] = (b[i] - s) / A[i][i];
		}
		if (converge(A, b, x, x1)) {
			printf("%d\n", it);
			break;
		}
		for (int i = 1; i <= n; i++) x[i] = x1[i];
	}
	puts("Jacobi");
	for (int i = 1; i <= n; i++) {
		printf("%.4lf", x[i]);
		if (i == n) putchar('\n'); else putchar(' ');
	}
}

inline void G_S() {
	memset(x, 0, sizeof(x));
	for (int it = 0; it < iter_num; it++) {
		memset(x1, 0, sizeof(x1));
		for (int i = 1; i <= n; i++) {
			double s = 0;
			for (int j = 1; j < i; j++) s += A[i][j] * x1[j];
			for (int j = i + 1; j <= n; j++) s += A[i][j] * x[j];
			x1[i] = (b[i] - s) / A[i][i];
		}
		if (converge(A, b, x, x1)) {
			printf("%d\n", it);
			break;
		}
		for (int i = 1; i <= n; i++) x[i] = x1[i];
	}
	puts("G_S");
	for (int i = 1; i <= n; i++) {
		printf("%.4lf", x[i]);
		if (i == n) putchar('\n'); else putchar(' ');
	}
}

inline void SOR() {
	memset(x, 0, sizeof(x));
	for (int it = 0; it < iter_num; it++) {
		memset(x1, 0, sizeof(x1));
		for (int i = 1; i <= n; i++) {
			double s = 0;
			for (int j = 1; j < i; j++) s += A[i][j] * x1[j];
			for (int j = i + 1; j <= n; j++) s += A[i][j] * x[j];
			x1[i] = (1 - omega) * x[i] + omega * (b[i] - s) / A[i][i];
		}
		if (converge(A, b, x, x1)) {
			printf("%d\n", it);
			break;
		}
		for (int i = 1; i <= n; i++) x[i] = x1[i];
	}
	puts("SOR");
	for (int i = 1; i <= n; i++) {
		printf("%.4lf", x[i]);
		if (i == n) putchar('\n'); else putchar(' ');
	}
}

inline void Gaussian_Elimination() {
	memset(x, 0, sizeof(x));
	for (int i = 1; i <= n; i++) {
		int maxLine = i;
		for (int j = i + 1; j <= n; j++)
			if (fabs(A[j][i]) > fabs(A[maxLine][i])) maxLine = j;
		for (int j = i; j <= n; j++) swap(A[i][j], A[maxLine][j]);
		swap(b[i], b[maxLine]);
		double t = A[i][i];
		for (int j = i; j <= n; j++) A[i][j] /= t;
		b[i] /= t;
		for (int j = i + 1; j <= n; j++) if (fabs(A[j][i]) > 1e-10) {
			t = A[j][i];
			for (int k = i; k <= n; k++) A[j][k] -= A[i][k] * t;
			b[j] -= b[i] * t;
		}
	}
	for (int i = n; i; i--) {
		x[i] = b[i];
		for (int k = i + 1; k <= n; k++) x[i] -= A[i][k] * x[k];
	}
	puts("Gaussian_Elimination");
	for (int i = 1; i <= n; i++) {
		printf("%.4lf", x[i]);
		if (i == n) putchar('\n'); else putchar(' ');
	}
}

int main() {
	eps = 1.0;
	for (int id = 0; id < 5; id++) {
		printf("eps = %.4lf\n", eps);
		init();
		Jacobi();
		G_S();
		SOR();
		Gaussian_Elimination();
		system("pause");
		eps /= 10.0;
	}
	return 0;
}
