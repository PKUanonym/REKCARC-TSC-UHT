#include "my_function.h"

void print_error(string s){
	cin.clear();
	cin.sync();
	cout << s;
}


void print_title(){
	cout << "==================Puzzle Game======================" << endl;
	cout << "	Arthor : Zhou EnXian" << endl;
	cout << "	Date : 2019.01.06"  << endl;
	cout << "===================================================" << endl;
}

void print_menu(){
		cout << "\nPlease select a mode(not case sensitive) :" << endl 
			 << "  1: M*N Mode [General Solution]" << endl
			 << "  2: 3*3 Mode [BFS] " << endl
			 << "  P: Quit the game\t" ; 
}

void print_instruction(){
	cout << "====================================================================================" << endl 
		 << "Instructions(not case sensitive) :" << endl
		 << "W: Switch the blank block with its upper block" << endl
		 << "A: Switch the blank block with its left block"  << endl
		 << "S: Switch the blank block with its lower block" << endl
		 << "D: Switch the blank block with its right block"  << endl
		 << "R: Restart the game with the origin puzzle" << endl
		 << "G: Save the current graph. Next line enter its path" << endl
		 << "I: Save the current procedure for the game. Next line enter the file name (case sensitive)" << endl
		 << "O: Read the previous-saved procedure for the game. Next line enter the file name (case sensitive)" << endl
		 << "L: Print out all the names of the saved files" << endl //¸½¼Ó 
		 << "F: Automatically solve the game and print out the solution" << endl 
		 << "P: Quit the game (Return to menu)" << endl
		 << "Note : You can move many steps in one line of enter" << endl
	     << "====================================================================================" << endl << endl ;  	 
}

void print_puzzle(int M, int N, int puzzle[]){
	int mark = 0;
	for (int i=1; i<=M; i++){
		for (int j=1; j<=N; j++){ //use printf to make the puzzle neat
			printf("%3d ",puzzle[mark++]);
		}
		cout << endl;
	}
	cout << endl;
}

