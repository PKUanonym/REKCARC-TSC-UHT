#include "_Device.h"
#include "_Employee.h"
#include <vector>
Employee::Employee(int id){
    this->id = id;
}
Employee::~Employee(){
    delete profile;
}

class SecPrf: public SecurityProfile{
public:
    SecPrf(Department department){
        this->department = department;
        this->level = 1; //junior
    }
    bool validate(Device *d){
        std::string device_name = d->getName();
        if(d->isUnlocked(accessed)==false)return false;
        if(device_name == "BaseLock" || device_name == "SecurityPanel"){
            if(department == Department::OPTICS_AND_DESIGN)return false;
            return true;
        }else if(device_name == "DataTerminal"){
            if(department == Department::MACRODATA_REFINEMENT && level == 2)
                return true;
            return false;
        }else if(device_name == "OpticalTool"){
            if(department == Department::OPTICS_AND_DESIGN && level == 2)
                return true;
            return false;
        }
        return false;
    }
    void upgradeLevel(){
        if(level == 1){
            level = 2;
        }
    }
    SecurityProfile *clone(){
        SecPrf *new_sec = new SecPrf(this->department);
        new_sec->level = this->level;
        new_sec->accessed = this->accessed;
        return new_sec;
    }
};


class MDRSenior: public Employee{
public:
    MDRSenior(int id): Employee(id){
        this->id = id;
        this->profile = new SecPrf(Department::MACRODATA_REFINEMENT);
        this->profile->upgradeLevel();
    }
    Employee *promote(){
        return this;
    }
    bool accessDevice(Device *d){
        if(this->profile->validate(d)){
            d->execute();
            this->profile->accessed.push_back(d);
        }else{
            if(d->getName() == "OpticalTool")
                std::cout<<"No permission. ACCESS DENIED."<<std::endl;
            else
                std::cout<<"Dependency not met. ACCESS DENIED."<<std::endl;
        }
        return this->profile->validate(d);
    }
    std::string getType()const{
        return std::string("MDR-Senior");
    }
    Department getDepartment()const{
        return Department::MACRODATA_REFINEMENT;
    }
    Employee *clone(){
        Employee *new_emp = new MDRSenior(this->id);
        new_emp->profile = this->profile->clone();
        return new_emp;
    }
};

class MDRJunior: public Employee{
    public:
        MDRJunior(int id): Employee(id){
            this->id = id;
            this->profile = new SecPrf(Department::MACRODATA_REFINEMENT);
        }
        Employee *promote(){
            Employee* new_emp = new MDRSenior(this->id);
            new_emp->profile->accessed = this->profile->accessed;
            return new_emp;
        }
        bool accessDevice(Device *d){
            if(this->profile->validate(d)){
                d->execute();
                this->profile->accessed.push_back(d);
            }else{
                if(d->getName() == "OpticalTool" || d->getName() == "DataTerminal")
                    std::cout<<"No permission. ACCESS DENIED."<<std::endl;
                else
                    std::cout<<"Dependency not met. ACCESS DENIED."<<std::endl;            
            }   
            return this->profile->validate(d);
        }
        std::string getType()const{
            return std::string("MDR-Junior");
        }
        Department getDepartment()const{
            return Department::MACRODATA_REFINEMENT;
        }
        Employee *clone(){
            Employee *new_emp = new MDRJunior(this->id);
            new_emp->profile = this->profile->clone();
            return new_emp;
        }
};
    

class OnDSenior: public Employee{
public:
    OnDSenior(int id): Employee(id){
        this->id = id;
        this->profile = new SecPrf(Department::OPTICS_AND_DESIGN);
        this->profile->upgradeLevel();
    }
    Employee *promote(){
        return this;
    }
    bool accessDevice(Device *d){
        if(this->profile->validate(d)){
            d->execute();
            this->profile->accessed.push_back(d);
        }else{
            std::cout<<"No permission. ACCESS DENIED."<<std::endl;
        }
        return this->profile->validate(d);
    }
    std::string getType()const{
        return std::string("O&D-Senior");
    }
    Department getDepartment()const{
        return Department::OPTICS_AND_DESIGN;
    }
    Employee *clone(){
        Employee *new_emp = new OnDSenior(this->id);
        new_emp->profile = this->profile->clone();
        return new_emp;
    }
};

class OnDJunior: public Employee{
    public:
        OnDJunior(int id): Employee(id){
            this->id = id;
            this->profile = new SecPrf(Department::OPTICS_AND_DESIGN);
        }
        Employee *promote(){
            Employee* new_emp = new OnDSenior(this->id);
            new_emp->profile->accessed = this->profile->accessed;
            return new_emp;
        }
        bool accessDevice(Device *d){
            if(this->profile->validate(d)){
                d->execute();
                this->profile->accessed.push_back(d);
            }else{
                std::cout<<"No permission. ACCESS DENIED."<<std::endl;
            }
            return this->profile->validate(d);
        }
        std::string getType()const{
            return std::string("O&D-Junior");
        }
        Department getDepartment()const{
            return Department::OPTICS_AND_DESIGN;
        }
        Employee *clone(){
            Employee *new_emp = new OnDJunior(this->id);
            new_emp->profile = this->profile->clone();
            return new_emp;
        }
};
    