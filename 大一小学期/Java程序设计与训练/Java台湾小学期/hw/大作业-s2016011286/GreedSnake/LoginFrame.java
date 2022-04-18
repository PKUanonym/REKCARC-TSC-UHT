package GreedSnake;

import javax.swing.JTextField;
import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionListener;
import java.io.*;
import java.util.Scanner;
import java.awt.event.*;

import javax.imageio.*;

class Login extends JFrame implements ActionListener
{
    JButton login;
    JButton exit;
    JButton register;
    JTextField name;
    JPasswordField password; 

    Login()
    {
        login = new JButton("Login");
        login.addActionListener(this);
        exit = new JButton("Exit");
        exit.addActionListener(this);
        register = new JButton("Register");
        register.addActionListener(this);
        JLabel n = new JLabel("Name :");
        JLabel p = new JLabel("Password:");
        name = new JTextField(15);
        password = new JPasswordField(15);

        JPanel temp = (JPanel) this.getContentPane();
        temp.setLayout(new BoxLayout(temp,BoxLayout.Y_AXIS));
        

        try 
        {
            //System.out.print("hhhh");
            JPanel head = new JPanel()
            {
				Image bg = ImageIO.read(getClass().getResourceAsStream("image/header.png"));
				public void paintComponent(Graphics g)
				{
                    
                    g.drawImage(bg , 0, 0, 300, 100, this);
                    
                    //System.out.print("hhhh");
                    //g.fillArc(50, 10, 400, 400, 20, 13);
				}
			};
			head.setPreferredSize(new Dimension(300,100));
			//head.setBounds(new Rectangle(800,600));
			temp.add(head);
        } catch (IOException e) {e.printStackTrace();}




        JPanel nn = new JPanel();
        nn.setLayout(new FlowLayout());
        nn.add(n);
        nn.add(name);
        nn.setBackground(new Color(255, 255, 255));
        temp.add(nn);

        JPanel pp = new JPanel();
        pp.setLayout(new FlowLayout());
        pp.add(p);
        pp.add(password);
        pp.setBackground(new Color(255, 255, 255));
        temp.add(pp);

        JPanel btn = new JPanel();
        btn.setLayout(new FlowLayout());
        btn.add(login);
        btn.add(register);
        btn.add(exit);
        btn.setBackground(new Color(255, 255, 255));

        temp.add(btn);
        temp.setBackground(new Color(255, 255, 255));

        this.setSize(300, 350);
        this.setResizable(false);
        //temp.setBounds(0, 0, 200, 400);
    }


    @Override
    public void actionPerformed(ActionEvent e)
    {
        if (e.getSource().equals(this.register))
        {
            String name = this.name.getText();
            File f = new File("GreedSnake/data/name.txt");
            try{
                Scanner sin = new Scanner(new FileInputStream(f));
                while(sin.hasNext())
                {
                    String n = sin.nextLine();
                    if (name.equals(n))
                    {
                        JOptionPane.showMessageDialog(null, "用户名已存在，请重新输入" );
                        this.name.setText("");
                        this.password.setText("");
                        return;
                    }
                }
                //String pass = this.password.getText();
            }catch(IOException e3)
            {
                System.out.println("名字文件没打开");
            }

            try{
                /*
                PrintStream ps = new PrintStream(new FileOutputStream("GreedSnake/data/pass.txt"));
                ps.println(this.password.getPassword());
                ps = new PrintStream(new FileOutputStream("GreedSnake/data/name.txt"));
                ps.println(name);*/
                FileWriter writer1 = new FileWriter("GreedSnake/data/pass.txt", true);
                writer1.write(new String(this.password.getPassword())+"\n");
                FileWriter writer2 = new FileWriter("GreedSnake/data/name.txt", true);
                writer2.write(name+"\n");
                writer1.close();
                writer2.close();

            }catch(IOException e2)
            {
                System.out.println("输出文件没打开");
            }
        }
        else if (e.getSource().equals(this.login))
        {
            String name = this.name.getText();
            String pass = new String(this.password.getPassword());
            File f1 = new File("GreedSnake/data/name.txt");
            File f2 = new File("GreedSnake/data/pass.txt");
            try{
                Scanner sin1 = new Scanner(new FileInputStream(f1));
                Scanner sin2 = new Scanner(new FileInputStream(f2));
                boolean flag = false;
                while(sin1.hasNext() && sin2.hasNext())
                {
                    String temp1 = sin1.nextLine();
                    String temp2 = sin2.nextLine();
                    if (name.equals(temp1) && pass.equals(temp2))
                    {
                        flag = true;
                        break;
                    }
                }
                if(!flag)
                {
                    JOptionPane.showMessageDialog(null, "用户名或密码错误，请重新输入" );
                    this.name.setText("");
                    this.password.setText("");
                }
                else
                {
                    this.setVisible(false);
                    GameUI game = new GameUI(name);
                    game.setVisible(true);
                }
            }catch(IOException r)
            {
                System.out.println("用户信息文件没打开");
            }

        }
        else if (e.getSource().equals(this.exit))
        {
            System.exit(0);
			return;
        }
    }
}