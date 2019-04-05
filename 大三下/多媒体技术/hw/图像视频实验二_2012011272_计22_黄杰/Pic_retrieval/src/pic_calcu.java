import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;


public class pic_calcu {
	String type;
	int bin;
	pic_calcu(String t,int b)
	{
		type =t;
		bin=b;
	}
	void set_bin(int t)
	{
		bin=t;
	}
	void set_type(String t)
	{
		type =t;
	}
	double calcu(pic_node x,pic_node y)
	{

		if (type.equals("L2"))
		{
			double ans = 0;
			
			for (int i=0;i<bin;i++)
			{
				if (bin==16)
				{
					double xx = x.color_space_16[i];
					double yy = y.color_space_16[i];
					ans = ans + (xx-yy)*(xx-yy);
				}
				else
				{
					double xx = x.color_space_128[i];
					double yy = y.color_space_128[i];
					ans = ans + (xx-yy)*(xx-yy);
				}
				
			}
			return Math.sqrt(ans);
		}
		if (type.equals("HI"))
		{
			double ans = 0;
			for (int i=0;i<bin;i++)
			{
				
				if (bin==16)
				{
					double xx = x.color_space_16[i];
					double yy = y.color_space_16[i];
					ans = ans + Math.min(xx,yy);
				}
				else
				{
					double xx = x.color_space_128[i];
					double yy = y.color_space_128[i];
					ans = ans + Math.min(xx,yy);
				}
				
			}
			return -ans;
		}
		if (type.equals("Bh"))
		{
		
			
			double xsum =0;
			double ysum = 0;
			for (int i=0;i<bin;i++)
			{
				if (bin==16)
				{
					double xx = x.color_space_16[i];
					double yy = y.color_space_16[i];
					xsum+=xx;
					ysum+=yy;
				}
				else
				{
					double xx = x.color_space_128[i];
					double yy = y.color_space_128[i];
					xsum+=xx;
					ysum+=yy;
				}
				
			}
			double ans = 1;
			for (int i=0;i<bin;i++)
			{
				if (bin==16)
				{
					double xx = x.color_space_16[i];
					double yy = y.color_space_16[i];
					ans=ans-Math.sqrt(xx/xsum*yy/ysum);
				}
				else
				{
					double xx = x.color_space_128[i];
					double yy = y.color_space_128[i];
					ans=ans-Math.sqrt(xx/xsum*yy/ysum);
				}
				
			}
			return Math.sqrt(ans);
		}
		if (type.equals("Cam"))
		{
			double ans = 0;
			
			for (int i=0;i<bin;i++)
			{
				if (bin==16)
				{
					double xx = x.color_space_16[i];
					double yy = y.color_space_16[i];
					if (xx+yy!=0)
					ans = ans + Math.abs((xx-yy)/(xx+yy));
				}
				else
				{
					double xx = x.color_space_128[i];
					double yy = y.color_space_128[i];
					if (xx+yy!=0)
					ans = ans + Math.abs((xx-yy)/(xx+yy));
				}
				
			}
			return Math.sqrt(ans);
		}
		if (type.equals("Jff"))
		{
			double ans = 0;
			
			for (int i=0;i<bin;i++)
			{
				if (bin==16)
				{
					double xx = Math.sqrt(x.color_space_16[i]);
					double yy = Math.sqrt(y.color_space_16[i]);
					ans = ans + (xx-yy)*(xx-yy);
				}
				else
				{
					double xx = Math.sqrt(x.color_space_128[i]);
					double yy = Math.sqrt(y.color_space_128[i]);
					ans = ans + (xx-yy)*(xx-yy);
				}
				
			}
			return Math.sqrt(ans);
		}
		
		
		return 0;
		
	}
	
	
	
	
	public static void main(String[] args) throws Exception  {
		pic_node p = new pic_node();
		p.load("DAtaSet/arborgreens/Image02.jpg");
		pic_node pp = new pic_node();
		pp.load("DAtaSet/tribe/5.jpg");
		
		pic_calcu c = new pic_calcu("Bh",16);
		System.out.println(c.calcu(p, pp));
		
	}
}
