#include <cstdio>
#include <cmath>

int n = 10;

double** createHilbert(){
	double** temp = new double*[n];
	for (int i = 0; i < n; i++){
		temp[i] = new double[n * 2];
		for (int j = 0; j < n; j++)
			temp[i][j] = 1.0 / (i + j + 1);
		for (int j = n; j < 2 * n; j++)
			temp[i][j] = 0;
		temp[i][n + i] = 1.0;
	}
	return temp;
}

double norm(double** h){
	double mmax = 0;
	for (int i = 0; i < n; i++){
		double s = 0;
		for (int j = 0; j < n; j++)
			s += fabs(h[i][j]);
		if (s > mmax) mmax = s;
	}
	return mmax;
}

int main(){
	double** HI = createHilbert();

	double** Hilbert = new double*[n];
	for (int i = 0; i < n; i++){
		Hilbert[i] = new double[n];
		for (int j = 0; j < n; j++)
			Hilbert[i][j] = HI[i][j];
	}

	for (int i = 1; i < n; i++)
		for (int j = 0; j < i; j++){
			double bk = HI[i][j] / HI[j][j];
			for (int k = j; k < 2 * n; k++)
				HI[i][k] = HI[i][k] - HI[j][k] * bk;			
		}
	for (int i = n-2; i >= 0; i--)
		for (int j = n-1; j > i; j--){
			double bk = HI[i][j] / HI[j][j];
			for (int k = j; k < 2 * n; k++)
				HI[i][k] = HI[i][k] - HI[j][k] * bk;	
		}
	for (int i = 0; i < n; i++){
		double bk = HI[i][i];
		for (int j = 0; j < 2 * n; j++)
			HI[i][j] = HI[i][j] / bk;
	}

	double** invHilbert = new double*[n];
	for (int i = 0; i < n; i++){
		invHilbert[i] = new double[n];
		for (int j = 0; j < n; j++)
			invHilbert[i][j] = HI[i][j + n];
	}

	FILE* fp = fopen("test.txt", "w");
	fprintf(fp, "Hilbert:\n");
	for (int i = 0; i < n; i++){
		for (int j = 0; j < n; j++)
			fprintf(fp, "%26f\t", Hilbert[i][j]);
		fprintf(fp, "\n");
	}
	fprintf(fp, "invHilbert:\n");
	for (int i = 0; i < n; i++){
		for (int j = 0; j < n; j++)
			fprintf(fp, "%26f\t", invHilbert[i][j]);
		fprintf(fp, "\n");
	}
	fclose(fp);

	printf("%.10f\n", norm(Hilbert) * norm(invHilbert));

	for (int i = 0; i < n; i++)
		delete[] HI[i];
	delete[] HI;
	for (int i = 0; i < n; i++)
		delete[] invHilbert[i];
	delete[] invHilbert;
	for (int i = 0; i < n; i++)
		delete[] Hilbert[i];
	delete[] Hilbert;
	return 0;
}