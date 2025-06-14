#include <iostream>
#include "Pair.h"
#include "Map.h"
using namespace std;

void test(){
    int n, k;
    cin >> n >> k;
    Map map(n);
    const Map & cmap = map;
    int query;
    string key;
    int val;
    for(int i = 0; i < k; ++i){
        cin >> query;
        if(query == 1){
            cin >> key;
            cout << map[key] << endl;
        }
        else if(query == 2){
            cin >> key >> val;
            map[key] = val;
        }
        else if(query == 3){
            cin >> key;
            cout << cmap[key] << endl;
        }
    }
    cout << map.size() << endl;
}

int main(){
    test();
    return 0;
}