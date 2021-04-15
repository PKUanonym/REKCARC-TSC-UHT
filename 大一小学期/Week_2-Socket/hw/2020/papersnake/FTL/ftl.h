#ifndef FTL_H
#define FTL_H
#include <iostream>
#include <vector>
#include <string>
#include <map>
#include <unordered_map>
#include <QList>
typedef std::unordered_map<std::string,std::vector<std::pair<std::string,int>>> CARD_DATA;

void split(const std::string& s,std::vector<std::string>& sv,const char* delim);
std::vector<std::string> split(const std::string& s,const char* delim);

void join(const std::vector<std::string>& s,std::string& sv,const char* c);
std::string join(const std::vector<std::string>& s,const char* c);

template<typename T>
std::map<T,int> make_index(const std::vector<T>& s);

template<typename T>
std::map<T,int> make_count(const std::vector<T>& s);

std::vector<std::string> make_copy(const std::string& c,int n);
std::vector<std::string> make_copy(const std::vector<std::string>& s,int n);

class FTL
{
    CARD_DATA data;
    int CARDS_NUM[15]={4,4,4,4,4,4,4,4,4,4,4,4,4,1,1};
    std::vector<std::string>CARDS_NO_JOKERS = split("3-4-5-6-7-8-9-10-J-Q-K-A-2","-");
    std::vector<std::string>CARD_PAIR = make_copy(CARDS_NO_JOKERS,2);
    std::vector<std::string>CARD_TRIO = make_copy(CARDS_NO_JOKERS,3);
    std::vector<std::string>CARD_FOUR = make_copy(CARDS_NO_JOKERS,4);

    void set_value(CARD_DATA& res,const std::vector<std::string>& cards,const std::string& type,int value);

    void set_value(CARD_DATA& res,const std::string& cards_str,const std::string& type,int value);

    //枚举所有单牌
    void enum_solo(CARD_DATA& res,const std::string& type);

    //枚举所有单顺子
    void enum_solo_chain(CARD_DATA& res,const std::string& type,int length);

    //枚举所有对子
    void enum_pair(CARD_DATA& res,const std::string& type);

    //枚举所有连对
    void enum_pair_chain(CARD_DATA& res,const std::string& type,int length);

    //枚举所有三连和连三
    void enum_tri_chain(CARD_DATA& res,const std::string& type,int length);

    //枚举所有三带一
    void enum_tri_solo(CARD_DATA& res,const std::string& type);

    //枚举所有三带一对
    void enum_tri_pair(CARD_DATA& res,const std::string& type);

    //枚举所有飞机带单
    void enum_tri_chain_solo(CARD_DATA& res,const std::string& type,int length);

    //枚举所有飞机带双
    void enum_tri_chain_pair(CARD_DATA& res,const std::string& type,int length);

    //枚举所有四带二单
    void enum_four_two_solo(CARD_DATA& res,const std::string& type);

    //枚举所有四带二双
    void enum_four_two_pair(CARD_DATA& res,const std::string& type);

    //枚举所有炸弹
    void enum_bomb(CARD_DATA& res,const std::string& type);

    //枚举王炸
    void enum_rocket(CARD_DATA& res,const std::string& type);

    void init();

public:
    std::vector<std::string> CARDS = split("3-4-5-6-7-8-9-10-J-Q-K-A-2-BJ-RJ","-");
    std::map<std::string,int> CARD_IDX= make_index(CARDS);

    FTL();
    int check(const std::vector<std::string>& cards);
    int check(const std::string& str_cards);
    int check(const std::vector<std::string>& cards1,const std::vector<std::string>& cards2,const std::string& type);
    int check(const std::string& str_cards_1,const std::string& str_cards_2,const std::string& type);
    int check(const std::string& str_cards_1,const std::string& str_cards_2);
    std::vector<std::pair<std::string,int>> type(const std::vector<std::string>& cards);
    std::vector<std::pair<std::string,int>> type(const std::string& str_cards);
    std::string to_string(const std::vector<std::string>& cards);
    std::vector<std::string> to_vector(const std::string& str_cards);
    std::vector<std::string> sort_cards(const std::vector<std::string>& cards,bool reverse = false);
    std::vector<std::string> get_cards_byID(const std::vector<int>& cards_id);
    std::vector<std::string> get_cards_byID(const QList<int>& cards_id);
};

class GameStatus{
public:
    int id;
    int last_card_id;
    int step;
    int lord;
    int gamestatus[3]; //3 同意重开
    int round[3]={1,2,3}; //出牌顺序
    QList<int> index[3];
    int player_cards[3]={17,17,17}; //手牌
    bool msg_to_send;
    QString msg;
    QString lastPostCards;
};

#endif // FTL_H
