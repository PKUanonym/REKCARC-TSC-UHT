#pragma once
#include <iostream>
#include <vector>
#include <string>
#include "Student.h"
class ClassSystem{
public:
    std::vector<Student> students;
    int classNumber;
    ClassSystem(): classNumber(0){}
    void addStudent(Student stu){
        students.push_back(stu);
    }
    void addClassNumber(){
        classNumber++;
    }
    void signIn(std::string name){
        for(Student& stu : students){
            if(stu.getName() == name){
                stu.presentTimes += 1;
            }
            stu.classNumber = classNumber;
        }
    }
    Student getStudentByName(std::string name){
        for(Student& stu : students){
            if(stu.getName() == name){
                return stu;
            }
        }
        return Student();
    }
    Student getStudentById(int id){return students[id];}
};