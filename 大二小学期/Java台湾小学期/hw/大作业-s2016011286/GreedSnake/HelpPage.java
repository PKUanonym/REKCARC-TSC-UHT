package GreedSnake;

import java.awt.*;
import javax.swing.*;
import java.awt.event.*;


/*
游戏的帮助说明界面
*/

class HelpPage extends JPanel
{
    private GameUI ui;
    HelpPage(GameUI parent)
    {
        ui = parent;
        initComponent(parent);
    }

    public void initComponent(GameUI parent)
    {
        this.setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));
        this.add(new JLabel("Greed Snake"));
        this.add(new JLabel("操作说明："));
		this.add(new JLabel("		上下左右方向键或者ASDW控制蛇的移动"));
		this.add(new JLabel("		按空格暂停游戏（对双方有效）"));
		this.add(new JLabel("		通过旁边的speed滑块调整速度，对双方有效"));
		this.add(new JLabel("		按音符按钮可以播放或暂停音乐"));
		this.add(new JLabel("		游戏信息会在地图上方显示"));
        this.add(new JLabel(" "));
        this.add(new JLabel("连接说明："));
		this.add(new JLabel("		点击server为建立服务器，ip会在上方显示"));
		this.add(new JLabel("		点击client为连接服务器，IP与端口需要自己输入"));
		this.add(new JLabel("		点击Return为返回游戏初始界面"));
        this.add(new JLabel(" "));
        this.add(new JLabel("其他说明："));
		this.add(new JLabel("		游戏结束后会更新分数到排行榜，可以自行查看"));
        this.add(new JLabel(" "));
        
        JButton Back = new JButton("Back");
        
        ActionListener listener = new ActionListener() 
        {
            public void actionPerformed(ActionEvent e) 
            {
				parent.setContentPane(parent.init);
				parent.revalidate();
				parent.pack();
				parent.repaint();
			}
        };
        
        Back.addActionListener(listener);
        this.add(Back);
        this.setSize(800,600);
    }

}