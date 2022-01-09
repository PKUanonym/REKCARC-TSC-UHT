#include <stdio.h>
#include <stdlib.h>
//using namespace std;

int test[10000];

int main(int argc, char const *argv[])
{
	allocate_init();
	//srand(20);
	for (int i = 0; i < 10000; ++i)
	{
		int tmp = 111-(i/100);
		printf("%d\n",tmp);
		test[i] = allocate(tmp);
		if(i%3==0)
		{
			printf("deallocate\n");
			deallocate(test[i]);
		}
		printf("%d: %d\n",i,tmp );
	}
	return 0;
}