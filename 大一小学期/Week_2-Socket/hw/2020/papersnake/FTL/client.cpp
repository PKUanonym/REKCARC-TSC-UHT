#include "client.h"

client::client(Ui::MainWindow *_parent)
{
    parent = _parent;
    m_pRemoteNode1 = new QRemoteObjectNode(this);
    qDebug()<<m_pRemoteNode1->connectToNode(QUrl("tcp://127.0.0.1:32001"));
    m_pInterface1 = m_pRemoteNode1->acquire<CommonInterfaceReplica>();
    m_pRemoteNode1->setHeartbeatInterval(1000);
    m_pRemoteNode2 = new QRemoteObjectNode(this);
    qDebug()<<m_pRemoteNode2->connectToNode(QUrl("tcp://127.0.0.1:32002"));
    m_pInterface2 = m_pRemoteNode2->acquire<CommonInterfaceReplica>();
    m_pRemoteNode2->setHeartbeatInterval(1000);
    m_pRemoteNode3 = new QRemoteObjectNode(this);
    qDebug()<<m_pRemoteNode3->connectToNode(QUrl("tcp://127.0.0.1:32003"));
    m_pInterface3 = m_pRemoteNode3->acquire<CommonInterfaceReplica>();
    m_pRemoteNode3->setHeartbeatInterval(1000);
    connect(m_pInterface1,&CommonInterfaceReplica::ping,this,&client::onReceivePing);
    connect(m_pInterface2,&CommonInterfaceReplica::ping,this,&client::onReceivePing);
    connect(m_pInterface3,&CommonInterfaceReplica::ping,this,&client::onReceivePing);
}

void client::onReceivePing(QString msg){
    parent->textEdit->setText(msg);
    qDebug()<<"Ping:"<<msg;
    auto t = msg.split("*");
    int r = t[0].toInt();
    auto s = t[1].split(":");
    qDebug()<<s[0]<<s[1];
    int from = s[0].toInt();

    if(gamestatus->index[from].size()){
        for(auto i:gamestatus->index[from]){
            if(r==i) return;
        }
    }
    gamestatus->index[from].append(r);

    QString text = s[1];
    if(text=="StartGame"){
        gamestatus->gamestatus[from] = 1;
        return;
    }
    else if(text=="GetCards"){
        QString str_cards = s[2];
        auto cards = str_cards.split("-");
        for(auto card:cards){
            basewidget->numbersList.append(card.toInt());
        }
        gamestatus->gamestatus[0]=2;
        gamestatus->gamestatus[1]=2;
        gamestatus->gamestatus[2]=2;
        return;
    }
    else if(text=="ChooseLord"){
        int lord_id = s[2].toInt();
        gamestatus->lord = lord_id;
        gamestatus->gamestatus[0]=3;
        gamestatus->gamestatus[1]=3;
        gamestatus->gamestatus[2]=3;
        return;
    }
    else if(text=="DecideLord"){
        int decision = s[2].toInt();
        gamestatus->gamestatus[from] = decision;
        if(gamestatus->id==(from+1)%3){
            basewidget->getDizhuButton->show();
            basewidget->abandonDizhuButton->show();
        }
        return;
    }
    else if(text=="BecomeLord"){
        int lord_id = s[2].toInt();
        gamestatus->lord = lord_id;
        gamestatus->last_card_id = lord_id;
        basewidget->becomelord();
        gamestatus->player_cards[lord_id] += 3;
        return;
    }
    else if(text=="PostCards"){
        QString cards_str = s[2];
        auto cards_str_list = cards_str.split("-");
        QList<int> cards;
        for(auto card_str:cards_str_list){
            cards.append(card_str.toInt());
        }
        gamestatus->player_cards[from] -= cards.size();
        qDeleteAll(basewidget->cardShow);
        basewidget->cardShow.clear();
        std::sort(cards.begin(),cards.end());
        for(int i=0;i<cards.size();i++)
        {
            qDebug()<<cards[i];
            QLabel *cardLabel = new QLabel(basewidget);
            cardLabel->clear();
            QPixmap cardpix(":/cards/resources/"+QString::number(cards[i])+".png");
            cardLabel->setGeometry(350*basewidget->ver+40*i*basewidget->ver,200*basewidget->ver,100*basewidget->ver,150*basewidget->ver);
            cardLabel->setPixmap(cardpix.scaled(100*basewidget->ver,150*basewidget->ver));
            cardLabel->setScaledContents(true);
            basewidget->cardShow.append(cardLabel);
            cardLabel->show();
        }
        gamestatus->last_card_id = from;
        gamestatus->lastPostCards = cards_str;

        if(gamestatus->player_cards[from]==0){
            if(from==gamestatus->id) basewidget->win();
            else if(gamestatus->id==gamestatus->lord) basewidget->loss();
            else if(from==gamestatus->lord) basewidget->loss();
            else basewidget->win();
            return;
        }

        if(gamestatus->id==(from+1)%3)
            basewidget->showChuOrBuyaoButton();
    }
    else if(text=="BuYao"){
        if(gamestatus->last_card_id==(from+1)%3)
            gamestatus->lastPostCards = "";
        if(gamestatus->id==(from+1)%3)
            basewidget->showChuOrBuyaoButton();
    }
}

