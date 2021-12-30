package GreedSnake;

import java.awt.Color;
import java.util.*;
import javax.swing.*;
import java.awt.*;
import java.io.*;
import javax.imageio.*;
import java.awt.image.BufferedImage;

class bufferedImages
{
    public Image egg;
    public Image stone;
    public Image hole;
    bufferedImages()
    {
        egg = PaintObj("GreedSnake/image/egg.png");
        stone = PaintObj("GreedSnake/image/stone.png");
        hole = null;
    }

    public Image PaintObj(String path)    //设置背景图片
    {
        BufferedImage bg = new BufferedImage(Entity.AreaSize, Entity.AreaSize, BufferedImage.TYPE_4BYTE_ABGR);
        Graphics2D g = bg.createGraphics();
        try 
        {
			g.drawImage(ImageIO.read(GameUI.loader.getResourceAsStream(path)), 0, 0, Entity.AreaSize, Entity.AreaSize, null);
        } catch (Exception e) 
        {
			e.printStackTrace();
		}
		bg.flush();
		return bg;
        //return new BufferedImageFilter(null);
    }
}