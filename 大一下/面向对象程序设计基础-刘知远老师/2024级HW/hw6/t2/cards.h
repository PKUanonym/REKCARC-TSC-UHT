#pragma once
#include "card.h"
#include <vector>
#include <list>
#include <iostream>

class Cards {
	std::list<Card> cards;
	std::string cards_name;
public:
	Cards(){}
	Cards(std::string name, std::vector<int> vector_cards):cards_name(name){
		for(auto card: vector_cards){
			cards.push_back(Card(cards_name, card));
		}
	}
	void put(Card card){
		cards.push_front(card);
	}
	void print(){
		if(cards.size()){
			for(Card card: cards){
				std::cout<<card<<" ";
			}
			std::cout<<std::endl;
		}else{
			std::cout<<"empty"<<std::endl;
		}
	}
	int count(){
		return cards.size();
	}
	void merge(Cards & another_cards){
		if(another_cards.cards.size())cards.back().number = cards.back().number^another_cards.cards.front().number;
		cards.splice(cards.end(), another_cards.cards);
	}
};