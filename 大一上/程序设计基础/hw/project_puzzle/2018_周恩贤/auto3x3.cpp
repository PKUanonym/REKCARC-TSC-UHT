#include "my_function.h"

//利用 BFS求解 
struct Node{
	vector<int> puzzle;
	int p_b; //position of the blank 
	Node *parent; //BFS上层 
	char c; //saving the solution
};

Node* Up(Node *&a){
	if(a->p_b <= 2) //不可往上  
		return nullptr;
	else{
		Node* temp=new Node(*a);
		swap(temp->puzzle[temp->p_b],temp->puzzle[temp->p_b-3]);
		temp->p_b-=3;
		return temp;
	}
}

Node* Down(Node *&a){
	if(a->p_b >= 6) //不可往下 
		return nullptr;
	else{
		Node* temp=new Node(*a);
		swap(temp->puzzle[temp->p_b],temp->puzzle[temp->p_b+3]);
		temp->p_b+=3;
		return temp;
	}
} 

Node* Left(Node *&a){
	if(a->p_b % 3 == 0) //不可往左  
		return nullptr;
	else{
		Node* temp=new Node(*a);
		swap(temp->puzzle[temp->p_b],temp->puzzle[temp->p_b-1]);
		temp->p_b--;
		return temp;
	}
}

Node* Right(Node *&a){
	if(a->p_b % 3 == 2) //不可往右  
		return nullptr;
	else{
		Node* temp=new Node(*a);
		swap(temp->puzzle[temp->p_b],temp->puzzle[temp->p_b+1]);
		temp->p_b++;
		return temp;
	}
}

int autosolve_3x3(int puzzle[], vector<char> &sol){
	cout << "Solving..." << endl;  
	clock_t t1,t2;
	t1=clock();
	Node a,b; //a->原拼图 
	for(int i=0;i<9;i++)
		a.puzzle.push_back(puzzle[i]);
	//要把vector -> int* 
	int* p_a = &(a.puzzle[0]);
	a.p_b = find(3, 3, p_a, -1); 
	a.parent=nullptr;
	
	Node* head = &a;
	Node* end = &b;

	queue<Node*> q;
	q.push(head);
	set<vector<int>> visited; 
	visited.insert(head->puzzle);
	while(!q.empty()){
		Node* root=q.front();
		q.pop();
		if(check_solved(3,3,&(root->puzzle[0]))) {
			end = root;
			break;
		}
		Node* W=Up(root); //W 
		Node* A=Left(root); //A
		Node* S=Down(root); //S
		Node* D=Right(root); //D
		if(W!=nullptr&&visited.find(W->puzzle)==visited.end()){
			W->parent=root;
			W->c = 'W';
			visited.insert(W->puzzle);
			q.push(W);
		}
		if(A!=nullptr&&visited.find(A->puzzle)==visited.end()){
			A->parent=root;
			A->c = 'A';			
			visited.insert(A->puzzle);
			q.push(A);
		}
		if(S!=nullptr&&visited.find(S->puzzle)==visited.end()){
			S->parent=root;
			S->c = 'S';
			visited.insert(S->puzzle);
			q.push(S);
		}
		if(D!=nullptr&&visited.find(D->puzzle)==visited.end()){
			D->parent=root;
			D->c = 'D';
			visited.insert(D->puzzle);
			q.push(D);
		}
	}
	
	Node* p = end;
	vector<Node*> result;
	while(p!=nullptr){
		result.push_back(p);
		sol.push_back(p->c);
		p = p->parent;
	}
	
	reverse(sol.begin(),sol.end());
	int count=1 ;
	int step = result.size()-1;
	for(int i=result.size()-2, j=1; i>=0; i--,j++){
		cout << "Step " << count++ << ": " << sol[j] << endl;
		int* p = &(result[i]->puzzle[0]); //vector<int> -> int*		
		print_puzzle(3,3,p);
	}
	t2=clock();
	cout << "Time used : " << (t2-t1)/(double)(CLOCKS_PER_SEC) << endl;
	cout << "The solution is:";
	for(auto it = sol.begin()+1; it != sol.end(); it++){
		cout << *it << " ";
	}
	cout << endl;
	//change the puzzle
	for (int i=0; i<=9 ;i++){
		puzzle[i] = result[0]->puzzle[i];
	}
	return step;
}

