#include <cstdio>
#include <cmath>

int n = 10;
double w = 0.01;

double** createHilbert(){
	double** temp = new double*[n];
	for (int i = 0; i < n; i++){
		temp[i] = new double[n];
		for (int j = 0; j < n; j++)
			temp[i][j] = 1.0 / (i + j + 1);
	}
	return temp;
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
	double* x0 = new double[n];
	x0[0] = 1.0;
	for (int i = 1; i < n; i++) x0[i] = 0;

	FILE* fp = fopen("test0.txt", "w");

	for (;w < 2; w += 0.01){
		for (int i = 0; i < n; i++) x[i] = 0;
		int counter = 0;
		do{                    //SOR
			for (int i = 0; i < n; i++) y[i] = x[i];
			for (int i = 0; i < n; i++){
				double s = 0.0;
				for (int j = 0; j < n; j++)
					if (j != i) s += Hilbert[i][j] * x[j];
				x[i] = (1 - w) * x[i] + w * (b[i] - s) / Hilbert[i][i];
			}
			counter++;
		} while(norm(x, y) >= 0.0001);

		fprintf(fp, "w = %f\n", w);
		fprintf(fp, "Answer is:\n");
		for (int i = 0; i < n; i++)
			fprintf(fp, "%f\t", x[i]);
		fprintf(fp, "\n");
		double nor = norm(x, x0);
		fprintf(fp, "wu cha fan shu: %f\n", nor);
		fprintf(fp, "counter = %d\n\n", counter);
	}
	fclose(fp);


	for (int i = 0; i < n; i++)
		delete[] Hilbert[i];
	delete[] Hilbert;
	delete[] b;
	delete[] x;
	delete[] y;
	return 0;
}
