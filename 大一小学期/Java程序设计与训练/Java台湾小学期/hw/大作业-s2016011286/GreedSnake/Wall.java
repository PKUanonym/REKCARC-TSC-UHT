package GreedSnake;

import java.awt.Color;
import java.util.*;
import java.util.List;
import javax.swing.*;
import java.awt.*;
import java.io.*;
import javax.imageio.*;
import java.awt.image.BufferedImage;
/**
 * 墙的生成
 * */


class WallEntity implements Serializable
{
    private static final long serialVersionUID = 778735364676147L;
    private int locx, locy;
    private Image wallImg;
    WallEntity(int x, int y, SnakeLogic logic)
    {
        locx = x;
        locy = y;
        logic.GridState[locx][locy] = true;
        logic.GridBlocked[locx][locy] = true;     //标记好地图上的状态
        wallImg = PaintWall();
    }

    void DrawObject(Graphics g)
    {
        /*
        g.setColor(Color.RED);
        //System.out.println(""+Entity.AreaSize*(this.locx-1));
        g.fillRect(Entity.AreaSize*(this.locx), 20+Entity.AreaSize*(this.locy), Entity.AreaSize, Entity.AreaSize);
        */
        if (wallImg == null)
            System.out.println("墙壁图片加载失败");
        g.drawImage(wallImg, Entity.AreaSize*(this.locx), 20+Entity.AreaSize*(this.locy), (int)(Entity.AreaSize*1), (int)(1*Entity.AreaSize), null);
    }
    
    public Image PaintWall()    //设置背景图片
    {
        BufferedImage bg = new BufferedImage(Entity.AreaSize, Entity.AreaSize, BufferedImage.TYPE_4BYTE_ABGR);
        Graphics2D g = bg.createGraphics();
        try 
        {
			g.drawImage(ImageIO.read(GameUI.loader.getResourceAsStream("GreedSnake/image/wall.png")), 0, 0, Entity.AreaSize, Entity.AreaSize, null);
        } catch (Exception e) 
        {
			e.printStackTrace();
		}
		bg.flush();
		return bg;
        //return new BufferedImageFilter(null);
    }
}
class Wall implements Serializable
{
    private static final long serialVersionUID = 12123131236147L;
    public int locx, locy;
    public int length;  //长度
    private int test = 4;
    Wall(int x, int y, int z)
    {
        locx = x;
        locy = y;
        length = z;
        
    }

    public void Generate(SnakeLogic logic) {};
    public void DrawObject(Graphics g) {};
}

class HoriWall extends Wall     //水平方向的墙
{
    List<WallEntity> body;
    HoriWall(int x, int y,int length)
    {
        super(x,y,length);
        body = new ArrayList<WallEntity> ();
    }

    //@Override
    public void Generate(SnakeLogic logic)
    {
        for (int i = 0;i < this.length;i++)
        {
            if (this.locx+i>=SnakeLogic.MapMaxX)
                return;
            //if (logic.GridState[locx+])
            body.add(new WallEntity(this.locx+i, this.locy, logic));
        }
    }

    //@Override
    public void DrawObject(Graphics g)
    {
        for (int i = 0;i < this.body.size();i++)
        {
            this.body.get(i).DrawObject(g);
        }
    }
}

class VertWall extends Wall     // 垂直方向的墙
{
    List<WallEntity> body;
    VertWall(int x, int y,int length)
    {
        super(x,y,length);
        body = new ArrayList<WallEntity>();
    }

    //@Override
    public void Generate(SnakeLogic logic)
    {
        for (int i = 0;i < this.length;i++)
        {
            if (this.locy+i>=SnakeLogic.MapMaxY)
                return;
            body.add(new WallEntity(this.locx, this.locy+i, logic));
        }
    }

   // @Override
    public void DrawObject(Graphics g)
    {
        for (int i = 0;i < this.body.size();i++)
        {
            this.body.get(i).DrawObject(g);
        }
    }
}

/**
 * 直角形的墙
 */

class AngleWall extends Wall     
{
    List<WallEntity> body;
    AngleWall(int x, int y,int length)
    {
        super(x,y,length);
        body = new ArrayList<WallEntity>();
    }

    //@Override
    public void Generate(SnakeLogic logic)
    {
        boolean judgex = (this.locx > SnakeLogic.MapMaxX/2);
        boolean judgey = (this.locy > SnakeLogic.MapMaxY/2);
        int x1, y1;
        for (int i = 0;i < this.length;i++)
        {
            
            if (judgex)
                x1 = locx-i;
            else 
                x1 = locx+i;
            
            if (judgey)
                y1 = locy-i;
            else y1 = locy+i;

            if (y1>=SnakeLogic.MapMaxY || x1 >= SnakeLogic.MapMaxX)
                continue;

            body.add(new WallEntity(this.locx, y1, logic));
            body.add(new WallEntity(x1, this.locy, logic));
        }
    }

   // @Override
    public void DrawObject(Graphics g)
    {
        for (int i = 0;i < this.body.size();i++)
        {
            this.body.get(i).DrawObject(g);
        }
    }
}



/**
 * 圆弧型的墙，使用了中点画圆算法
 */
class CircleWall extends Wall
{
    List<WallEntity> body;
    CircleWall(int x, int y, int r)
    {
        super(x, y, r);
        body = new ArrayList<WallEntity>();
    }

    //@Override
    public void Generate(SnakeLogic logic)
    {
        int x = 0; 
        int y = this.length;
        double d = 1.25 - length;
        while (x <= y)
        {
            if (d < 0)
                d += 2*x + 3;
            else
            {
                d += 2*(x-y)+5;
                y -= 1;
            }
            x += 1;
            if (locx + x >= SnakeLogic.MapMaxX || locy+y>=SnakeLogic.MapMaxY)
                return;
            this.body.add(new WallEntity(locx+x, locy+y, logic));

        }
        
    }

    //@Override
    public void DrawObject(Graphics g)
    {
        for (int i = 0;i < body.size();i++)
            body.get(i).DrawObject(g);
    }
}