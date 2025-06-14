#include <iostream>
#include <vector>
#include <string>
#include "PalString.h"
using namespace std;
int main(){
	vector<PalString*> palstring_list;
	int n, m;
	string str;
	cin >> n;
	getline(cin, str);
	for (int i = 0; i < n; ++i){
		getline(cin, str);
		PalString* palstring = new PalString{str.c_str()};
		palstring_list.push_back(palstring);
	}
	cin >> m;
	for (int i = 0; i < m; ++i){
		int tmp, k, k2;
		cin >> tmp;
		if (tmp == 0){
			cin >> k;
			cout << palstring_list[k]->getString() <<endl;
		}else if (tmp == 1){
			cin >> k;
			getline(cin, str);
			getline(cin, str);
			palstring_list[k]->changeString(str.c_str());
		}else if (tmp == 2){
			cin >> k;
			PalString* palstring = new PalString{*palstring_list[k]};
			palstring_list.push_back(palstring);
		}else{
			cin >> k;
			cout << *palstring_list[k] << endl;
		}
	}
	for (int i = 0; i < palstring_list.size(); ++i){
		delete palstring_list[i];
	}
}