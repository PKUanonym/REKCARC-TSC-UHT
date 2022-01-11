package colorword;

import javax.swing.JFrame;
import javax.swing.*;
import java.awt.*;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.util.*;


class ColorWord extends JFrame  implements ItemListener
{
    JTextArea txt;
    JRadioButton jrb1;
    JRadioButton jrb2;
    public ColorWord()
    {
        this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);  
        this.setTitle("Color the Word");

        Container c = this.getContentPane();
        txt = new JTextArea();
        JPanel center = new JPanel();
        center.setLayout(new GridBagLayout());
        center.add(txt, getGBC(0, 0, 5, 5));

        ButtonGroup setcolor = new ButtonGroup();
        jrb1 = new JRadioButton("蓝色", true);
        jrb2 = new JRadioButton("红色", false);
        setcolor.add(jrb1);
        setcolor.add(jrb2);
        center.add(jrb1, getGBC(1, 5, 1, 1));
        center.add(jrb2, getGBC(3, 5, 1, 1));

        jrb1.addItemListener(this) ;
        jrb2.addItemListener(this) ;




        c.add(center, BorderLayout.CENTER);
        this.setSize(500, 500);
        this.setVisible(true);

    }
    GridBagConstraints getGBC(int x, int y, int width, int height)
    {
        GridBagConstraints temp = new GridBagConstraints();
        temp.gridx = x;
        temp.gridy = y;
        temp.gridwidth = width;
        temp.gridheight = height;
        temp.weightx = 30;
        temp.weighty = 30;
        temp.fill = GridBagConstraints.BOTH;
        return temp;
    }
    public void itemStateChanged(ItemEvent e)
    {
        if (e.getItemSelectable() == this.jrb1)
            txt.setForeground(Color.BLUE);
        else       
            txt.setForeground(Color.RED);
    }
}

