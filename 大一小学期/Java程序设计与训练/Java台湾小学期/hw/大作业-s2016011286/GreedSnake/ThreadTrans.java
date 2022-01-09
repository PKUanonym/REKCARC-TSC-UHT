package GreedSnake;

import java.net.*;
import java.awt.*;
import java.io.IOException;
import java.net.Socket;
import java.util.*;
import javax.swing.*;
import java.io.*;



/**
 * 发送方向信息
 */

class DirectionTrans extends Thread  
{
    int direction;
    Socket connect;
    public DirectionTrans(Socket c, int d)
    {
        direction = d;
        connect = c;
    }

    @Override
    public void run()
    {
        new Thread(new Runnable(){
        
            @Override
            public void run() {
                try
                {
                    connect.getOutputStream().write(direction);
                }catch(IOException e)
                {
                    JOptionPane.showMessageDialog(null, "连接错误，请点击return返回", "错误", JOptionPane.ERROR_MESSAGE);
					//e.printStackTrace();
                }
            }
        }).start();
    }
}

/**
 * 发送物体信息
 */
class EntityTrans extends Thread 
{
    int index;
    int x;
    int y;
    Socket connect;
    EntityTrans(Socket s, int i, int xx, int yy)
    {
        connect = s;
        index = i;
        x = xx;
        y = yy;
    }

    @Override
    public void run()
    {
        new Thread(new Runnable(){
        
            @Override
            public void run() {
                try{
                    connect.getOutputStream().write(index);
                    connect.getOutputStream().write(x);
                    connect.getOutputStream().write(y);
                    connect.getOutputStream().flush();
                }catch(IOException e)
                {
                    JOptionPane.showMessageDialog(null, "连接错误，请点击return返回", "错误", JOptionPane.ERROR_MESSAGE);
					//e.printStackTrace();
                }
            }
        }).start();
    }

}