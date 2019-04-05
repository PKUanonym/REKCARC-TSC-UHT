#include <bits/stdc++.h>
#include "windows.h" 
using namespace std;

void print_error(string s);
void print_title();
void print_instruction();
void run_MxN();
void run_3x3();
void print_menu();
void read_1();
void read_2(int M,int N,int puzzle[]);
void print_puzzle(int M, int N, int puzzle[]);
bool can_solve(int M, int N, int puzzle[]);
void playgame(int M, int N, int puzzle[]);
void change(int M, int N, int puzzle[], char c);
void read_MxN(int M, int N, int puzzle[]);
void read_3x3(int puzzle[],int M, int N);
bool check_solved(int M,int N,int puzzle[]);
int find(int M, int N,int puzzle[],int num);
bool readsize(int &M, int &N);
void reshuffle(int M,int N,int puzzle[],bool mark);
int myrandom(int num);
long long autosolve(int M, int N, int puzzle[], vector<char>& sol);
int autosolve_3x3(int puzzle[], vector<char> &sol);
void read_pic();
void save_pic(int M, int N, int puzzle[]);
