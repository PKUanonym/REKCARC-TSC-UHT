package GreedSnake;

import java.awt.Color;
import java.util.*;
import javax.swing.*;
import java.awt.*;
import java.io.*;
import javax.imageio.*;
import java.awt.image.BufferedImage;

/**
 * 物体基类
 */

class Ran 
{
    public static int seed;   //种子
    public static Random random;
    Ran(int s)
    {
        seed = s;
        random = new Random(seed);
    }
    public int nextInt(int bound)
    {
        int r = ((random.nextInt() % bound) + bound) % bound;
        //System.out.println(r);
        return r;
    }
    static int getSeed()
    {
        return Ran.seed;
    }


}
public abstract class Entity  implements Serializable
{
    public int kind=0;    //标记种类，区分食物和障碍物
	public static int AreaSize=11; //判定方块的大小(像素)
    public int locx, locy;
    public boolean paintORnot;   //控制是否画出来，刚被吃的食物是不画的
    public int nextHole=-1;    //下一个出口
    //private int test;
    //public static Random ran = new Random(100);
	Entity(int x, int y)
    {
        locx = x;
        locy = y;
    }

    Entity()
    {
        
    }
    public abstract void DrawObject(Graphics g, Image i);
    public abstract void GenerateLocation();
    public void GenerateLocation(SnakeLogic d)
    {

    }
	public boolean IsHit(Entity target)
	{
		return (locx==target.locx)&&(locy==target.locy);
    }

    
    
    public int getX()
    {
        return locx;
    }

    public int getY()
    {
        return locy;
    }
}

class Food extends Entity    //地图中食物类
{
    //SnakeLogic logic;

    //public Image egg;
    Food(int x, int y, SnakeLogic c)  //制定位置生成
    {
        super(x,y);
        kind = 1;
        //logic = c;
        c.GridState[locx][locy] = true;
        paintORnot = true;
    }
    Food(SnakeLogic c)   //随机生成食物
    {
        //logic = c;
        kind = 1;
        GenerateLocation(c);
        c.GridState[locx][locy] = true;
        paintORnot = true;
       
    }

    public void GenerateLocation(SnakeLogic logic) 
    {
        paintORnot = true;
        //Random r = new Random();
        Ran r = logic.random;
		do {
			locx = r.nextInt(SnakeLogic.MapMaxX);
            locy = r.nextInt(SnakeLogic.MapMaxY);
            //System.out.println(locx);
        } while (logic.GridState[locx][locy]);
        logic.GridState[locx][locy] = true;
    }

    public void GenerateLocation() 
    {

    }

    
    @Override
    public void DrawObject(Graphics g, Image i) 
    {
        if (!paintORnot)
            return;
        /*
        g.setColor(Color.GREEN);
        //System.out.println(""+Entity.AreaSize*(this.locx-1));
        g.fillRect(Entity.AreaSize*(this.locx), 20+Entity.AreaSize*(this.locy), Entity.AreaSize, Entity.AreaSize);
        //g.drawRect(10, 10, 20, 20);*/
        if (i == null)
            System.out.println("鸡蛋图片加载失败");
        g.drawImage(i, Entity.AreaSize*(this.locx), 20+Entity.AreaSize*(this.locy), (int)(Entity.AreaSize*1.5), (int)(1.5*Entity.AreaSize), null);
	}
}

class Hole extends Entity 
{
    SnakeLogic logic;
    int nextHole = -1;
    Hole(int x, int y, SnakeLogic l)
    {
        super(x,y);
        kind = 3;
        logic = l;
        l.GridState[x][y] = true;
        paintORnot = true;
    }

    Hole(SnakeLogic l)  //随机生成洞
    {
        logic = l;
        kind = 3;
        GenerateLocation();
        l.GridState[locx][locy] = true;
        paintORnot = true;

    }
    @Override
    public void DrawObject(Graphics g, Image hole)
    {
        g.setColor(new Color(139,69,19));
        g.fillOval(Entity.AreaSize*(this.locx), 20+Entity.AreaSize*(this.locy), Entity.AreaSize, Entity.AreaSize);

    }

    @Override
    public void GenerateLocation()
    {
		Random r = new Random();
		do {
			locx = r.nextInt(SnakeLogic.MapMaxX);
			locy = r.nextInt(SnakeLogic.MapMaxY);
        } while (this.logic.GridState[locx][locy]);
        logic.GridState[locx][locy] = true;
    }
}

class Obstacle extends Entity
{
    //SnakeLogic logic;
    Obstacle(int x, int y, SnakeLogic l)
    {
        super(x,y);
        kind = 2;
        //logic = l;
        l.GridBlocked[x][y] = true;
        l.GridState[x][y] = true;
        paintORnot = true;
    }

    Obstacle(SnakeLogic l)     //随机生成障碍物
    {
        //logic = l;
        kind = 2;
        GenerateLocation(l);
        l.GridBlocked[locx][locy] = true;
        l.GridState[locx][locy] = true;
        paintORnot = true;
    }
    @Override
    public void DrawObject(Graphics g, Image stone) 
    {
        /*
		g.setColor(Color.GRAY);
        g.fillRect(Entity.AreaSize*(this.locx), 20+Entity.AreaSize*(this.locy), Entity.AreaSize, Entity.AreaSize);*/
        if (stone == null)
            System.out.println("石头图片加载失败");
        g.drawImage(stone, Entity.AreaSize*(this.locx), 20+Entity.AreaSize*(this.locy), (int)(Entity.AreaSize*1.5), (int)(1.5*Entity.AreaSize), null);
    }
    @ Override
    public void GenerateLocation()
    {
        
    }
    public void GenerateLocation(SnakeLogic logic) 
    {
		Random r = new Random();
		do {
			locx = r.nextInt(SnakeLogic.MapMaxX-1);
			locy = r.nextInt(SnakeLogic.MapMaxY-1);
		} while (logic.GridState[locx][locy]);
    }
}

class SnakeEntity extends Entity  implements Serializable  //蛇身体的每一部分，不是整条蛇
{
    private static final long serialVersionUID = 795622776147L;
    public int dir;    //1234 上下左右
    private int test;
    SnakeEntity(int x, int y, int d)
    {   
        super(x,y);
        dir = d;
        kind = 5;
        test = new Random().nextInt();
    }

    public int getTest()
    {
        return test;
    }

    @Override
    public void DrawObject(java.awt.Graphics g, Image i) 
    {
		g.setColor(Color.ORANGE);
        g.fillRect(Entity.AreaSize*(this.locx), 20+Entity.AreaSize*(this.locy), Entity.AreaSize, Entity.AreaSize);
        
    }
    public void DrawHead(Graphics g, int kind) 
    {
        if (kind == 1)
            g.setColor(Color.RED);
        else if (kind == 2)
            g.setColor(Color.GRAY);
        g.fillRect(Entity.AreaSize*(this.locx), 20+Entity.AreaSize*(this.locy), Entity.AreaSize, Entity.AreaSize);
        if (dir == 1)
        {
            //System.out.println("向上啦");
            g.setColor(Color.BLACK);
            g.fillOval(Entity.AreaSize*(this.locx)+Entity.AreaSize/5, 20+Entity.AreaSize*(this.locy)+Entity.AreaSize/5, Entity.AreaSize/5+1,Entity.AreaSize/5+1);
            g.fillOval(Entity.AreaSize*(this.locx)+(int)(Entity.AreaSize*0.8)-Entity.AreaSize/5, 20+Entity.AreaSize*(this.locy)+Entity.AreaSize/5, Entity.AreaSize/5+1,Entity.AreaSize/5+1);

        }
        else if (dir == 2)
        {
            g.setColor(Color.BLACK);
            g.fillOval(Entity.AreaSize*(this.locx)+Entity.AreaSize/5, 20+Entity.AreaSize*(this.locy)+(int)(Entity.AreaSize*0.8), Entity.AreaSize/5+1,Entity.AreaSize/5+1);
            g.fillOval(Entity.AreaSize*(this.locx)+(int)(Entity.AreaSize*0.8)-Entity.AreaSize/5, 20+Entity.AreaSize*(this.locy)+(int)(Entity.AreaSize*0.8), Entity.AreaSize/5+1,Entity.AreaSize/5+1);
        }
        else if (dir == 3)
        {
            g.setColor(Color.BLACK);
            g.fillOval(Entity.AreaSize*(this.locx)+Entity.AreaSize/5, 20+Entity.AreaSize*(this.locy)+Entity.AreaSize/5, Entity.AreaSize/5+1,Entity.AreaSize/5+1);
            g.fillOval(Entity.AreaSize*(this.locx)+Entity.AreaSize/5, 20+Entity.AreaSize*(this.locy)+(int)(Entity.AreaSize*0.8)-Entity.AreaSize/5, Entity.AreaSize/5+1,Entity.AreaSize/5+1);

        }
        else if (dir == 4)
        {
            g.setColor(Color.BLACK);
            g.fillOval(Entity.AreaSize*(this.locx)+(int)(Entity.AreaSize*0.8), 20+Entity.AreaSize*(this.locy)+Entity.AreaSize/5, Entity.AreaSize/5+1,Entity.AreaSize/5+1);
            g.fillOval(Entity.AreaSize*(this.locx)+(int)(Entity.AreaSize*0.8), 20+Entity.AreaSize*(this.locy)+(int)(Entity.AreaSize*0.8)-Entity.AreaSize/5, Entity.AreaSize/5+1,Entity.AreaSize/5+1);
        }
    }
    public void DrawTail(Graphics g)
    {
        g.setColor(Color.BLUE);
        g.fillOval(Entity.AreaSize*(this.locx), 20+Entity.AreaSize*(this.locy), Entity.AreaSize, Entity.AreaSize);
    }

    @ Override
    public void GenerateLocation()
    {

    }
}

