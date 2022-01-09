package simplenotepad;

import javax.swing.JFrame;
import javax.swing.JMenuBar;
import javax.swing.filechooser.FileNameExtensionFilter;

import java.awt.event.*;
import javax.swing.*;
import java.awt.*;
import java.io.*;
import java.util.*;

class SimpleNotepad extends JFrame implements ActionListener
{
    FileDialog openDia, saveDia;
    TextArea txt;

    SimpleNotepad()
    {
        JMenuBar bar = new JMenuBar();
        JMenu fileMenu = new JMenu("文件");
        JMenuItem closeItem = new JMenuItem("退出");
        JMenuItem openItem = new JMenuItem("打开");
        JMenuItem saveItem = new JMenuItem("保存");

        openItem.addActionListener(this);
        saveItem.addActionListener(this);
        closeItem.addActionListener(this);
        fileMenu.add(openItem);
        fileMenu.add(saveItem);
        fileMenu.add(closeItem); 
        bar.add(fileMenu); 
        this.setJMenuBar(bar);
        this.setSize(600, 400);
        
        this.setDefaultCloseOperation(this.EXIT_ON_CLOSE);
        this.setTitle("记事本");

        txt = new TextArea();
        this.add(new JScrollPane(txt));
        this.setVisible(true);

        



    }

    public void actionPerformed(ActionEvent e)
    {
       
        String cmd = e.getActionCommand();
        if (cmd.equals("打开"))
        {
            JFileChooser fileChooser = new JFileChooser();  //对话框  
            //fileChooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
            fileChooser.setCurrentDirectory(new File("."));//设置当前目录  
            fileChooser.setAcceptAllFileFilterUsed(false); //禁用选择 所有文件 
            fileChooser.setFileFilter(new FileNameExtensionFilter("TXT", "txt"));
            int returnVal  = fileChooser.showOpenDialog(getContentPane());  //opendialog  
            if(returnVal == JFileChooser.APPROVE_OPTION)  //判断是否为打开的按钮  
            {  
                File selectedFile = fileChooser.getSelectedFile();  //取得选中的文件  
                try   
                {
                    Scanner s = new Scanner(new FileInputStream(selectedFile)); 
                    String content = "";
                    while(s.hasNext())
                        content = content + s.nextLine()+"\n";
                    this.txt.setText(content);
                    //this.txt.setVisible(true);
                    this.setContentPane(this.getContentPane());
                }
                catch(FileNotFoundException g)
                {
                    System.out.println("No");
                }
                
            } 
        }
        else if (cmd.equals("保存"))
        {
            JFileChooser fileChooser = new JFileChooser();
            int retval = fileChooser.showSaveDialog(getContentPane());
            if (retval == JFileChooser.APPROVE_OPTION) 
            {
                File file = fileChooser.getSelectedFile();
                try         
                {
                    PrintStream ps = new PrintStream(new FileOutputStream(file));
			        ps.println(txt.getText());
                }
                catch (FileNotFoundException eee)
                {

                }
               
            }
        }
        else if (cmd.equals("退出"))
        {
            System.exit(0);
			return;
        }
        
    }

    
}

