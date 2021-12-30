package GreedSnake;

import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JPanel;
import java.awt.*;


class GamePage extends JPanel
{
    private GameUI ui;
    public ConnectPanel connect;
    public chatPanel chat;
    public JPanel game;
    public SnakeLogic logic;
    int width, height;
    GamePage(GameUI parent)
    {
        ui = parent;
        logic = new SnakeLogic();
        chat = new chatPanel();
        connect = new ConnectPanel(parent, logic, chat);
        
        logic.setFocusable(true);

        this.setLayout(new BorderLayout());
        this.add("Center", logic);
        JPanel temp = new JPanel();
        temp.setLayout(new BorderLayout());
        temp.add("Center", chat);
        temp.add("South", connect);
        this.add("East", temp);
        /*
        this.setLayout(null);
        //this.setBackground(Color.BLUE);
       
       
        this.add(logic);
        this.add(connect);
        this.add(chat);

        int width = 800;
        int height = 600;
        //System.out.println(""+width+" "+height);
        logic.setBounds(0,0,(int)(0.6875*width), height);
        connect.setBounds((int)(0.6875*width), (int)(0.633*height), (int)(0.3125*width),(int)(0.33*height));
        chat.setBounds((int)(0.6875*width), 0, (int)(0.3125*width), (int)(0.6166*height));
        connect.setBackground(Color.BLUE);*/
        /*
        logic.setBounds(0, 0, 550, 600);
        connect.setBounds(550,380,250,200);
        chat.setBounds(550,0,250,370);*/
        

        //this.add(mask);
        this.setVisible(true);
        
    }

    public void paintComponent(Graphics g)
    {/*
        this.setLayout(null);
        this.add(logic);
        this.add(connect);
        this.add(chat);
        logic.setBounds(0,0,(int)(0.6875*width), height);
        connect.setBounds((int)(0.6875*width), (int)(0.633*height), (int)(0.3125*width),(int)(0.33*height));
        chat.setBounds((int)(0.6875*width), 0, (int)(0.3125*width), (int)(0.6166*height));
        this.setVisible(true);
        this.revalidate();*/
    }
    public void resizeComponent(int width, int height)
    {
        
        //System.out.println("resize"+w+" "+h);
        int size;
        if ((int)(0.6875*width) > height)
            size = height;
        else size = (int)(0.6875*width);
        Entity.AreaSize = size / 50;
        //logic.background = logic.PaintBackground();
        //System.out.println(Entity.AreaSize);
       
        
    }
}