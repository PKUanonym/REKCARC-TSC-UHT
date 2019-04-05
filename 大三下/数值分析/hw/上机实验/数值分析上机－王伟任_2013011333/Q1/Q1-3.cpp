#include <cstdio>

int main(){
	float s1 = 0, adder1;
	double s2 = 0, adder2;

	for (int i = 1; i <= 2097152; i++){
		adder1 = 1.0 / i;
		adder2 = 1.0 / i;
		s1 += adder1;
		s2 += adder2;
	}

	printf("Using single: %.50f\n", s1);
	printf("Using double: %.50f\n", s2);
	return 0;
}