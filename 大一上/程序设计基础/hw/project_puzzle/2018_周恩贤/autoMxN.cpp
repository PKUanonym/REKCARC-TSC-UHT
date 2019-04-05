#include "my_function.h" 

bool printout = true;

vector<char> operator+(vector<char> v1, vector<char> v2){
	v1.insert(v1.end(),v2.begin(),v2.end());
	return v1;
}

void auto_change(int M, int N, int puzzle[], char c, vector<char>&sol ){
		change(M, N, puzzle, c);
		sol.push_back(c);
		if (printout){
		system("cls");
		printf("\n\n===============AUTOMATICAL SOLVING=======================\n\n");
		print_puzzle(M,N,puzzle);
		}
//		Sleep(100);
}

void append(int M, int N, int puzzle[], vector<char>&sol, vector<char> s ){
//		vector<char>::iterator it;
		sol = sol + s;
		for(auto it = s.begin(); it != s.end(); it++){
			change(M,N,puzzle,*it); 
			if (printout){
			system("cls");
			printf("\n\n===============AUTOMATICAL SOLVING=======================\n\n");
			print_puzzle(M,N,puzzle);
			}	
		}
}

void move_h(int M, int N, int puzzle[], int c, vector<char>& sol){
	int c_b = find(M, N, puzzle, -1)%N ;
	int d = c_b - c;
	if (d>0)
		for (int i=1; i<=d; i++)
			auto_change(M, N, puzzle, 'A', sol);
			
	else
		for (int i=1; i<= -1*d; i++)
			auto_change(M, N, puzzle, 'D',sol);
}
void move_v(int M, int N, int puzzle[], int r, vector<char>& sol){
	int r_b = find(M, N, puzzle, -1) / N ;
	int d = r_b - r;
	if (d>0)
		for (int i=1; i<=d; i++)
			auto_change(M, N, puzzle, 'W', sol);
	else
		for (int i=1; i<=-1*d; i++)
			auto_change(M, N, puzzle, 'S', sol);
}


//move puzzle[r*N+c] --> i*N+j  note : r >= j
void move(int r, int c, int i, int j, int M, int N, int puzzle[], vector<char>& sol){
	int num = puzzle[r*N+c];
	bool dir; bool same_c = true;
	if (c != j){ //先移動到同一列, 注意空白格不可以在第i行 
		if(find(M,N,puzzle,-1) / N == i) 
			auto_change(M,N,puzzle,'S',sol);
		if (puzzle[i*N+j]==num) return; 
		same_c = false; 
		dir = c < j; 
			if(dir)	
				move_h(M, N, puzzle, c+1, sol); 
			else
				move_h(M, N, puzzle, c-1, sol);
		if (puzzle[i*N+j]==num) return; 
		move_v(M, N, puzzle, r, sol);
		if (puzzle[i*N+j]==num) return; 
		if (r != M-1){ //並非最後一行, 以向下繞圈的方式
			if (dir){
				auto_change(M, N, puzzle, 'A', sol);
				if (puzzle[i*N+j]==num) return; 
				for (int i=2; i<=j-c ; i++){
					vector<char> s = {'S','D','D','W','A'};
					append(M,N,puzzle,sol,s);
				}
				
			} else {
				auto_change(M, N, puzzle, 'D',sol);
				if (puzzle[i*N+j]==num) return; 
				for (int i=2; i<=c-j ; i++){
					vector<char> s = {'S','A','A','W','D'};
					append(M,N,puzzle,sol,s);
				}
			}
		}else {
			if (dir){
				auto_change(M, N, puzzle, 'A', sol); 
				if (puzzle[i*N+j]==num) return; 
				for (int i=2; i<=j-c ; i++){
					vector<char> s = {'W','D','D','S','A'};
					append(M,N,puzzle,sol,s);
				}
			} else { //以向上繞圈 
				auto_change(M, N, puzzle, 'D', sol);
				if (puzzle[i*N+j]==num) return; 
				for (int i=2; i<=c-j ; i++){
					vector<char> s = {'W','A','A','S','D'};
					append(M,N,puzzle,sol,s);
				}
			}	
		}
	}   
	int d_r;
	if (r != i ){  
		d_r = r-i; 	//把空白格移到上方 
		if (same_c){ 
		/*	
			注意,此時移動放是在極端狀況下有特例, 如: 
			64 
			空白  65 , 會把原本移動好的弄掉, 所以要用繞的
		*/
			if (r!=i+1){
				move_v(M, N, puzzle, r-1, sol);
				if (puzzle[i*N+j]==num) return; 
				move_h(M, N, puzzle, c, sol);
				if (puzzle[i*N+j]==num) return; 
			}
			else {
				move_v(M, N, puzzle, r+1, sol);
				if (puzzle[i*N+j]==num) return; 
				move_h(M, N, puzzle, c+1, sol);
				if (puzzle[i*N+j]==num) return; 
				move_v(M, N, puzzle, r-1, sol);
				if (puzzle[i*N+j]==num) return; 
				move_h(M, N, puzzle, c, sol);
				if (puzzle[i*N+j]==num) return; 
			}
		}
		else if (dir){  //這時候空白格在目標左方 
			if (r!=M-1){ //非最後一行,由下繞 S D D W W A ,由下,右邊繞才安全 
				vector<char> s = {'S','D','D','W','W','A'};
				append(M,N,puzzle,sol,s);
				if (puzzle[i*N+j]==num) return; 
			}
			else { //由上繞   W D 
				auto_change(M, N, puzzle, 'W', sol);
				if (puzzle[i*N+j]==num) return; 
				auto_change(M, N, puzzle, 'D', sol);
				if (puzzle[i*N+j]==num) return; 
			}
			auto_change(M, N, puzzle, 'S', sol);
			if (puzzle[i*N+j]==num) return; 
		}
		else{ //這時候空白格在目標右方, 直接 W A
			auto_change(M, N, puzzle, 'W', sol);
			if (puzzle[i*N+j]==num) return; 
			auto_change(M, N, puzzle, 'A', sol);
			if (puzzle[i*N+j]==num) return; 
		}
		//開始以 S, D W W A S 解
		auto_change(M, N, puzzle, 'S', sol);
		for (int i=2 ; i<=d_r; i++){
			vector<char> s = {'D','W','W','A','S'};
			append(M,N,puzzle,sol,s);				
			if (puzzle[i*N+j]==num) return; 			
		}
	} 
}

//把第i行的第n-2, n-1列解完 
void solve_1x2(int M, int N, int puzzle[], vector<char>& sol, int i){
	//注意, 不要讓空白格在第i行
	if(find(M,N,puzzle,-1) / N == i) 
			auto_change(M,N,puzzle,'S',sol); 
	int c[3]; int r[3];
	char ch;
	int pos = find(M,N,puzzle, i*N+N);
	r[2] = pos/N;
	c[2] = pos%N;
	/* 
		為了減少之後特例的發生, 我們採用比較繞的方法, 先把最大的數移到下面
	*/ 
	if(r[2]<i+2){
		move_v(M,N,puzzle,i+2,sol);
		move_h(M,N,puzzle,c[2],sol);
		move_v(M,N,puzzle,r[2]+1,sol);
		auto_change(M,N,puzzle,'W',sol);
		if(c[2]!=N-1){
			for(int k=2; k<=i+2-r[2];k++){ //
				vector<char> s = {'D','S','S','A','W'};
				append(M,N,puzzle,sol,s);
			}
		}else{
			for(int k=2; k<=i+2-r[2];k++){
				vector<char> s = {'A','S','S','D','W'};
				append(M,N,puzzle,sol,s);
			}
		} 
	}
	
	//把第n-2列的數放到 i+1行N-1列, 先移列 (否則移動行的時候就會動到已拚好的）
	//注意不要讓空白格在同一行
	pos = find(M,N,puzzle,i*N+N-1);
	r[1] = pos/N;
	c[1] = pos%N;	
	int r_b = find(M,N,puzzle,-1)/N;
	if (r[1] == r_b)
		auto_change(M,N,puzzle,'S',sol); 
	bool same_c = true;
	if (c[1] != N-1){
		same_c = false;
		move_h(M,N,puzzle,c[1]+1,sol);
		move_v(M,N,puzzle,r[1],sol);
		 //以A S D D W A 解, 如果在最後一行就 A W D D S A 
		auto_change(M, N, puzzle, 'A', sol);
		pos = find(M,N,puzzle,i*N+N-1);
		r[1] = pos/N;
		c[1] = pos%N;	
		int d = N-1 - c[1];
		for (int i=1; i <= d; i++ ){
			if(r[1] != M-1){
				vector<char> s = {'S','D','D','W','A'};		
				append(M,N,puzzle,sol,s);
			}else {
				vector<char> s = {'W','D','D','S','A'};
				append(M,N,puzzle,sol,s);
			}			
		}
	}
	//在移到第i+1行, 唯一特例是在目標數字已在第i行
	if (r[1]!= i+1){
		//把空白格統一移到左方 
		if (same_c){
			move_h(M,N,puzzle,N-1,sol);
			move_v(M,N,puzzle,r[1],sol);
		}
		if (r[1] == i){ //S D W A S  解完  ,最後將空白格移到第i+1行以確保不會動到已經解好的前i行   
			vector<char> s = {'S','D','W','A','S'};
			append(M,N,puzzle,sol,s);					
		}
		else {  
			auto_change(M, N, puzzle, 'W', sol);
			auto_change(M, N, puzzle, 'D', sol); //將空白格移到上方 
			auto_change(M, N, puzzle, 'S', sol);
			int d = r[1] - (i+1) ;// 以 A W W D S解完  
			for (int i=2; i<=d; i++){
			vector<char> s = {'A','W','W','D','S'};
			append(M,N,puzzle,sol,s);			
			}
		}
	}
	//把第i行n-1行的數移動到第i+2行N-1列,  
	//有一個特例是他在第i行N-1列, 先特判, 把空白格移動到第i行, 第N-2列接 下來以 "D S A W D S S A W W D S S A W D S A" 解
	//［超重要］因為移動後拼圖已打亂，要再重新判斷位置． 
	same_c = true;
	int temp = find(M,N,puzzle,i*N+N);
	r[2] = temp / N;
	c[2] = temp % N; 
	if (r[2] == i && c[2] == N-1){ 
	//先把空白格移動到第i行, 第N-2列 
		move_h(M,N,puzzle,N-2,sol);
		move_v(M,N,puzzle,i,sol);
		//接下來以 "D S A W D S S A W W D S S A W D S A" 解 
		vector<char> s = {'D','S','A','W','D','S','S','A','W','W','D','S','S','A','W','D','S','A'};
		append(M,N,puzzle,sol,s);
	}
	else{  //移動到第N-1行 
		int r_b = find(M,N,puzzle,-1)/N;
		if (c[2] != N-1){
			same_c = false;
			//不要讓空白同一行
			if (r[2] == r_b)
				auto_change(M,N,puzzle,'S',sol);
			/*
				注意 這個寫法一樣有問題 
				Ex   空白  9
					  10	    會把已經排好的9打亂  
			*/
			if(c[2]!=N-2){
				move_h(M,N,puzzle,c[2]+1,sol);
				move_v(M,N,puzzle,r[2],sol);
			}else 
			{
				if(r[2]!=i+2){
					move_v(M,N,puzzle,r[2]-1,sol);
					move_h(M,N,puzzle,c[2]+1,sol);
					move_v(M,N,puzzle,r[2],sol);			
				}else {
					move_h(M,N,puzzle,c[2]-1,sol);
					move_v(M,N,puzzle,r[2]+1,sol);		
					move_h(M,N,puzzle,c[2]+1,sol);	
					move_v(M,N,puzzle,r[2],sol);			
				}
			}
		 //以A S D D W A 解, 如果在最後一行就 A W D D S A 
			auto_change(M, N, puzzle, 'A', sol);
			for (int i=2; i<= N-1-c[2]; i++ ){
				if(r[2] != M-1){
					vector<char> s = {'S','D','D','W','A'};		
					append(M,N,puzzle,sol,s);
				}else {
					vector<char> s = {'W','D','D','S','A'};
					append(M,N,puzzle,sol,s);
				}			
			}
		}
		//再移到第i+2行 
		if (r[2]!= i+2){
			if (same_c){
				move_h(M,N,puzzle,N-2,sol);
				move_v(M,N,puzzle,r[2],sol);
			}
			auto_change(M, N, puzzle, 'W', sol);
			auto_change(M, N, puzzle, 'D', sol); //將空白格移到上方 
			auto_change(M, N, puzzle, 'S', sol);
			int d = r[2] - (i+2) ;// 以 A W W D S解完  
			for (int i=2; i<=d; i++){
			vector<char> s = {'A','W','W','D','S'};
			append(M,N,puzzle,sol,s);			
			}
		}
	}
	//最後拼起來 
	move_h(M, N, puzzle, N-2, sol);
	move_v(M, N, puzzle, i, sol);
	vector<char> s = {'D','S','S','A','W','W','D','S'};
	append(M,N,puzzle,sol,s) ;
}


void solve_2x1(int M, int N, int puzzle[], vector<char>& sol){
	//解第i列的小方塊 , 直到N-3 
	int pos1,c1,r1,pos2,c2,r2;
	for(int i=0; i<=N-3 ;i++){
		pos1 = find(M,N,puzzle,(M-2)*N+i+1); r1 = pos1/N; c1 = pos1%N;
		if (r1 != M-1){ //r1 == M-2
			move_v(M,N,puzzle,M-1,sol);
			move_h(M,N,puzzle,c1,sol);
			auto_change(M,N,puzzle,'W',sol);
		}
		if (c1 != i){
			move_v(M,N,puzzle,M-2,sol);
			move_h(M,N,puzzle,c1-1,sol);
			move_v(M,N,puzzle,M-1,sol);
			auto_change(M,N,puzzle,'D',sol); c1--;
			while(c1 != i){
				vector<char> s = {'W','A','A','S','D'};
				append(M,N,puzzle,sol,s);
				c1--;
			}
		}
//		print_puzzle(M,N,puzzle); Sleep(1000);
		pos2 = find(M,N,puzzle,(M-1)*N+i+1); r2 = pos2/N; c2 = pos2%N;
		if (r2 == M-2 && c2 == i){ //ASDDWASAWDSDWASDWAASD 
			move_v(M,N,puzzle,M-2,sol);
			move_h(M,N,puzzle,i+1,sol);
			vector <char> s = {'A','S','D','D','W','A','S','A','W','D','S','D','W','A','S','D','W','A','A','S','D'};
			append(M,N,puzzle,sol,s);
		}else if (r2 == M-2 && c2 == i+1 && puzzle[(M-2)*N+i] == -1){
			vector <char> s = {'S','D','D','W','A','S','A','W','D','S','D','W','A','S','D','W','A','A','S','D'};
			append(M,N,puzzle,sol,s);			
		}else{
			if (r2 != M-1){
				move_h(M,N,puzzle,i+1,sol);
				move_v(M,N,puzzle,M-1,sol);
				move_h(M,N,puzzle,c2,sol);
				auto_change(M,N,puzzle,'W',sol);			
			}
			if (c2 != i+1){
				move_v(M,N,puzzle,M-2,sol);
				move_h(M,N,puzzle,c2-1,sol);
				move_v(M,N,puzzle,M-1,sol);
				auto_change(M,N,puzzle,'D',sol); c2--;
				while(c2 != i+1){
					vector<char> s = {'W','A','A','S','D'};
					append(M,N,puzzle,sol,s);
					c2--;
				}
			}
		}
		if(puzzle[(M-2)*N+i] != (M-2)*N+i+1){
			move_v(M,N,puzzle,M-2,sol);
			move_h(M,N,puzzle,i,sol);
			auto_change(M,N,puzzle,'S',sol);
			auto_change(M,N,puzzle,'D',sol);
		}
	//	print_puzzle(M,N,puzzle); Sleep(1000);
	}
}

long long autosolve(int M, int N, int puzzle[], vector<char>& sol){
	printout = true;
	if( M*N >= 600){
		cout << "The solution is too complex ! Still print out the solution? [y/n]: " << endl;
	}else {
		cout << "Print out the solution? [y/n]: " << endl;
	}
	char c;
	cin >> c;
	switch(c){
		case 'Y':
		case 'y':
			printout = true;
			break;
		case 'N':
		case 'n':
			printout = false;
			break;
	}
	clock_t t1, t2; //计时用 
    t1 = clock(); 
	long long step = 0;
//	cout << "Solving:..." << endl;
	//求解前0~m-4行 
	for (int i=0; i<=M-4; i++){
		//先解前0~n-2列 
		system("cls"); 
		printf("\n\n===============AUTOMATICAL SOLVING=======================\n\n");
		cout << "\tSolving the #" << i+1 << " row" << endl;
		Sleep(1000*printout);
		for (int j=0; j<=N-3; j++){ //把數字為i*N+j+1的塊移動到 i*N+j 
			int num = i*N+j+1;   
			while (puzzle[i*N+j] != num){
				int pos = find(M, N, puzzle, num); //注意到找到的位直一定在目標位置的下方
				int r = pos / N;
				int c = pos % N;  
				move(r, c, i, j, M, N, puzzle, sol);
			}
		} 
		//接下來解第, n-2, n-1列,  
		bool correct = true;
		solve_1x2(M, N, puzzle, sol, i);
		for (int k=(i+1)*N-3; k<=(i+1)*N-1; k++){
			if (puzzle[k]!=k+1){
				correct = false;
				break;
			}
		}
		if(!correct){
			vector<char> s = {'A','W','D','S'};
			append(M, N, puzzle, sol, s);
		} 
		bool check = true; 
		for (int k=0; k<=N-1; k++){
			if (puzzle[i*N+k] != i*N+k+1) {
			check = false;
			break; 
			}
		}
		if(check){
				if(printout){
					print_puzzle(M,N,puzzle);
				cout << "The solution of row #" << i+1 << " is:" <<endl; 
				Sleep(1000*printout); 
				for (vector<char>::iterator it = sol.begin(); it != sol.end(); it++){
					cout << *it << " ";
					step ++ ;
				}
			}else{
				step += sol.size();
			}
//			cout << endl << endl;
			sol.clear();
			Sleep(2000*printout);
		}
	}
	//解最後三行
	if(M>=3) {
		int i = M-3;
		system("cls");
		printf("\n\n===============AUTOMATICAL SOLVING=======================\n\n");
		cout << "\tSolving the last three row" << endl;
		for (int j=0; j<N-2; j++){ //把數字為i*N+j+1的塊移動到 i*N+j 
			int num = i*N+j+1;   
			while (puzzle[i*N+j] != num){
				int pos = find(M, N, puzzle, num); 	
				int r = pos / N;
				int c = pos % N;  
				move(r, c, i, j, M, N, puzzle, sol);
			}	
		}
			int num = (i+1)*N;
			while (puzzle[i*N+N-2] != num) {
				int pos = find(M, N, puzzle, num); 	
				int r = pos / N;
				int c = pos % N;  
				move(r, c, i, N-2, M, N, puzzle, sol);
			}
			num = (i+1)*N-1;	
			int pos = find(M,N,puzzle,num); 
			int r = pos / N; int c = pos % N;
			if (r == M-3 && c == N-1){
				move_h(M,N,puzzle,N-2,sol);
				move_v(M,N,puzzle,M-2,sol);
				vector<char> s = {'W','D','S','S','A','W','D','S','A','W','W','D','S','A','W','D','S','S','A','W','W','D','S','S'};
				append(M,N,puzzle,sol,s);
			}
			else{
				num = (i+1)*N-1;
				while (puzzle[(M-2)*N+N-2] != num){
					int pos = find(M,N,puzzle,num); r = pos/N; c = pos%N;
					move(r,c,M-2,N-2,M,N,puzzle,sol); 					
				}
				move_v(M,N,puzzle,M-1,sol);  
				move_h(M,N,puzzle,N-1,sol); 
				move_v(M,N,puzzle,M-3,sol);  
				auto_change(M,N,puzzle,'A',sol); 
				auto_change(M,N,puzzle,'S',sol);
			}
	}
	//求解最后两行 
	solve_2x1(M,N,puzzle,sol);
	//2*2必定有解 
	move_h(M,N,puzzle,N-1,sol);
	move_v(M,N,puzzle,M-1,sol);
	while (puzzle[M*N-2]!= M*N-1 || puzzle[(M-1)*N-1]!=(M-1)*N || puzzle[(M-1)*N-2]!=(M-1)*N-1){
		vector<char> s = {'A','W','D','S'};
		append(M,N,puzzle,sol,s);
	}
  	t2 = clock();
    printf("Time used: %lf (ms)\n", (t2-t1)/(double)(CLOCKS_PER_SEC));

	if(printout){
		cout << "The solution of the last three line is:" <<endl;
		for(auto it = sol.begin(); it!=sol.end(); it++){
			cout << *it << " ";
			step++;
		}
		Sleep(1000);
	}else {
		step += sol.size(); 
	}
	sol.clear();
	cout << endl << "\n\nAutomatic Solving successful!" << endl << endl ; 
	Sleep(1000);
	print_puzzle(M,N,puzzle);	
	Sleep(1000);
	return step; 
}
