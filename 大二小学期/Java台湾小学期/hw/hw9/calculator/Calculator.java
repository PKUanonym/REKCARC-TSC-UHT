package calculator;

import java.awt.*;
import javax.swing.*;
import java.util.*;
import javax.imageio.*;
import java.io.*;


public class Calculator extends JFrame
{
    JTextField txt=new JTextField();

    Calculator()
    {
        
        this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);  
        Container c = this.getContentPane();
        this.setTitle("Calculator");
        
        JMenuBar bar = new JMenuBar();  //菜单
        this.setJMenuBar(bar);
        JMenu viewMenu=new JMenu("View");
        JMenu editMenu=new JMenu("Edit");
        JMenu helpMenu=new JMenu("Edit");
        bar.add(viewMenu);
        bar.add(editMenu);
        bar.add(helpMenu);

        Font font1 = new Font("Simsun", Font.BOLD, 25);
        txt.setSize(350, 50);
        txt.setFont(font1);
        txt.setText("0");
        txt.setHorizontalAlignment(JTextField.RIGHT);  //文字右对齐
        //c.add(txt, BorderLayout.NORTH);

        JPanel center = new JPanel();
        center.setLayout(new GridBagLayout());
        //GridBagConstraints s = new GridBagConstraints();
        center.add(txt, getGBC(0,0,5,1));
        center.add(new JButton("MC"), getGBC(0, 1, 1, 1));
        center.add(new JButton("MR"), getGBC(1, 1, 1, 1));
        center.add(new JButton("MS"), getGBC(2, 1, 1, 1));
        center.add(new JButton("M+"), getGBC(3, 1, 1, 1));
        center.add(new JButton("M-"), getGBC(4, 1, 1, 1));

        center.add(new JButton("<-"), getGBC(0, 2, 1, 1));
        center.add(new JButton("CE"), getGBC(1, 2, 1, 1));
        center.add(new JButton("C"), getGBC(2, 2, 1, 1));
        center.add(new JButton("="), getGBC(3, 2, 1, 1));
        center.add(new JButton("根号"), getGBC(4, 2, 1, 1));

        center.add(new JButton("7"), getGBC(0, 3, 1, 1));
        center.add(new JButton("8"), getGBC(1, 3, 1, 1));
        center.add(new JButton("9"), getGBC(2, 3, 1, 1));
        center.add(new JButton("/"), getGBC(3, 3, 1, 1));
        center.add(new JButton("%"), getGBC(4, 3, 1, 1));

        center.add(new JButton("7"), getGBC(0, 3, 1, 1));
        center.add(new JButton("8"), getGBC(1, 3, 1, 1));
        center.add(new JButton("9"), getGBC(2, 3, 1, 1));
        center.add(new JButton("/"), getGBC(3, 3, 1, 1));
        center.add(new JButton("%"), getGBC(4, 3, 1, 1));

        center.add(new JButton("4"), getGBC(0, 4, 1, 1));
        center.add(new JButton("5"), getGBC(1, 4, 1, 1));
        center.add(new JButton("6"), getGBC(2, 4, 1, 1));
        center.add(new JButton("*"), getGBC(3, 4, 1, 1));
        center.add(new JButton("1/x"), getGBC(4, 4, 1, 1));

        center.add(new JButton("1"), getGBC(0, 5, 1, 1));
        center.add(new JButton("2"), getGBC(1, 5, 1, 1));
        center.add(new JButton("3"), getGBC(2, 5, 1, 1));
        center.add(new JButton("-"), getGBC(3, 5, 1, 1));
        center.add(new JButton("="), getGBC(4, 5, 1, 2));

        center.add(new JButton("0"), getGBC(0, 6, 2, 1));
        center.add(new JButton("."), getGBC(2, 6, 1, 1));
        center.add(new JButton("+"), getGBC(3, 6, 1, 1));
        





        c.add(center, BorderLayout.CENTER);
        setVisible(true);
        setSize(400,500);

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

    

}