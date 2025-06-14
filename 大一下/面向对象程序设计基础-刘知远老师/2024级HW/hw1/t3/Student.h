#pragma once
#include <string>
class Student{
public:
    std::string name;
    int presentTimes;
    int classNumber;
    Student(){}
    
    Student(std::string s):name(s), presentTimes(0), classNumber(0){}
    std::string getName(){
        return name;
    }
    int getPresentTimes(){
        return presentTimes;
    }
    int getAbsentTimes(){
        return classNumber - presentTimes;
    }
};