#include <QThread>
#include <cstdio>
#include <cmath>
#include <QDebug>
const int K = 5;
int B[4][K], s[K];
int a[10000000];
int n;

struct Thread : public QThread
{
    void set(int a, int b, int c)
    {
        id = a;
        l = b;
        r = c;
    }

    void run()
    {
        qDebug() << "thread ID : " << currentThreadId();
        int cnt = 0;
        for (int i=l; i<r; i++)
        {
            B[id][a[i]%K]++;
            if (cnt < 3)
            {
                qDebug() << currentThreadId() << " " << a[i]%K;
                cnt++;
            }
        }
    }

    int id, l, r;
} t[4];

int main(int argc, char *argv[])
{
    freopen("q2.txt", "r", stdin);
    qDebug() <<  "q1";
    while (scanf("%d",&a[n])!=EOF)
        n++;
    qDebug() << "q2";
    int q[5];
    for (int i=0; i<4; i++)
        q[i] = n/4*i;
    qDebug() << "q3";
    q[4] = n;
    for (int i=0; i<4; i++)
        t[i].set(i, q[i], q[i+1]);
    qDebug() << "q4";
    for (int i=0; i<4; i++)
        t[i].start();
    qDebug() << "q5";
    for (int i=0; i<4; i++)
        t[i].wait();
    qDebug() << "q6";
    for (int i=0; i<K; i++)
    {
        s[i] = 0;
        for (int j=0; j<4; j++)
            s[i]+=B[j][i];
        qDebug("%d : %d\n", i, s[i]);
    }
    double xx = n*1.0/K;
    double via = 0;
    for (int i=0; i<K; i++)
        via += (s[i]-xx)*(s[i]-xx);
    via/=K;
    via = sqrt(via);
    qDebug() << via;
    return 0;
}
