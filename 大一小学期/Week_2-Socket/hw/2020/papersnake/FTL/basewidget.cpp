#include "basewidget.h"
#include <QPropertyAnimation>

BaseWidget::BaseWidget(QWidget *parent) : QWidget(parent)
{
    desktop = new Desktop(this);
    ver = desktop->getDesktop();
    background_id = QRandomGenerator::global()->bounded(18);
    setBaseWidgetSizeAndBackground();
    setCardBaseWidgetOnBaseWidget();
    setPersonPixmapLabel();
    connect(cardBaseWidget,SIGNAL(hideCardssssLabel()),this,SLOT(getHideCardsss()));
    connect(openGameButton,SIGNAL(clicked(bool)),this,SLOT(openGameButtonSlot()));
    connect(getDizhuButton,SIGNAL(clicked(bool)),this,SLOT(getDizhuButtonSlot()));
    connect(abandonDizhuButton,SIGNAL(clicked(bool)),SLOT(abandonDizhuButtonSlot()));
    connect(chupaiButton,SIGNAL(clicked(bool)),this,SLOT(chupaiButtonSlot()));
    connect(buyaoButton,SIGNAL(clicked(bool)),this,SLOT(buyaoButtonSlot()));
    connect(chongkai,SIGNAL(clicked(bool)),this,SLOT(chongkaiSlot()));
    connect(tuichu,SIGNAL(clicked(bool)),this,SLOT(tuichuSlot()));
}
void BaseWidget::setBaseWidgetSizeAndBackground()
{
    this->setGeometry(5*ver,5*ver,1300*ver,900*ver);
    this->setMinimumSize(1300*ver,900*ver);
    this->setMaximumSize(1300*ver,900*ver);
}
void BaseWidget::changeBaseBackgroundPicture()
{
}
void BaseWidget::setNormalBaseBackgroundPicture()
{
}
void BaseWidget::paintEvent(QPaintEvent *event)
{
    Q_UNUSED(event);
    QPixmap background;
    background.load(":/background/resources/background"+QString::number(background_id)+".png");
    background.scaled(1300*ver,900*ver);
    QPainter painter(this);
    painter.save();
    painter.drawPixmap(0,0,1300*ver,900*ver,background);
    painter.restore();
}
void BaseWidget::setPersonPixmapLabel()
{
    dizhuLabel=new QLabel(this);
    nongmin0Label=new QLabel(this);
    nongmin1Label=new QLabel(this);
    cardsAllLabel=new QLabel(this);
    openGameButton=new QPushButton(this);
    rightCardAllLabel=new QLabel(this);
    leftCardAllLabel=new QLabel(this);
    waiting = new QLabel(this);
    result_win = new QLabel(this);
    result_fail = new QLabel(this);
    leftCardSizeWidget=new QWidget(this);
    leftCardSizeLabel=new QLabel(leftCardSizeWidget);
    rightCardSizeWidget=new QWidget(this);
    rightCardSizeLabel=new QLabel(rightCardSizeWidget);
    getDizhuButton=new QPushButton(this);
    abandonDizhuButton=new QPushButton(this);
    chupaiButton=new QPushButton(this);
    buyaoButton=new QPushButton(this);
    dizhupai1=new QLabel(this);
    dizhupai2=new QLabel(this);
    dizhupai3=new QLabel(this);
    chongkai=new QPushButton(this);
    tuichu=new QPushButton(this);
    wrongCard = new QLabel(this);
    QPixmap cardpix(":/cards/resources/BackBlue.png");
    dizhupai1->setGeometry(550*ver,30*ver,100*ver,150*ver);
    dizhupai1->setPixmap(cardpix.scaled(100*ver,150*ver));
    dizhupai2->setGeometry(600*ver,30*ver,100*ver,150*ver);
    dizhupai2->setPixmap(cardpix.scaled(100*ver,150*ver));
    dizhupai3->setGeometry(650*ver,30*ver,100*ver,150*ver);
    dizhupai3->setPixmap(cardpix.scaled(100*ver,150*ver));
    dizhupai1->hide();
    dizhupai2->hide();
    dizhupai3->hide();
    QPixmap nongmin0Pix(":/res/resources/nongmin0.png");
    nongmin0Label->setGeometry(0,280*ver,155*ver,210*ver);
    nongmin0Label->setPixmap(nongmin0Pix.scaled(155*ver,210*ver));
    QPixmap nongmin1Pix(":/res/resources/nongmin1.png");
    nongmin1Label->setGeometry(1148*ver,280*ver,155*ver,210*ver);
    nongmin1Label->setPixmap(nongmin1Pix.scaled(155*ver,210*ver));
    QPixmap dizhuPix(":/res/resources/dizhu.png");
    dizhuLabel->setGeometry(10*ver,603*ver,170*ver,240*ver);
    dizhuLabel->setPixmap(dizhuPix.scaled(155*ver,210*ver));
    QPixmap cardsssPix(":/res/resources/cardsss.png");
    cardsAllLabel->setGeometry(550*ver,370*ver,150*ver,150*ver);
    cardsAllLabel->setPixmap(cardsssPix.scaled(150*ver,150*ver));
    cardsAllLabel->setScaledContents(true);
    QPixmap rightCardsssPix(":/res/resources/rightcardsss.png");
    rightCardAllLabel->setPixmap(rightCardsssPix.scaled(150*ver,110*ver));
    rightCardAllLabel->setGeometry(155*ver,370*ver,150*ver,110*ver);
    rightCardAllLabel->hide();
    QPixmap leftCardssPix(":/res/resources/leftcardsss.png");
    leftCardAllLabel->setPixmap(leftCardssPix.scaled(150*ver,110*ver));
    leftCardAllLabel->setGeometry(1005*ver,370*ver,150*ver,110*ver);
    leftCardAllLabel->hide();
    cardsAllLabel->hide();
    waiting->setText("<h2>连接中</h2>");
    waiting->setGeometry(550*ver,370*ver,100*ver,50*ver);
    waiting->hide();
    wrongCard->setText("<h2><font color=red>出牌不合法！</font></h2>");
    wrongCard->setGeometry(550*ver,370*ver,100*ver,50*ver);
    wrongCard->hide();
    result_win->setPixmap(QPixmap(":/res/resources/victorytext.png").scaled(170*ver,90*ver));
    result_win->setGeometry(520*ver,370*ver,170*ver,90*ver);
    result_win->hide();
    result_fail->setPixmap(QPixmap(":/res/resources/failtext.png").scaled(170*ver,90*ver));
    result_fail->setGeometry(520*ver,370*ver,170*ver,90*ver);
    result_fail->hide();
    openGameButton->setGeometry(550*ver,370*ver,100*ver,50*ver);
    openGameButton->setText(tr("开始游戏"));
    rightCardSizeWidget->setGeometry(120*ver,275*ver,50*ver,50*ver);
    rightCardSizeLabel->setGeometry(0,0,50*ver,50*ver);
    rightCardSizeLabel->setText(tr(""));
    leftCardSizeWidget->setGeometry(1130*ver,275*ver,50*ver,50*ver);
    leftCardSizeLabel->setGeometry(0,0,50*ver,50*ver);
    leftCardSizeLabel->setText(tr(""));
    getDizhuButton->setGeometry(450*ver,500*ver,100*ver,50*ver);
    getDizhuButton->setText(tr("抢地主"));
    getDizhuButton->hide();
    abandonDizhuButton->setGeometry(650*ver,500*ver,100*ver,50*ver);
    abandonDizhuButton->setText("不抢");
    abandonDizhuButton->hide();
    chupaiButton->setGeometry(450*ver,500*ver,100*ver,50*ver);
    chupaiButton->setText("出牌");
    chupaiButton->hide();
    buyaoButton->setGeometry(650*ver,500*ver,100*ver,50*ver);
    buyaoButton->setText("不要");
    buyaoButton->hide();
    chongkai->setGeometry(450*ver,500*ver,100*ver,50*ver);
    chongkai->setText("再来一局");
    chongkai->hide();
    tuichu->setGeometry(650*ver,500*ver,100*ver,50*ver);
    tuichu->setText("退出");
    tuichu->hide();
}
void BaseWidget::showChuOrBuyaoButton()
{
    chupaiButton->show();
    buyaoButton->show();
}
void BaseWidget::setCardBaseWidgetOnBaseWidget()
{
    cardBaseWidget=new CardsBaseWidget(this);
    cardBaseWidget->show();
//    cardShow = new CardsBaseWidget(this);
//    cardShow->isShow = true;
    //cardShow->show();

}
void BaseWidget::getHideCardsss()
{
    rightCardAllLabel->show();
    leftCardAllLabel->show();
    cardsAllLabel->hide();
    dizhupai1->show();
    dizhupai2->show();
    dizhupai3->show();
    if(gamestatus->lord==gamestatus->id){
        getDizhuButton->show();
        abandonDizhuButton->show();
    }
}
void BaseWidget::openGameButtonSlot()
{
    openGameButton->hide();
    waiting->show();
    gamestatus->step = 1;
}
void BaseWidget::startGame(){
    setUserRandomCardNumList();
    sortUserRandomCardNumList();
    cardsAllLabel->show();
    QPropertyAnimation *animation0=new QPropertyAnimation(cardsAllLabel,"geometry");
    animation0->setDuration(6000);
    animation0->setStartValue(QRect(550*ver,370*ver,150*ver,150*ver));
    animation0->setEndValue(QRect(550*ver,420*ver,150*ver,100*ver));
    animation0->start(QAbstractAnimation::DeleteWhenStopped);
    cardBaseWidget->openGame();
}
void BaseWidget::writeLeftCardSize(int size)
{
    leftCardAllLabel->setText(QString::number(size));
}
void BaseWidget::writeRightCardSize(int size)
{
    rightCardAllLabel->setText(QString::number(size));
}
void BaseWidget::getRandomCardNumList()
{
    int i,j;
    for(i=0;i<54;i++)//生成54个随机数
    {
        numbersList.append(QRandomGenerator::global()->bounded(54));
        bool flag=true;
        while(flag)
        {
            for(j=0;j<i;j++)
            {
                if(numbersList[i]==numbersList[j])
                {
                    break;
                }
            }
            if(j<i)
            {
                numbersList[i]=QRandomGenerator::global()->bounded(54);
            }
            if(j==i)
            {
                flag=!flag;
            }
        }
    }
    QString msg = QString::number(gamestatus->id) + ":GetCards:";
    for(i=0;i<53;i++)
    {
        msg += QString::number(numbersList[i]) + "-";
    }
    msg += QString::number(numbersList[53]);
    //msg += QString::fromLocal8Bit(join(ftl.get_cards_byID(numbersList),"-").c_str());
    qDebug()<<msg;
    gamestatus->msg_to_send = true;
    gamestatus->msg = msg;
}
void BaseWidget::setUserRandomCardNumList()
{
    int k = gamestatus->id;
    for(int i=k*17;i<k*17+17;i++)
    {
        userNumCardList.append(numbersList[i]);
    }
    k = (k+1) % 3;
    for(int i=k*17;i<k*17+17;i++)
    {
        nongmin1NumCardList.append(numbersList[i]);
    }
    k = (k+1) % 3;
    for(int i=k*17;i<k*17+17;i++)
    {
        nongmin0NumCardList.append(numbersList[i]);
    }
}
void BaseWidget::sortUserRandomCardNumList()
{
    qDebug()<<userNumCardList.size();
    qDebug()<<cardBaseWidget->vector_card.size();
    qDeleteAll(cardBaseWidget->vector_card);
    cardBaseWidget->vector_card.clear();
    cardBaseWidget->writeCardsSize(userNumCardList.size());
    cardBaseWidget->setGeometryAndLabels();
    std::sort(userNumCardList.begin(),userNumCardList.end());
    for(int i=0;i<userNumCardList.size();i++)
    {
        qDebug()<<userNumCardList[i];
        cardBaseWidget->vector_card.at(i)->writeCardNum(userNumCardList[i]);
        cardBaseWidget->vector_card.at(i)->cardLabel->clear();
        cardBaseWidget->vector_card.at(i)->setGeometryAndLabel();
    }
}
void BaseWidget::getDizhuButtonSlot()//用户抢完地主后重新刷新牌面显示并且加入三张牌
{
    player.setMedia(QUrl("qrc:sound/resources/Woman_Rob"+QString::number(gamestatus->id+1)+".mp3"));
    player.setVolume(30);
    player.play();
    gamestatus->gamestatus[gamestatus->id] = 4;//抢地主
    gamestatus->step = 4;
    getDizhuButton->hide();
    abandonDizhuButton->hide();
}

void BaseWidget::abandonDizhuButtonSlot()
{
    player.setMedia(QUrl("qrc:sound/resources/Woman_NoOrder.mp3"));
    player.setVolume(30);
    player.play();
    gamestatus->gamestatus[gamestatus->id] = 5;//不抢地主
    gamestatus->step = 4;
    getDizhuButton->hide();
    abandonDizhuButton->hide();
}

void BaseWidget::becomelord(){
    QPixmap nongmin0Pix(":/res/resources/nongmin0.png");
    QPixmap nongmin1Pix(":/res/resources/nongmin1.png");
    QPixmap dizhuPix(":/res/resources/dizhu.png");
    if(gamestatus->lord==gamestatus->id){
        nongmin0Label->setPixmap(nongmin0Pix.scaled(155*ver,210*ver));
        nongmin1Label->setPixmap(nongmin1Pix.scaled(155*ver,210*ver));
        dizhuLabel->setPixmap(dizhuPix.scaled(155*ver,210*ver));

        userNumCardList.append(numbersList[51]);
        userNumCardList.append(numbersList[52]);
        userNumCardList.append(numbersList[53]);
        qDeleteAll(cardBaseWidget->vector_card);
        cardBaseWidget->vector_card.clear();
        cardBaseWidget->writeCardsSize(userNumCardList.size());
        std::sort(userNumCardList.begin(),userNumCardList.end());
        cardBaseWidget->setGeometryAndLabels();
        qDebug()<<userNumCardList.size();
        for(int i=0;i<userNumCardList.size();i++)
        {
            cardBaseWidget->vector_card.at(i)->writeCardNum(userNumCardList[i]);
            cardBaseWidget->vector_card.at(i)->cardLabel->clear();
            cardBaseWidget->vector_card.at(i)->setGeometryAndLabel();
            cardBaseWidget->vector_card.at(i)->setNoAnimation();
        }
        getDizhuButton->hide();
        abandonDizhuButton->hide();
        showChuOrBuyaoButton();
    }
    else if(gamestatus->id==(gamestatus->lord+1)%3){
        nongmin0Label->setPixmap(dizhuPix.scaled(155*ver,210*ver));
        nongmin1Label->setPixmap(nongmin0Pix.scaled(155*ver,210*ver));
        dizhuLabel->setPixmap(nongmin1Pix.scaled(155*ver,210*ver));
        nongmin0NumCardList.append(numbersList[51]);
        nongmin0NumCardList.append(numbersList[52]);
        nongmin0NumCardList.append(numbersList[53]);
        getDizhuButton->hide();
        abandonDizhuButton->hide();
        //showChuOrBuyaoButton();
    }
    else{
        nongmin0Label->setPixmap(nongmin1Pix.scaled(155*ver,210*ver));
        nongmin1Label->setPixmap(dizhuPix.scaled(155*ver,210*ver));
        dizhuLabel->setPixmap(nongmin0Pix.scaled(155*ver,210*ver));
        nongmin1NumCardList.append(numbersList[51]);
        nongmin1NumCardList.append(numbersList[52]);
        nongmin1NumCardList.append(numbersList[53]);
        getDizhuButton->hide();
        abandonDizhuButton->hide();
        //showChuOrBuyaoButton();
    }
    dizhupai1->setPixmap(QPixmap(":/cards/resources/"+QString::number(numbersList[51])+".png").scaled(100*ver,150*ver));
    dizhupai2->setPixmap(QPixmap(":/cards/resources/"+QString::number(numbersList[52])+".png").scaled(100*ver,150*ver));
    dizhupai3->setPixmap(QPixmap(":/cards/resources/"+QString::number(numbersList[53])+".png").scaled(100*ver,150*ver));
    dizhupai1->show();
    dizhupai2->show();
    dizhupai3->show();
}

void BaseWidget::chupaiButtonSlot()//出牌动作的实现，以及后台数据分析进行。
{
    QList<int> chooseCard;
    int size=cardBaseWidget->readCardsSize();
    for(int i=0;i<size;i++)
        if(cardBaseWidget->vector_card.at(i)->isup==true)
            chooseCard.append(cardBaseWidget->vector_card.at(i)->readCardNum());
    if(chooseCard.size()==0) return;
    qDebug()<<"出牌"<<QString::fromLocal8Bit(ftl.to_string(ftl.get_cards_byID(chooseCard)).c_str());
    std::string cards_string = ftl.to_string(ftl.get_cards_byID(chooseCard));
    if(!ftl.check(cards_string)){
        wrongCard->show();
        return;
    }
    if(gamestatus->lastPostCards.size()){
        auto lastPostCards_str = gamestatus->lastPostCards.split("-");
        QList<int> lastPostCards;
        for(auto card_str:lastPostCards_str){
            lastPostCards.append(card_str.toInt());
        }
        qDebug()<<lastPostCards.size();
        if(lastPostCards.size()&&!ftl.check(ftl.to_string(ftl.get_cards_byID(lastPostCards)),cards_string)) {wrongCard->show();return;}
    }

    wrongCard->hide();
    auto type = ftl.type(ftl.to_string(ftl.get_cards_byID(chooseCard)))[0].first;
    bool flag = false;
    if(type=="bomb"){
        player.setMedia(QUrl("qrc:sound/resources/Woman_zhadan.mp3"));
        flag = true;
    }
    else if(type=="rocket"){
        player.setMedia(QUrl("qrc:sound/resources/Woman_wangzha.mp3"));
        flag = true;
    }
    if(flag){
        player.setVolume(30);
        player.play();
    }
    //QString cards_qstring = QString::fromLocal8Bit(cards_string.c_str());

    for(int i=0;i<size;i++)
    {
        if(cardBaseWidget->vector_card.at(i)->isup==true)
        {
            int value=cardBaseWidget->vector_card.at(i)->readCardNum();
            userNumCardList.removeOne(value);
            continue;
        }
    }
    qDeleteAll(cardBaseWidget->vector_card);
    cardBaseWidget->vector_card.clear();
    cardBaseWidget->writeCardsSize(userNumCardList.size());
    std::sort(userNumCardList.begin(),userNumCardList.end());
    cardBaseWidget->setGeometryAndLabels();
    qDebug()<<userNumCardList.size();
    for(int i=0;i<userNumCardList.size();i++)
    {
        cardBaseWidget->vector_card.at(i)->writeCardNum(userNumCardList[i]);
        cardBaseWidget->vector_card.at(i)->cardLabel->clear();
        cardBaseWidget->vector_card.at(i)->setGeometryAndLabel();
        cardBaseWidget->vector_card.at(i)->setNoAnimation();

    }
    gamestatus->msg = QString::number(gamestatus->id)+":PostCards:";
    for(int i=0;i<chooseCard.size();i++){
        gamestatus->msg += QString::number(chooseCard[i]) + (i==(chooseCard.size()-1)?"":"-");
    }
    gamestatus->msg_to_send = true;

    chupaiButton->hide();
    buyaoButton->hide();

}

void BaseWidget::buyaoButtonSlot()
{
    if(gamestatus->last_card_id==gamestatus->id) return;
    if(!gamestatus->lastPostCards.size()) return;
    gamestatus->msg_to_send = true;
    gamestatus->msg = QString::number(gamestatus->id)+":BuYao";
    chupaiButton->hide();
    buyaoButton->hide();
}

void BaseWidget::chongkaiSlot()
{
    chongkai->hide();
    tuichu->hide();
    waiting->show();
    wrongCard->hide();
    numbersList.clear();
    userNumCardList.clear();
    nongmin0NumCardList.clear();
    nongmin1NumCardList.clear();
    qDeleteAll(cardShow);
    cardShow.clear();
    QPixmap cardpix(":/cards/resources/BackBlue.png");
    dizhupai1->setGeometry(550*ver,30*ver,100*ver,150*ver);
    dizhupai1->setPixmap(cardpix.scaled(100*ver,150*ver));
    dizhupai2->setGeometry(600*ver,30*ver,100*ver,150*ver);
    dizhupai2->setPixmap(cardpix.scaled(100*ver,150*ver));
    dizhupai3->setGeometry(650*ver,30*ver,100*ver,150*ver);
    dizhupai3->setPixmap(cardpix.scaled(100*ver,150*ver));
    dizhupai1->hide();
    dizhupai2->hide();
    dizhupai3->hide();
    QPixmap nongmin0Pix(":/res/resources/nongmin0.png");
    nongmin0Label->setGeometry(0,280*ver,155*ver,210*ver);
    nongmin0Label->setPixmap(nongmin0Pix.scaled(155*ver,210*ver));
    QPixmap nongmin1Pix(":/res/resources/nongmin1.png");
    nongmin1Label->setGeometry(1148*ver,280*ver,155*ver,210*ver);
    nongmin1Label->setPixmap(nongmin1Pix.scaled(155*ver,210*ver));
    QPixmap dizhuPix(":/res/resources/dizhu.png");
    dizhuLabel->setGeometry(10*ver,603*ver,170*ver,240*ver);
    dizhuLabel->setPixmap(dizhuPix.scaled(155*ver,210*ver));
    rightCardAllLabel->hide();
    leftCardAllLabel->hide();
    cardsAllLabel->hide();
    result_win->hide();
    result_fail->hide();
    openGameButton->hide();
    rightCardSizeLabel->setText(tr(""));
    leftCardSizeLabel->setText(tr(""));
    getDizhuButton->hide();
    abandonDizhuButton->hide();
    chupaiButton->hide();
    buyaoButton->hide();
    gamestatus->gamestatus[0]=0;
    gamestatus->gamestatus[1]=0;
    gamestatus->gamestatus[2]=0;
    gamestatus->player_cards[0] = 17;
    gamestatus->player_cards[1] = 17;
    gamestatus->player_cards[2] = 17;
    gamestatus->msg_to_send = false;
    gamestatus->msg = "";
    gamestatus->lastPostCards = "";
    gamestatus->step = 1;

}

void BaseWidget::tuichuSlot(){
    exit(1);
}

void BaseWidget::win(){
    wrongCard->hide();
    result_win->show();
    chongkai->show();
    tuichu->show();
    player.setMedia(QUrl("qrc:sound/resources/MusicEx_Win.mp3"));
    player.setVolume(30);
    player.play();
}

void BaseWidget::loss(){
    wrongCard->hide();
    result_fail->show();
    chongkai->show();
    tuichu->show();
    player.setMedia(QUrl("qrc:sound/resources/MusicEx_Lose.mp3"));
    player.setVolume(30);
    player.play();
}


