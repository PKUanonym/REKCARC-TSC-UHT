#include <cstdio>
#include <cmath>

void multiply(int n, double** A, double* bl, double* ans){
	for (int i = 0; i < n; i++){
		ans[i] = 0;
		for (int j = 0; j < n; j++)
			ans[i] += A[i][j] * bl[j];
	}
}

double mmax(int n, double* v){
	double ans = 0;
	double nmax = 0;
	for (int i = 0; i < n; i++)
		if (fabs(v[i]) > nmax){
			ans = v[i];
			nmax = fabs(v[i]);
		}
	return ans;
}

int main(int argc, char** argv){
	FILE* fp = fopen(argv[1], "r");
	int n;
	fscanf(fp, "%d", &n);
	fgetc(fp);
	double** array = new double*[n];
	for (int i = 0; i < n; i++){
		array[i] = new double[n];
		for (int j = 0; j < n; j++){
			fscanf(fp, "%lf", &array[i][j]);
			fgetc(fp);
		}
	}
	fclose(fp);

	double* v = new double[n];
	double* u = new double[n];
	v[0] = u[0] = 1.0;
	for (int i = 1; i < n; i++)
		v[i] = u[i] = 0.0;
	double l1, l2;
	l1 = 0;
	do{
		l2 = l1;
		multiply(n, array, u, v);
		l1 = mmax(n, v);
		for (int i = 0; i < n; i++)
			u[i] = v[i] / l1;
	} while(fabs(l1 - l2) >= 0.00001);

	fp = fopen(argv[2], "w");
	fprintf(fp, "l = %.10f\n", l1);
	fprintf(fp, "x = [");
	for (int i = 0; i < n - 1; i++)
		fprintf(fp, "%.10f\t", u[i]);
	fprintf(fp, "%.10f]\n", u[n - 1]);

	fclose(fp);
	for (int i = 0; i < n; i++)
		delete[] array[i];
	delete[] array;
	delete[] u;
	delete[] v;
	return 0;
}