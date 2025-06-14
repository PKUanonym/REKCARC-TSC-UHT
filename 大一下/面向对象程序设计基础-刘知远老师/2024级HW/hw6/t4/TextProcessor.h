#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <algorithm>
#include <sstream>
#include <cassert>
#include <cctype>
class TextProcessor {
public:
    // 构造函数
    TextProcessor() : text_("") {}
    TextProcessor(const std::string& text) : text_(text) {}

    // 设置和获取文本
    void setText(const std::string& text);
    std::string getText() const;

    // 基础字符串操作
    std::string removeSpaces();                    // 移除所有空格
    std::string toLowerCase();                     // 转换为小写
    std::string toUpperCase();                     // 转换为大写
    std::string reverse();                         // 反转字符串

    // 字符串查找和替换
    int countOccurrences(const std::string& substr);        // 统计子串出现次数
    std::vector<int> findPositions(const std::string& substr); // 查找所有位置
    std::string replaceAll(const std::string& from, const std::string& to); // 全部替换

    // 字符串分割
    std::vector<std::string> split(char delimiter);        // 按字符分割

    // 字符和单词统计
    int getCharCount();                           // 字符数（包含空格）
    int getCharCountNoSpaces();                   // 字符数（不含空格）
    int getLineCount();                           // 行数

    // 字符串验证
    bool isPalindrome();                          // 是否为回文
    bool isNumeric();                             // 是否为数字
    bool containsOnly(const std::string& charset); // 是否只包含指定字符

    // 格式化功能
    std::string centerAlign(int width, char fillChar = ' '); // 居中对齐
    std::string leftAlign(int width, char fillChar = ' ');   // 左对齐
    std::string rightAlign(int width, char fillChar = ' ');  // 右对齐

private:
    std::string text_;
    bool isDigit(char c) const {
        return c >= '0' && c <= '9';
    }
    bool isAlpha(char c) const {
        return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z');
    }
};