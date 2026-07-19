#include<bits/stdc++.h>
using namespace std;
int main(){
    int n;
    cin>>n;
    long long ans=0;
    priority_queue<long long,vector<long long>,greater<long long>> q;
    for(int i=0;i<n;i++){
        long long x;
        cin>>x;
        q.push(x);
    }
    while(q.size()>1){
        long long a=q.top();
        q.pop();
        long long b=q.top();
        q.pop();
        ans+=a+b;
        q.push(a+b);
    }
    cout<<ans<<endl;
    return 0;
}