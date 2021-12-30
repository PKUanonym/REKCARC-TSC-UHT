package GreedSnake;


import java.awt.*;
import java.awt.event.*;
import java.io.IOException;
import java.net.*;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.concurrent.TimeoutException;
import java.util.*;
import javax.imageio.*;
import javax.sound.sampled.AudioSystem;
import javax.swing.*;
import javax.swing.event.ChangeEvent;

import javax.swing.event.ChangeListener;
import java.applet.AudioClip;
import java.net.MalformedURLException;
import java.net.URL;
import javax.swing.JApplet;
import java.io.*;
import javax.sound.sampled.*;



class ConnectPanel extends JPanel implements ActionListener, ChangeListener   //游戏界面中的拨号连接界面 
{
    private boolean judge;    //判断连接是否成功
    private ChangeListener changeListener;
    JButton startserver, joinserver, back, music;
	JLabel address,	port, status, speed;
    JTextField txt_address,	txt_port;
    JSlider slider;     //调整速度使用
    GameUI ui;
    SnakeLogic logic;
    chatPanel chat;

    int portnum=0;   //端口
    boolean GameisOn;
    boolean MusicIsOn;
    Clip clp;

    ConnectPanel(GameUI parent, SnakeLogic l, chatPanel c)
    {
        //this.setBorder(BorderFactory.createLineBorder(new Color(175,238,238), 3));
        ui = parent;
        logic = l;
        chat = c;
        MusicIsOn = false;
        
        File clip = new File("GreedSnake/music/music.wav");
        try{
            clp = AudioSystem.getClip();
            clp.open(AudioSystem.getAudioInputStream(clip));
        }catch(Exception r)
        {
            System.out.println("加载音乐文件出错");
        }
        initComponent(parent);

    }

    public void initComponent(GameUI parent)
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

        speed = new JLabel("Speed");
        slider = new JSlider(1,5);
        slider.setPaintTicks(true);
        slider.setPaintLabels(true);
        slider.setMajorTickSpacing(1);
        //slider.setMinorTickSpacing(0.1);
        //slider.setFont(new Font("Arial", Font.ITALIC,3));
        
        Hashtable<Integer, JComponent> hashtable = new Hashtable<Integer, JComponent>();
        hashtable.put(1, new JLabel("1"));
        hashtable.put(2, new JLabel("slow"));     
        hashtable.put(3, new JLabel("3"));  
        hashtable.put(4, new JLabel("fast"));  
        hashtable.put(5, new JLabel("5"));       
        slider.setLabelTable(hashtable);



        
        slider.addChangeListener(this);
        slider.setEnabled(false);     //锁死按钮

        

        
        JPanel joinaddress = new JPanel();
		joinaddress.setLayout(new FlowLayout());
		joinaddress.add(address);
		joinaddress.add(txt_address);
		JPanel joinport = new JPanel();
		joinport.setLayout(new FlowLayout());
		joinport.add(port);
        joinport.add(txt_port);

        back = new JButton("Return");
		back.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				ui.setContentPane(ui.init);
				ui.revalidate();
				ui.pack();
				ui.repaint();
			}
		});

        JPanel btn = new JPanel();
        //btn.setLayout(new BoxLayout(btn, BoxLayout.PAGE_AXIS));
        btn.setLayout(new FlowLayout());
		btn.add(joinserver);
        btn.add(startserver);
        btn.add(back);
        

        JPanel s = new JPanel();
        s.setLayout(new FlowLayout());
        s.add(speed);
        s.add(slider);

        music = new JButton("");
        music.setPreferredSize(new Dimension(30,30));
        try {
            Image img1 = ImageIO.read(getClass().getResourceAsStream("image/music.png")).getScaledInstance(30, 30, Image.SCALE_DEFAULT);
            
            music.setIcon(new ImageIcon(img1));
            

            } catch (Exception ex) {
                System.out.println("音乐图标加载失败");
        
            }
        music.addActionListener(this);
        s.add(music);
        
        JPanel input = new JPanel();

        input.setLayout(new BoxLayout(input, BoxLayout.Y_AXIS));
        JPanel tt = new JPanel();
        tt.setLayout(new FlowLayout());
        status = new JLabel("Connect Info", JLabel.CENTER);
        tt.add(status);
        
        input.add(s);
        input.add(tt);
        input.add(joinaddress);
        input.add(joinport);
        input.add(btn);
        

        

        this.add(input);
    }

    public void stateChanged(ChangeEvent e)
    {
        JSlider temp = (JSlider)e.getSource();
        int value = temp.getValue();
        logic.changeWaitTime(value);
    }

    public static final int checksleeptime = 1000; //同步成功之后数3秒每秒的间隔
    public void actionPerformed(ActionEvent e)
    {
        if (e.getSource().equals(this.startserver))
        {
            logic.isServer = true;
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

            new Thread(new Runnable(){
            
                @Override
                public void run() {
                    while(true)
                    {
                        try{
                            Thread.sleep(100);
                            slider.setValue((1200-logic.waittime)/200);
                        }catch(InterruptedException e)
                        {

                        }
                        
                    }
                    
                }
            }).start();;
            
            new Thread(new Runnable()
            {
            
                @Override
                public void run() 
                {
                    try
                    {
                        ServerSocket server = new ServerSocket(portnum);
                        txt_address.setText(InetAddress.getLocalHost().toString().split("/")[1]);
                        txt_port.setText(""+portnum);
                        status.setText("等待玩家加入");
                        Socket connect = server.accept();
                        server.close();
                        chat.send.setEnabled(true);
                        chat.edit.setEnabled(true);
                        slider.setEnabled(true);
                        status.setText("玩家" + connect.getInetAddress().toString() + "已连入，同步游戏设定中");
                        SocketHandle soc = new SocketHandle(logic, connect, true);
                        soc.chat = chat;
                        soc.ui = ui;
                        soc.SynParamServer();
                        //System.out.println("Server 2");
                        soc.SynSnakeServer();
                        //System.out.println("Server 3");
                        logic.soc = soc;
                        chat.soc = soc;
                        Thread.sleep(checksleeptime);
						status.setText("同步成功，游戏即将开始...2");
						Thread.sleep(checksleeptime);
                        status.setText("同步成功，游戏即将开始...1");
                        soc.SynStartServer();
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
        else if (e.getSource().equals(this.joinserver))
        {
            new Thread(new Runnable(){
            
                @Override
                public void run() {
                    while(true)
                    {
                        try{
                            Thread.sleep(100);
                            slider.setValue((1200-logic.waittime)/200);
                        }catch(InterruptedException e)
                        {
                            
                        }
                        
                    }
                    
                }
            }).start();;
            logic.initX = 30;
            logic.initY = 30;
            logic.isServer = false;
            logic.my = new Snake(logic, 30, 30);
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
                Socket connect2 = new Socket();
                connect2.connect(new InetSocketAddress(tarip, portnum), 3000);
                
                chat.send.setEnabled(true);
                chat.edit.setEnabled(true);
                slider.setEnabled(true);
                status.setText("已连接");
                SocketHandle soc2 = new SocketHandle(logic, connect2, false);
                soc2.chat = chat;
                soc2.ui = ui;
                soc2.SynParamClient();
                soc2.SynSnakeClient();
                logic.soc = soc2;
                chat.soc = soc2;




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
                            logic.soc.SynStartClient();
                            StartGame();
                        }catch (InterruptedException e) 
                        {
							e.printStackTrace();
                        }catch(IOException e)
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
        else if (e.getSource().equals(this.music))
        {
            if (MusicIsOn)
                clp.stop();
            else
            {
                new Thread(new Runnable(){
                
                    @Override
                    public void run() {
                        clp.start();
                    }
                }).start();
            }
            MusicIsOn = !MusicIsOn;
        }
    }

    public void StartGame()
    {
        
        logic.addKeyListener(logic);   //game界面添加键盘监听事件
        this.GameisOn = true;
        logic.requestFocusInWindow();
        //this.StartGameThread();  //开启游戏逻辑主线程
        logic.soc.MainStartGame();
    }

}