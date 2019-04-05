import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;


public class pic_node {
	int color_space_16[];
	int color_space_128[];
	double tmp;
	String name;
	BufferedImage bi;
	pic_node()
	{
		set_Color_space_partitioning();
	}
	void set_Color_space_partitioning()
	{
		color_space_16 = new int[16]; 
		color_space_128 = new int[128];
		for (int i=0;i<16;i++)
			color_space_16[i]=0;
		for (int i=0;i<128;i++)
			color_space_128[i]=0;
		
	}
	int pd_in_which(int r,int g,int b,int bin)
	{
		if (bin==16)
		{
			int x  = (int) (r/256.0*2);
			int y  = (int) (g/256.0*4);
			int z  = (int) (b/256.0*2);
			return x*8+y*2+z;
		}
		else
		{
			int x  = (int) (r/256.0*4);
			int y  = (int) (g/256.0*8);
			int z  = (int) (b/256.0*4);
			return x*32+y*4+z;
		}
	}
	void add_color_space(int t,int bin)
	{
		if (bin==16)
			color_space_16[t]+=1;
		else
			color_space_128[t]+=1;
	}


	
	void load(String path) throws IOException
	{
		name = path;
		
		File file = new File(path);
		
		bi = ImageIO.read(file);
		int width = bi.getWidth();
		int height = bi.getHeight();
		int minx = bi.getMinX();
		int miny = bi.getMinY();
		int rgb[] = new int[3];  
		for (int i=minx;i<width;i++)
			for (int j=miny;j<height;j++)
			{
				 int pixel=bi.getRGB(i, j);     
				 rgb[0] = (pixel & 0xff0000 ) >> 16;         
				 rgb[1] = (pixel & 0xff00 ) >> 8;
				 rgb[2] = (pixel & 0xff ); 
				 add_color_space(pd_in_which(rgb[0],rgb[1],rgb[2],16),16);
				 add_color_space(pd_in_which(rgb[0],rgb[1],rgb[2],128),128);
			}
	}
	
	
	public static void main(String[] args) throws Exception  {
		pic_node p = new pic_node();
		p.load("D:\\Program\\workspace\\Pic_retrieval\\DataSet\\buses\\300.jpg");
		p.load("D:\\Program\\workspace\\Pic_retrieval\\DataSet\\beach\\138.jpg");
	}
}
