package GreedSnake;

import java.util.*;
import java.util.List;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.Serializable;
import java.awt.*;
/**
 * 整条蛇，和蛇有关的一切
 */
/*
class Animal implements Serializable
{
    private static final long serialVersionUID = 7526472295622776147L;
    Animal()
    {

    }
}*/
public class Snake implements Serializable   
{
    private static final long serialVersionUID = 795622776147L;
    public static final int InitLength = 2;
    List<SnakeEntity> body;
    //List<SnakeEntity> body = new ArrayList<SnakeEntity>();   //蛇的身体
    //SnakeLogic logic;   //游戏主逻辑
    int score = 0;      //蛇的分数
    boolean SnakeShow = true;   //是否显示蛇（撞墙或出局之后不显示）
    public static boolean CanTurnBack = true; 			//蛇是否可以掉头
	boolean CrossWall = false; 							//存储穿边墙信息
	SnakeEntity nextpart; 								//预测下一个body出现的位置
	int drawStyle = 0; 									//蛇身的样式，用于区别玩家
    int bodytoadd = 0; 	
    boolean hitWall = false;    //是否撞墙
    boolean GameisON = true;   //游戏是否开始
    int numLife = 300;   //总的生命数
    private int hhh;

    boolean inHole;   //是否在进洞过程中
    int whichHole;    //现在在哪个洞里面，出洞的时候排除
    int leftLength;   //进洞剩余长度
    int savedLength;   //开始进洞时储存的长度
    public boolean isTimeout = false;   //是否暂停游戏

    
    Snake()     
    {

    }
    Snake(SnakeLogic p, int x, int y)
    {
        //logic = p;
        body = new ArrayList<SnakeEntity>(); 
        body.add(new SnakeEntity(x, y, 4));
        GenerateNext();
        AddBody(InitLength-1);
        SnakeShow = true;
        numLife = 3;

        

    }

    Snake(SnakeLogic p)
    {
        //logic = p;
        body = new ArrayList<SnakeEntity>(); 
        body.add(new SnakeEntity(10, 10, 4));
        GenerateNext();
        AddBody(InitLength-1);
        SnakeShow = true;
        numLife = 3;

        

    }

    public void reLife(int kind, SnakeLogic logic)   //撞到之后重新初始化使用
    {

        int relifex;
        int relifey;

        int numHole = 0;
        if (kind == 1)
        {
            Random ran = new Random();
            int temp = ran.nextInt(100);
            numHole = 7+ temp % 2;

        }
        else
        {
            Random ran = new Random();
            int temp = ran.nextInt(100);
            numHole = 9+ temp % 2;
        }
        
        for (int i = body.size() - 1; i >= 0; i--) 
        {
            Entity temp = body.get(i);
            int x = temp.locx, y = temp.locy;
            logic.GridState[x][y] = false;
            logic.GridBlocked[x][y] = false;
        }   //恢复棋盘状态

        relifex = logic.entities[numHole].locx;
        relifey = logic.entities[numHole].locy;
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
                dx =  0;dy = 1;
            }
            int newX = relifex + dx;
            int newY = relifey + dy;
            if (newX<0||newX >= logic.MapMaxX || newY < 0 || newY >=logic.MapMaxY || logic.GridBlocked[newX][newY])   //如果出洞方向会带来死亡，就换方向
                continue;
             
            dir = k;
            break;
        }
        body = new ArrayList<SnakeEntity>();
        body.add(new SnakeEntity(relifex, relifey, dir));
        hitWall = false;
        bodytoadd = 0;
        GenerateNext();
        AddBody(InitLength-1);
        numLife -= 1;
        SnakeShow = true;   //初始化之后开始显示

        
        
    }

    public void initComponnent()
    {
        

    }

    public void MoveStep(SnakeLogic logic)   //向前移动一步
    {

        if (isTimeout)
            return;
        Tail(logic);
        AddBody(logic);
    }

    void Tail(SnakeLogic logic)    //移动的时候将蛇的尾巴去掉
    {
        if (bodytoadd >= 0) 
        {
			bodytoadd --;
			return;
		}
		SnakeEntity tail = body.get(body.size() - 1);
		logic.GridState[tail.locx][tail.locy] = false;
		if (SnakeLogic.isSnakeWall)
			logic.GridBlocked[tail.locx][tail.locy] = false;
		body.remove(body.size() - 1);
    }

    public void outHole(SnakeLogic logic)    //蛇出洞
    {
        int tempx = logic.entities[logic.entities[this.whichHole].nextHole].locx, 
            tempy = logic.entities[logic.entities[this.whichHole].nextHole].locy;
        this.inHole = false;

        int dir = 4;
        for (int k = 4;k >0;k--)
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
            int newX = tempx + dx;
            int newY = tempy + dy;
            if (newX<0||newX >= logic.MapMaxX || newY < 0 || newY >=logic.MapMaxY || logic.GridBlocked[newX][newY])   //如果出洞方向会带来死亡，就换方向
                continue;
             
            dir = k;
            break;
        }





        body = new ArrayList<SnakeEntity>();
        body.add(new SnakeEntity(tempx, tempy, dir));  //一个不是自己的洞，出洞方向
        hitWall = false;
        bodytoadd = 0;
        GenerateNext();
        AddBody(savedLength-1);
        SnakeShow = true;   //初始化之后开始显示

    }

    public synchronized void AddBody(SnakeLogic logic)  //移动的时候头增加一个
    {
        if(this.inHole)
        {
            if (this.leftLength == 0)
                outHole(logic);
            //System.out.println("Addbody -- this.inhole ="+this.leftLength);
            this.leftLength -= 1;
            
            return;      //在进洞的时候不增加长度

        }
            
        if (SnakeLogic.isSnakeWall)  //添加到障碍物
            logic.GridBlocked[nextpart.locx][nextpart.locy] = true;
        logic.GridState[nextpart.locx][nextpart.locy] = true;
        body.add(0, nextpart);
        GenerateNext();
    }

    public void AddBody(int num) 
    {
		bodytoadd += num;
    }
    
    public void GenerateNext()
    {
        hitWall = false;
        SnakeEntity head = body.get(0);
		
        switch(head.dir)
        {
		case 1:
            if (head.locy <= 0) 
            {
				if (!SnakeLogic.hasSideWall)
					head = new SnakeEntity(head.locx, SnakeLogic.MapMaxY, head.dir);
				else
					hitWall = true;
			}
			nextpart = new SnakeEntity(head.locx, head.locy - 1, head.dir);
			break;
		case 2:
            if (head.locy >= SnakeLogic.MapMaxY - 1) 
            {
				if (!SnakeLogic.hasSideWall)
					head = new SnakeEntity(head.locx, -1, head.dir);
				else
					hitWall = true;
			}
			nextpart = new SnakeEntity(head.locx, head.locy + 1, head.dir);
            break;
        case 3:
            if (head.locx <= 0) 
            {
				if (!SnakeLogic.hasSideWall)
					head = new SnakeEntity(SnakeLogic.MapMaxX, head.locy, head.dir);
				else
					hitWall = true;
			}
			nextpart = new SnakeEntity(head.locx - 1, head.locy, head.dir);
			break;
		case 4:
            if (head.locx >= SnakeLogic.MapMaxX - 1) 
            {
				if (!SnakeLogic.hasSideWall)
					head = new SnakeEntity(-1, head.locy, head.dir);
				else
					hitWall = true;
			}
			nextpart = new SnakeEntity(head.locx + 1, head.locy, head.dir);
			break;
		default:
			break;
		}
    }

    public void SetDirection(int d)  //设定蛇头方向并且走一步
    {
        SnakeEntity head = this.body.get(0);
        if ((d+head.dir == 3 && d*head.dir == 2) || (d+head.dir == 7 && d*head.dir == 12))
            return;     //不能掉头
        body.get(0).dir = d;
        GenerateNext();
    }


    void DrawBody(Graphics g, int kind)  //绘制蛇的身体
    {
        body.get(body.size() - 1).DrawTail(g);
        for (int i = body.size() - 2; i > 0; i--) 
        {
			body.get(i).DrawObject(g, null);
		}
		body.get(0).DrawHead(g, kind);
    }

    public boolean judgeHit(SnakeLogic logic)  //判断是否相撞（与障碍物）
    {
        //在洞里
        if(this.inHole)
            return false;    //正在进洞，不相撞
        //撞两边的墙
        if(hitWall)
        {
            hitWall = false;
            return true;
        }

        //int hitted = -1;
        for (int i = 0;i < logic.entities.length;i++)
        {
            if (this.nextpart.IsHit(logic.entities[i]))
            {
                
                //可以增加相应吃食物效果
                if (logic.entities[i].kind == 1)
                {
                    //System.out.println("Hit Food");
                    logic.entities[i].paintORnot = false;
                    this.bodytoadd += 1;
                    this.score += 1;    //吃一个蛋加2分
                    //System.out.println(this.bodytoadd);
                    logic.GridState[logic.entities[i].locx][logic.entities[i].locy] = false;
                    final int hhh = i;
                    //logic.entities.remove(hitted);
                    if ((!logic.entities[0].paintORnot)&& (!logic.entities[1].paintORnot))
                    {
                        new Thread(new Runnable(){             //先吃蛋，并且等2s再出一个蛋
            
                            @Override
                            public void run() {
                                try  
                                {
                                    Thread.sleep(2000);
                                    logic.entities[0].GenerateLocation(logic);
                                    logic.entities[1].GenerateLocation(logic);

                                    //logic.soc.SynEntity(hhh);
                                    return;
                                }catch(InterruptedException e)
                                {
    
                                }
                            }
                        }).start();
                    }
                    
                    //logic.GridState[logic.entities[i].locx][logic.entities[i].locy] = false;
                    //break;
                    i = 1000000;
                    //("Hit food");
                    return false;
                }
                else if (logic.entities[i].kind == 3)   //进洞
                {
                    //System.out.println("Hit Hole");
                    this.inHole = true;
                    this.whichHole = i;   //储存了进哪个洞
                    this.savedLength = this.body.size()+bodytoadd;
                    this.leftLength = this.savedLength;
                    //System.out.println("Hit Hole");
                    return false;
                }


            }
            //break;
        }
            
        
        return logic.GridBlocked[nextpart.locx][nextpart.locy];

    }

}