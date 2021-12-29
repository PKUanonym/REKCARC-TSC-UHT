package GreedSnake;

import javax.swing.JFrame;
import javax.swing.JPanel;
import java.awt.*;
import javax.swing.*;
import java.awt.event.*;

/*
游戏的主窗口类，JFrame的子类，内置多个panel，使用cardlayout来切换各个窗口
*/

public class GameUI extends JFrame implements ComponentListener
{
    public JPanel init;
    GamePage game;
    JPanel set;
    RankPage rank;
    JPanel help;
    JPanel chat;
    public String playerName;
    public static ClassLoader loader = new LoaderClass().getClass().getClassLoader();

    public GameUI(String name)
    {
        playerName = name;
        init = new InitPage(this);
        game = new GamePage(this);
        //set = new SetPage(this);
        rank = new RankPage(this);
        rank.currentName = name;
        help = new HelpPage(this);
        //chat = new ChatPage(this);
        this.UI_init();

    }

    private void UI_init()
    {
        //init = new InitPage(this);
        this.setContentPane(this.init);    //初始界面设置为initpage
        this.setSize(850, 620);
        
        this.setPreferredSize(new Dimension(850,620));
		this.pack();
        this.setTitle("Greedy Snake By liujiashuo");
        this.setDefaultCloseOperation(EXIT_ON_CLOSE);
        this.addComponentListener(this);



        
        //this.setVisible(true);
    }

    public int getWidth()
    {
        return this.getSize().width;
    }

    public int getHeight()
    {
        return this.getSize().height;
    }

    @Override 
    public void componentResized(ComponentEvent e)
    {
        int width = this.getSize().width;
        int height = this.getSize().height;
        game.resizeComponent(width, height);
        this.repaint();
        //System.out.println("大小"+width +" "+height );
    }
    public void componentHidden(ComponentEvent e)
    {

    }
    public void componentShown(ComponentEvent e)
    {

    }
    public void componentMoved(ComponentEvent e)
    {

    }
    


}

class LoaderClass {}