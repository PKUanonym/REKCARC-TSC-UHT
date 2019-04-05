import java.awt.BorderLayout;
import java.awt.Button;  
import java.awt.FlowLayout;  
import java.awt.Frame;  
import java.awt.TextArea;
import java.awt.event.WindowAdapter;  
import java.awt.event.WindowEvent;  

import javax.swing.JFrame;

import java.awt.event.ActionEvent;  
import java.awt.event.ActionListener;  
import java.io.File;  
  



import java.io.IOException;

import javax.swing.ButtonGroup;
import javax.swing.JButton;  
import javax.swing.JFileChooser;  
import javax.swing.JFrame;  
import javax.swing.JLabel;  
import javax.swing.JPanel;
import javax.swing.JRadioButton;
import javax.swing.JTextArea;
import javax.swing.JTextField;
  
public class pic_ui extends JFrame implements ActionListener{  
    JButton data_set=null; 
    JButton query_set=null;
    JButton search=null;
    JPanel p1 = null;
    JPanel p2 = null;
    TextArea  te = null;
    pic_retrieval pic_r;
    
    
	JRadioButton jrb1;
	JRadioButton jrb2;
	JRadioButton cal_L2;
	JRadioButton cal_Bh;
	JRadioButton cal_HI;
	JRadioButton cal_Cam;
	JRadioButton cal_Jff;
    
    
    public static void main(String[] args) {  
        new pic_ui();  
    }  
    void views()
    {
    	
    	this.setLayout(new BorderLayout());
    	
    	
    	ButtonGroup bin = new ButtonGroup();//创建按钮组
    	ButtonGroup cal = new ButtonGroup();//创建按钮组
    	
    	jrb1 = new JRadioButton("bin16");
    	jrb1.setSelected(true);
    	jrb2 = new JRadioButton("bin128");	
    	cal_L2 = new JRadioButton("L2");
    	cal_L2.setSelected(true);
    	cal_Bh = new JRadioButton("Bh");	
    	cal_HI = new JRadioButton("HI");	
    	cal_Cam = new JRadioButton("Cam");	
    	cal_Jff = new JRadioButton("Jff");	
    	p1= new JPanel();
    	p1.add(jrb1);
    	p1.add(jrb2);
    	p1.add(cal_L2);
    	p1.add(cal_Bh);
    	p1.add(cal_HI);
    	p1.add(cal_Cam);
    	p1.add(cal_Jff);
    	
    	
    	
    	bin.add(jrb1);
    	bin.add(jrb2);
    	cal.add(cal_L2);
    	cal.add(cal_Bh);
    	cal.add(cal_HI);
    	cal.add(cal_Cam);
    	cal.add(cal_Jff);
    	this.getContentPane().add("North",p1);
    	//this.getContentPane().add("North",jrb2);
    	//this.getContentPane().add(cal_L2);
    	//this.getContentPane().add(cal_Bh);
    	//this.getContentPane().add(cal_HI);
    	jrb1.addActionListener(this);
    	jrb2.addActionListener(this);
    	cal_L2.addActionListener(this);
    	cal_Bh.addActionListener(this);
    	cal_HI.addActionListener(this);
    	cal_Cam.addActionListener(this);
    	cal_Jff.addActionListener(this);
    	
    	data_set=new JButton("DataSet");  
    	query_set = new JButton("QuerySet");
    	search = new JButton("Search");
    	
        this.add("West",data_set);  
        this.add("East",query_set); 
        this.add("South",search);
        this.setBounds(100, 100, 100, 100);  
        
        
        search.addActionListener(this);  
        data_set.addActionListener(this);  
        query_set.addActionListener(this);  
        
        
        te = new TextArea ();
    	te.setText("Information");
    	te.setEditable(false);
    	te.setBounds(200,200,300,300);
    	this.add("Center",te);
    	
    	
    	this.setBounds(100,100,500,500);
    	this.setVisible(true);  
        this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE); 
    }
    public pic_ui(){  
    	views();
    	pic_r = new pic_retrieval("L2",16);
        
    }  
    @Override  
    public void actionPerformed(ActionEvent e) {  
    	if (e.getSource()==data_set)
    	{
    		 JFileChooser jfc=new JFileChooser();  
    	        jfc.setFileSelectionMode(JFileChooser.FILES_ONLY);  
    	        jfc.showDialog(new JLabel(), "选择");  
    	        File file=jfc.getSelectedFile();  
    	        if(file!=null){  
    	        	pic_r.loaddataset(file.getAbsolutePath());
    	        }  
    	        String text = te.getText();
        		te.setText(text+"\r\nLoad DataSet end!");
    	}
    	if (e.getSource()==query_set)
    	{
    		 JFileChooser jfc=new JFileChooser();  
    	        jfc.setFileSelectionMode(JFileChooser.FILES_ONLY );  
    	   
    	        jfc.showDialog(new JLabel(), "选择");  
    	        File file=jfc.getSelectedFile();  
    	        if(file!=null){  
    	        	pic_r.loadqueryset(file.getAbsolutePath());
    	        }  
    	        String text = te.getText();
        		te.setText(text+"\r\nLoad QuerySet end!");
    	}
    	if (e.getSource()==search)
    	{
    		try {
    			String text = te.getText();
    			te.setText(text + "\r\nSearching..");
				double t = pic_r.find_all_in_list();
				text = te.getText();
    			te.setText(text + "\r\n averag precision is "+t);
				
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
    	}
    	if (e.getSource()==jrb1)
    	{
    		pic_r.set_bin(16);
    		String text = te.getText();
    		
    		te.setText(text+"\r\nbin=16");
    	}
    	if (e.getSource()==jrb2)
    	{
    		pic_r.set_bin(128);
    		String text = te.getText();
    		te.setText(text+"\r\nbin=128");
    	}
    	if (e.getSource()==cal_L2)
    	{
    		pic_r.set_calu_method("L2");
    		String text = te.getText();
    		te.setText(text+"\r\nmethod=L2");
    	}
    	if (e.getSource()==cal_Bh)
    	{
    		pic_r.set_calu_method("Bh");
    		String text = te.getText();
    		te.setText(text+"\r\nmethod=Bh");
    	}
    	if (e.getSource()==cal_HI)
    	{
    		pic_r.set_calu_method("HI");
    		String text = te.getText();
    		te.setText(text+"\r\nmethod=HI");
    	}
    	if (e.getSource()==cal_Cam)
    	{
    		pic_r.set_calu_method("Cam");
    		String text = te.getText();
    		te.setText(text+"\r\nmethod=Cam");
    	}
    	if (e.getSource()==cal_Jff)
    	{
    		pic_r.set_calu_method("Jff");
    		String text = te.getText();
    		te.setText(text+"\r\nmethod=Jff");
    	}
        // TODO Auto-generated method stub  
       
          
    }  
  
}  
