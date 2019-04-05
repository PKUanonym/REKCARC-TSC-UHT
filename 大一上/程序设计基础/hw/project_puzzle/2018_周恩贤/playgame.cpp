#include "my_function.h"

void playgame(int M, int N, int puzzle[]){
	print_instruction();
	printf("Ready? Game Start!\n");
	Sleep(1500);
	system("cls");
	print_instruction();
	print_puzzle(M,N,puzzle);
	read_MxN(M,N,puzzle);
}; 


int find(int M, int N, int puzzle[], int num){
	for (int i=0;i<M*N;i++){
		if (puzzle[i] == num) return i;
	}
}

void change(int M, int N, int puzzle[], char c){
	int pos = find(M,N,puzzle,-1);
	switch(c){
		case 'W':
		case 'w':
			if (pos-N >= 0) //合理的移動 
				swap(puzzle[pos],puzzle[pos-N]);
			break;
		case 'A':
		case 'a':
			if (pos%N != 0)
				swap(puzzle[pos],puzzle[pos-1]);
			break;
		case 'S':
		case 's':
			if (pos+N <= M*N-1) //合理的移動 
				swap(puzzle[pos],puzzle[pos+N]);
			break;
		case 'D':
		case 'd':
			if (pos%N != N-1)
				swap(puzzle[pos],puzzle[pos+1]);
			break;
	}
};

bool check_solved(int M,int N,int puzzle[]){
	for (int i=0; i<M*N-1; i++)
		if (puzzle[i]!= i+1)
			return false;
	return true;
}


