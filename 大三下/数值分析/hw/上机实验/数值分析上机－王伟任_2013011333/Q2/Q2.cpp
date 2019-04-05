#include <cstdio>
#include <cmath>

using namespace std;

const double e = 0.0000000001;
double l = 0.9 * 2;
int a3, a2, a1, a0;

void print(){
	printf("The equation is : ");
	if ((a3 != 1)&&(a3 != -1)&&(a3 != 0)) printf("%dX^3", a3);
	else if (a3 == 1) printf("X^3");
	else if (a3 == -1) printf("-X^3");
	if ((a2 > 0)&&(abs(a3)>0)) printf("+");
	if ((a2 != 1)&&(a2 != -1)&&(a2 != 0)) printf("%dX^2", a2);
	else if (a2 == 1) printf("X^2");
	else if (a2 == -1) printf("-X^2");
	if ((a1 > 0)&&(abs(a3)+abs(a2)>0)) printf("+");
	if ((a1 != 1)&&(a1 != -1)&&(a1 != 0)) printf("%dX", a1);
	else if (a1 == 1) printf("X");
	else if (a1 == -1) printf("-X");
	if ((a0 > 0)&&(abs(a3)+abs(a2)+abs(a1)>0)) printf("+");
	if (a0 != 0) printf("%d", a0);
	printf("=0\n");
}

double function(double x){
	return a3*x*x*x+a2*x*x+a1*x+a0;
}

double dfunction(double x){
	return 3*a3*x*x+2*a2*x+a1;
}

int main(){
	printf("a3=1, a2=0, a1=-1, a0=-1, x0=0.6\n");
	printf("a3=-1, a2=0, a1=5, a0=0, x0=1.2\n");
	scanf("%d %d %d %d", &a3, &a2, &a1, &a0);
	print();
	printf("e = %.10f; l = %f\n", e, l / 2);
	double x0, x1, s;
	scanf("%lf", &x0);
	while (fabs(function(x0)) > e){
		s = function(x0) / dfunction(x0);
		x1 = x0 - s;
		while (fabs(function(x1)) >= fabs(function(x0))){
			l = l / 2;
			x1 = x0 - l * s;
		}
		x0 = x1;
		printf("current ans = %.20f; l = %f\n", x0, l);
	}
	printf("ans = %.20f\n", x0);
	return 0;
}
