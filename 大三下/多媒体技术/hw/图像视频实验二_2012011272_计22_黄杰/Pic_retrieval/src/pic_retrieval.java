import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;


public class pic_retrieval {
	pic_node piclist[] ;
	pic_node querylist[] ;
	int num;
	int querynum;
	int bin;
	String calu_method;
	void set_calu_method(String t)
	{
		calu_method=t;
	}
	void set_bin(int t)
	{
		bin =t;
	}
	pic_retrieval(String t,int b)
	{
		calu_method = t;
		bin=b;
		num=0;
		querynum=0;
		piclist =new pic_node[300];
		for (int i=0;i<300;i++)
			piclist[i]= new pic_node();
		querylist =new pic_node[300];
		for (int i=0;i<300;i++)
			querylist[i]= new pic_node();
	}
	void loaddataset(String fileName) {
		num=0;
	        File file = new File(fileName);
	        BufferedReader reader = null;
	        try {
	            reader = new BufferedReader(new FileReader(file));
	            String tempString = null;
	            int line = 1;
	            while ((tempString = reader.readLine()) != null) {
	            	if (tempString.length()==0) continue;
	            	String s[]=tempString.split(" ");
	            	//System.out.println("DAtaSet/"+s[0]);
	            	piclist[num].load("DAtaSet/"+s[0]);
	                num ++;
	                //System.out.println("line " + line + ": " + tempString);
	                line++;
	            }
	            reader.close();
	        } catch (IOException e) {
	            e.printStackTrace();
	        } finally {
	            if (reader != null) {
	                try {
	                    reader.close();
	                } catch (IOException e1) {
	                }
	            }
	        }
	        System.out.println("load end");
	    }
	void loadqueryset(String fileName) {
		querynum = 0;
	        File file = new File(fileName);
	        BufferedReader reader = null;
	        try {
	            reader = new BufferedReader(new FileReader(file));
	            String tempString = null;
	            int line = 1;
	            while ((tempString = reader.readLine()) != null) {
	            	if (tempString.length()<=2) continue;
	            	String s[]=tempString.split(" ");
	            	//System.out.println("DAtaSet/"+s[0]);
	            	querylist[querynum].load("DAtaSet/"+s[0]);
	            	querynum ++;
	                //System.out.println("line " + line + ": " + tempString);
	                line++;
	            }
	            reader.close();
	        } catch (IOException e) {
	            e.printStackTrace();
	        } finally {
	            if (reader != null) {
	                try {
	                    reader.close();
	                } catch (IOException e1) {
	                }
	            }
	        }
	        System.out.println("load end");
	    }
	boolean ifright(String name1,String name2)
	{
		String s[]=name1.split("/");
		name1 = s[s.length-2];
		s=name2.split("/");
		name2 = s[s.length-2];
		
		return name1.equals(name2);
	}
	double find_near(pic_node p) throws IOException
	{
		for (int i=0;i<num;i++)
		{
			pic_calcu c = new pic_calcu(calu_method,bin);
			piclist[i].tmp = c.calcu(p, piclist[i]);
		}
		for (int i=0;i<num;i++)
			for (int j=i+1;j<num;j++)
				if (piclist[j].tmp<piclist[i].tmp)
				{
					pic_node tmp = piclist[j];
					piclist[j] = piclist[i];
					piclist[i]=tmp;
				}
		

		String s[] =p.name.split("/");
		int le = s.length;
		String new_name = "res_"+s[le-2]+"_"+s[le-1];
		new_name = new_name.replaceAll("jpg","txt");
				
		 File file = new File(new_name);
		 if (!file.exists()) {
		    file.createNewFile();
		   }

		   FileWriter fw = new FileWriter(file.getAbsoluteFile());
		   BufferedWriter bw = new BufferedWriter(fw);
		   
		   
		
		
		
		int right = 0;
		for (int i=0;i<30;i++)
		{
			
			bw.write(piclist[i].name+" "+piclist[i].tmp);
			bw.newLine();
			bw.flush();
			if (ifright(p.name,piclist[i].name))
				right+=1;
		}
		
		
		bw.close();
		return right/30.0;
		//System.out.println(right/30.0);
	}
	double find_all_in_list() throws IOException
	{
		File file = new File("res_overall.txt");
		 if (!file.exists()) {
		    file.createNewFile();
		   }

		   FileWriter fw = new FileWriter(file.getAbsoluteFile());
		   BufferedWriter bw = new BufferedWriter(fw);
		
		
		
		double ans=0;
		for (int i=0;i<querynum;i++)
		{
			double t = find_near(querylist[i]);;
			ans=ans+t;
			bw.write(querylist[i].name+" "+t);
			bw.newLine();
			bw.flush();
		}
		bw.write(""+ans/querynum);
		bw.newLine();
		bw.flush();
		return ans/querynum;
	}
	public static void main(String[] args) throws Exception  {
		
		
		
		pic_retrieval p = new pic_retrieval("Bh",16);
		p.loaddataset("AllImages.txt");
		
		p.loadqueryset("QueryImages.txt");
		System.out.println(p.find_all_in_list());
		
		
	}
}
