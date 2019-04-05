/*
2016011446 翁家翌
2016011440 孙钊乐
*/

#include <bits/stdc++.h>
#define READ "data1.txt"
/*
UFRDBL
012345
YRGWOB
WGRYBO
*/
const int N=200010;
const int K=9;
const char *cna="UFRDBL";
char can[128];
const int block[]={
 8, 8, 8, 8, 8, 8, 8, 8, 8,
17,17,17,17,17,17,17,17,17,
26,26,26,26,26,26,26,26,26,
35,35,35,35,35,35,35,35,35,
44,44,44,44,44,44,44,44,44,
53,53,53,53,53,53,53,53,53};
const int pr2[6][9]={
	{ 9,10,11,16,17,12,15,14,13},
	{38,39,40,37,44,41,36,43,42},
	{18,19,20,25,26,21,24,23,22},
	{47,48,49,46,53,50,45,52,51},
	{ 0, 1, 2, 7, 8, 3, 6, 5, 4},
	{33,34,27,32,35,28,31,30,29}
};
const int pr3[9][13]={
	{-2,-2,-2, 0, 1, 2,-1},
	{-2,-2,-2, 7, 8, 3,-1},
	{-2,-2,-2, 6, 5, 4,-1},
	{47,48,49, 9,10,11,18,19,20,38,39,40,-1},
	{46,53,50,16,17,12,25,26,21,37,44,41,-1},
	{45,52,51,15,14,13,24,23,22,36,43,42,-1},
	{-2,-2,-2,33,34,27,-1},
	{-2,-2,-2,32,35,28,-1},
	{-2,-2,-2,31,30,29,-1},
};

const char *allcmd="U \0U2\0Ui\0F \0F2\0Fi\0R \0R2\0Ri\0D \0D2\0Di\0B \0B2\0Bi\0L \0L2\0Li\0y \0y2\0yi\0";

char cmd[N],ans[N],ask[N];
int anslen,add_times;

void addans(const char*a){for(int i=0;a[i];i++)ans[anslen++]=a[i];add_times++;}

class rot
{public:
	int a,b,c,d;
	rot operator+(int x){return (rot){(a+x)%54,(b+x)%54,(c+x)%54,(d+x)%54};}
	rot inverse(){return (rot){a,d,c,b};}
	void run(char nxt,int*C){
		int tmp;
		switch(nxt){
			case 'i':
				tmp=C[a],C[a]=C[b],C[b]=C[c],C[c]=C[d],C[d]=tmp;
				break;
			case '2':
				tmp=C[a],C[a]=C[c],C[c]=tmp,
				tmp=C[b],C[b]=C[d],C[d]=tmp;
				break;
			default:
				tmp=C[a],C[a]=C[d],C[d]=C[c],C[c]=C[b],C[b]=tmp;
		}
	}
}s[6][5],t[13];

class statement
{
public:
	int C[K*6];char last[3];
	
	statement&operator=(const statement&a){
		for(int i=0;i<K*6;i++)C[i]=a.C[i];
		last[0]=a.last[0],last[1]=a.last[1];
	}
#define delay for(int i=clock(),s=clock();i-s<=10000000;i++);
	void execute(const char*cmd,int x=0){
		for(int j=0;cmd[j];j++)
			if(cmd[j]>='A'&&cmd[j]<='Z'){
				for(int k=0;k<5;k++)
					s[can[cmd[j]]][k].run(cmd[j+1],C);
				last[0]=cmd[j];last[1]=cmd[j+1];
				if(x){
					printf("now: %c%c\n",cmd[j],cmd[j+1]),print();
					delay
				}
			}
			else if(cmd[j]=='y'){
				for(int k=0;k<13;k++)
					t[k].run(cmd[j+1],C);
				last[0]=cmd[j];last[1]=cmd[j+1];
				if(x){
					printf("now: %c%c\n",cmd[j],cmd[j+1]),print();
					delay
				}
			}
	}

	void init_random(){
		int len=0;
		for(int i=1;i<=30;i++){
			cmd[len++]=cna[rand()%6];
			if(rand()%3)cmd[len++]="i2"[rand()&1];
		}
		cmd[len++]=0,execute(cmd);
		puts("***");
		for(int i=0;i<6;i++,puts(""))
			for(int j=0;j<9;j++)printf("%c","YRGWOB"[C[pr2[i][j]]]);
		puts("***");
	}

	int init_user(){
		const char *s="input.txt",*na="YRGWOB";
		char t[20],an[128]="";
		for(int i=0;i<6;i++)an[na[i]]=i;
//		printf("Please input the color like \"YRGWOB\"\nY:yellow\nR:red\nG:green\nW:white or black\nO:orange\nB:blue\n");
		//system("gedit input.txt");
		FILE*f=fopen(READ,"r");
		for(int i=0;i<6;i++){
			fscanf(f,"%s",t);
			for(int j=0;j<9;j++)
				C[pr2[i][j]]=an[t[j]];
		}
		fclose(f);
		return 1;
	}

	void init(int x=0){
		for(int i=0;i<K*6;i++)C[i]=i/K;
		if(x)init_random();
		else init_user();
	}

	int check_first_cross(){return (C[14]==C[17]&&C[34]==C[35])+(C[52]==C[53]&&C[32]==C[35])+(C[43]==C[44]&&C[30]==C[35])+(C[23]==C[26]&&C[28]==C[35]);}
	int check_first_layer(){return check_first_cross()+(C[27]==C[35]&&C[24]==C[26])+(C[29]==C[35]&&C[36]==C[44])+(C[31]==C[35]&&C[45]==C[53])+(C[33]==C[35]&&C[15]==C[17]);}
	int check_second_layer(){return (C[12]==C[17]&&C[25]==C[26])+(C[21]==C[26]&&C[37]==C[44])+(C[41]==C[44]&&C[46]==C[53])+(C[50]==C[53]&&C[16]==C[17]);}
	int cnt_third_cross(){return (C[1]==C[8])+(C[3]==C[8])+(C[5]==C[8])+(C[7]==C[8]);}
	int cnt_third_corner(){return (C[0]==C[8])+(C[2]==C[8])+(C[4]==C[8])+(C[6]==C[8]);}
	int check_third_layer_corner(){return (C[18]==C[20])+(C[9]==C[11])+(C[47]==C[49])+(C[38]==C[40]);}
	int check_final_cross(){return (C[9]==C[10])+(C[18]==C[19])+(C[38]==C[39])+(C[47]==C[48]);}
#define in_pos(c,d) (C[17]==C[c]&&C[26]==C[d]||C[17]==C[d]&&C[26]==C[c])
#define in_ex_pos(c,d) (C[17]==C[c]&&C[26]==C[d])
	int find_second_layer(){//12 25
		if(in_ex_pos(12,25))return -1;
		if(in_ex_pos(25,12))return 4;
		if(in_pos(21,37))return 5;
		if(in_pos(41,46))return 6;
		if(in_pos(50,16))return 7;
		if(in_ex_pos(10,5))return 2;
		if(in_ex_pos(3,19))return 3;
		return 0;
	}

	int cnt_third_cross_type(){
		if(cnt_third_cross()==4)return 3;
		if(cnt_third_cross()==0)return 0;
		if(C[3]==C[8]&&C[7]==C[8])return 1;
		if(C[1]==C[8]&&C[7]==C[8])return 2;
		return -1;
	}

	bool checkall(){
		for(int i=0;i<K*6;i++)
			if(C[i]!=C[block[i]])
				return 0;
		return 1;
	}

	void print(){
		const int cc[6]={43,41,42,47,46,44};
		for(int i=0;i<9;i++)
			for(int j=0,flag=1;flag;j++)
				if(pr3[i][j]==-2)putchar(' ');
				else if(pr3[i][j]==-1)puts(""),flag=0;
				else if((pr3[i][j]+1)%K!=0)
					printf("\033[39;%dm \033[0m",cc[C[pr3[i][j]]]);
				else printf("\033[%d;29m%c\033[0m",cc[C[pr3[i][j]]]-10,cna[pr3[i][j]/K]);
		puts("");
	}
}rubik,origin;

bool cmp_2l2(statement&a){return a.find_second_layer()>=2;}
bool cmp_3ct(statement&a){return a.cnt_third_cross_type()>0;}
bool cmp_18_20(statement&a){return a.C[18]==a.C[20];}
bool cmp_18_25(statement&a){return a.C[18]==a.C[25];}
bool cmp_18_26(statement&a){return a.C[18]==a.C[26];}
bool cmp_38_39(statement&a){return a.C[38]==a.C[39];}

bool cmp_first_layer(statement&a,statement&b){
	const int arr[]={13,14,15,22,23,24,27,28,29,30,31,32,33,34,36,42,43,45,51,52,-1};
	for(int i=0;arr[i]!=-1;i++)
		if(a.C[arr[i]]!=b.C[arr[i]])return 1;
	return 0;
}

statement q[N];
int fa[N],son[N];
#define tm ((clock()-c0)/CLOCKS_PER_SEC)
#define bruteforce(a,bool_cmd,int_cmd,limit,neq_cmp)\
int cnt=0;double c0=clock();\
while(a.bool_cmd&&tm<0.1){\
	cnt++;\
	int l=0,r=0,flag=0,max=0,id=-1;q[0]=a;\
	for(;l<=r&&r<=limit&&!flag;l++){\
		for(int i=0;i<54&&!flag;i+=3)\
			if(allcmd[i]!=q[l].last[0]&&r<=limit){\
				q[++r]=q[l],q[r].execute(allcmd+i),fa[r]=l;\
				if(!(q[r].bool_cmd))flag=r;\
				if(neq_cmp(a,q[r]))\
				if(q[r].int_cmd>max||q[r].int_cmd==max&&(rand()&1))\
					max=q[r].int_cmd,id=r;\
			}\
	}\
	if(flag)r=flag;else r=id;\
	for(int i=r;i;i=fa[i])son[fa[i]]=i;\
	for(int i=son[0],j=0;j!=r;i=son[i],j=son[j])addans(q[i].last),q[i].last[1]!=' '?ans[anslen++]=' ':1;\
	a=q[r];\
}

int first_layer_cross(statement&a){
	if(a.check_first_cross()==4)return 1;
	bruteforce(a,check_first_cross()<4,check_first_cross(),100000,cmp_first_layer)
	return a.check_first_cross()==4;
}

int first_layer_corner(statement&a){
	if(a.check_first_layer()==8)return 1;
	bruteforce(a,check_first_layer()<8,check_first_layer(),100000,cmp_first_layer)
	return a.check_first_layer()==8;
}

#define fit(bool_cmp) \
	if(bool_cmp(a)==0){\
		q[1]=a,q[2]=a,q[3]=a;\
		q[1].execute("U ");\
		q[2].execute("U2 ");\
		q[3].execute("Ui ");\
		if(bool_cmp(q[1]))\
			a.execute("U "),addans("U ");\
		else if(bool_cmp(q[2]))\
			a.execute("U2 "),addans("U2 ");\
		else a.execute("Ui "),addans("Ui ");\
	}

void second_layer(statement&a){
	const char *op0="U R Ui Ri Ui Fi U F ";
	const char *op1="Ui Fi U F U R Ui Ri ";
	if(a.check_second_layer()==4)return;
	//one by one
	for(int i=0;i<4;i++){
		int tmp=a.find_second_layer();
		if(tmp!=-1){
			if(tmp>=4){
				if(tmp==5)a.execute("y "),addans("y ");
				if(tmp==6)a.execute("y2 "),addans("y2 ");
				if(tmp==7)a.execute("yi "),addans("yi ");
				a.execute(op0);addans(op0);
				if(tmp==5)a.execute("yi "),addans("yi ");
				if(tmp==6)a.execute("y2 "),addans("y2 ");
				if(tmp==7)a.execute("y "),addans("y ");
				tmp=a.find_second_layer();				
			}
			fit(cmp_2l2)
			tmp=a.find_second_layer();
			if(tmp==2)a.execute(op0),addans(op0);
			else if(tmp==3)a.execute(op1),addans(op1);
		}
		a.execute("y "),addans("y ");
	}
}

void third_layer_cross(statement&a){
	const char*op0="F R U Ri Ui Fi ";
	const char*op1="Ri Ui Fi U F R ";
	if(a.cnt_third_cross()==4)return;
	if(a.cnt_third_cross()==0)a.execute(op0),addans(op0);
	fit(cmp_3ct)
	if(a.cnt_third_cross_type()==1)
		a.execute(op0),addans(op0);
	else
		a.execute(op1),addans(op1);
}

#define layout(checker) \
	for(int i=0;i<8;i++)q[i]=a;\
	q[2].execute("y ");q[3].execute("y ");\
	q[4].execute("y2 ");q[5].execute("y2 ");\
	q[6].execute("yi ");q[7].execute("yi ");\
	q[0].execute(op0);q[1].execute(op1);\
	q[2].execute(op0);q[3].execute(op1);\
	q[4].execute(op0);q[5].execute(op1);\
	q[6].execute(op0);q[7].execute(op1);\
	int id=-1;\
	for(int i=0;i<8&&id<0;i++)\
		if(q[i].checker)id=i;\
	if(id/2==1)a.execute("y "),addans("y ");\
	else if(id/2==2)a.execute("y2 "),addans("y2 ");\
	else if(id/2==3)a.execute("yi "),addans("yi ");\
	if(id&1)a.execute(op1),addans(op1);\
	else a.execute(op0),addans(op0);

void third_layer_corner(statement&a){
	const char *op0="Fi Ui F Ui Fi U2 F ";
	const char *op1="R U Ri U R U2 Ri ";
	if(a.cnt_third_corner()==4)return;
	if(a.cnt_third_corner()!=1){
		layout(cnt_third_corner()==1)
	}
	layout(cnt_third_corner()==4)
}

void final_corner(statement&a){
	const char *op="R2 F2 Ri Bi R F2 Ri B Ri ";
	if(a.check_third_layer_corner()!=4){
		if(a.check_third_layer_corner()==0)//cross
			a.execute(op),addans(op);
		fit(cmp_18_20)
		a.execute(op),addans(op);	
	}
	fit(cmp_18_26)
}

void final_cross(statement&a){
	const char *op0="R Ui R U R U R Ui Ri Ui R2 ";
	const char *op1="R2 U R U Ri Ui Ri Ui Ri U Ri ";
	if(a.check_final_cross()<4){
		if(a.check_final_cross()==0)
			a.execute(op0),addans(op0);
		fit(cmp_38_39)
		q[0]=a,q[0].execute(op0);
		q[1]=a,q[1].execute(op1);
		if(q[0].check_final_cross()==4)
			a.execute(op0),addans(op0);
		else if(q[1].check_final_cross()==4)
			a.execute(op1),addans(op1);
	}
	fit(cmp_18_25)
}

void solve(statement&rubik){
	if(!first_layer_cross(rubik))return;
	if(!first_layer_corner(rubik))return;
	second_layer(rubik);
	third_layer_cross(rubik);
	third_layer_corner(rubik);
	final_corner(rubik);
	final_cross(rubik);
}

void change_ans(char*s,char*t){
	memset(t,0,sizeof t);
	int len=0,cnt=0;char state[128],tmp;
	for(int i=0;i<6;i++)state[cna[i]]=cna[i];
	for(int i=0;s[i];i++)
		if(s[i]=='y'){
			if(s[i+1]=='2')
				std::swap(state['B'],state['F']),std::swap(state['L'],state['R']);
			else if(s[i+1]==' ')
				tmp=state['L'],state['L']=state['F'],state['F']=state['R'],state['R']=state['B'],state['B']=tmp;
			else
				tmp=state['L'],state['L']=state['B'],state['B']=state['R'],state['R']=state['F'],state['F']=tmp;
		}
		else if(s[i]>='B'&&s[i]<='U'){
			t[len++]=state[s[i]],t[len++]=s[i+1];
			if(s[i+1]!=' ')t[len++]=' ';
			cnt++;
		}
//	rubik.execute(t,1);
	t[len++]='Z',t[len++]=' ',t[len++]=0;
	anslen=add_times=0;tmp='A';cnt=12;
	for(int i=0;t[i];i++)
		if(t[i]>='A'&&t[i]<='Z'){
			if(t[i]!=tmp){
				cnt%=4;
				state[0]=tmp,state[1]=' ';
				if(cnt==3)state[1]='i',state[2]=' ',state[3]=0;
				else if(cnt==2)state[2]=tmp,state[3]=' ',state[4]=0,add_times++;
				else state[2]=0;
				if(cnt)addans(state);
				tmp=t[i],cnt=12;
			}
			if(t[i+1]=='i')cnt--;
			else if(t[i+1]=='2')cnt+=2;
			else cnt++;
		}
	ans[anslen++]=0;
}
int least=100000;char outp[1000];
int main(int argc, char const *argv[]){
	srand(time(0));double c0=clock();
	for(int i=0;i<6;i++)can[cna[i]]=i;
	s[0][0]=(rot){0,2,4,6},s[0][1]=s[0][0]+1;
	for(int i=1;i<6;i++)s[i][0]=s[i-1][0]+K,s[i][1]=s[i-1][1]+K;
	s[0][2]=(rot){9,47,38,18},s[0][3]=s[0][2]+1,s[0][4]=s[0][3]+1;
	s[1][2]=(rot){4,24,33,49},s[1][3]=s[1][2]+1,s[1][4]=(rot){6,18,27,51};
	for(int i=2;i<6;i++)
		for(int j=2;j<5;j++)
			s[i][j]=s[i-2][j]+K*2;
	for(int i=0;i<5;i++)
		t[i]=s[0][i],t[5+i]=s[3][i].inverse();
	t[10]=(rot){12,50,41,21},t[11]=(rot){17,53,44,26},t[12]=(rot){16,46,37,25};

	rubik.init(),origin=rubik;rubik.print();
	while(tm<0.5){
		rubik=origin;
		for(int i=rand()&3;i--;addans("y "),rubik.execute("y "));
		solve(rubik);
		if(!rubik.checkall())continue;//return!puts("No solution!");
		change_ans(ans,ask);
		for(int last=add_times;change_ans(ans,ask),last!=add_times;last=add_times);
		if(add_times<least){
			least=add_times;
			strcpy(outp,ans);
		}
		anslen=0;memset(ans,0,sizeof ans);
	}
	rubik=origin;
	printf("need %d moves\n",least);puts(outp);
	rubik.execute(outp);rubik.print();
	return 0;
}