#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>
#define LEN 2048
#define PRIMELEN 50
#define DLEN 90
struct BigNumber{
    int len;        // length
    char num[LEN];  // number
    bool neg;       // negative or positive
};

BigNumber ex, ey;   // use in extend euclid

long long num2Long(BigNumber* p){
    long long sum = 0, k = 1;
    for (int i=0; i< p->len; i++){
        if (p->num[i] == 1)
            sum += k;
        k = k << 1;
    }
    //printf("The long number is: %lld\n", sum);
    if (p->neg)
        return -1 * sum;
    else
        return sum;
}

void clearNumber(BigNumber* p){
    p->len = 0;
    for (int i=0; i< LEN; i++)
        p->num[i] = 0;
    p->neg = 0;
}

void long2Num(long long k, BigNumber* x){
    clearNumber(x);
    x->len = 0;
    while (k > 0){
        x->num[x->len] = k & 1;
        x->len ++;
        k = k >> 1;
    }
}
void printNumber(BigNumber* p){
    if (p->neg)
        printf("-");
    for (int i=0; i< p->len; i++)
        printf("%d", p->num[p->len - i - 1]);
    printf("\n");
    
}

bool checkValue(BigNumber* x, long t){
    for (int i=0; i<x->len; i++){
        if (x->num[i] != ((t >> i) & 1)) return false;
    }
    return true;
}




void copyNumber(BigNumber* x, BigNumber* y){
    y->len = x->len;
    y->neg = x->neg;
    for (int i=0; i< LEN; i++)
        y->num[i] = x->num[i];
}
void addNumber(BigNumber* x, BigNumber* y, BigNumber* z){
    clearNumber(z);
    
    //if (x->neg != y->neg)
    //    printf("Different neg inputs of add!!");
    //else
    //    z->neg = x->neg;
    
    
    int len = x->len;
    if (y->len > len) len = y->len;
    
    for (int i=0; i< len; i++){
        z->num[i] += x->num[i];
        z->num[i] += y->num[i];
        if (z->num[i] > 1){
            z->num[i+1] += 1;
            z->num[i] = z->num[i] & 1;
        }
    }
    if (z->num[len] > 0 && len < LEN) len ++;
    z->len = len;
    z->neg = false;
    //printf("The answer after addNumber: ");
    //printNumber(z);

}

void leftShiftNumber(BigNumber* x){
    if (x->len < LEN) x->len ++;
    for (int i=LEN-1; i>0; i--)
        x->num[i] = x->num[i-1];
    x->num[0] = 0;
}

void rightShiftNumber(BigNumber* x){
    if (x->len > 0) x->len --;
    for (int i=0; i<LEN-1; i++)
        x->num[i] = x->num[i+1];
    x->num[LEN-1] = 0;
}

void mulNumber(BigNumber* x, BigNumber* y, BigNumber* z){
    if (checkValue(y,0) || checkValue(x,0)){
        clearNumber(z);
        z->len = 1;
        z->num[0] = 0;
        return;
    }
    BigNumber* s= new BigNumber;
    clearNumber(z);
    copyNumber(x, z);
    
    for (int i=1; i< y->len; i++){
        leftShiftNumber(z);
        if (y->num[y->len-i-1] == 1){
            addNumber(z, x, s);
            copyNumber(s, z);
        }
    }
    
    if (x->neg != y->neg)
        z->neg = true;
    else z->neg = false;
    //printf("The answer after mulNumber: ");
    //printf("\n");
    //printf("The mul\n");
    //printNumber(x);
    //printNumber(y);
    //printNumber(z);
}

void decNumber(BigNumber* x, BigNumber* y){
    copyNumber(x, y);
    y->num[0] --;
    // because the last bit is always 1, so we don't need to judge the higher bit
    // printf("The answer after decNumber: ");
    // printNumber(y);
}

int cmpNumber(BigNumber* x, BigNumber* y){
    for (int i=LEN-1; i>=0; i--){
        if (x->num[i] > y->num[i]) return 1;
        if (x->num[i] < y->num[i]) return -1;
    }
    return 0;
}

void subNumber(BigNumber* x, BigNumber* y, BigNumber* z){ // assume that x > y
    BigNumber* x0 = new BigNumber;
    BigNumber* y0 = new BigNumber;

    if (x->neg && y->neg){  // - -
        if (cmpNumber(x,y) >= 0){
            copyNumber(x, x0);
            copyNumber(y, y0);
            z->neg = true;
        }else{
            copyNumber(x, y0);
            copyNumber(y, x0);
            z->neg = false;
        }
    }
    else if ((!x->neg) && y->neg){  // + -
        addNumber(x, y, z);
        z->neg = false;
        return;
    }
    else if (x->neg && (!y->neg)){  // - +
        addNumber(x, y, z);
        z->neg = true;
        return;
    }
    else{   // + +
        if (cmpNumber(x, y)>=0){
            copyNumber(x, x0);
            copyNumber(y, y0);
            z->neg = false;
        }
        else {
            copyNumber(x, y0);
            copyNumber(y, x0);
            z->neg = true;
        }
    }
    
    z->len = x0->len;
    for (int i=0; i< x0->len; i++){
        if (x0->num[i] < y0->num[i]){
            x0->num[i] += 2;
            x0->num[i+1] -= 1;
        }
        z->num[i] = x0->num[i] - y0->num[i];
    }
    while (z->num[z->len-1] == 0 && z->len >= 1) z->len--;
}

void modNumber(BigNumber* x, BigNumber* y, BigNumber* z){   // no negative consider
    if (cmpNumber(x, y) < 0){
        clearNumber(z);
        copyNumber(x, z);
        return;
    }
    BigNumber* s = new BigNumber;
    clearNumber(s);
    clearNumber(z);
    for (int i=x->len - 1; i>=0; i--){
        leftShiftNumber(z);
        z->num[0] = x->num[i];
        if (cmpNumber(z, y) >= 0){
            subNumber(z, y, s);
            copyNumber(s, z);
        }
    }
    for (int i=LEN-1; i>=0; i--)
        if (z->num[i] != 0){
            z->len = i+1;
            break;
        }
}

void divNumber(BigNumber* x, BigNumber* y, BigNumber* z){

    BigNumber* s = new BigNumber;
    BigNumber* t = new BigNumber;
    clearNumber(s);
    clearNumber(t);
    
    for (int i=x->len-1; i>=0; i--){
        leftShiftNumber(t);
        leftShiftNumber(z);
        t->num[0] = x->num[i];
        z->num[0] = 0;
        if (cmpNumber(t, y) >= 0){
            subNumber(t, y, s);
            copyNumber(s, t);
            z->num[0] = 1;
        }
    }
    while (z->num[z->len-1] == 0 && z->len >= 1) z->len --;
    
    if (x->neg != y->neg)
        z->neg = true;
    else z->neg = false;
}

void expNumber(BigNumber* a, BigNumber* b, BigNumber* n, BigNumber* ans){
    clearNumber(ans);
    long2Num(1, ans);
    
    BigNumber* base = new BigNumber;
    BigNumber* exp = new BigNumber;
    BigNumber* t = new BigNumber;
    BigNumber* tmp = new BigNumber;
    clearNumber(t);
    clearNumber(tmp);
    clearNumber(exp);
    clearNumber(base);
    copyNumber(a, base);
    copyNumber(b, exp);
    while (!checkValue(exp, 0)){
        if (exp->num[0] == 1){
           // printf("The base is: %lld\n", num2Long(base));
            //printf("The ans is: %lld\n", num2Long(ans));
            mulNumber(ans, base, t);
            //printf("The t is: %lld\n", num2Long(t));
            modNumber(t, n, tmp);
            //printf("The tmp is: %lld\n", num2Long(tmp));
            copyNumber(tmp, ans);
        }
        //copyNumber(base, tmp);
        mulNumber(base, base, t);
        modNumber(t, n, tmp);
        copyNumber(tmp, base);
            
        rightShiftNumber(exp);
        //printf("The base is: %lld\n", num2Long(base));
        //printf("The ans is: %lld\n", num2Long(ans));

    }
}

bool corprime(BigNumber* m, BigNumber* d){
    //num2Long(m);
    //num2Long(d);
    
    BigNumber* a = new BigNumber;
    BigNumber* b = new BigNumber;
    BigNumber* t = new BigNumber;
    BigNumber* s = new BigNumber;
    clearNumber(a);
    clearNumber(b);
    clearNumber(t);
    clearNumber(s);
    
    copyNumber(m, a);
    copyNumber(d, b);
    
    while (!checkValue(b, 0)){
        copyNumber(b, t);
        
        modNumber(a, b, s);
        //num2Long(s);
        copyNumber(s, b);
        copyNumber(t, a);
    }
    
    if (checkValue(a, 1))
        return true;
    else return false;
}

void genRSAD(BigNumber* m, BigNumber* d, int len){
    if (len < 1 || len > LEN)
        return;
    
    int k;
    d->len = len;
    d->neg = 0;
    
    d->num[d->len - 1] = 1;
    
    do{
        for (int i=0; i< len-1; i++)
            d->num[i] = rand() % 2;
    } while (!corprime(m, d));
    //printNumber(d);
}

BigNumber genRSAE(BigNumber* a, BigNumber* b){ // extend euclid
    BigNumber m, n, ans, s, t0, t1;
    clearNumber(&m);
    clearNumber(&n);
    clearNumber(&ans);
    clearNumber(&s);
    clearNumber(&t0);
    clearNumber(&t1);
    

    
    if (checkValue(b, 0)){
        ex.len = 1;
        ey.len = 1;
        ex.num[0] = 1;
        ey.num[0] = 0;
        copyNumber(a, &ans);
        return ans;
    } else{
        modNumber(a, b, &s);
        n = genRSAE(b, &s);
        //printf("The a is: %lld\n", num2Long(a));
        //printf("The b is: %lld\n", num2Long(b));
        //printf("The ex is: %lld\n", num2Long(&ex));
        //printf("The ey is: %lld\n", num2Long(&ey));
        copyNumber(&ex, &m);
        copyNumber(&ey, &ex);
        
        divNumber(a, b, &t0);
        //printf("The t0 is: %lld\n", num2Long(&t0));
        mulNumber(&t0, &ey, &t1);
        //printf("The t1 is: %lld\n", num2Long(&t1));
        subNumber(&m, &t1, &ey);
        
        return n;
    }
    
}

void genRandomValue(BigNumber* p, int len){
    if (len == 0 || len > LEN)  // Error return
        return;
    p->neg = false;
    for (int i=0; i< len; i++)
        p->num[i] = rand() % 2;
    p->len=0;
    for(int i=len-1;i>=0;i--){
        if(p->num[i] == 1){
            p->len=i+1;
            break;
        }
    }
}
bool witness1(BigNumber* a,BigNumber* n){
    BigNumber* t = new BigNumber;
    BigNumber* d = new BigNumber;
    BigNumber* x = new BigNumber;
    clearNumber(t);
    clearNumber(d);
    clearNumber(x);
    long2Num(1, d);
    
    BigNumber* tempi = new BigNumber;
    clearNumber(tempi);
    decNumber(n,tempi);
    
    int i = tempi->len-1;
    if(checkValue(tempi,1<<i)){
        //printf("spectial case:\n");
        i--;
    }
    BigNumber* temp1 = new BigNumber;
    BigNumber* temp2 = new BigNumber;
    for(;i>=0;i--){
        clearNumber(x);
        copyNumber(d,x);
        clearNumber(temp1);
        copyNumber(d,temp1);
        clearNumber(temp2);
        mulNumber(d, temp1, temp2);
        clearNumber(d);
        modNumber(temp2,n,d);
        clearNumber(temp1);
        decNumber(n,temp1);
        
        if(checkValue(d,1) && !checkValue(x,1) && cmpNumber(x,temp1)!=0)
            return true;
        if(temp1->num[i]==1){
            clearNumber(temp2);
            mulNumber(d,a,temp2);
            clearNumber(d);
            modNumber(temp2,n,d);
        }
    }
    if(checkValue(d,1)){
        return false;
    }else return true;
}
bool isPrime(BigNumber* p){     // Miller-Rabin
    
    if(checkValue(p,2) || checkValue(p,3)) return true;
    if(checkValue(p,1) || p->num[0] == 0) return false;
    BigNumber* temp1 = new BigNumber;
    BigNumber* temp2 = new BigNumber;
    int length=0;
    for(int i=p->len-1;i>=0;i--){
        if(p->num[i]==1){
            length=i;
            break;
        }
    }
    for(int i=0;i<5;i++){
        
        BigNumber *e = new BigNumber;
        clearNumber(e);
        genRandomValue(e, p->len);
        clearNumber(temp1);
        clearNumber(temp2);
        
        decNumber(p, temp2);
        
        long2Num(1,temp1);
        
        while(!(cmpNumber(e, temp1) == 1 && cmpNumber(temp2, e) == 1)){
            clearNumber(e);                                               
            genRandomValue(e, length);
        }
        if(witness1(e,p)) return false;
    }
    return true;
}

void genRandomPrime(BigNumber* p, int len){
    if (len == 0 || len > LEN)  // Error return
        return;
    
    p->len = len;
    p->neg = false;
    
    p->num[0] = 1;
    p->num[p->len - 1] = 1;
    
    do{
        for (int i=1; i< p->len - 1; i++)
            p->num[i] = rand() % 2;
    } while (! isPrime(p));
    //printNumber(p);
}

int main(){
    char cmd;
    BigNumber p, q, p1, q1, m, n, d, e, tmp;
    
    srand((int)time(0));
    
    BigNumber* a = new BigNumber;
    BigNumber* b = new BigNumber;
    BigNumber* c = new BigNumber;
    BigNumber* k = new BigNumber;
    BigNumber* msg = new BigNumber;
    char file[200];
    char ch;
    FILE* fp;
    long long sum = 0;

    while (1){
        printf("欢迎使用RSA公钥加密程序，请输入您的指令：\n");
        printf("\tR - 初始化设置\n");
        printf("\tC - 加密文件\n");
        printf("\tD - 解密文件\n");
        printf("\tT - 特殊测试\n");
        printf("\tQ - 退出\n");
        printf("请输入您的指令： ");
        scanf("%s", &cmd);
        switch(cmd){
            case 'R':
                printf("初始化中...\n");
                clearNumber(&p);
                clearNumber(&q);
                clearNumber(&n);
                clearNumber(&m);
                clearNumber(&d);
                clearNumber(&e);

                genRandomPrime(&p, PRIMELEN);
                genRandomPrime(&q, PRIMELEN);
                while (cmpNumber(&p, &q) == 0)
                    genRandomPrime(&q, PRIMELEN);
                printf("The p is: %lld\n", num2Long(&p));
                printf("The q is: %lld\n", num2Long(&q));
                
                mulNumber(&p, &q, &n);
                decNumber(&p, &p1);
                decNumber(&q, &q1);
                mulNumber(&p1, &q1, &m);
                //num2Long(&m);
                genRSAD(&m, &d, DLEN);
                
                clearNumber(&ex);
                clearNumber(&ey);
                genRSAE(&m, &d);
                copyNumber(&ey, &e);
                if (e.neg){
                    e.neg = false;
                    subNumber(&m, &e, &tmp);
                    copyNumber(&tmp, &e);
                }
                //printf("The ex is: %lld\n", num2Long(&ex));
                //printf("The ey is: %lld\n", num2Long(&ey));
                
                // num2Long(&p);
                // num2Long(&q);
                // num2Long(&n);
                // num2Long(&p1);
                // num2Long(&q1);
                printf("The n is: ");
                printNumber(&n);
                printf("The m is: ");
                printNumber(&m);
                printf("The d is: ");
                printNumber(&d);
                printf("The e is: ");
                printNumber(&e);
                break;
            case 'C':
                printf("加密文件，请输入需要加密的文件路径：\n");
                clearNumber(msg);
                
                scanf("%s", file);
                fp = fopen(file, "rb");
                if (fp == NULL){
                    printf("File not exist!");
                    break;
                }
                sum = 0;
                msg->len = 1;
                while (!feof(fp)){
                    ch = fgetc(fp);
                    if (ch == -1) continue;
                    msg->num[0] = int(ch) - int('0');
                    leftShiftNumber(msg);
                }
                printNumber(msg);
                //long2Num(sum, msg);
                
                expNumber(msg, &e, &n, c);
                printNumber(c);
                expNumber(c, &d, &n, a);
                //printNumber(a);
                break;
            case 'D':
                printf("解密文件，请输入需要解密的文件：\n");
                clearNumber(msg);
                scanf("%s", file);
                fp = fopen(file, "rb");
                if (fp == NULL){
                    printf("File not exist!");
                    break;
                }
                //msg->len = 1;
                while (!feof(fp)){
                    leftShiftNumber(msg);
                    ch = fgetc(fp);
                    if (ch == -1) continue;
                    msg->num[0] = int(ch) - int('0');
                    
                }
                rightShiftNumber(msg);
                printNumber(msg);
                clearNumber(a);
                expNumber(msg, &d, &n, a);
                printf("实际的明文：");
                printNumber(a);
                break;
            case 'Q':
                printf("感谢使用，再见！");
                return 0;
            case 'T':
                printf("调试过程中特殊测试...\n");
 
                long2Num(5, a);
                long2Num(4, b);
                long2Num(6, k);
                //a->neg = 1;
                //printf("%lld ^ %lld mod %lld \n", num2Long(a), num2Long(b), num2Long(k));
                expNumber(a, &e, &n, c);
                printf("%lld\n", num2Long(c));
                expNumber(c, &d, &n, a);
                //modNumber(a, b, c);
                printf("%lld\n", num2Long(a));

                break;
            default:
                printf("对不起，请输入正确指令！\n");
                break;
        }
    }
    return 0;
}