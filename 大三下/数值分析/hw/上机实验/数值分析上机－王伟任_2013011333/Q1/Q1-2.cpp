#include <cstdio>
#include <cmath>

int main(){
	double s1 = 0.0;
	long long i = 1;
	double adder;
	for (;i < 20000000; i++){
		adder = 1.0 / i;
		s1 += adder;
	}
	double klans = s1;
	double ansSum = s1;
	adder = log(5*i)-log(i);
	double s2 = s1 + adder;
	adder = 1.0 / (5*i);
	s1 = s2 + adder;
	while(s1 != s2){
		ansSum = s1;
		i = 5 * i + 1;
		adder = log(5*i)-log(i);
		s2 = s1 + adder;
		adder = 1.0 / (5*i);
		s1 = s2 + adder;
	}
	long long beginn = i;
	long long eend = 5 * i;
	while (beginn < eend){
		long long delta = (eend - beginn) / 4;
		long long b[5];
		b[0] = beginn - 1; 
		b[1] = beginn + delta;
		b[2] = b[1] + delta;
		b[3] = b[2] + delta;
		b[4] = eend;
		for (int kk = 0; kk < 4; kk ++){
			adder = log(b[kk + 1]) - log(b[kk] + 1);
			double as1 = ansSum + adder;
			double as2 = as1 + 1.0 / b[kk + 1];
			if (as1 == as2){
				beginn = b[kk] + 1;
				eend = b[kk + 1];
				break;
			}
			ansSum = as2;
		}
	}
	printf("Answer is %lld\n", beginn);
	printf("The summary is %.50f\n", ansSum); 
	printf("Cor summary is %.50f\n", klans + log(beginn+1) - log(20000000));
	return 0;
}
