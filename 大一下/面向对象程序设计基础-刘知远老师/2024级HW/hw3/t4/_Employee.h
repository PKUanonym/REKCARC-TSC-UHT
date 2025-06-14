#pragma once
#include "_Device.h"
#include <vector>
#include <memory>
#include <string>

class SecurityProfile
{
public:
    int level;
    Department department;
    std::vector<Device *> accessed;
    virtual bool validate(Device *d) = 0;
    virtual void upgradeLevel() = 0;
    virtual SecurityProfile *clone() = 0;
    virtual ~SecurityProfile() = default;
};

class Employee
{
protected:
    int id;
public:
    SecurityProfile *profile;
    Employee(int id);
    virtual Employee *promote() = 0; // 返回晋升后的新对象
    virtual bool accessDevice(Device *d) = 0;
    virtual std::string getType() const = 0;
    virtual Department getDepartment() const = 0;
    virtual Employee *clone() = 0;
    virtual ~Employee();
    int getID() const { return id; }
};