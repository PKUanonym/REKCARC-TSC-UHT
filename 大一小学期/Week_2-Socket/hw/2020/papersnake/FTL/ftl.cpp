#include "ftl.h"

void split(const std::string& s,
    std::vector<std::string>& sv,
    const char* delim) {
    sv.clear();
    char* buffer = new char[s.size() + 1];
    buffer[s.size()] = '\0';
    std::copy(s.begin(), s.end(), buffer);
    char* p = std::strtok(buffer, delim);
    do {
        sv.push_back(p);
    } while ((p = std::strtok(NULL, delim)));
    delete[] buffer;
    return;
}

std::vector<std::string> split(const std::string& s,
    const char* delim) {
    std::vector<std::string> sv;
    sv.clear();
    char* buffer = new char[s.size() + 1];
    buffer[s.size()] = '\0';
    std::copy(s.begin(), s.end(), buffer);
    char* p = std::strtok(buffer, delim);
    do {
        sv.push_back(p);
    } while ((p = std::strtok(NULL, delim)));
    delete[] buffer;
    return sv;
}

void join(const std::vector<std::string>& s,
    std::string& sv,
    const char* c){
        for(const auto &piece:s){
            sv += piece + c;
        }
        sv.erase(sv.end()-1);
        return;
}

std::string join(const std::vector<std::string>& s,
    const char* c){
        std::string sv;
        for(const auto &piece:s){
            sv += piece + c;
        }
        sv.erase(sv.end()-1);
        return sv;
}

template<typename T>
std::map<T,int> make_index(const std::vector<T>& s){
    int i=0;
    std::map<T,int> sv;
    for(auto c:s){
        sv[c] = i++;
    }
    return sv;
}

template<typename T>
std::map<T,int> make_count(const std::vector<T>& s){
    std::map<T,int> sv;
    for(auto c:s){
        ++sv[c];
    }
    return sv;
}

std::vector<std::string> make_copy(const std::string& c,int n){
    std::vector<std::string> sv;
    for(int i=0;i<n;i++){
        sv.push_back(c);
    }
    return sv;
}

std::vector<std::string> make_copy(const std::vector<std::string>& s,int n){
    std::vector<std::string> sv;
    for(const auto& c:s){
        for(int i=0;i<n;i++){
            sv.push_back(c);
        }
    }
    return sv;
}

void FTL::set_value(CARD_DATA& res,const std::vector<std::string>& cards,const std::string& type,int value){
    std::string cards_str = join(sort_cards(cards),"-");
    res[cards_str].push_back(std::make_pair(type,value));
}

void FTL::set_value(CARD_DATA& res,const std::string& cards_str,const std::string& type,int value){
    res[cards_str].push_back(std::make_pair(type,value));
}

std::vector<std::string> FTL::sort_cards(const std::vector<std::string>& cards,bool reverse){
    std::vector<std::string> s_cards(cards);
    sort(s_cards.begin(),s_cards.end(),[&](std::string& x,std::string& y){return reverse?CARD_IDX[x]>CARD_IDX[y]:CARD_IDX[x]<CARD_IDX[y];});
    return s_cards;
}

//枚举所有单牌
void FTL::enum_solo(CARD_DATA& res,const std::string& type){
    int i=0;
    for(auto card:CARDS){
        set_value(res,card,type,++i);
    }
}

//枚举所有单顺子
void FTL::enum_solo_chain(CARD_DATA& res,const std::string& type,int length){
    if(length<5||length>12){
        std::cout << "solo_chain length is in [5,12]"<<std::endl;
        return;
    }
    std::vector<std::string> cards;
    for(int i=0;i<length;i++){
        cards.push_back(CARDS[i]);
    }
    set_value(res, cards, type, 1);
    for(int i=length;i<12;i++){
        cards.erase(cards.begin());
        cards.push_back(CARDS[i]);
        set_value(res, cards, type, i - length + 2);
    }
}

//枚举所有对子
void FTL::enum_pair(CARD_DATA& res,const std::string& type){
    int i=0;
    for(auto card:CARDS_NO_JOKERS){
        set_value(res,make_copy(card,2),type,++i);
    }
}

//枚举所有连对
void FTL::enum_pair_chain(CARD_DATA& res,const std::string& type,int length){
    if(length<3||length>10){
        std::cout << "pair_chain length is in [3,10]"<<std::endl;
        return;
    }
    std::vector<std::string> cards;
    for(int i=0;i<length;i++){
        cards.push_back(CARDS[i]);
        cards.push_back(CARDS[i]);
    }
    set_value(res, cards, type, 1);
    for(int i=length;i<12;i++){
        cards.erase(cards.begin());
        cards.erase(cards.begin());
        cards.push_back(CARDS[i]);
        cards.push_back(CARDS[i]);
        set_value(res, cards, type, i - length + 2);
    }
}

//枚举所有三连和连三
void FTL::enum_tri_chain(CARD_DATA& res,const std::string& type,int length){
    if(length<1||length>6){
        std::cout << "tri_chain length is in [1,6]"<<std::endl;
        return;
    }
    std::vector<std::string> cards;
    for(int i=0;i<length;i++){
        cards.push_back(CARDS[i]);
        cards.push_back(CARDS[i]);
        cards.push_back(CARDS[i]);
    }
    set_value(res, cards, type, 1);
    for(int i=length;i<12;i++){
        cards.erase(cards.begin());
        cards.erase(cards.begin());
        cards.erase(cards.begin());
        cards.push_back(CARDS[i]);
        cards.push_back(CARDS[i]);
        cards.push_back(CARDS[i]);
        set_value(res, cards, type, i - length + 2);
    }
}

//枚举所有三带一
void FTL::enum_tri_solo(CARD_DATA& res,const std::string& type){
    for(int i=0;i<=12;i++){
        for(int j=0;j<=14;j++){
            if(j==i) continue; //四个相同不算
            std::vector<std::string> cards{CARDS[i],CARDS[i],CARDS[i],CARDS[j]};
            set_value(res, cards, type, i+1);
        }
    }
}

//枚举所有三带一对
void FTL::enum_tri_pair(CARD_DATA& res,const std::string& type){
    for(int i=0;i<=12;i++){
        for(int j=0;j<=12;j++){
            if(j==i) continue; //没有五个相同和出现两张大小王的情况
            std::vector<std::string> cards{CARDS[i],CARDS[i],CARDS[i],CARDS[j],CARDS[j]};
            set_value(res, cards, type, i+1);
        }
    }
}

//枚举所有飞机带单
void FTL::enum_tri_chain_solo(CARD_DATA& res,const std::string& type,int length){
    if(length<2||length>5){
        std::cout << "tri_chain length is in [2,5]"<<std::endl;
        return;
    }
    std::vector<std::string> cards;
    for(int i=0;i<length;i++){
        cards.push_back(CARDS[i]);
        cards.push_back(CARDS[i]);
        cards.push_back(CARDS[i]);
    }
    std::function<void(int,int,int,int)> dfs = [&](int value,int c,int d,int step){
        if(c==d){
            set_value(res, cards, type, value);
            return;
        }
        auto count = make_count(cards);
        for(int i=step;i<=14;i++){
            if(count[CARDS[i]]<CARDS_NUM[i]){
                cards.push_back(CARDS[i]);
                dfs(value,c+1,d,i);
                cards.pop_back();
            }
        }
    };
    dfs(1,0,length,0);
    for(int i=length;i<12;i++){
        cards.erase(cards.begin());
        cards.erase(cards.begin());
        cards.erase(cards.begin());
        cards.push_back(CARDS[i]);
        cards.push_back(CARDS[i]);
        cards.push_back(CARDS[i]);
        dfs(i - length + 2,0,length,0);
    }
}

//枚举所有飞机带双
void FTL::enum_tri_chain_pair(CARD_DATA& res,const std::string& type,int length){
    if(length<2||length>4){
        std::cout << "tri_chain length is in [2,4]"<<std::endl;
        return;
    }
    std::vector<std::string> cards;
    for(int i=0;i<length;i++){
        cards.push_back(CARDS[i]);
        cards.push_back(CARDS[i]);
        cards.push_back(CARDS[i]);
    }
    std::function<void(int,int,int,int)> dfs = [&](int value,int c,int d,int step){
        if(c==d){
            set_value(res, cards, type, value);
            return;
        }
        auto count = make_count(cards);
        for(int i=step;i<=14;i++){
            if(count[CARDS[i]]+2<=CARDS_NUM[i]){
                cards.push_back(CARDS[i]);
                cards.push_back(CARDS[i]);
                dfs(value,c+1,d,i);
                cards.pop_back();
                cards.pop_back();
            }
        }
    };
    dfs(1,0,length,0);
    for(int i=length;i<12;i++){
        cards.erase(cards.begin());
        cards.erase(cards.begin());
        cards.erase(cards.begin());
        cards.push_back(CARDS[i]);
        cards.push_back(CARDS[i]);
        cards.push_back(CARDS[i]);
        dfs(i - length + 2,0,length,0);
    }
}

//枚举所有四带二单
void FTL::enum_four_two_solo(CARD_DATA& res,const std::string& type){
    //带两个不同的
    for(int i=0;i<=12;i++){
        for(int j=0;j<=14;j++){
            if(j==i) continue;
            for(int k=0;k<=14;k++){
                if(k==j||k==i) continue;
                std::vector<std::string> cards{CARDS[i],CARDS[i],CARDS[i],CARDS[i],CARDS[j],CARDS[k]};
                set_value(res, cards, type, i+1);
            }
        }
    }
    //带两个相同的
    for(int i=0;i<=12;i++){
        for(int j=0;j<=12;j++){
            if(j==i) continue;
            std::vector<std::string> cards{CARDS[i],CARDS[i],CARDS[i],CARDS[i],CARDS[j],CARDS[j]};
            set_value(res, cards, type, i+1);
        }
    }
}

//枚举所有四带二双
void FTL::enum_four_two_pair(CARD_DATA& res,const std::string& type){
    //带两个不同的
    for(int i=0;i<=12;i++){
        for(int j=0;j<=12;j++){
            if(j==i) continue;
            for(int k=0;k<=12;k++){
                if(k==j||k==i) continue;
                std::vector<std::string> cards{CARDS[i],CARDS[i],CARDS[i],CARDS[i],CARDS[j],CARDS[j],CARDS[k],CARDS[k]};
                set_value(res, cards, type, i+1);
            }
        }
    }
    //带两个相同的
    for(int i=0;i<=12;i++){
        for(int j=0;j<=12;j++){
            if(j==i) continue;
            std::vector<std::string> cards{CARDS[i],CARDS[i],CARDS[i],CARDS[i],CARDS[j],CARDS[j],CARDS[j],CARDS[j]};
            set_value(res, cards, type, i+1);
        }
    }
}

//枚举所有炸弹
void FTL::enum_bomb(CARD_DATA& res,const std::string& type){
    int i=0;
    for(auto card:CARDS_NO_JOKERS){
        set_value(res,make_copy(card,4),type,++i);
    }
}

//枚举王炸
void FTL::enum_rocket(CARD_DATA& res,const std::string& type){
    set_value(res,std::vector<std::string>{CARDS[13],CARDS[14]},type,1);
}

void FTL::init(){
    enum_solo(data,"solo");
    for(int i=5;i<=12;i++){
        enum_solo_chain(data,"solo_chain_"+std::to_string(i),i);
    }
    enum_pair(data,"pair");
    for(int i=3;i<=10;i++){
        enum_pair_chain(data,"pair_chain_"+std::to_string(i),i);
    }
    for(int i=1;i<=6;i++){
        enum_tri_chain(data,"tri_chain_"+std::to_string(i),i);
    }
    enum_tri_solo(data,"tri_solo");
    enum_tri_pair(data,"tri_solo");
    for(int i=2;i<=2;i++){ //这里i<=5会慢一点（
        enum_tri_chain_solo(data, "tri_chain_solo_"+std::to_string(i),i);
    }
    for(int i=2;i<=2;i++){ //i<=4 一样
        enum_tri_chain_pair(data, "tri_chain_pair_"+std::to_string(i),i);
    }
    enum_four_two_solo(data,"four_two_solo");
    enum_four_two_pair(data,"four_two_pair");
    enum_bomb(data, "bomb");
    enum_rocket(data, "rocket");
}

FTL::FTL(){
    init();
}
int FTL::check(const std::vector<std::string>& cards){
    if(data.find(join(sort_cards(cards),"-"))!=data.end())
        return 1;
    return 0;
}
int FTL::check(const std::string& str_cards){
    if(data.find(str_cards)!=data.end())
        return 1;
    return 0;
}
int FTL::check(const std::vector<std::string>& cards1,const std::vector<std::string>& cards2,const std::string& type){
    std::string str_cards_1 = join(cards1,"-"),str_cards_2 = join(cards2,"-");
    if(check(str_cards_1)*check(str_cards_2)==0)
        return 0;
    auto d1 = data[str_cards_1],d2 = data[str_cards_2];
    for(auto i:d1){
        if(i.first==type){
            for(auto j:d2)
                if(j.first==type&&j.second>i.second)
                        return 1;
                else
                    return 0;//由于炸弹只可能是炸弹，所以不会冲突
        }
    }
    //此时两者没有相同类型,则若后出的牌2有炸，则前者无；有火箭，则前者无；均可直接出
    for(auto i:d2)
        if(i.first=="rocket"||i.first=="bomb")
            return 1;
    return 0;
}
int FTL::check(const std::string& str_cards_1,const std::string& str_cards_2){
    if(check(str_cards_1)*check(str_cards_2)==0)
        return 0;
    auto d1 = data[str_cards_1],d2 = data[str_cards_2];
    for(auto i:d1){
            for(auto j:d2)
                if(j.first==i.first&&j.second>i.second)
                    return 1;
                else if(j.first==i.first)
                    return 0;
    }
    //此时两者没有相同类型,则若后出的牌2有炸，则前者无；有火箭，则前者无；均可直接出
    for(auto i:d2)
        if(i.first=="rocket"||i.first=="bomb")
            return 1;
    return 0;
}
int FTL::check(const std::string& str_cards_1,const std::string& str_cards_2,const std::string& type){
    if(check(str_cards_1)*check(str_cards_2)==0)
        return 0;
    auto d1 = data[str_cards_1],d2 = data[str_cards_2];
    for(auto i:d1){
        if(i.first==type){
            for(auto j:d2)
                if(j.first==type&&j.second>i.second)
                    return 1;
                else if(j.first==type)
                    return 0;//由于炸弹只可能是炸弹，所以不会冲突
        }
    }
    //此时两者没有相同类型,则若后出的牌2有炸，则前者无；有火箭，则前者无；均可直接出
    for(auto i:d2)
        if(i.first=="rocket"||i.first=="bomb")
            return 1;
    return 0;
}
std::vector<std::pair<std::string,int>> FTL::type(const std::vector<std::string>& cards){
    std::string str_cards = join(cards,"-");
    if(data.find(str_cards)!=data.end())
        return data[str_cards];
    return std::vector<std::pair<std::string,int>>();
}
std::vector<std::pair<std::string,int>> FTL::type(const std::string& str_cards){
    if(data.find(str_cards)!=data.end())
        return data[str_cards];
    return std::vector<std::pair<std::string,int>>();
}

std::string FTL::to_string(const std::vector<std::string>& cards){
    return join(sort_cards(cards),"-");
}
std::vector<std::string> FTL::to_vector(const std::string& str_cards){
    return sort_cards(split(str_cards,"-"));
}

std::vector<std::string> FTL::get_cards_byID(const std::vector<int>& cards_id){
    std::vector<std::string> cards;
    for(auto id:cards_id){
        if(id==53) cards.push_back(CARDS[14]);
        else cards.push_back(CARDS[id/4]);
    }
    return cards;
}

std::vector<std::string> FTL::get_cards_byID(const QList<int>& cards_id){
    std::vector<std::string> cards;
    for(auto id:cards_id){
        if(id==53) cards.push_back(CARDS[14]);
        else cards.push_back(CARDS[id/4]);
    }
    return cards;
}

//int main(int argc, char *argv[]) {
//	FTL ftl;
//	//"4-4-4-4-5-5-6-6"必须按照扑克牌大小，{"3","4","6","5","7"}不用
//	std::cout<<ftl.check(std::vector<std::string>{"3","4","6","5","7"})<<" "<<ftl.check("4-4-4-4-5-5-6-6")<<" "<<ftl.check("BJ-RJ")<<" "<<ftl.check("8-8-8-9-9-9-9")<<std::endl;
//	std::cout<<ftl.check("4-4-4-4-5-5-6-6","3-3-3-3","four_two_pair")<<std::endl;
//	std::cout<<ftl.type("4-4-4-4-5-5-6-6")[0].first<<" "<<ftl.type("4-4-4-4-5-5-6-6")[0].second<<std::endl;
//	std::cout<<ftl.type("5-5-6-6-7-7-7-7")[0].first<<" "<<ftl.type("5-5-6-6-7-7-7-7")[0].second<<std::endl;
//	return 0;
//}
