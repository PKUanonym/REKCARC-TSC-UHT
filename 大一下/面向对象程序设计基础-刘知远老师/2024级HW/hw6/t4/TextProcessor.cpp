#include "TextProcessor.h"
#include <regex>
#include <sstream>
void TextProcessor::setText(const std::string& text){
    text_ = text;
}

std::string TextProcessor::getText() const
{
    return text_;
}

std::string TextProcessor::removeSpaces()
{
    std::regex e(R"([\s])");
    return std::regex_replace(text_, e, "");
}

std::string TextProcessor::toLowerCase()
{
    std::string s = text_;
    for(auto& c: s){
        if(std::isupper(c)){
            c = std::tolower(c);
        }
    }
    return s;
}

std::string TextProcessor::toUpperCase()
{
    std::string s = text_;
    for(auto& c: s){
        if(std::islower(c)){
            c = std::toupper(c);
        }
    }
    return s;
}
std::string TextProcessor::reverse()
{
    std::string s = text_;
    std::reverse(s.begin(), s.end());
    return s;
}

int TextProcessor::countOccurrences(const std::string &substr)
{
    std::string s = text_;
    int cnt = 0;
    while(s.find(substr)!=std::string::npos){
        s = s.substr(s.find(substr) + substr.size());
        cnt++;
    }
    return cnt;
}

std::vector<int> TextProcessor::findPositions(const std::string &substr)
{
    std::vector<int> v;
    std::string s = text_;
    int idx = 0;
    while(s.find(substr)!=std::string::npos){
        idx += s.find(substr);
        s = s.substr(s.find(substr) + substr.size());
        v.push_back(idx);
        idx += substr.size();
    }
    return v;
}

std::string TextProcessor::replaceAll(const std::string &from, const std::string &to)
{
    std::regex e(from);
    return std::regex_replace(text_, e, to);
}

std::vector<std::string> TextProcessor::split(char delimiter)
{
    std::vector<std::string> ss;
    std::stringstream s(text_);
    std::string substr;
    while(std::getline(s, substr, delimiter)){//getline会把最后读进去
        ss.push_back(substr);
    }
    return ss;
}

int TextProcessor::getCharCount()
{
    return text_.size();
}

int TextProcessor::getCharCountNoSpaces()
{
    return removeSpaces().size();
}

int TextProcessor::getLineCount()
{
    int cnt = 0;
    for(auto c: text_){
        cnt += c=='\n';
    }
    return cnt+1;
}

bool TextProcessor::isPalindrome()
{
    std::string s = text_;
    for(auto& c: s){
        if(std::isupper(c)){
            c = tolower(c);
        }
    }
    
    std::regex e(R"([\s])");
    s = std::regex_replace(s, e, "");
    std::string t = s;
    std::reverse(s.begin(), s.end());
    return s==t;
}

bool TextProcessor::isNumeric()
{
    std::regex e(R"(^[+-]?((\d+(\.\d*)?)|(\.\d+))$)");
    return std::regex_match(text_, e);
}

bool TextProcessor::containsOnly(const std::string &charset)
{
    for(auto c: text_){
        if(charset.find(c)==std::string::npos)return false;
    }
    return true;
}

std::string TextProcessor::centerAlign(int width, char fillChar)
{
    std::string v;
    if(width <= text_.size())return text_;
    else{
        if((width - text_.size()) % 2 == 0){
            v.append((width - text_.size()) / 2, fillChar);
            v += text_;
            v.append((width - text_.size()) / 2, fillChar);
        }else{
            v.append((width - text_.size()) / 2, fillChar);
            v += text_;
            v.append((width - text_.size()) / 2 + 1, fillChar);
        }
    }

    return v;
}

std::string TextProcessor::leftAlign(int width, char fillChar)
{
    std::string v;
    if(width <= text_.size())return text_;
    else{
        v += text_;
        v.append((width - text_.size()), fillChar);
    }

    return v;
}

std::string TextProcessor::rightAlign(int width, char fillChar)
{
    std::string v;
    if(width <= text_.size())return text_;
    else{
        v.append((width - text_.size()), fillChar);
        v += text_;
    }

    return v;
}
