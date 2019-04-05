#include <bits/stdc++.h>
#define N 101005

using namespace std;

int n,m,a[N],b[N];
void print(){
	printf("%d\n",n);
	for (int i=1;i<=n;++i){
		printf("%d",a[i]);
		if (i<n) putchar(' ');
		else puts("");
	}
	printf("%d\n",m);
	for (int i=1;i<=m;++i){
		printf("%d",b[i]);
		if (i<m) putchar(' ');
		else puts("");
	}
}

bool solve(int *a,int n,int maxa){
	a[n]=0;
	for (int i=n-1;i;--i) a[i]+=a[i+1];
	int mx=maxa,mn=1;
	for (int i=1;i<=n;++i){
		mx=min(mx,maxa-a[i]);
		mn=max(mn,1-a[i]);
	}
	if (mn>mx) return 1;
	int dlt=rand()%(mx-mn+1)+mn;
	for (int i=1;i<=n;++i) a[i]+=dlt;
	return 0;
}

bool flag;
void generator(int mxn,int mxm,int mxa){
	int eps=sqrt(mxn);
	int T=mxa<mxn?5:6;
	printf("%d\n",T);
	for (int t=0;t<T;++t){
		if (t==0){
			n=mxn;
			m=mxn;
			int dlt=rand()%mxa;
			int mod=mxa-dlt;
			for (int i=1;i<=n;++i) b[i]=(a[i]=rand()%mod+1)+dlt;
			if (rand()%2){
				for (int i=1;i<=n;++i) a[i]=mxa+1-a[i];
				for (int i=1;i<=m;++i) b[i]=mxa+1-b[i];
			}
			if (rand()%2) b[n]=rand()%mxa+1;
		}
		else if (t<=2){
			n=mxn-rand()%2*rand()%7;
			m=mxn/2-eps+rand()%(2*eps);
			int dlt=rand()%(mxa/mxn-2)-(mxa/mxn/2-1);
			if (mxa<mxn) dlt=0;
			for (int i=1;i<n;++i) a[i]=dlt;
			for (int j=1;j<m;++j) b[j]=dlt;
			int pos=n-rand()%(n/3);
			if (mxa<mxn){
				int len=rand()%eps;
				for (int i=1;i<=len;++i) b[m-i]=a[pos-i]=rand()%11-5;
			}
			else{
				int len=rand()%eps;
				for (int i=1;i<=len;++i) b[m-i]=a[pos-i]=rand()%(mxa/mxn-2)-(mxa/mxn/2-1);
			}
			if (solve(a,n,mxa)){--t;continue;}
			if (solve(b,m,mxa)){--t;continue;}
		}
		else if(t<=4){
			n=mxn-rand()%2*rand()%7;
			m=mxn/6-eps+rand()%(2*eps);
			int step=rand()%eps+1,dlt=rand()%(mxa/2);
			int mod=mxa-dlt;
			for (int i=1;i<=step;++i){
				b[i]=rand()%mod+1;
				for (int j=i+step;j<=m;j+=step)
					b[j]=b[i];
			}
			b[0]=b[step];
			int x=rand()%step;
			for (int i=1;i<=n;++i) a[i]=b[(i+x)%step]+dlt;
			if (rand()%2){
				for (int i=1;i<=n;++i) a[i]=mxa+1-a[i];
				for (int i=1;i<=m;++i) b[i]=mxa+1-b[i];
			}
			for (int i=rand()%eps;i;--i)
				if (rand()%2) a[rand()%(n/17)+1]=rand()%mxa+1;
				else a[n-rand()%(n/17)]=rand()%mxa+1;
			for (int i=rand()%2;i;--i)
				a[rand()%n+1]=rand()%mxa+1;
		}
		else if (t<=5){
			if (flag==1){
				n=mxn-rand()%7;
				m=1;
				for (int i=1;i<=n;++i) a[i]=rand()%mxa+1;
				for (int i=1;i<=m;++i) b[i]=rand()%mxa+1;
			}
			else{
				n=mxn-rand()%7;
				m=mxn/2-eps+rand()%(2*eps);
				int dlt=rand()%7+1;
				a[1]=rand()%(n/10)+1;
				for (int i=2;i<=n;++i) a[i]=a[i-1]+dlt;
				b[1]=rand()%(n/10)+1;
				for (int i=2;i<=m;++i) b[i]=b[i-1]+dlt;
			}
		}
		if (t&1){
			for (int i=1;i<=n/2;++i) swap(a[i],a[n-i+1]);
			for (int i=1;i<=m/2;++i) swap(b[i],b[m-i+1]);
		}
		print();
	}
}

void work(int type){
	if (type<=2) flag=1;
	else flag=0;
	if (type<=3) generator(100,100,1000);
	else if (type<=5) generator(1000,1000,1e9);
	else if (type<=7) generator(1e5,1e5,100);
	else generator(1e5,1e5,1e9);
}

int main(){
	srand((unsigned int)time(0));
	const int cas=10;
	for (int i=1;i<=cas;++i){
		char fname[233];
		sprintf(fname,"%d.in",i);
		freopen(fname,"w",stdout);
		work(i);
		fclose(stdout);
	}
	return 0;
}
