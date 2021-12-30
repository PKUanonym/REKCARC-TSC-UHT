package GreedSnake;

import javax.swing.*;


import java.util.*;
import java.awt.*;
import java.io.*;
import java.awt.event.*;

/*
游戏的排名显示界面
*/

class RankPage extends JPanel 
{
    private GameUI ui;
    private static final String path = "GreedSnake/data/rank.txt";
    public static RankItem[] ranks = new RankItem[10];
    public static String currentName;

    RankPage(GameUI parent)
    {
        ui = parent;
        InitComponent(parent);
    }

    public static JScrollPane GetRankTable() 
    {
		Object[]titles = new Object[]{
			"Rank",
			"Name",
			"Score"
		};
		Object[][]vals = new Object[10][3];
		for (int i = 0; i < 10; i++) {
			vals[i][0] = i + 1;
            if (ranks[i] == null) 
            {
				vals[i][1] = "";
				vals[i][2] = "N/A";
				//vals[i][3] = "N/A";
				continue;
			}
			vals[i][1] = ranks[i].name;
			vals[i][2] = ranks[i].score;
			
		}
		JTable rankst = new JTable(vals, titles);
		return new JScrollPane(rankst);
    }
    
    /**
	 * 初始化界面
	 */
    public void InitComponent(GameUI parent) 
    {
        this.setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));
        
		LoadRank();
		this.add(GetRankTable());
        JButton Back = new JButton("Back");
        
        ActionListener listener = new ActionListener() 
        {
            public void actionPerformed(ActionEvent e) 
            {
                SaveRank();
				parent.setContentPane(parent.init);
				parent.revalidate();
				parent.pack();
				parent.repaint();
			}
        };
        
        Back.addActionListener(listener);
        this.add(Back);
        this.setSize(800,600);
        
	}



    /**
     * 将排名数据写入文件中
     */
    public static void SaveRank() 
    {
        try 
        {
			PrintStream ps = new PrintStream(new FileOutputStream(path));
			ps.println("[SnakeRanking]");
			for (int i = 0; i < 10; i++)
				if (ranks[i] != null)
					ps.println(ranks[i].name + " " + ranks[i].score);
			ps.flush();
			ps.close();
        } catch (IOException e) 
        {
			System.out.println("排名输出文件打开失败");
		}
    }
    /**
     * 加载排名信息
     */
    public static boolean LoadRank() 
    {
		File f = new File(path);
		if (!f.exists())
			return false;
        try 
        {
			Scanner sin = new Scanner(new FileInputStream(f));
            if (sin.nextLine().indexOf("[SnakeRanking]") < 0) 
            {
				sin.close();
				return false;
			}
			int pointer = 0;
            while (sin.hasNext() && (pointer < 10)) 
            {
				String n = sin.next();
				int s = sin.nextInt();
				//int m = sin.nextInt();
				ranks[pointer++] = new RankItem(n, s);
			}
			sin.close();
        } catch (IOException e) 
        {
            //e.printStackTrace();
            System.out.println("排名加载文件失败");
			return false;
		}
		return true;
    }
    
    /**
	 * 在排行榜中插入新值
	 * @param value
	 * 插入的新值
	 */

    public static void insertRank(int score)
    {
        RankItem temp = new RankItem(currentName, score);
        InsertRank(temp);
        SaveRank();

    }
    public static void InsertRank(RankItem value) 
    {
        if (value.score > ((ranks[9] == null) ? 0 : (ranks[9].score))) 
        {
			ranks[9] = value;
			for (int i = 8; i >= 0; i--) {
                if (ranks[i + 1].score > ((ranks[i] == null) ? 0 : (ranks[i].score))) 
                {
					RankItem t = ranks[i];
					ranks[i] = ranks[i + 1];
					ranks[i + 1] = t;
                } 
                else
					break;
			}
		}
    }
    

}







/**
 *  处理单个排名信息
 */
class RankItem 
{
    String name;
    int score;
    int rank;

    RankItem(String n, int m)
    {
        name = n;
        score = m;
    }
}