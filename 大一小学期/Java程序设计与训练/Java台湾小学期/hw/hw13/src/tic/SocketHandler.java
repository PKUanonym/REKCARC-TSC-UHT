package tic;

import java.net.*;
import java.util.*;
import java.io.*;
import java.awt.*;
import javax.swing.*;
import javax.imageio.*;

class SocketHandler
{
    public static int CHECK = 0x0002;
    public static int Params=0x0001;
    public boolean isServer;
    Socket connect;
    //public ObjectOutputStream out;
    //public ObjectInputStream in ;
    public DataOutputStream output;
    public BufferedReader input;
    GamePanel logic;
    SocketHandler(boolean server, Socket c, GamePanel t)
    {
        isServer = server;
        connect = c;
        logic = t;
        try{
            //out = new ObjectOutputStream(connect.getOutputStream());
            output = new DataOutputStream(connect.getOutputStream());
            input = new BufferedReader(new InputStreamReader(connect.getInputStream()));
            //pw = new PrintWriter(connect.getOutputStream());
            
        }catch(IOException r)
        {
            System.out.println("没成功");
        }
        
    }

    public boolean SynParamServer() throws IOException
    {
        ObjectOutputStream out = new ObjectOutputStream(connect.getOutputStream());
        //System.out.println("SynParamServer() 1");
        out.write(Params);
        
        System.out.println("服务器完成种子同步");

        out.flush();
        //System.out.println("SynParamServer() 2");
        if (connect.getInputStream().read() != Params)   //客户端收到信息之后需要回复 check一下，确保收到了
            return false;
        return true;
    }

    /**
     * 客户端收到服务器消息之后的同步
     */
    public boolean SynParamClient() throws IOException
    {
        ObjectInputStream in = new ObjectInputStream(connect.getInputStream());
        int hhh = in.read();
        //System.out.println(hhh);
		if (hhh != Params)
            return false;
        
        connect.getOutputStream().write(Params);
        connect.getOutputStream().flush();
        return true;
        
    }

    public void Syn(int n)
    {
        new DirectionTrans(connect, n).start();
    }
    public void startGame()
    {
            new Thread(new Runnable(){
        
                @Override
                public void run() {
                    
                    //BufferedReader input;
                    try{
                        //input = new BufferedReader(new InputStreamReader(connect.getInputStream()));

                        while (true)
                        {
                            
                            System.out.println("开始接受");
                            String temp = input.readLine();
                            //System.out.println("接受到了temp："+temp);
                            String[] points = temp.split(" ");
                            int x = Integer.parseInt(points[0]);
                            int y = Integer.parseInt(points[1]);
                            int value;
                            if (isServer)
                            {
                                value = -1;
                                //logic.gamePage[x][y].setText("Y");
                                try {
                                    Image img = ImageIO.read(getClass().getResourceAsStream("images/image2.png"));
                                    logic.gamePage[x][y].setIcon(new ImageIcon(img));
                                  } catch (Exception ex) {
                                    System.out.println(ex);
                                  }
                                //logic.gamePage[0][0].setText("Y");
                            
                                //logic.repaint();
                            }
                                
                            else 
                            {
                                value = 1;
                                //logic.gamePage[x][y].setText("X");
                                try {
                                    Image img = ImageIO.read(getClass().getResourceAsStream("images/image1.png"));
                                    logic.gamePage[x][y].setIcon(new ImageIcon(img));
                                  } catch (Exception ex) {
                                    System.out.println(ex);
                                  }
                                //logic.repaint();
                            }

                            logic.chessGame.setPoint(x,y,value);
                            int result = logic.chessGame.judgeWin();
                            String re = "";
                            if (result != 0)
                            {
                                if ((isServer && result == 1) ||(!isServer && result == -1))
                                    re = "You win!";
                                else re = "You lose!";
                                JOptionPane.showMessageDialog(null, "游戏结束啦:" + re);
                                System.exit(0);
                            }
                                
                            


                            logic.ismyTurn = true;
                            logic.repaint();

                            
                                

                            
                        }
                    }catch(IOException e)
                    {
                        
                    }
                    
                }
            }).start();

        
    }
}