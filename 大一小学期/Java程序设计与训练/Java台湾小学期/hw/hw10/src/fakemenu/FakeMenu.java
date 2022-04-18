package fakemenu;

import java.awt.*;
import java.awt.event.ActionListener;
import java.awt.event.*;

import javax.swing.*;

class FakeMenu  extends JFrame implements ActionListener
{
    FakeMenu()
    {
        this.setSize(600,400);
        this.setDefaultCloseOperation(this.EXIT_ON_CLOSE);
        JMenuBar menuBar = new JMenuBar();
		this.setJMenuBar(menuBar);
		JMenu menu1 = new JMenu("File");
		JMenu menu2 = new JMenu("Edit");
		JMenu menu3 = new JMenu("Help");
		menuBar.add(menu1);
		menuBar.add(menu2);
        menuBar.add(menu3);

        JMenuItem item1 = new JMenuItem("New");
		JMenuItem item2 = new JMenuItem("Open");
        JMenuItem item3 = new JMenuItem("Save");
        
        item1.addActionListener(this);
        item2.addActionListener(this);
        item3.addActionListener(this);
		menu1.add(item1);
		menu1.add(item2);
		menu1.add(item3);
        menu1.addSeparator();
        
        JMenuItem item11 = new JMenuItem("Copy");
		JMenuItem item22 = new JMenuItem("Cut");
        JMenuItem item33 = new JMenuItem("Paste");
        item11.addActionListener(this);
        item22.addActionListener(this);
        item33.addActionListener(this);
        
		menu2.add(item11);
		menu2.add(item22);
		menu2.add(item33);
        menu2.addSeparator();
        
        JMenuItem item12 = new JMenuItem("About");
        item12.addActionListener(this);
        
     
        menu3.add(item12);
		
        

        this.setVisible(true);

    }

    public void actionPerformed(ActionEvent e)
    {
        String cmd = e.getActionCommand();
        if (cmd.equals("New"))
        {
            System.out.println("New is pressed");
        }
        if (cmd.equals("Open"))
        {
            System.out.println("Open is pressed");
        }
        if (cmd.equals("Save"))
        {
            System.out.println("Save is pressed");
        }
        if (cmd.equals("Copy"))
        {
            System.out.println("Copy is pressed");
        }
        if (cmd.equals("Cut"))
        {
            System.out.println("Cut is pressed");
        }
        if (cmd.equals("Paste"))
        {
            System.out.println("Paste is pressed");
        }
        if (cmd.equals("About"))
        {
            System.out.println("About is pressed");
        }
    }
}