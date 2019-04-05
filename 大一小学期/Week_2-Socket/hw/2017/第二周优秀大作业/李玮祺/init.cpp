#include "mainwindow.h"
#include "ui_mainwindow.h"

void MainWindow::init()
{
    severonoff = false;
    lastmove = -1;
    testmood = false;
    dfsmax = dfsans = 0;
    jsbool = false;
    delsum = 0;
    setWindowIcon(QIcon("C:/Coding/chess/pic/KanChess.png"));
    m = new QSignalMapper(this);
    sestatue = bgmstatue = true;
    ifequal = 0;
    statenow = false;
    ifdialog = false;
    active1 = active2 = 0;
    mremain = eremain = 20;
    updatepoint();

    ui->qh1->setAlignment(Qt::AlignCenter);
    ui->qh2->setAlignment(Qt::AlignCenter);

    ui->testmov->setVisible(false);
    ui->testdel->setVisible(false);
    ui->testend->setVisible(false);
    ui->teststart->setVisible(false);
    ui->changeGod->setVisible(false);

    ui->testdel->setEnabled(false);
    ui->testend->setEnabled(false);
    ui->teststart->setEnabled(false);
    ui->changeGod->setEnabled(false);

    ui->quitButton->setVisible(false);
    ui->quitButton->setEnabled(false);
    ui->link->setVisible(false);
    ui->link->setEnabled(false);
    ui->escape->setVisible(false);
    ui->escape->setEnabled(false);
    ui->equa->setVisible(false);
    ui->equa->setEnabled(false);
    ui->bgmbut->setVisible(false);
    ui->bgmbut->setEnabled(false);
    ui->sebut->setVisible(false);
    ui->sebut->setEnabled(false);

    QPixmap pixtar("C:/Coding/chess/pic/tar.png");
    taricon = new QIcon(pixtar);
    QPixmap pixac("C:/Coding/chess/pic/ac.png");
    acicon = new QIcon(pixac);
    QPixmap pixoc("C:/Coding/chess/pic/oc.png");
    ocicon = new QIcon(pixoc);
    QPixmap pixac1("C:/Coding/chess/pic/ac1.png");
    acicon1 = new QIcon(pixac1);
    QPixmap pixoc1("C:/Coding/chess/pic/oc1.png");
    ocicon1 = new QIcon(pixoc1);
    QPixmap pixoc2("C:/Coding/chess/pic/oc2.png");
    ocicon2 = new QIcon(pixoc2);
    QPixmap pixoc3("C:/Coding/chess/pic/oc3.png");
    ocicon3 = new QIcon(pixoc3);
    QPixmap emptpng("C:/Coding/chess/pic/empt.png");
    empt = new QIcon(emptpng);

    QPixmap t7("C:/Coding/chess/pic/se.png");
    ui->se_2->setPixmap(t7);
    ui->se_2->setScaledContents(true);
    QPixmap t8("C:/Coding/chess/pic/bgm.png");
    ui->bgm_2->setPixmap(t8);
    ui->bgm_2->setScaledContents(true);
    QPixmap t9("C:/Coding/chess/pic/ser.png");
    ui->sever_2->setPixmap(t9);
    ui->sever_2->setScaledContents(true);

    QPixmap t5("C:/Coding/chess/pic/yes.png");
    ui->se->setPixmap(t5);
    ui->se->setScaledContents(true);
    ui->bgm->setPixmap(t5);
    ui->bgm->setScaledContents(true);
    QPixmap t6("C:/Coding/chess/pic/no.png");
    ui->sever->setPixmap(t6);
    ui->sever->setScaledContents(true);

    ui->echess->setAlignment(Qt::AlignCenter);
    ui->ochess->setAlignment(Qt::AlignCenter);
    ui->echess->setStyleSheet("border: 0px; background-color: rgba(0,0,0,0)");
    ui->ochess->setStyleSheet("border: 0px; background-color: rgba(0,0,0,0)");

    ui->sebut->setStyleSheet("border: 0px; background-color: rgba(0,0,0,0)");
    ui->bgmbut->setStyleSheet("border: 0px; background-color: rgba(0,0,0,0)");
    ui->severon->setStyleSheet("border: 0px; background-color: rgba(0,0,0,0)");

    QPixmap walkicon("C:/Coding/chess/pic/walk.png");
    ui->walk->setPixmap(walkicon);
    ui->walk->setScaledContents(true);

    QPixmap t1("C:/Coding/chess/pic/link.png");
    ui->link1->setPixmap(t1);
    ui->link1->setScaledContents(true);
    ui->link->setStyleSheet("background-color: rgba(0,0,0,0)");
    QPixmap t2("C:/Coding/chess/pic/equa.png");
    ui->equa1->setPixmap(t2);
    ui->equa1->setScaledContents(true);
    ui->equa->setStyleSheet("background-color: rgba(0,0,0,0)");
    QPixmap t3("C:/Coding/chess/pic/esca.png");
    ui->escape1->setPixmap(t3);
    ui->escape1->setScaledContents(true);
    ui->escape->setStyleSheet("background-color: rgba(0,0,0,0)");
    QPixmap t4("C:/Coding/chess/pic/exit.png");
    ui->quitButton1->setPixmap(t4);
    ui->quitButton1->setScaledContents(true);
    ui->quitButton->setStyleSheet("background-color: rgba(0,0,0,0)");

    /*ui->pushButton_1->setIconSize(QSize(30,30));
    ui->pushButton_1->setIcon(* tar);
    ui->pushButton_1->show();
    ui->pushButton_2->setIconSize(QSize(30,30));
    ui->pushButton_2->setIcon(* ac);
    ui->pushButton_2->show();
    ui->pushButton_3->setIconSize(QSize(40,40));
    ui->pushButton_3->setIcon(* oc);
    ui->pushButton_3->show();*/

    connectMap();

    for (int i = 0; i <= 11; i++)
    {
        intMap[0][i] = intMap[11][i] = intMap[i][0] = intMap[i][11] = -1;
    }
    for (int i = 1; i <= 10; i++)
    	for (int j = 1; j <= 10; j++)
    	{
    		if ((i + j) % 2 == 0)
    		{
                ButtonMap[i][j]->setStyleSheet("background-color: rgba(56,129,172,0.7)");
                intMap[i][j] = 0;
    		}
    		else
    		{
                ButtonMap[i][j]->setStyleSheet("background-color: rgba(129,186,213,0.7)");
    		}
    	}

    QPushButton * b;

    int counter = 0;
    for (int i = 1; i <= 10; i++)
    	for (int j = 1; j <= 10; j++)
    	{
    		if ((i + j) % 2 == 0) continue;
    		counter++;
            intMap[i][j] = counter;
            xMap[counter] = i;
            yMap[counter] = j;
    		b = ButtonMap[i][j];
    		ActiveMap[counter] = b;
    		connect(b, SIGNAL(clicked()), m, SLOT(map()));
    		m -> setMapping(b, counter);
    	}
    for (int i = 1; i <= 50; i++) ActiveInfo[i] = 0;
    for (int i = 1; i <= 20; i++) 
    {
		ActiveMap[i]->setIconSize(QSize(30,30));
    	ActiveMap[i]->setIcon(* acicon);
    	ActiveMap[i]->show();    	
        ActiveInfo[i] = 3;
    }
    /*for (int i = 21; i <= 25; i++)
    {
        ActiveMap[i]->setIconSize(QSize(30,30));
        ActiveMap[i]->setIcon(* acicon1);
        ActiveMap[i]->show();
    }
    for (int i = 26; i <= 30; i++)
    {
        ActiveMap[i]->setIconSize(QSize(30,30));
        ActiveMap[i]->setIcon(* ocicon1);
    	ActiveMap[i]->show();    	
    }*/
    for (int i = 31; i <= 50; i++)
    {
        ActiveMap[i]->setIconSize(QSize(30,30));
        ActiveMap[i]->setIcon(* ocicon);
        ActiveMap[i]->show();
        ActiveInfo[i] = 1;
    }

    connect(m, SIGNAL(mapped(int)), this, SLOT(ButtonPressed(int)));

}

void MainWindow::connectMap()
{
    ButtonMap[1][1] = ui->pushButton_1;
    ButtonMap[1][2] = ui->pushButton_2;
    ButtonMap[1][3] = ui->pushButton_3;
    ButtonMap[1][4] = ui->pushButton_4;
    ButtonMap[1][5] = ui->pushButton_5;
    ButtonMap[1][6] = ui->pushButton_6;
    ButtonMap[1][7] = ui->pushButton_7;
    ButtonMap[1][8] = ui->pushButton_8;
    ButtonMap[1][9] = ui->pushButton_9;
    ButtonMap[1][10] = ui->pushButton_10;

	ButtonMap[2][1] = ui->pushButton_11;
    ButtonMap[2][2] = ui->pushButton_12;
    ButtonMap[2][3] = ui->pushButton_13;
    ButtonMap[2][4] = ui->pushButton_14;
    ButtonMap[2][5] = ui->pushButton_15;
    ButtonMap[2][6] = ui->pushButton_16;
    ButtonMap[2][7] = ui->pushButton_17;
    ButtonMap[2][8] = ui->pushButton_18;
    ButtonMap[2][9] = ui->pushButton_19;
    ButtonMap[2][10] = ui->pushButton_20;    

	ButtonMap[3][1] = ui->pushButton_21;
    ButtonMap[3][2] = ui->pushButton_22;
    ButtonMap[3][3] = ui->pushButton_23;
    ButtonMap[3][4] = ui->pushButton_24;
    ButtonMap[3][5] = ui->pushButton_25;
    ButtonMap[3][6] = ui->pushButton_26;
    ButtonMap[3][7] = ui->pushButton_27;
    ButtonMap[3][8] = ui->pushButton_28;
    ButtonMap[3][9] = ui->pushButton_29;
    ButtonMap[3][10] = ui->pushButton_30;    

	ButtonMap[4][1] = ui->pushButton_31;
    ButtonMap[4][2] = ui->pushButton_32;
    ButtonMap[4][3] = ui->pushButton_33;
    ButtonMap[4][4] = ui->pushButton_34;
    ButtonMap[4][5] = ui->pushButton_35;
    ButtonMap[4][6] = ui->pushButton_36;
    ButtonMap[4][7] = ui->pushButton_37;
    ButtonMap[4][8] = ui->pushButton_38;
    ButtonMap[4][9] = ui->pushButton_39;
    ButtonMap[4][10] = ui->pushButton_40;    

	ButtonMap[5][1] = ui->pushButton_41;
    ButtonMap[5][2] = ui->pushButton_42;
    ButtonMap[5][3] = ui->pushButton_43;
    ButtonMap[5][4] = ui->pushButton_44;
    ButtonMap[5][5] = ui->pushButton_45;
    ButtonMap[5][6] = ui->pushButton_46;
    ButtonMap[5][7] = ui->pushButton_47;
    ButtonMap[5][8] = ui->pushButton_48;
    ButtonMap[5][9] = ui->pushButton_49;
    ButtonMap[5][10] = ui->pushButton_50;

	ButtonMap[6][1] = ui->pushButton_51;
    ButtonMap[6][2] = ui->pushButton_52;
    ButtonMap[6][3] = ui->pushButton_53;
    ButtonMap[6][4] = ui->pushButton_54;
    ButtonMap[6][5] = ui->pushButton_55;
    ButtonMap[6][6] = ui->pushButton_56;
    ButtonMap[6][7] = ui->pushButton_57;
    ButtonMap[6][8] = ui->pushButton_58;
    ButtonMap[6][9] = ui->pushButton_59;
    ButtonMap[6][10] = ui->pushButton_60;    

	ButtonMap[7][1] = ui->pushButton_61;
    ButtonMap[7][2] = ui->pushButton_62;
    ButtonMap[7][3] = ui->pushButton_63;
    ButtonMap[7][4] = ui->pushButton_64;
    ButtonMap[7][5] = ui->pushButton_65;
    ButtonMap[7][6] = ui->pushButton_66;
    ButtonMap[7][7] = ui->pushButton_67;
    ButtonMap[7][8] = ui->pushButton_68;
    ButtonMap[7][9] = ui->pushButton_69;
    ButtonMap[7][10] = ui->pushButton_70;    

	ButtonMap[8][1] = ui->pushButton_71;
    ButtonMap[8][2] = ui->pushButton_72;
    ButtonMap[8][3] = ui->pushButton_73;
    ButtonMap[8][4] = ui->pushButton_74;
    ButtonMap[8][5] = ui->pushButton_75;
    ButtonMap[8][6] = ui->pushButton_76;
    ButtonMap[8][7] = ui->pushButton_77;
    ButtonMap[8][8] = ui->pushButton_78;
    ButtonMap[8][9] = ui->pushButton_79;
    ButtonMap[8][10] = ui->pushButton_80;   

	ButtonMap[9][1] = ui->pushButton_81;
    ButtonMap[9][2] = ui->pushButton_82;
    ButtonMap[9][3] = ui->pushButton_83;
    ButtonMap[9][4] = ui->pushButton_84;
    ButtonMap[9][5] = ui->pushButton_85;
    ButtonMap[9][6] = ui->pushButton_86;
    ButtonMap[9][7] = ui->pushButton_87;
    ButtonMap[9][8] = ui->pushButton_88;
    ButtonMap[9][9] = ui->pushButton_89;
    ButtonMap[9][10] = ui->pushButton_90;    

	ButtonMap[10][1] = ui->pushButton_91;
    ButtonMap[10][2] = ui->pushButton_92;
    ButtonMap[10][3] = ui->pushButton_93;
    ButtonMap[10][4] = ui->pushButton_94;
    ButtonMap[10][5] = ui->pushButton_95;
    ButtonMap[10][6] = ui->pushButton_96;
    ButtonMap[10][7] = ui->pushButton_97;
    ButtonMap[10][8] = ui->pushButton_98;
    ButtonMap[10][9] = ui->pushButton_99;
    ButtonMap[10][10] = ui->pushButton_100;          
}















