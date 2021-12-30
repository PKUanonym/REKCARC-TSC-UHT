package GreedSnake;

import java.awt.*;
import javax.swing.*;
import javax.imageio.ImageIO;
import java.io.*;
import java.awt.event.*;


/*
游戏的开始界面，继承了JPanel
*/

public class InitPage extends JPanel 
                        implements ActionListener
{
    public GameUI ui;
    public JButton start, setting, ranking, help, exit,chatting;

    public InitPage(GameUI parent)   //界面切换的时候要用到ui里面的几个界面
    {
        ui = parent;
        init(parent);
       
        
    }

    public void init(GameUI parent)
    {   
        this.setLayout(new BoxLayout(this,BoxLayout.Y_AXIS));
        try 
        {
            JPanel head = new JPanel()
            {
				Image bg = ImageIO.read(GameUI.loader.getResourceAsStream("GreedSnake/image/header2.png"));
				public void paintComponent(Graphics g)
				{
                    int width = parent.getWidth();
                    int height = parent.getHeight();
                    g.drawImage(bg, 0, 0, width, height, this);
				}
			};
			head.setPreferredSize(new Dimension(800,600));
			head.setBounds(new Rectangle(800,600));
			this.add(head);
        } catch (IOException e) {e.printStackTrace();}

        JPanel bp = new JPanel(true);
        start = new JButton("Start Game");
        start.setOpaque(true);
        start.addActionListener(this);
        ranking = new JButton("Ranking List");
        ranking.addActionListener(this);


        help = new JButton("Help");
        help.addActionListener(this);


        exit = new JButton("Exit");
        exit.addActionListener(this);
        bp.add(start, getGBC(0, 0, 1, 2));
        //bp.add(setting, getGBC(0, 1, 1, 2));
        bp.add(ranking, getGBC(0, 2, 1, 2));
        bp.add(help, getGBC(0, 3, 1, 2));
        //bp.add(chatting, getGBC(0, 4, 1, 2));
        bp.add(exit, getGBC(0, 5, 1, 2));
        bp.setBounds(50, 450, 650, 120);
        bp.setOpaque(false);
        this.add(bp);
		
    }

    private JButton addButton(String text) 
	{
        JButton button = new JButton(text);
        //button.addActionListener(this);
        button.setPreferredSize(new Dimension(150, 45));
        //button.setMargin(new Insets(10,15,10,15));
        JPanel bp = new JPanel();
        bp.setPreferredSize(new Dimension(400,60));
        bp.add(button);
        this.add(bp);
        //this.add(button);
        return button;
    }

    GridBagConstraints getGBC(int x, int y, int width, int height)
    {
        GridBagConstraints temp = new GridBagConstraints();
        temp.gridx = x;
        temp.gridy = y;
        temp.gridwidth = width;
        temp.gridheight = height;
        temp.weightx = 100;
        temp.weighty = 100;
        temp.fill = GridBagConstraints.BOTH;
        return temp;
    }

    public void actionPerformed(ActionEvent e)
	{
		if(e.getSource().equals(exit))
		{
			System.exit(0);
			return;
		}
        if(e.getSource().equals(start))
        {
            ui.setContentPane(new GamePage(ui));
            ui.setSize(800, 600);
		    ui.pack();
        }
        if(e.getSource().equals(this.ranking))
        {
            ui.setContentPane(new RankPage(ui));
            ui.setSize(800, 600);
		    //this.setBounds(200, 100, 1200, 800);
		    ui.pack();
            //System.out.println("Rank");
        }
			
        if(e.getSource().equals(help))
        {
            ui.setContentPane(ui.help);
        }
		ui.revalidate();
		ui.pack();
		ui.repaint();
	}

    

    
}