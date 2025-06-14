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
    // ���캯��
    TextProcessor() : text_("") {}
    TextProcessor(const std::string& text) : text_(text) {}

    // ���úͻ�ȡ�ı�
    void setText(const std::string& text);
    std::string getText() const;

    // �����ַ�������
    std::string removeSpaces();                    // �Ƴ����пո�
    std::string toLowerCase();                     // ת��ΪСд
    std::string toUpperCase();                     // ת��Ϊ��д
    std::string reverse();                         // ��ת�ַ���

    // �ַ������Һ��滻
    int countOccurrences(const std::string& substr);        // ͳ���Ӵ����ִ���
    std::vector<int> findPositions(const std::string& substr); // ��������λ��
    std::string replaceAll(const std::string& from, const std::string& to); // ȫ���滻

    // �ַ����ָ�
    std::vector<std::string> split(char delimiter);        // ���ַ��ָ�

    // �ַ��͵���ͳ��
    int getCharCount();                           // �ַ����������ո�
    int getCharCountNoSpaces();                   // �ַ����������ո�
    int getLineCount();                           // ����

    // �ַ�����֤
    bool isPalindrome();                          // �Ƿ�Ϊ����
    bool isNumeric();                             // �Ƿ�Ϊ����
    bool containsOnly(const std::string& charset); // �Ƿ�ֻ����ָ���ַ�

    // ��ʽ������
    std::string centerAlign(int width, char fillChar = ' '); // ���ж���
    std::string leftAlign(int width, char fillChar = ' ');   // �����
    std::string rightAlign(int width, char fillChar = ' ');  // �Ҷ���

private:
    std::string text_;
    bool isDigit(char c) const {
        return c >= '0' && c <= '9';
    }
    bool isAlpha(char c) const {
        return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z');
    }
};