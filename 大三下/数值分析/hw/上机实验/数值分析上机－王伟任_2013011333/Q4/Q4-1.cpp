#include <cstdio>
#include <cmath>

int n = 10;

double** createHilbert(){
	double** temp = new double*[n];
	for (int i = 0; i < n; i++){
		temp[i] = new double[n];
		for (int j = 0; j < n; j++)
			temp[i][j] = 1.0 / (i + j + 1);
	}
	return temp;
}

double* multiply(double** A, double* bl){
	double* ans = new double[n];
	for (int i = 0; i < n; i++){
		ans[i] = 0;
		for (int j = 0; j < n; j++)
			ans[i] += A[i][j] * bl[j];
	}
	return ans;
}

double norm(double* A, double* B){
	double mmax = 0.0;
	for (int i = 0; i < n; i++)
		if (fabs(A[i] - B[i]) > mmax) mmax = fabs(A[i] - B[i]);
	return mmax;
}

int main(){
	double** Hilbert = createHilbert();
	double* b = new double[n];
	for (int i = 0; i < n; i++) b[i] = 1.0 / (i + 1);
	double* x = new double[n];
	double* y = new double[n];
	for (int i = 0; i < n; i++) x[i] = 0;

	FILE* fp = fopen("test1.txt", "w");

	do{                          //Jacobi
		for (int i = 0; i < n; i++) y[i] = x[i];
		for (int i = 0; i < n; i++){
			double s = 0.0;
			for (int j = 0; j < n; j++)
				if (j != i) s += Hilbert[i][j] * y[j];
			x[i] = (b[i] - s) / Hilbert[i][i];
		}

		for (int i = 0; i < n; i++)
			fprintf(fp, "%f\t", x[i]);
		fprintf(fp, "\n");

	} while(norm(x, y) >= 0.0001);


	fprintf(fp, "Answer is:\n");
	for (int i = 0; i < n; i++)
		fprintf(fp, "%f\t", x[i]);
	fprintf(fp, "\n");
	fclose(fp);


	for (int i = 0; i < n; i++)
		delete[] Hilbert[i];
	delete[] Hilbert;
	delete[] b;
	delete[] x;
	delete[] y;
	return 0;
}
