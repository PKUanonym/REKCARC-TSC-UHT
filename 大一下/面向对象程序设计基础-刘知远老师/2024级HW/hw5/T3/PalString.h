#ifndef PALSTRING_H
#define PALSTRING_H
#include <iostream>
#include <cstring>
class PalString {
public:
   char* data_;    //A character array that stores strings
   int len;
   //TODO [Optional] : define other useful variables

   //TODO: finish the constructor
   PalString(const char* pStr) {
      len = std::strlen(pStr);
      data_ = new char[len + 1];
      for(int i = 0; i< len; ++i)data_[i] = pStr[i];
      data_[len] = '\0';
   }

   //TODO: finish the destructor
   ~PalString(){
      delete[] data_;
   }

   //TODO: finish the function getString
   char * getString(){
      char* str = new char[2 * len + 1];
      for(int i = 0; i< len; ++i){
         str[i] = data_[i];
         str[2 * len - i - 1] = data_[i];
      }
      str[2 * len] = '\0';
      return str;

   }

   //TODO: finish the function changeString
   void changeString(const char* pStr){
      delete[] data_;

      len = std::strlen(pStr);
      data_ = new char[len + 1];
      for(int i = 0; i< len; ++i)data_[i] = pStr[i];
      data_[len] = '\0';
   }

   //TODO: finish the copy constructor
   PalString(const PalString& rhs){
      len = std::strlen(rhs.data_);
      data_ = new char[len + 1];
      for(int i = 0; i< len; ++i)data_[i] = rhs.data_[i];
      data_[len] = '\0';
   }

   //TODO: override the operator <<
   
};
std::ostream& operator<<(std::ostream& out, PalString rhs){
   int i = 0;
   char* str = rhs.getString();
   while(*(str + i)){
      out<<*(str + i++);
   }
   return out;
}
#endif // #ifndef PALSTRING_H