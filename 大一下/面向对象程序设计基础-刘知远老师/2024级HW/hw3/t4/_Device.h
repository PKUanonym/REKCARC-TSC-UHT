#pragma once
#include <vector>
#include <iostream>
#include <algorithm>
#include <string>

enum Department
{
    MACRODATA_REFINEMENT,
    OPTICS_AND_DESIGN
};

class Device
{
public:
    virtual bool isUnlocked(const std::vector<Device *> &accessed) = 0;
    virtual void execute() = 0;
    virtual std::string getName() const = 0;
    virtual Department getAllowedDepartment() const = 0;
    virtual ~Device() = default;
};