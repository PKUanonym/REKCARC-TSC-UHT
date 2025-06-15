#include "card.h"
#include "cards.h"
#include <iostream>

using namespace std;

int main()
{
	Cards s1;
	Cards s2("two", { 6, 3, 8 });
	Cards s3("three", { 4, 0 });
	Cards s4("four", { 1, 5, 5 });
	cout << s2.count() << endl;
	s3.print();
	s2.merge(s3);
	cout << s2.count() << endl;
	s3.print();
	s1.merge(s3);
	s1.put(Card("zero", 7));
	s1.print();
	s1.merge(s4);
	s2.merge(s1);
	s2.print();
	return 0;
}