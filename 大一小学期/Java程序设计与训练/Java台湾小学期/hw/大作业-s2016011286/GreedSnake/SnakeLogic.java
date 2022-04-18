package GreedSnake;

import java.awt.image.BufferedImageFilter;

import java.awt.*;
import java.awt.event.KeyListener;
import java.util.*;
import java.util.logging.SocketHandler;

import javax.swing.*;

import GreedSnake.GameUI;

import java.awt.event.*;
import java.io.*;
import javax.imageio.*;
import java.awt.image.BufferedImage;

/**
 * 游戏的逻辑类
 */
class SnakeLogic extends JPanel implements KeyListener, MouseListener
{
    public int waittime = 200;
    public static  int MapMaxX = 50;
    public static  int MapMaxY = 50;
    public boolean[][] GridBlocked = new boolean[MapMaxX][MapMaxY]; //障碍物标志
    public boolean[][] GridState = new boolean[MapMaxX][MapMaxY]; //是否有物体标志
    public int initX = 10;
    public int initY = 10;
    public int theyX;
    public int theyY;

    public int relifeX;
    public int relifeY;
    
    public static boolean isSnakeWall = true; //蛇的身体算障碍物
    public static boolean hasSideWall = true;
    public boolean isTimeout;  //游戏暂停
    public static Ran random;   //随机数类

    public SocketHandle soc;
    public Entity[] entities;
    public boolean isServer;


    public int difficulty = 1;   //游戏难度系数，控制障碍物的数目等
    
    public Snake my = new Snake(this, initX, initY);
    public Snake they;                  //两条蛇

    public Wall[] walls;     //墙
    public JPanel gamePanel;            //绘制游戏界面
    public Image background;
    public int timestamp = 0;
    public bufferedImages buffered; 
    Random ran;
    

    SnakeLogic()
    {
        ran = new Random();
        Calendar cl = Calendar.getInstance();
        int second = cl.get(Calendar.SECOND);
        int min = cl.get(Calendar.MINUTE);
        buffered = new bufferedImages();
        random = new Ran(60*second + min); //设置好随机数种子

        for (int i = 0;i < MapMaxX;i++)
            for (int j = 0;j < MapMaxY;j++)
            {
                this.GridBlocked[i][j] = false;
                this.GridState[i][j] = false;
            }
        generateMap();   //先生成墙

        entities = new Entity[]{
                new Food(this),
                new Food(this),
                new Obstacle(this),
                new Obstacle(this),
                new Obstacle(this),
                new Obstacle(this),
                new Obstacle(this),
                new Hole(this),
                new Hole(this),
                new Hole(this),
                new Hole(this)
            };
            
        
        
        for (int i = 7;i < 10;i++)
        {
            this.entities[i].nextHole = i+1;
            //System.out.println(this.entities[i].nextHole);
        }
        this.entities[10].nextHole = 7;     //提前确定出洞
        background = PaintBackground();
        
        //this.addKeyListener(this);
        this.addMouseListener(this);
    }


    /**
     * 生成地图
     */
    void generateMap()     
    {
        
        int num = 3*difficulty;    //墙的数目是3*难度系数
        this.walls = new Wall[num+4];
        Random r = new Random();

        for (int i = 0;i < 4;i++)
        {
            int x = (r.nextInt() % MapMaxX + MapMaxX) % (MapMaxX/5);
            int y = (r.nextInt() % MapMaxY + MapMaxY) % (MapMaxY/5);
            int length = (r.nextInt() % 5 + 5) % 5 + 6;

            int judgex = i % 2;
            int judgey = i / 2;

            int xx, yy;

            if (judgex==1)
                xx = x;
            else xx = MapMaxX-3 - x;
            if (judgey==1)
                yy = y;
            else yy = MapMaxY-3 - y;
            
            this.walls[i] = new AngleWall(xx,yy,length);

            
        }

        for (int i = 4;i < num+4;i++)
        {
            int kind = i % 2;
            int x = (r.nextInt() % MapMaxX + MapMaxX) % (MapMaxX*3/5)+MapMaxX/5;
            int y = (r.nextInt() % MapMaxY + MapMaxY) % (MapMaxY*3/5)+MapMaxY/5;
            int length = (r.nextInt() % 5 + 5) % 6 + 7;

            
            if (kind == 0)
                this.walls[i] = new HoriWall(x,y,length);
            else if (kind == 1)
                this.walls[i] = new VertWall(x,y,length);
                /*
            else if (kind == 2)
                this.walls[i] = new AngleWall(x,y,length);
            else if (kind == 3)
            {
                x = (x % (MapMaxX/3)) + MapMaxX/3;
                y = (y % (MapMaxY/3)) + MapMaxY/3;
                length = length * 2;

                this.walls[i] = new CircleWall(x,y,length);
            }*/
                
        }

        for (int i = 0;i < num+4;i++)
            this.walls[i].Generate(this);    // 造墙

    }

    public Image PaintBackground()    //设置背景图片
    {
        BufferedImage bg = new BufferedImage((MapMaxX) * Entity.AreaSize, (MapMaxY) * Entity.AreaSize, BufferedImage.TYPE_3BYTE_BGR);
        Graphics2D g = bg.createGraphics();
        try 
        {
			g.drawImage(ImageIO.read(GameUI.loader.getResourceAsStream("GreedSnake/image/grass.jpg")), 0, 0, bg.getWidth(), bg.getHeight(), this);
		} catch (Exception e) {
			e.printStackTrace();
		}
		bg.flush();
		return bg;
        //return new BufferedImageFilter(null);
    }

    public void paintComponent(Graphics g)  //画背景、障碍、蛇
    {
        
        g.drawImage(background, 0, 20, (MapMaxX) * Entity.AreaSize, (MapMaxY) * Entity.AreaSize, this);
        g.setColor(Color.BLACK);
        //g.drawRect(10, 10, 50, 50);

        for(Wall w:walls)
        {
            w.DrawObject(g);
        }
        for (Entity e : entities) //绘制地图物体
        {
            //System.out.println(""+e.locx+" "+e.locy);
            if (e.kind == 1)
                e.DrawObject(g, buffered.egg);
            else if (e.kind == 2)
                e.DrawObject(g, buffered.stone);
            else if (e.kind == 3)
                e.DrawObject(g, buffered.hole);
            else e.DrawObject(g, null);
        }

        //System.out.println(""+my.SnakeShow);
        if(my.SnakeShow)
            my.DrawBody(g,1);
        int scores = 0;
        int numlife = 0;
        if (they != null) //绘制玩家
        {
            if(they.SnakeShow)
                they.DrawBody(g,2);
            scores = they.score;
            numlife = they.numLife;
        }


        g.setFont(new Font("Calibri", Font.ITALIC + Font.BOLD, 10));
        g.setColor(new Color(0, 0, 0, 0.9f));
        if (!my.inHole)
            g.drawString("Your Score: " + my.score+" Your life: "+my.numLife, 5, 15);
        else g.drawString("Your Score: " + my.score+" Your life: "+my.numLife+" In Hole", 5, 15);
        if (they!= null && !they.inHole)
            g.drawString("The Other Player's Score: " + scores+" His life: "+numlife, 230, 15);
        else g.drawString("The Other Player's Score: " + scores+" His life: "+numlife+" In Hole", 190, 15);
        if (isTimeout)
            g.drawString("TIME OUT", 450, 15);
        else
            g.drawString("GAME ON", 450, 15);

    }

    public void changeWaitTime(int value)
    {
        switch(value)
        {
            case 1:
                this.waittime = 1000;
                break;
            case 2:
                this.waittime = 800;
                break;
            case 3:
                this.waittime = 600;
                break;
            case 4:
                this.waittime = 400;
                break;
            case 5:
                this.waittime = 200;
                break;
            default:
                this.waittime = 600;
                break;
        }
        if (!isServer)
        {
            try{
                soc.SynParam(soc.SYN_ENTITY+value);
            }catch(java.lang.NullPointerException rr)
            {
                
            }
            
        }
    }

    public void HandleHit(Snake s)    //处理蛇撞到后的地图复原
    {
        
            for (int i = s.body.size() - 1; i >= 0; i--) 
            {
                Entity temp = s.body.get(i);
                int x = temp.locx, y = temp.locy;
                this.GridState[x][y] = false;
                this.GridBlocked[x][y] = false;
            } 
            
       
    }

    public void reLife(Snake snake, int kind)
    {
        int relifex;
        int relifey;
        int numHole = 0;
        if (kind == 1)
        {
            
            int temp = ran.nextInt(100);
            numHole = 7+ temp % 2;

        }
        else
        {
            int temp = ran.nextInt(100);
            numHole = 9+ temp % 2;
        }

        
        for (int i = snake.body.size() - 1; i >= 0; i--) 
        {
            Entity temp = snake.body.get(i);
            int x = temp.locx, y = temp.locy;
            this.GridState[x][y] = false;
            this.GridBlocked[x][y] = false;
        }   //恢复棋盘状态

        relifex = entities[numHole].locx;
        relifey = entities[numHole].locy;
        int dir = 4;
        for (int k = 1;k <5;k++)
        {
            int dx=0, dy=0;
            if (k == 1)
            {
                dx = 0;dy = 1;
            }
            else if (k == 2)
            {
                dx = 0;dy = -1;
            }
            else if (k == 3)
            {
                dx = -1;dy = 0;
            }
            else if (k == 4)
            {
                dx =  1;dy = 0;
            }
            int newX = relifex + dx;
            int newY = relifey + dy;
            if (newX<0||newX >= MapMaxX || newY < 0 || newY >=MapMaxY || GridBlocked[newX][newY])   //如果出洞方向会带来死亡，就换方向
                continue;
             
            dir = k;
            break;
        }

        snake.body = new ArrayList<SnakeEntity>();
        snake.body.add(new SnakeEntity(relifex, relifey, dir));
        snake.hitWall = false;
        snake.bodytoadd = 0;
        snake.GenerateNext();
        snake.AddBody(snake.InitLength-1);
        snake.numLife -= 1;
        snake.SnakeShow = true;   //初始化之后开始显示
    }

    public void Judge()    //每次刷新后的结算,判断有没有撞墙
    {
        
        if (this.isTimeout)
        {
            //System.out.println("Judge return by timeout");
            return;
        }
            
        timestamp += 1;
        boolean myHit=false;
        boolean theyHit=false;

        if (they!= null && my.nextpart.IsHit(they.nextpart))
        {
            my.reLife(1, this);
            they.reLife(2, this);
        }
        if (my.SnakeShow)
        {
            if (my.judgeHit(this))
            {
                
                if (my.numLife <= 1)
                {
                    my.numLife = 0;
                    my.SnakeShow = false;
                    myHit = true;
                   
                    this.GameEnd(1);
                }
                   
                else    
                {
                    
                    my.SnakeShow = false;
                    myHit = true;
                    
                    new Thread(new Runnable(){
                
                     @Override
                        public void run() 
                        {
                            try
                            {
                                Thread.sleep(2000);
                                
                                reLife(my, 1);
                                //System.out.println("my snake relife");
                            }catch(InterruptedException e)
                            {

                            }
                        
                        }
                    }).start();
                }
            }
            else    
                my.MoveStep(this);
        }
        
            
        if (they != null)
        {
            if (they.SnakeShow)
            {
                if (they.judgeHit(this))
                {
                //加上对手的判断
                    //System.out.println("They hit");
                    if (they.numLife <= 1)
                    {
                        they.numLife = 0;
                        they.SnakeShow = false;
                       
                        theyHit = true;
                        this.GameEnd(1);
                    }
                   
                    else    
                    {
                        they.SnakeShow = false;
                        
                        theyHit = true;
                        new Thread(new Runnable(){
                
                        @Override
                            public void run() 
                            {
                                try
                                {
                                    Thread.sleep(2000);
                                    reLife(they, 2);
                                    //System.out.println("they snake relife");
                                }catch(InterruptedException e)
                                {

                                }
                        
                            }
                        }).start();
                    }
                }
                
                else
                    they.MoveStep(this);
            }
            
        }

        if (myHit)
            HandleHit(my);
        if (theyHit)
            HandleHit(they);

    }

    public void GameEnd(int state)   //游戏结束
    {

    }

    @ Override
    public void keyPressed(KeyEvent e)  //检测键盘事件，上下左右的移动，还没有支持暂停什么的
    {
        //System.out.println("Key Pressed");
        switch (e.getKeyCode()) 
        {
            case KeyEvent.VK_LEFT:
            case KeyEvent.VK_A:
           
                        
                my.SetDirection(3);
                soc.SynDirection();
                break;
            case KeyEvent.VK_RIGHT:
            case KeyEvent.VK_D:
                my.SetDirection(4);
                soc.SynDirection();
                break;
            case KeyEvent.VK_UP:
            case KeyEvent.VK_W:
                my.SetDirection(1);
                soc.SynDirection();
                break;
            case KeyEvent.VK_DOWN:
            case KeyEvent.VK_S:
                my.SetDirection(2);
                soc.SynDirection();;
                break;
            
        }
    }
    @ Override
    public void keyReleased(KeyEvent e) 
    {
        switch (e.getKeyCode()) 
        {
            case KeyEvent.VK_SPACE:
                if (this.isTimeout)
                    this.isTimeout = false;
                else this.isTimeout = true;
                my.isTimeout = this.isTimeout;
                soc.SynParam(soc.STOP_Game);
                break;
        }
    }

	 @ Override
	public void keyTyped(KeyEvent e) {}

    
    @ Override
    public void mousePressed(MouseEvent e)
    {
        this.requestFocusInWindow();
    }
    @ Override
    public void mouseClicked (MouseEvent e)
    {
        this.requestFocusInWindow();
    }
    @ Override
    public void mouseEntered(MouseEvent e)
    {
        this.requestFocusInWindow();
    }
    @ Override 
    public void mouseExited (MouseEvent e)
    {

    }
    @ Override 
    public void mouseReleased  (MouseEvent e)
    {

    }


}