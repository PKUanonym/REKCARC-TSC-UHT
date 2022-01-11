package GreedSnake;

import java.io.*;
import java.net.*;
import java.awt.*;
import javax.swing.*;

import GreedSnake.GameUI;
import java.util.*;


class Message implements Serializable
{
    private static final long serialVersionUID = 79898598494545147L;
    public String mess = "";
    boolean shake;   //是否窗口抖动
    Message()
    {
        mess = "";
    }
}
/**
 * 处理网络通信的类
 */
class SocketHandle    
{

    public static final int Params = 0x0020; 
    public static final int Objects = 0x0002;  //同步物体
    public static final int SnakeParam = 0x2221;
    public static final int MESSAGE = 0x0011;  //发送消息
    public static final int StartGame = 0x0021;
    public static final int ConnectCheck = 0x0001;
    public static final int DIRECT_CHANGE = 0x0000;//改变方向
    public static final int SYN_ENTITY = 0x0031;//同步物体
    public static final int STOP_Game = 5;  //暂停游戏信号
    public GameUI ui;
    public SnakeLogic logic;
    Socket connect;
    boolean gameIsOn;
    boolean isServer;   //因为写在了一起，要判断是否是服务器
    public DataOutputStream output;
    public BufferedReader input;
    public chatPanel chat;
    public Message message;  //要传送的聊天消息
    

    SocketHandle(SnakeLogic l, Socket s, boolean n)  //绑定游戏逻辑、通信
    {
        logic = l;
        connect = s;
        isServer = n;
        gameIsOn = false;
        message = new Message();
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

    public void TransMess()     //传送消息特征数
    {
        try{
            //ObjectOutputStream out = new ObjectOutputStream(connect.getOutputStream());
            System.out.println("MESSAGE is "+MESSAGE);
            output.writeInt(MESSAGE);
            output.flush();
        }catch(IOException t)
        {
            System.out.println("同步message出错");
            
        }
        
    }
    /**
     * 服务器向客户端同步地图参数信息
     */
    public boolean SynParamServer() throws IOException
    {
        ObjectOutputStream out = new ObjectOutputStream(connect.getOutputStream());
        //System.out.println("SynParamServer() 1");
        out.write(Params);
        //System.out.println(Params);
        out.writeInt(logic.MapMaxX);
        //System.out.println(logic.MapMaxX);
        out.writeInt(logic.MapMaxY);
        out.writeBoolean(logic.isSnakeWall);
        out.writeBoolean(logic.hasSideWall);

        out.write(Objects);
        int sum = 3*logic.difficulty + 4;
        out.writeInt(sum);   //同步墙的数目
        Wall wtemp;
        for (int i = 0;i < sum;i++)
        {
            wtemp = logic.walls[i];
            out.writeInt(wtemp.locx);
            out.writeInt(wtemp.locy);
            out.writeInt(wtemp.length);
        }


        Entity temp;
        for (int i = 0;i < 11;i++)   //将随机生成的物体同步给客户端
        {
            temp = this.logic.entities[i];
            out.writeInt(temp.locx);
            out.writeInt(temp.locy);
        }
        int seed = logic.random.getSeed();
        out.writeInt(logic.random.getSeed());
        logic.random = new Ran(seed);
        //System.out.println("服务器完成种子同步");

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
        //System.out.println("hhh");
        logic.MapMaxX = in.readInt();
        //System.out.println(""+logic.MapMaxX );
        logic.MapMaxY = in.readInt();
        //System.out.println(""+logic.MapMaxX + " "+logic.MapMaxY);
        logic.isSnakeWall = in.readBoolean();
        //System.out.println(""+logic.MapMaxX + " "+logic.MapMaxY+" "+logic.isSnakeWall);
        logic.hasSideWall = in.readBoolean();
        //System.out.println(""+logic.MapMaxX + " "+logic.MapMaxY+" "+logic.isSnakeWall +" "+logic.hasSideWall);

        int obj = in.read();
        if (obj != Objects)
        {
            System.out.println("同步物体失败");
            return false;
        }

        int sum = 0;   //同步墙的信息
        sum = in.readInt();
        logic.walls = new Wall[sum];
        for (int i = 0;i < 4;i++)
        {
            int x = in.readInt();
            int y = in.readInt();
            int length = in.readInt();
            logic.walls[i] = new AngleWall(x,y,length);
        }
        for (int i = 4;i < sum;i++)
        {
            int kind = i % 2;
            int x = in.readInt();
            int y = in.readInt();
            int length = in.readInt();
            if (kind == 0)
                logic.walls[i] = new HoriWall(x,y,length);
            else if (kind == 1)
                logic.walls[i] = new VertWall(x,y,length);

        }

        for (int i = 0;i < sum;i++)
            logic.walls[i].Generate(logic);

        Entity ttt;
        for (int i = 0;i < 11;i++)
        {
            ttt = logic.entities[i];
            logic.GridState[ttt.locx][ttt.locy] = false;
            logic.GridBlocked[ttt.locx][ttt.locy] = false;

            int xx = in.readInt();
            int yy = in.readInt();
            logic.entities[i].locx = xx;
            logic.entities[i].locy = yy;
            logic.GridState[xx][yy] = true;
            if (logic.entities[i].kind == 2)
            {
                logic.GridBlocked[xx][yy] = true;
            }
           
                


        }

        logic.random = new Ran(in.readInt());
        connect.getOutputStream().write(Params);
        connect.getOutputStream().flush();
        return true;
        
    }

    /**
     * 服务器端同步蛇的信息
     */
    public boolean SynSnakeServer() throws IOException
    {   
        ObjectOutputStream out = new ObjectOutputStream(connect.getOutputStream());
        //out.write(SnakeParam);
        out.writeInt(logic.my.body.get(0).locx);
        out.writeInt(logic.my.body.get(0).locy);
        out.flush();

        ObjectInputStream in = new ObjectInputStream(connect.getInputStream());
        int x = in.readInt();
        int y = in.readInt();
        logic.they = new Snake(logic, x, y);    //将对方的蛇同步进来
        logic.theyX = x;
        logic.theyY = y;

        return true;
    }

    /**
     * 服务器向客户端同步蛇的身体
     */
    public String SynSnakeBodyServer()
    {
        String info = "";
        //info = info + 
        for (int i = 0;i < logic.my.body.size();i++)   //自己蛇的信息
        {
            info = info + logic.my.body.get(i).locx + " "+logic.my.body.get(i).locy+"#";
        }
        info = info + "&&";
        for (int i = 0;i < logic.they.body.size();i++)
        {
            info = info + logic.they.body.get(i).locx + " "+logic.they.body.get(i).locy+"#"; 
        }
        info = info + "\n";
        return info;

    }

    public String SynFoodServer()
    {
        String info = "";
        for (int i = 0;i < logic.entities.length;i++)
        {
            if (logic.entities[i].kind != 1)
                break;
            Entity temp = logic.entities[i];
            info = info + temp.locx + " "+temp.locy+" ";
            if (temp.paintORnot)
                info = info + "1";
            else info = info + "0";
            info = info + "&&";
        }
        info = info+"\n";
        return info;
    }

    /**
     * 客户端同步蛇的信息
     */
    public boolean SynSnakeClient() throws IOException
    {
        ObjectInputStream in = new ObjectInputStream(connect.getInputStream());
		int locx = in.readInt();
		int locy = in.readInt();
        logic.they = new Snake(logic, locx, locy);
        logic.theyX = locx;
        logic.theyY = locy;
		ObjectOutputStream out = new ObjectOutputStream(connect.getOutputStream());
		out.writeInt(logic.my.body.get(0).locx);
		out.writeInt(logic.my.body.get(0).locy);
		out.flush();
		return true;
    }

    /**
     * 游戏开始服务器同步
     */
    public boolean SynStartServer() throws IOException
    {
        connect.getOutputStream().write(StartGame);
		if (connect.getInputStream().read() == StartGame)
			return true;
		return false;
    }

    /**
     * 游戏开始客户端同步
     */
    public boolean SynStartClient() throws IOException
    {
        if (connect.getInputStream().read() != StartGame)
            return false;
        connect.getOutputStream().write(StartGame);
        return true;
    }

    /**
     * 同步方向
     */

    public void SynDirection()
    {
        if (!isServer)
            new DirectionTrans(connect, this.DIRECT_CHANGE+this.logic.my.body.get(0).dir).start();
    }

    public void SynParam(int n)    //客户端向服务器同步参数
    {
       
        //System.out.println(n);
        if (!isServer)
            new DirectionTrans(connect, n).start();
            

    }

    /**
     * 同步物体
     */
    public void SynEntity(int index)
    {
        if (isServer)
        {
            new EntityTrans(connect, SYN_ENTITY + index, logic.entities[index].locx, logic.entities[index].locy).start();
        }
    }

    public boolean ModSnake(String info)
    {
        //System.out.println(info);
        String[] stack = info.split("&&");
        String[] my = stack[1].split("#");
        String[] they = stack[0].split("#");
        logic.my.body = new ArrayList<SnakeEntity>();
        for (String s:my)
        {
            String[] loc = s.split(" ");
            logic.my.body.add(new SnakeEntity(Integer.parseInt(loc[0]), Integer.parseInt(loc[1]), 4));
        }
        logic.they.body = new ArrayList<SnakeEntity>();
        for (String s:they)
        {
            String[] loc = s.split(" ");
            logic.they.body.add(new SnakeEntity(Integer.parseInt(loc[0]), Integer.parseInt(loc[1]), 4));
        }

        return true;


    }

    public boolean ModEntity(String info)
    {
        System.out.println(info);
        String[] stack = info.split("&&");
        String[] food1 = stack[0].split(" ");
        String[] food2 = stack[1].split(" ");
        logic.entities[0].locx = Integer.parseInt(food1[0]);
        logic.entities[0].locy = Integer.parseInt(food1[1]);
        logic.entities[1].locx = Integer.parseInt(food2[0]);
        logic.entities[1].locy = Integer.parseInt(food2[1]);
        if (food1[2].equals("1"))
            logic.entities[0].paintORnot = true;
        else logic.entities[0].paintORnot = false;

        if (food2[2].equals("1"))
            logic.entities[1].paintORnot = true;
        else logic.entities[1].paintORnot = false;

        //System.out.println(food2[2] == "1");
        //System.out.println(food1[2] + " "+food2[2]);
        //System.out.println(logic.entities[0].paintORnot + " "+logic.entities[1].paintORnot);

        return true;

    }

    /**
     * 游戏开始主控制
     */
    public void MainStartGame()
    {
        this.gameIsOn = true;
        if (isServer)
        {
            //服务器的传输信息线程
            new Thread(new Runnable(){
            
                @Override
                public void run() {
                    
                    //while (gameIsOn)
                    //{
                        try 
                        {
                            ObjectOutputStream out = new ObjectOutputStream(connect.getOutputStream());
                            while(gameIsOn)
                            {
                                Thread.sleep(logic.waittime);
                            
                                logic.Judge();
                                out.writeInt(ConnectCheck);   //服务器发送更新信息，并且传送蛇的身体信息
                                out.writeObject(logic.my);
                                out.flush();
                                out = new ObjectOutputStream(connect.getOutputStream());
                                out.writeObject(logic.they);
                                out.flush();

                                

                                out = new ObjectOutputStream(connect.getOutputStream());
                                out.writeObject(logic.entities[0]);
                                out.flush();

                                out = new ObjectOutputStream(connect.getOutputStream());
                                out.writeObject(logic.entities[1]);
                                out.flush();

                                out = new ObjectOutputStream(connect.getOutputStream());
                                out.writeObject(message);

                                out.flush();
                                //logic.Judge();    //服务器端的更新
                                logic.repaint();  //服务器端的重绘
                                chat.content.setText(message.mess);
                                if (logic.my.numLife == 0)
                                {
                                    JOptionPane.showMessageDialog(null, "哎，你输啦！" );
                                    //System.exit(0);
                                    ui.setContentPane(ui.init);
				                    ui.revalidate();
				                    ui.pack();
                                    ui.repaint();
                                    gameIsOn = false;
                                    RankPage.insertRank(logic.my.score);
                                }
                                    
                                else if (logic.they.numLife == 0)
                                {
                                    JOptionPane.showMessageDialog(null, "恭喜，你赢啦!" );
                                    //System.exit(0);
                                    ui.setContentPane(ui.init);
				                    ui.revalidate();
				                    ui.pack();
                                    ui.repaint();
                                    gameIsOn = false;
                                    RankPage.insertRank(logic.my.score);
                                }
                                    
                                //out.close();
                            }
                            
                        }
                        catch(java.net.SocketException rr)
                        {
                            JOptionPane.showMessageDialog(null, "客户端已断开，游戏终止" );
                            ui.setContentPane(ui.init);
				            ui.revalidate();
				            ui.pack();
                            ui.repaint();
                            gameIsOn = false;

                        }catch (InterruptedException e)
                        {
                            e.printStackTrace();
                        }catch (IOException e)
                        {
                            e.printStackTrace();
                        }

                    }
                //}
            }).start();

            //服务器监听对方同步的线程
            new Thread(new Runnable(){
        
                @Override
                public void run() {
                    //BufferedReader input;
    
                    try{
                        
                        while (gameIsOn)
                        {
                            int temp = input.read();
                            //System.out.println("temp"+temp);
                            
                            if (temp < 5)    //监听对方的方向信息
                            {
                                logic.they.SetDirection(temp);
                                continue;
                            }
                            //else System.out.println("temp is "+temp);
                            if (temp == STOP_Game)
                            {
                                logic.isTimeout = !logic.isTimeout;
                                logic.my.isTimeout = logic.isTimeout;
                            }
                            if (temp >= SYN_ENTITY && temp < SYN_ENTITY+6)
                            {
                                int index = temp - SYN_ENTITY;
                                logic.waittime = 1200-200*index;
                                
                                continue;
                            }
                            if (temp == MESSAGE)
                            {
                                System.out.println("开始接受消息了");
                                String mess = input.readLine();
                                System.out.println("接受到的消息是 "+mess);
                                chat.content.append("Client:    "+mess+"\n");
                                message.mess += "Client:    "+mess+"\n";     //服务区接受到消息之后同步到message中
                            }
    
                        }
                    }catch(IOException e)
                    {
                        
                    }
                    
                }
            }).start();

        }
        else    //客户端
        {
            new Thread(new Runnable(){
            
                @Override
                public void run() {
                    //BufferedReader input;
                    ObjectInputStream input;
                    try
                    {
                        //input = new BufferedReader(new InputStreamReader(connect.getInputStream()));
                        input = new ObjectInputStream(connect.getInputStream());
                        while(gameIsOn)
                        {
                            int temp = input.read();
                            //System.out.println("客户端收到"+temp);
                            if (temp == ConnectCheck)
                            {   
                                try{
                                    Object buff = input.readObject();
                                    
                                    if (buff!= null)
                                    {
                                        logic.they = (Snake) buff;
                                        logic.isTimeout = logic.they.isTimeout;
                                    }else{
                                        JOptionPane.showMessageDialog(null, "服务区中断了连接，游戏终止" );
                                        ui.setContentPane(ui.init);
				                        ui.revalidate();
				                        ui.pack();
                                        ui.repaint();
                                        gameIsOn = false;
                                    }
                                    
                                    input = new ObjectInputStream(connect.getInputStream());
                                    buff = input.readObject();
                                    if (buff!= null)
                                    {
                                        logic.my = (Snake) buff;
                                    }else{
                                        JOptionPane.showMessageDialog(null, "服务区中断了连接，游戏终止" );
                                        ui.setContentPane(ui.init);
				                        ui.revalidate();
				                        ui.pack();
                                        ui.repaint();
                                        gameIsOn = false;
                                    }

                                    if (logic.my.numLife == 0)
                                    {
                                        JOptionPane.showMessageDialog(null, "哎，你输啦！" );
                                        ui.setContentPane(ui.init);
				                        ui.revalidate();
				                        ui.pack();
                                        ui.repaint();
                                        gameIsOn = false;
                                        RankPage.insertRank(logic.my.score);
                                        //System.exit(0);
                                    }
                                        
                                    else if (logic.they.numLife == 0)
                                    {
                                        JOptionPane.showMessageDialog(null, "恭喜，你赢啦!" );
                                        ui.setContentPane(ui.init);
				                        ui.revalidate();
				                        ui.pack();
                                        ui.repaint();
                                        gameIsOn = false;
                                        RankPage.insertRank(logic.my.score);
                                        //System.exit(0);
                                    }

                                    input = new ObjectInputStream(connect.getInputStream());
                                    buff = input.readObject();
                                    if (buff!= null)
                                    {
                                        logic.entities[0] = (Entity) buff;
                                    }else{
                                        JOptionPane.showMessageDialog(null, "服务器中断了连接，游戏终止" );
                                        ui.setContentPane(ui.init);
				                        ui.revalidate();
				                        ui.pack();
                                        ui.repaint();
                                        gameIsOn = false;
                                    }

                                    input = new ObjectInputStream(connect.getInputStream());
                                    buff = input.readObject();
                                    if (buff!= null)
                                    {
                                        logic.entities[1] = (Entity) buff;
                                    }else{
                                        JOptionPane.showMessageDialog(null, "服务器中断了连接，游戏终止" );
                                        ui.setContentPane(ui.init);
				                        ui.revalidate();
				                        ui.pack();
                                        ui.repaint();
                                        gameIsOn = false;
                                    }

                                    input = new ObjectInputStream(connect.getInputStream());
                                    buff = input.readObject();
                                    if (buff!= null)
                                    {
                                        Message rece = (Message)buff;
                                        chat.content.setText(rece.mess);
                                    }else{
                                        JOptionPane.showMessageDialog(null, "服务器中断了连接，游戏终止" );
                                        ui.setContentPane(ui.init);
				                        ui.revalidate();
				                        ui.pack();
                                        ui.repaint();
                                        gameIsOn = false;
                                    }


                                }catch(ClassNotFoundException e)
                                {
                                    System.out.println("蛇的对象传输错误");

                                }
                                
                            
                                logic.repaint();
                            }
                            
                        }

                    }
                    catch(IOException e)
                    {

                    }
                }
            }).start();
        }

        
    }




}