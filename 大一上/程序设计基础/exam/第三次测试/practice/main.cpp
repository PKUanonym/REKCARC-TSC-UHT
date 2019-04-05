//
//  main.cpp
//  practice
//
//  Created by 刘家硕 on 2016/12/20.
//  Copyright © 2016年 刘家硕. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <iostream>
using namespace std;

typedef int value;

// 链表节点的结构体
typedef struct node {
    value val; // 值
    node *next; // 下一个节点指针
};

// 判断两个值a和b是否相等，若相等，返回true，否则返回false
bool is_equal(value a, value b);

// 在链表头为head的链表第x个节点之后插入值为v的节点
// 保证链表非空，1<=x<=链表长度，且不会在链表头插入节点
void insert(node *head, int x, value v) {
    // TODO
    node *temp = head;
    int k = 1;
    while (!is_equal(k,x))
    {
        k++;
        temp = temp -> next;
    }
    
    node *pm = new node;
    pm->val = v;
    node *ki = temp -> next;
    temp->next = pm;
    pm->next = ki;
    
    
    
}

// 从链表头开始查找链表中第一个值等于v的节点，返回节点的位置（从链表头开始数第几个节点）
// 链表为1，以此类推，若不存值等于v的节点则返回-1
// 注：判断是否相等时，必须调用is_equal函数
int search(node *head, value v) {
    // TODO
    
    node *temp = head;
    int p = temp->val;
    int k = 1;
    while ( 1 )
    {
        if (is_equal(p,v)) return k;
            
        else
        {
            if (temp->next == NULL) return -1;
            k++;
            temp = temp->next;
            p = temp->val;
        }
            

    }
    
    
    return k;
    
    
    
}

bool is_equal(value a, value b) {
    return a == b;
}

int main() {
    node *head = new node;
    head -> next = NULL;
    head -> val = 0;
    insert(head, 1, 1);
    insert(head, 2, 2);
    if (search(head, 0) == 1 &&
        search(head, 1) == 2 &&
        search(head, 2) == 3 &&
        search(head, 3) == -1)
        cout << "Accept\n";
    else
        cout << "Wrong answer\n";
    system("pause");
}