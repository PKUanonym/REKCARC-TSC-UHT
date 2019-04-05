#include "my_function.h"
 
void read_1(){
	char c;
	while(true){
	print_menu();
		cin >> c;	
		if(!cin.fail()){
			switch(c){
				case '1':
					run_MxN();
					break;
				case '2':
					run_3x3();
					break;
				case 'p':
				case 'P':
					return;
					break;
				default :	
					print_error("You've entered a wrong instruction!\n");
					break;
			}
		}
		else{
			print_error("You've entered a wrong instruction!\n");
		}
	}
}

bool readsize(int &M, int &N){
	cin >> M >> N;
	if (!cin.fail() && M>1 && N>1) return true;
	return false;
}

void read_2(int M,int N,int puzzle[]){
	char c;
	cin >> c;
	if(!cin.fail()){
		switch(c){
			case 'y':
			case 'Y':
				playgame(M,N,puzzle);
				break;
			case 'n':
			case 'N': //退回上一層 
				break;
			default :
				print_error("You've entered a wrong instruction!\nPlease re-enter:\n");
				read_2(M,N,puzzle);
		}
	}else{
		print_error("You've entered a wrong instruction!\nPlease re-enter:\n");
		read_2(M,N,puzzle);
	}
}


struct storage{
	vector<int> p;
};

const int FILENUM = 100;
storage f[FILENUM];

// M*N puzzle
void read_MxN(int M,int N, int puzzle[]){
	const int FILENUM = 100;
	char c;
	string s;
	map<string,storage> puzzlefile;
	storage TEMP; 
	bool flag1 = true; // check whether save the file or not
	bool flag2 = true; // check wheteher char c was correctly read.
	int origin[M*N], mark = 0; int n = 0; 
	for (int i=0; i<M*N; i++)
		origin[i] = puzzle[i];
	bool solved = false;
	while (true){
		cin >> c;
		if (!cin.fail()){
			switch(c){
				case 'W':
				case 'w':
				case 'A':
				case 'a':
				case 'S':
				case 's':
				case 'D':
				case 'd':
					change(M,N,puzzle,c);
					system("cls");
					print_instruction();
					print_puzzle(M,N,puzzle);
					break;
				case 'R':
				case 'r':
					puzzle = origin;
					system("cls");
					print_instruction();
					print_puzzle(M,N,puzzle);
					cout << "Restart the game!\n" ;
					break;
				case 'G':
				case 'g':
					cin.sync();
					save_pic(M,N,puzzle);
					break;
				case 'I':
				case 'i':
					cin.sync();
					flag1 = flag2 = true;
					if (mark == FILENUM-1){
						cout << "Storage Maximum. Override previous file? [y/n]:  " ;	
							while (flag2){
							cin >> c;
							switch(c){
								case 'Y':
								case 'y':
									flag2 = false;
									cout << "Please enter the file name:\n";
									break;
								case 'N':
								case 'n':
									flag1 = false;
									flag2 = false;
									break;
								default :
									print_error("You've entered a wrong instruction!\n");
							}					
						}
					}
					if (flag1){
						cout << "Enter file name: ";
						getline(cin,s);
						//判断是否挡案已存 
						if (puzzlefile.count(s) != 0 ){
							cout << "File already exists. Override? [y/n]:  " ;
							while (flag2){
								cin >> c;
								switch(c){
									case 'Y':
									case 'y':
										flag2 = false;
										break;
									case 'N':
									case 'n':
										flag1 = false;
										flag2 = false;
										break;
									default :
										print_error("You've entered a wrong instruction!\n");
								}
							}
						}
					}
					if (flag1){
						for(int i=0; i<M*N; i++)
							f[mark].p.push_back(puzzle[i]);
						puzzlefile[s] = f[mark];
						mark = (++mark) % FILENUM; //the previous file will be overrided if mark>FILENUM
						cout << "File Saved.\n\n";
					}
					break;
				case 'O':
				case 'o':
					cin.sync();
					cout << "Enter file name: ";
					getline(cin,s);
					if (puzzlefile.count(s) != 0){
						TEMP = puzzlefile[s];
						for (int i=0; i<M*N; i++)
							puzzle[i] = TEMP.p[i];
						system("cls");
						print_instruction();
						print_puzzle(M,N,puzzle);
						cout << "File successfully read.\n" ;
					}else {
						print_error("File Not Found!\n");
					}		
					break;
				case 'L':
				case 'l':
					n = 0;
					if (puzzlefile.size() == 0)
						cout << "No Files saved";
					else{
						for (auto it = puzzlefile.begin(); it != puzzlefile.end(); it++ )
							cout << "\tFile_" << ++n << ": "  << it->first << endl;
						}
					break;
				case 'F':
				case 'f':
					//automatical solve
					if (can_solve(M,N,puzzle)){
						vector<char> ans;
						long long step = autosolve(M,N,puzzle,ans);
						cout << "Total steps:" << step << endl;
						Sleep(2000); 
					}else 
						printf("The puzzle is unsolvable!\n\n");
					break;
				case 'P':
				case 'p':
					return ;
					break;
				default :
					print_error("You've entered a wrong instruction!\nPlease re-enter:\n");
					break;
			}
		solved = check_solved(M,N,puzzle);
		if (solved)
			cout << "Congratulations! You've solved the puzzle!\n\n";
		}
	}
}

//3*3puzzle   
void read_3x3(int puzzle[], int M=3, int N=3){
	const int FILENUM = 100;
	char c; 
	string s;
	map<string, storage> puzzlefile;
	storage TEMP;
	bool flag1 = true; // check whether save the file or not
	bool flag2 = true; // check wheteher char c was correctly read.
	int origin[3*3], mark = 0; int n = 0; 
	for (int i=0; i<3*3; i++)
		origin[i] = puzzle[i];
	bool solved = false;
	while (true){
		cin >> c;
		if (!cin.fail()){
			switch(c){
				case 'W':
				case 'w':
				case 'A':
				case 'a':
				case 'S':
				case 's':
				case 'D':
				case 'd':
					change(M,N,puzzle,c);
					system("cls");
					print_instruction();
					print_puzzle(M,N,puzzle);
					break;
				case 'R':
				case 'r':
					puzzle = origin;
					system("cls");
					print_instruction();
					print_puzzle(M,N,puzzle);
					break;
				case 'G':
				case 'g':
					cin.sync();
					save_pic(3,3,puzzle);
					break;
				case 'I':
				case 'i':
					cin.sync();
					flag1 = flag2 = true;
					if (mark == FILENUM-1){
						cout << "Storage Maximum. Override previous file? [y/n]:  " ;	
							while (flag2){
							cin >> c;
							switch(c){
								case 'Y':
								case 'y':
									flag2 = false;
									cout << "Please enter the file name:\n";
									break;
								case 'N':
								case 'n':
									flag1 = false;
									flag2 = false;
									break;
								default :
									print_error("You've entered a wrong instruction!\n");
							}					
						}
					}
					if (flag1){
						cout << "Enter file name: ";
						getline(cin,s);
						//判断是否挡案已存 
						if (puzzlefile.count(s) != 0 ){
							cout << "File already exists. Override? [y/n]:  " ;
							while (flag2){
								cin >> c;
								switch(c){
									case 'Y':
									case 'y':
										flag2 = false;
										break;
									case 'N':
									case 'n':
										flag1 = false;
										flag2 = false;
										break;
									default :
										print_error("You've entered a wrong instruction!\n");
								}
							}
						}
					}
					if (flag1){
						for(int i=0; i<3*3; i++)
							f[mark].p[i] = puzzle[i];
						puzzlefile[s] = f[mark];
						mark = (++mark) % FILENUM; //the previous file will be overrided if mark>FILENUM
						cout << "File Saved.\n\n";
					}
					break;
				case 'O':
				case 'o':
					cin.sync();
					cout << "Enter file name: ";
					getline(cin,s);
					if (puzzlefile.count(s) != 0){
						TEMP = puzzlefile[s];
						for (int i=0; i<3*3; i++)
							puzzle[i] = TEMP.p[i];
						system("cls");
						print_instruction();
						print_puzzle(M,N,puzzle);
					}else {
						print_error("File Not Found!\n");
					}		
					break;
				case 'L':
				case 'l':
					n = 0;
					if (puzzlefile.size() == 0)
						cout << "No Files saved";
					else{
						for (auto it = puzzlefile.begin(); it != puzzlefile.end(); it++ )
							cout << "\tFile_" << ++n << ": "  << it->first << endl;
						}
					break;
				case 'F':
				case 'f':
					//automatical solve
					if (can_solve(M,N,puzzle)){
						vector<char> ans;
						int step = autosolve_3x3(puzzle,ans);
						cout << "Total steps:" << step << endl;
						Sleep(2000); 
					}else 
						printf("The puzzle is unsolvable!\n\n");
					break;
				case 'P':
				case 'p':
					return ;
					break;
				default :
					print_error("You've entered a wrong instruction!\nPlease re-enter:\n");
					break;
			}
		solved = check_solved(3,3,puzzle);
		if (solved)
			cout << "Congratulations! You've solved the puzzle!\n\n";
		}
	}
}
