#include "Student.h"
#include "ClassSystem.h"
#include <iostream>
#include <string>

using namespace std;

int main() {

    ClassSystem oop;

    string name;
    int n;
    cin >> n;

    for(int i = 0; i < n; i++) {
        cin >> name;
        Student stu(name);
        oop.addStudent(stu);
    }

    string opt;
    while (cin >> opt) {
        if (opt == "UPDATE"){
            oop.addClassNumber();
            int total;
            cin >> total;
            for (int i = 0; i < total; i++){
                cin >> name;
                oop.signIn(name);
            }
        } else if (opt == "QUERY"){
            for (int i = 0; i < n; i++){
                Student stu = oop.getStudentById(i);
                cout << stu.getName() << " " << stu.getPresentTimes() << " " << stu.getAbsentTimes() << endl;
            }
        } else if (opt == "CHECK"){
            cin >> name;
            Student stu = oop.getStudentByName(name);
            cout << stu.getName() << " " << stu.getPresentTimes() << " " << stu.getAbsentTimes() << endl;
        } else break;
    }

    return 0;
}