/* 
Created in 2016/12/12
Student's number : 2016011446 && 2016011440
Student's name : Weng Jiayi && Sun Zhaole
*/
#include <cstdio>
char s0[10],s1[10];
int case_name,case_dim;

const int io[54]={
9,10,11,16,17,12,15,14,13,
36,37,38,43,44,39,42,41,40,
45,46,47,52,53,48,51,50,49,
18,19,20,25,26,21,24,23,22,
0,1,2,7,8,3,6,5,4,
27,28,29,34,35,30,33,32,31
};
// digit=1 ascii=0

const char *cna="UFRDBL";
const int K=9;

char can[128];

char cmd[300];

class rubik_statement
{
public:
	int C[54];
	
	struct rot
	{
		int a,b,c,d;
		rot operator+(int x){return (rot){(a+x)%54,(b+x)%54,(c+x)%54,(d+x)%54};}
		rot inverse(){return (rot){a,d,c,b};}
		void run(char nxt,int*C)
		{
			int tmp;
			switch(nxt)
			{
				case '\'':
					tmp=C[a],C[a]=C[b],C[b]=C[c],C[c]=C[d],C[d]=tmp;
					break;
				case '2':
					tmp=C[a],C[a]=C[c],C[c]=tmp;
					tmp=C[b],C[b]=C[d],C[d]=tmp;
					break;
				default:
					tmp=C[a],C[a]=C[d],C[d]=C[c],C[c]=C[b],C[b]=tmp;
			}
		}
		void print(){printf("%d %d %d %d\n",a,b,c,d);}
	}s[6][5],t[13];

	void init_rot()
	{
		s[0][0]=(rot){0,2,4,6};
		s[0][1]=s[0][0]+1;
		for(int i=1;i<6;i++)
			s[i][0]=s[i-1][0]+K,s[i][1]=s[i-1][1]+K;
		s[0][2]=(rot){9,47,38,18};
		s[0][3]=s[0][2]+1;
		s[0][4]=s[0][3]+1;
		s[1][2]=(rot){4,24,33,49};
		s[1][3]=s[1][2]+1;
		s[1][4]=(rot){6,18,27,51};
		for(int i=2;i<6;i++)
			for(int j=2;j<5;j++)
				s[i][j]=s[i-2][j]+K*2;

		for(int i=0;i<5;i++)
			t[i]=s[0][i],t[5+i]=s[3][i].inverse();
		t[10]=(rot){12,50,41,21};
		t[11]=(rot){17,53,44,26};
		t[12]=(rot){16,46,37,25};
	}

	void init()
	{
		init_rot();
		const char *cna="RGBOWY";
		char can[128];
		for(int i=0;i<6;i++)can[cna[i]]=i;
		for(int i=0;i<54;i++)
		{
			char c;while(c=getchar(),!(c>='0'&&c<='5'||c>='A'&&c<='Z'));
			if(c>='A'&&c<='Z')c=can[c];else c-='0';
			C[io[i]]=c;
		}
	}
	void execute(const char*cmd)
	{
		for(int j=0;cmd[j];j++)
			if(cmd[j]>='A'&&cmd[j]<='Z')
				for(int k=0;k<5;k++)
					s[can[cmd[j]]][k].run(cmd[j+1],C);
	}

	bool checkall()
	{
		for(int i=0;i<K*6;i++)
			if(C[i]!=i/K)
				return 0;
		return 1;
	}

	void print()
	{
		const char *cna="RGBOWY";
		char can[128];
		for(int i=0;i<6;i++)can[cna[i]]=i;
		for(int i=0;i<54;i++)
		{
			if(i%9==0)
			{
				char tmp=cna[C[i+4]];
				puts(tmp=='R'?"Red":tmp=='G'?"Green":tmp=='B'?"Blue":tmp=='O'?"Orange":tmp=='W'?"White":"Yellow");
			}
			printf("%c",case_name?C[io[i]]+'0':cna[C[io[i]]]);
			if((i+1)%3==0)puts("");
		}
		puts("");
	}
}rubik;

int main(int argc, char const *argv[])
{
	for(int i=0;i<6;i++)
		can[cna[i]]=i;
	FILE *config=fopen("config.ini","r");
	fscanf(config,"%s = %s\n",s0,s1);
	if(s0[0]=='N')case_name=(s1[0]=='d');
	else case_dim=(s1[0]=='2');
	fscanf(config,"%s = %s\n",s0,s1);
	if(s0[0]=='N')case_name=(s1[0]=='d');
	else case_dim=(s1[0]=='2');
	printf("%d %d\n",case_name,case_dim);
	rubik.init();puts("*");rubik.print();
	while(scanf("%s",cmd),cmd[0]=='U'||cmd[0]=='D'||cmd[0]=='F'||cmd[0]=='R'||cmd[0]=='L'||cmd[0]=='B')
	{
		rubik.execute(cmd);
		rubik.print();
	}
	return 0;
}

/*
000000000
111111111
222222222
333333333
444444444
555555555
*/
