#include <cstdio>
#include <cmath>

int n;

int main(){
	FILE* fp = fopen("test.txt", "r");
	fscanf(fp, "%d", &n);
	fgetc(fp);
	double* x = new double[n];
	double* f = new double[n];
	for (int i = 0; i < n; i++)
		fscanf(fp, "%lf", &x[i]), fgetc(fp);
	for (int i = 0; i < n; i++)
		fscanf(fp, "%lf", &f[i]), fgetc(fp);
	double df0, dfn;
	fscanf(fp, "%lf", &df0);
	fgetc(fp);
	fscanf(fp, "%lf", &dfn);
	fclose(fp);

	double* h = new double[n - 1];
	for (int i = 0; i < n - 1; i++)
		h[i] = x[i + 1] - x[i];
	double* u = new double[n - 1];
	for (int i = 0; i < n - 2; i++)
		u[i] = h[i] / (h[i] + h[i + 1]);
	u[n - 2] = 1;
	double* l = new double[n - 1];
	for (int i = 1; i < n - 1; i++)
		l[i] = h[i] / (h[i - 1] + h[i]);
	l[0] = 1;
	double* d = new double[n];
	for (int i = 1; i < n - 1; i++)
		d[i] = 6 * (f[i-1] / (h[i-1] * (h[i-1] + h[i])) + f[i+1] / (h[i] * (h[i-1] + h[i])) - f[i] / (h[i-1] * h[i]));
	d[0] = 6 * ((f[1] - f[0]) / h[0] - df0) / h[0];
	d[n-1] = 6 * (dfn - (f[n-1] - f[n-2]) / h[n-2]) / h[n-2];
	double* array = new double[n];
	for (int i = 0; i < n; i++) array[i] = 2;

	double* m = new double[n - 1];
	for (int i = 2; i <= n ; i++){
		m[i - 2] = u[i - 2] / array[i - 2];
		array[i - 1] = array[i - 1] - m[i - 2] * l[i - 2];
		d[i - 1] = d[i - 1] - m[i - 2] * d[i - 2];
	}
	double* M = new double[n];
	M[n - 1] = d[n - 1] / array[n - 1];
	for (int i = n - 2; i >= 0; i--)
		M[i] = (d[i] - l[i] * M[i + 1]) / array[i];

	double tx;
	printf("input an X value:");
	scanf("%lf", &tx);
	while(tx != -1){
		int kk = 0;
		for (int i = 0; i < n - 1; i++)
			if ((tx >= x[i]) && (tx <= x[i + 1])){
				kk = i;
				break;
			}
		double df, ddf, ft;
		ft = M[kk]*(x[kk+1]-tx)*(x[kk+1]-tx)*(x[kk+1]-tx)/(6*h[kk])+M[kk+1]*(tx-x[kk])*(tx-x[kk])*(tx-x[kk])/(6*h[kk])+(f[kk]-M[kk]*h[kk]*h[kk]/6)*(x[kk+1]-tx)/h[kk]+(f[kk+1]-M[kk+1]*h[kk]*h[kk]/6)*(tx-x[kk])/h[kk];
		df = -M[kk]*(x[kk+1]-tx)*(x[kk+1]-tx)/(2*h[kk])+M[kk+1]*(tx-x[kk])*(tx-x[kk])/(2*h[kk])+(f[kk+1]-f[kk])/h[kk]-(M[kk+1]-M[kk])*h[kk]/6;
		ddf = M[kk]*(x[kk+1]-tx)/h[kk]+M[kk+1]*(tx-x[kk])/h[kk];
		printf("ft = %.10f; df = %.10f; ddf = %.10f.\n", ft, df, ddf);
		printf("input an X value:");
		scanf("%lf", &tx);
	}

	delete[] m;
	delete[] M;
	delete[] array;
	delete[] d;
	delete[] h;
	delete[] l;
	delete[] u;
	delete[] x;
	delete[] f;
	return 0;
}
