package drawarc;

import java.awt.*;
import java.awt.image.BufferedImage;

import javax.swing.*;



class DrawArc extends JFrame
{
    int angle = 10;
    BufferedImage bf;
    Graphics bg;
    Color[] colorList = {Color.RED,  Color.YELLOW, Color.BLUE, Color.CYAN};
    public DrawArc()
    {
        super("DrawArc");
        setVisible(true);
        setSize(500,500);
        bf = new BufferedImage(500,500,BufferedImage.TYPE_INT_RGB);
        
    }
    public void paint(Graphics p)
    {
        //super.paint(p);
        bg = bf.createGraphics();
        bg.setColor(Color.white);
	    bg.fillRect(0, 0, getWidth(), getHeight());
        this.drawRec(bg);
        for (int j = 0;j < 4;j++)
        {
            this.drawCir(bg, this.angle+90*j, colorList[j]);
        }
        
        this.angle = (this.angle+3) % 360;
        p.drawImage(bf, 0, 0, null);
        //System.out.println(angle);
        
    }

    public void run() 
    {
        while(true)
        {
            repaint();
            try
            {
                Thread.sleep(500);
                
            }
            catch(Exception e)
            {

            }
        }
    }

    public void drawCir(Graphics g, int a, Color c)
    {
        System.out.println(a);
        g.setColor(c);
        g.fillArc(50, 10, 400, 400, a, 13);
        //g.fillArc(x, y, width, height, startAngle, arcAngle);
    }

    public void drawRec(Graphics g)
    {
        g.setColor(Color.BLACK); 
        g.fillRoundRect(244,210,12,300,15,15);
    }

}