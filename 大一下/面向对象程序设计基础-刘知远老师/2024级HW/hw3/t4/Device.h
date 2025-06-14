#include "_Device.h"

class OpticalTool: public Device{
public:
    bool isUnlocked(const std::vector<Device *> &accessed){
        return true;
    }
    void execute(){
        std::cout<<"OpticalTool adjusted.\n";
    }
    std::string getName()const{
        return std::string("OpticalTool");
    }
    Department getAllowedDepartment()const{
        return Department::OPTICS_AND_DESIGN;
    }
};

class DataTerminal: public Device{
public:
    int vol;
    DataTerminal(int v):vol(v){}
    bool isUnlocked(const std::vector<Device *> &accessed){
        for(Device* d: accessed){
            if(d->getName()=="SecurityPanel")return true;
        }
        return false;
    }
    void execute(){
        std::cout<<"Processed "<<vol<<"TB data.\n";
    }
    std::string getName()const{
        return std::string("DataTerminal");
    }
    Department getAllowedDepartment()const{
        return Department::OPTICS_AND_DESIGN;
    }
};

class SecurityPanel: public Device{
public:
    bool isUnlocked(const std::vector<Device *> &accessed){
        for(Device* d: accessed){
            if(d->getName()=="BaseLock")return true;
        }
        return false;
    }
    void execute(){
        std::cout<<"SecurityPanel activated.\n";
    }
    std::string getName()const{
        return std::string("SecurityPanel");
    }
    Department getAllowedDepartment()const{
        return Department::MACRODATA_REFINEMENT;
    }
};

class BaseLock: public Device{
public:
    bool isUnlocked(const std::vector<Device *> &accessed){
        return true;
    }
    void execute(){
        std::cout<<"BaseLock engaged.\n";
    }
    std::string getName()const{
        return std::string("BaseLock");
    }
    Department getAllowedDepartment()const{
        return Department::MACRODATA_REFINEMENT;
    }
};