#include <iostream>
#include <vector>
#include <unordered_map>
#include "_Employee.h"
#include "_Device.h"
#include "Employee.h"
#include "Device.h"
//Depart
Device *createDevice(int type)
{
    switch (type)
    {
    case 0:
        return new BaseLock();
    case 1:
        return new SecurityPanel();
    case 2:
        return new DataTerminal(3); // DataTerminal 默认容量3TB
    case 3:
        return new OpticalTool();
    default:
        throw std::invalid_argument("Invalid device type");
    }
}

Employee *createEmployee(int dept, int id)
{
    switch (dept)
    {
    case 0:
        return new MDRJunior(id);
    case 1:
        return new MDRSenior(id);
    case 2:
        return new OnDJunior(id);
    case 3:
        return new OnDSenior(id);
    default:
        throw std::invalid_argument("Invalid department");
    }
}

int main()
{
    // 第一阶段：创建员工
    int n;
    std::cin >> n;
    std::unordered_map<int, Employee *> employees;
    for (int i = 0; i < n; ++i)
    {
        int id, dept;
        std::cin >> id >> dept;
        employees[id] = createEmployee(dept, id);
    }

    // 第二阶段：处理操作
    int m;
    std::cin >> m;
    std::vector<Device *> devices = {createDevice(0), createDevice(1), createDevice(2), createDevice(3)};

    for (int i = 0; i < m; ++i)
    {
        int id, op, deviceType;
        std::cin >> id >> op >> deviceType;

        if (employees.find(id) == employees.end())
        {
            std::cerr << "Error: Employee " << id << " does not exist.\n";
            continue;
        }
//clone
        Employee *emp = employees[id];
        if (op == 1)
        { // 晋升操作
            Employee *promotedEmp = emp->promote();//profile
            if (promotedEmp != emp)
            { // 返回新对象
                std::cout << emp->getType() << "(" << id << "): Promoted to " << promotedEmp->getType() << ".\n";
                delete emp; // 删除旧对象
                employees[id] = promotedEmp;
            }
            else//clone
            {
                std::cout << emp->getType() << "(" << id << "): Already at the highest level.\n";
            }
        }
        else
        { // 访问设备
            if (deviceType < 0 || deviceType >= devices.size())
            {
                std::cerr << "Error: Invalid device type.\n";
                continue;
            }
            Device *target = devices[deviceType];
            std::cout << emp->getType() << "(" << id << "): ";
            emp->accessDevice(target);
        }
    }

    // 清理内存
    for (auto &[id, emp] : employees)
        delete emp;
    for (auto d : devices)
        delete d;
    return 0;
}