package GreedSnake;

import javax.swing.JPanel;
import java.awt.*;
import java.awt.event.*;
import java.io.IOException;

import javax.swing.*;

class chatPanel extends JPanel implements ActionListener
{
    public JTextArea content;     //显示聊天内容
    public JTextField edit;        //发送框
    public JButton send;          //发送消息
    public SocketHandle soc;

    public chatPanel()
    {
        content = new JTextArea();
        content.setBackground(new Color(255,250,240));
        content.setBorder(BorderFactory.createLineBorder(new Color(175,238,238), 3));
        content.setEditable(false);
        edit = new JTextField(12);
        edit.setBackground(new Color(245,245,245));
        edit.setBorder(BorderFactory.createLineBorder(new Color(175,238,238), 3));
        edit.setEnabled(false);
        send = new JButton("Send");
        send.addActionListener(this);
        send.setEnabled(false);
        initComponent();
    }

    public void initComponent()
    {
        
        JPanel hold = new JPanel();
        /*
        hold.setLayout(new GridBagLayout());
        hold.add(content, getGBC(0,0,3,4));
        hold.add(edit, getGBC(0,5,3,1));
        hold.add(send, getGBC(2,5,1,1));
        hold.add(new JButton(), getGBC(0,5,1,1));
        hold.add(new JButton(), getGBC(1,5,1,1));*/

        hold.setLayout(new BorderLayout());
        hold.add("Center", content);
        JPanel mess = new JPanel();
        mess.setLayout(new FlowLayout());
        mess.add(edit);
        mess.add(send);
        hold.add("South", mess);

        this.setLayout(new GridLayout(1,1));
        this.add(hold);

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

    public void shake()   //jpanel抖动函数
    {
        Point point = this.getLocation();
        for (int i = 10;i >= 0;i--)
        {
            for(int j=10;j>0;j--)
            {
                point.y+=i;
                this.setLocation(point);
                point.x+=i;
                this.setLocation(point);
                point.y-=i;
                this.setLocation(point);
                point.x-=i;
                this.setLocation(point);
                 
                 
            }
        }
    }

    @Override
    public void actionPerformed(ActionEvent e)   //点击发送按钮之后，发送消息并清空编辑栏
    {
        String mess = edit.getText();
        
        try{
            if (!soc.isServer)     //客户端向服务器传送消息
            {
                soc.TransMess();
                soc.output.writeBytes(mess+"\n");
            }
                
            edit.setText("");
            if (soc.isServer)
            {
                content.append("Server:  "+mess+"\n");
                shake();
                soc.message.mess = content.getText();
            }
            else content.append("Client:    "+mess+"\n");
            
        
        }catch(IOException r)
        {
            System.out.println("发送消息失败");
        }
         
    }


}