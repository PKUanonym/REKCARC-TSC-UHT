#pragma once
#include <list>
#include <memory>
#include <iostream>

class MyList
{
private:
	std::shared_ptr<std::list<int> > pt; // a pointer to the real container
	std::list<int>::iterator left, right; // the position of slice is [left, right). 'left' is included, 'right' is excluded.

public:
	MyList(): pt(new std::list<int>()){
		left = pt->begin();
		right = pt->end();
	}

	MyList(const MyList& list){
		left = list.left;
		right = list.right;
		pt = list.pt;
	}


	MyList(MyList& list, int sta, int end){
		left = list.left;
		right = list.left;
		pt = list.pt;
		while(sta--)left++;
		while(end--)right++;
	}

	void append(int i){
		if(right != pt->end())pt->insert(right, i);
		else pt->push_back(i);
		if(left == right)left--;
	}

	int& operator[](int pos)const{
		auto now = left;
		while(pos--)now++;
		return *now;
	}

	MyList&& operator()(int sta, int end){
		MyList* mylist = new MyList(*this, sta, end);
		return std::move(*mylist);
	}

	void output(std::ostream& out)const{
		out << "[";
		if(right != left){
			auto now = left;
			auto last = right;
			last--;
			while(now != last && now != right){
				out<<*now<<",";
				now++;
			}
			out<<*last;
		}
		out << "]";
	}

	friend std::ostream& operator<<(std::ostream& out, const MyList& mylist){
		mylist.output(out);
		return out;
	}

};