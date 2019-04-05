#include <cstdio>
#include <cmath>

int n = 15;
int w = 3;

double** create(double* t){
	double** ans = new double*[n];
	for (int i = 0; i < n; i++){
		ans[i] = new double[w];
		for (int j = 0; j < w; j++){
			ans[i][j] = 1.0;
			for (int kk = 0; kk < j; kk++)
				ans[i][j] *= t[i];			
		}
	}
	return ans;
}

double* multiply1(double** A, double* f){
	double* ans = new double[w];
	for (int i = 0; i < w; i++){
		ans[i] = 0;
		for (int j = 0; j < n; j++)
			ans[i] += A[j][i] * f[j];
	}
	return ans;
}

double** multiply2(double** A){
	double** ans = new double*[w];
	for (int i = 0; i < w; i++){
		ans[i] = new double[w];
		for (int j = 0; j < w; j++){
			ans[i][j] = 0.0;
			for (int k = 0; k < n; k++)
				ans[i][j] += A[k][i] * A[k][j];
		}
	}
	return ans;
}

double** Cholesky(double** G){
	double** L = new double*[w];
	for (int i = 0; i < w; i++)
		L[i] = new double[w];
	for (int i = 0; i < w; i++)
		for (int j = i + 1; j < w; j++)
			L[i][j] = 0;

	L[0][0] = sqrt(G[0][0]);
	for (int i = 1; i < w; i++)
		L[i][0] = G[i][0] / L[0][0];
	for (int j = 1; j < w; j++){
		double ss = 0.0;
		for (int i = 0; i < j; i++)
			ss += L[j][i] * L[j][i];
		L[j][j] = sqrt(G[j][j] - ss);
		for (int i = j + 1; i < w; i++){
			double s = 0.0;
			for (int ii = 0; ii < j; ii++)
				s += L[i][ii] * L[j][ii];
			L[i][j] = (G[i][j] - s) / L[j][j];
		}
	}
	return L;
}

double* solve(double** L, double* b){
	double* y = new double[w];
	for (int i = 0; i < w; i++){
		y[i] = b[i] / L[i][i];
		for (int j = 0; j < i; j++)
			y[i] = y[i] - y[j] * L[i][j] / L[i][i];
	}
	return y;
}

double* solve2(double** L, double* y){
	double* x = new double[w];
	for (int i = w - 1; i >= 0; i--){
		x[i] = y[i] / L[i][i];
		for (int j = i + 1; j < w; j++)
			x[i] = x[i] - x[j] * L[j][i] / L[i][i];
	}
	return x;
}


int main(){
	FILE* fp = fopen("test.txt", "r");
	double* t = new double[n];
	double* f = new double[n];
	for (int i = 0; i < n; i++)
		fscanf(fp, "%lf", &t[i]), fgetc(fp);
	for (int i = 0; i < n; i++)
		fscanf(fp, "%lf", &f[i]), fgetc(fp);
	fclose(fp);

	double** A = create(t);
	double* b = multiply1(A, f);
	double** G = multiply2(A);
	double** L = Cholesky(G);
	double* y = solve(L, b);
	double* x = solve2(L, y);

	fp = fopen("out1.txt", "w");
	for (int i = 0; i < w; i++){
		if (i == 0) fprintf(fp, "a = ");
		if (i == 1) fprintf(fp, "b = ");
		if (i == 2) fprintf(fp, "c = ");
		fprintf(fp, "%.10f;\t", x[i]);
	}
	fprintf(fp, "\n");
	fprintf(fp, "wu cha 2-norm = ");
	double* delta = new double[n];
	for (int i = 0; i < n; i++){
		delta[i] = 0;
		for (int j = 0; j < w; j++)
			delta[i] += A[i][j] * x[j];
	}
	double norm = 0;
	for (int i = 0; i < n; i++)
		norm += (delta[i] - f[i]) * (delta[i] - f[i]);
	norm = sqrt(norm);
	fprintf(fp, "%.10f\n", norm);
	fclose(fp);

	delete[] t;
	delete[] f;
	delete[] b;
	delete[] y;
	delete[] x;
	delete[] delta;
	for (int i = 0; i < w; i++)
		delete[] G[i], delete[] L[i];
	delete[] G;
	delete[] L;
	for (int i = 0; i < n; i++)
		delete[] A[i];
	delete[] A;

	return 0;
}