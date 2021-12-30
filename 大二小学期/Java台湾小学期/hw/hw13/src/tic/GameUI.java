package tic;

import javax.swing.JFrame;
import javax.swing.JPanel;
import java.awt.*;
import javax.swing.*;
import java.awt.event.*;
import java.io.IOException;
import java.net.*;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.concurrent.TimeoutException;
import java.util.*;

import javax.swing.*;
import javax.swing.event.ChangeEvent;
import java.io.*;
import javax.imageio.*;

import javax.swing.event.ChangeListener;

class GameUI extends JFrame
{
    GamePanel game;           //游戏界面
    ConnectPanel connectPanel;   //连接界面

    GameUI()
    {
        JPanel now = (JPanel)this.getContentPane();
        now.setLayout(null);
        game = new GamePanel();
        connectPanel = new ConnectPanel(game);
        now.add(game);
        now.add(connectPanel);
        game.setBounds(0, 0, 550, 550);
        connectPanel.setBounds(550,0,250,600);
        this.setSize(800,600);
        this.setVisible(true);
        this.setDefaultCloseOperation(EXIT_ON_CLOSE);
    }

}

class GamePanel extends JPanel  implements ActionListener
{
    JButton[][] gamePage;   //表示3x3的棋盘格
    public boolean isServer = false;
    boolean ismyTurn;
    TicGame chessGame; 
    public SocketHandler soc;

    GamePanel()
    {
        gamePage = new JButton[3][3];
        chessGame = new TicGame();
        for (int i = 0;i < 3;i++)
            for (int j = 0;j < 3;j++)
            {
                gamePage[i][j] = new JButton();
                gamePage[i][j].addActionListener(this);
            }
                
        JPanel mask = new JPanel();
        //mask.setLayout(new GridBagLayout());
        mask.setLayout(new GridLayout(3,3));
        for (int i = 0;i < 3;i++)
            for (int j =  0;j < 3;j++)
                mask.add(gamePage[i][j]);
                //mask.add(gamePage[i][j],getGBC(i, j, 1, 1));
        this.setLayout(new GridLayout(1,1));
        this.add(mask);
        this.setSize(550,550);
        this.setVisible(true);

    }

    public void paintComponent(Graphics g)
    {
        try {
            Image img1 = ImageIO.read(getClass().getResourceAsStream("images/image1.png"));
            Image img2 = ImageIO.read(getClass().getResourceAsStream("images/image2.png"));
            for (int i = 0;i < 3;i++)
            for (int j = 0;j < 3;j++)
                if (chessGame.chess[i][j] == 1)
                    this.gamePage[i][j].setIcon(new ImageIcon(img1));
                    //this.gamePage[i][j].setText("X");
                else if (chessGame.chess[i][j] == -1)
                    this.gamePage[i][j].setIcon(new ImageIcon(img2));
                    //this.gamePage[i][j].setText("Y");
                else this.gamePage[i][j].setText("");
            //logic.gamePage[x][y].setIcon(new ImageIcon(img));
          } catch (Exception ex) {
            System.out.println(ex);
          }
        
    }

    @Override
    public void actionPerformed(ActionEvent e)
    {
        //System.out.println("button pressed");
        if (!ismyTurn)
            return;
        for (int i = 0;i < 3;i++)
            for (int j = 0;j <3;j++)
                if (e.getSource().equals(this.gamePage[i][j]))
                {
                    //System.out.println(""+i+" "+j);
                    int value;
                    JButton temp = gamePage[i][j];
                    if (!temp.getText().equals(""))
                        return;

                    try {
                        Image img1 = ImageIO.read(getClass().getResourceAsStream("images/image1.png"));
                        Image img2 = ImageIO.read(getClass().getResourceAsStream("images/image2.png"));
                        if (isServer)
                            temp.setIcon(new ImageIcon(img1));
                        else temp.setIcon(new ImageIcon(img2));

                        } catch (Exception ex) {
                            System.out.println(ex);
                    
                        }
                    if (isServer)
                    {
                       // System.out.println("jhhh");
                        //temp.setLabel("X");
                        value = 1;
                    }
                    else
                    {
                        //System.out.println("hhhhh");
                        //temp.setLabel("Y");
                        value = -1;
                    }
                    try{
                        //soc.output.writeBytes("hhh\n");
                        soc.output.writeBytes(""+i+" "+j+"\n");
                        System.out.println("发送");
                    }catch(IOException we)
                    {

                    }
                    chessGame.setPoint(i,j,value);
                    int result = chessGame.judgeWin();
                    String re = "";
                    if (result != 0)
                    {
                        if ((isServer && result == 1) ||(!isServer && result == -1))
                            re = "You win!";
                        else re = "You lose!";
                        JOptionPane.showMessageDialog(null, "游戏结束啦:" + re);
                        System.exit(0);
                    }
                    ismyTurn = false;

                    
                    
                    

                    break;
                }
        
        
    }
}

class ConnectPanel extends JPanel  implements ActionListener //游戏界面中的拨号连接界面 
{
    private boolean judge;    //判断连接是否成功
    JButton startserver, joinserver, back;
	JLabel address,	port, status, speed;
    JTextField txt_address,	txt_port;
   

    int portnum=0;   //端口
    boolean GameisOn;

    GamePanel game;

    ConnectPanel(GamePanel l)
    {
        game = l;
        initComponent();

    }

    public void initComponent() 
    {
        startserver = new JButton("Server");
		startserver.addActionListener(this);
		joinserver = new JButton("Client");
		joinserver.addActionListener(this);
		address = new JLabel("Address");
		port = new JLabel("Port");
		txt_address = new JTextField(12);
		txt_port = new JTextField(4);
        txt_port.setText(String.valueOf(1234));

        JPanel joinaddress = new JPanel();
		joinaddress.setLayout(new FlowLayout());
		joinaddress.add(address);
		joinaddress.add(txt_address);
		JPanel joinport = new JPanel();
		joinport.setLayout(new FlowLayout());
		joinport.add(port);
        joinport.add(txt_port);

        JPanel btn = new JPanel();
        //btn.setLayout(new BoxLayout(btn, BoxLayout.PAGE_AXIS));
        btn.setLayout(new FlowLayout());
		btn.add(joinserver);
        btn.add(startserver);
        
        

       
        JPanel input = new JPanel();

        input.setLayout(new BoxLayout(input, BoxLayout.Y_AXIS));
        JPanel tt = new JPanel();
        tt.setLayout(new FlowLayout());
        status = new JLabel("Connect Info", JLabel.CENTER);
        tt.add(status);
        
        input.add(tt);
        input.add(joinaddress);
        input.add(joinport);
        input.add(btn);
        this.add(input);
    }

    public void actionPerformed(ActionEvent e)
    {
        if (e.getSource().equals(this.startserver))
        {
            game.isServer = true;
            game.ismyTurn = true;
            game.repaint();
            game.setVisible(true);
            System.out.println("start server");
            try
            {
                portnum = Integer.parseInt(txt_port.getText());
            }catch(NumberFormatException ee)
            {
                JOptionPane.showMessageDialog(null, "端口输入格式错误", "输入错误", JOptionPane.ERROR_MESSAGE);
				return;
            }

            if (portnum > 65535 || portnum < 0) 
            {
				JOptionPane.showMessageDialog(null, "端口输入范围为0~65535", "输入错误", JOptionPane.ERROR_MESSAGE);
				return;
            }

            new Thread(new Runnable()
            {
            
                @Override
                public void run() 
                {
                    try
                    {
                        int checksleeptime = 1000;
                        ServerSocket server = new ServerSocket(portnum);
                        //System.out.println(InetAddress.getLocalHost().toString());
                        txt_address.setText(InetAddress.getLocalHost().toString().split("/")[1]);
                        txt_port.setText(""+portnum);
                        status.setText("等待玩家加入");
                        Socket connect = server.accept();
                        server.close();
                        status.setText("玩家" + connect.getInetAddress().toString() + "已连入，同步游戏设定中");
                        SocketHandler soc = new SocketHandler(true, connect, game);
                        game.soc = soc;
                        soc.SynParamServer();
                        Thread.sleep(checksleeptime);
						status.setText("同步成功，游戏即将开始...2");
						Thread.sleep(checksleeptime);
                        status.setText("同步成功，游戏即将开始...1");
                        StartGame();
                    }catch (IOException ie) 
                    {
						JOptionPane.showMessageDialog(null, "连接错误:" + ie.getMessage(), "错误", JOptionPane.ERROR_MESSAGE);
						ie.printStackTrace();
                    }catch(InterruptedException t)
                    {

                    }
                    
                }
            }).start();
        }
        else
        {
            game.isServer = false;
            game.ismyTurn = false;
            game.setVisible(true);
            game.isServer = false;
            try 
            {
				portnum = Integer.parseInt(txt_port.getText());
            } catch (NumberFormatException n) 
            {
				JOptionPane.showMessageDialog(null, "端口输入格式错误", "输入错误", JOptionPane.ERROR_MESSAGE);
				return;
			}
			if (portnum > 65535 || portnum < 0) {
				JOptionPane.showMessageDialog(null, "端口输入范围为0~65535", "输入错误", JOptionPane.ERROR_MESSAGE);
				return;
            }
            InetAddress tarip;
			try {
                tarip = InetAddress.getByName(txt_address.getText());
			} catch (Exception ex) {
				JOptionPane.showMessageDialog(null, "IP地址输入不正确", "输入错误", JOptionPane.ERROR_MESSAGE);
				return;
			}
            txt_address.setText(tarip.getHostAddress());
            try
            {
                Socket connect2 = new Socket(tarip, portnum);
                //connect2.setSoTimeout(3000);
                //connect2.connect(new InetSocketAddress(tarip, portnum), 3000);
                status.setText("已连接");
                SocketHandler soc2 = new SocketHandler(false, connect2, game);
                game.soc = soc2;
                game.soc.SynParamClient();

                new Thread(new Runnable(){
                
                    @Override
                    public void run() 
                    {
                        try
                        {
                            Thread.sleep(1000);
							status.setText("同步成功，游戏即将开始...2");
							Thread.sleep(1000);
							status.setText("同步成功，游戏即将开始...1");
                            Thread.sleep(1000);
                            StartGame();
                        }catch (InterruptedException e) 
                        {
							e.printStackTrace();
                        }catch(Exception oe)
                        {

                        }
                    }
                }).start();
            }catch (SocketTimeoutException r)
            {
                JOptionPane.showMessageDialog(null, "连接超时" , "错误", JOptionPane.ERROR_MESSAGE);
                return;
				//ie.printStackTrace();
            }
            catch (IOException ie) 
            { 
                JOptionPane.showMessageDialog(null, "连接错误:" + ie.getMessage(), "错误", JOptionPane.ERROR_MESSAGE);
				ie.printStackTrace();
            }
            
            catch(Exception eee)
            {

            }
        }
    }

    public void StartGame()
    {
        game.soc.startGame();
    }
}

class TicGame
{
    public int[][] chess;

    TicGame()
    {
        chess = new int[3][3];
        for (int i= 0;i<3;i++)
            for (int j = 0;j < 3;j++)
                chess[i][j] = 0;       //初始化棋盘
        
    }

    int judgeWin()   //游戏结束判断
    {
        
        for (int i = 0;i < 3;i++)
        {
            int temp = 0;
            for (int j = 0;j < 3;j++)
                temp += chess[i][j];
            if (temp == 3)
                return 1;
            else if (temp == -3)
                return -1;
            
        }

        for (int i = 0;i < 3;i++)
        {
            int temp = 0;
            for(int j = 0;j < 3;j++)
                temp += chess[j][i];
            if (temp == 3)
                return 1;
            else if (temp == -3)
                return -1;
        }
        int temp = 0;
        int temp2 = 0;
        for (int i = 0;i < 3;i++)
        {
            
            temp += chess[i][i];
            temp2 += chess[i][2-i];
        }
        if (temp == 3 || temp2 == 3)
                return 1;
            else if (temp == -3||temp2 == -3)
                return -1;

        return 0;


    }

    public void setPoint(int i, int j, int value)
    {
        chess[i][j] = value;
        for (int iii = 0;iii < 3;iii++)
        {
            for (int jj = 0;jj < 3;jj++)
                System.out.print(this.chess[iii][jj]);
            System.out.println("");
        }
    }
}
