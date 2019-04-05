import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.ArrayList;
import java.lang.Math;
import java.util.Arrays;

public class Test {
    public static  ArrayList<Sample> list = new ArrayList<Sample>();
    public static  ArrayList<Sample> list2 = new ArrayList<Sample>();
    static int data_length = 0;
    static int data_length2 = 0;
    static int correct_result = 0;
    public static void main(String[] args) {
        // 读取数据，放入list容器中
        File file = new File("/Users/steven/Desktop/exp1/data1/train.txt");
        txt2String(file,3);
        getMost();
//        System.out.println("2最多的是："+zz2[zzz2]);
//        System.out.println("4最多的是："+zz4[zzz4]);
//        System.out.println("6最多的是："+zz6[zzz6]);
//        System.out.println("7最多的是："+zz7[zzz7]);
//        System.out.println("8最多的是："+zz8[zzz8]);
//        System.out.println("9最多的是："+zz9[zzz9]);
//        System.out.println("10最多的是："+zz10[zzz10]);
//        System.out.println("14最多的是："+zz14[zzz14]);

        txt2String(file,1);

        int[] var1a = new int[7841],var3a = new int[7841],var5a = new int[7841],var11a = new int[7841], var12a = new int[7841], var13a = new int[7841];
        int[] var1b = new int[24720],var3b = new int[24720],var5b = new int[24720],var11b = new int[24720], var12b = new int[24720], var13b = new int[24720];
       
        int num_a = 0,num_b = 0;
        for(int i=0;i<list.size();i++){
            Sample aa=list.get(i);
                if(aa.getResult().equals(">50K.")){
                    var1a[num_a] = aa.getAge();
                    var3a[num_a] = aa.getFnlwgt();
                    var5a[num_a] = aa.getEducation_num();
                    var11a[num_a] = aa.getCapital_gain();
                    var12a[num_a] = aa.getCapital_loss();
                    var13a[num_a] = aa.getHours_per_week();
                    num_a++;
                }else {
                    var1b[num_b] = aa.getAge();
                    var3b[num_b] = aa.getFnlwgt();
                    var5b[num_b] = aa.getEducation_num();
                    var11b[num_b] = aa.getCapital_gain();
                    var12b[num_b] = aa.getCapital_loss();
                    var13b[num_b] = aa.getHours_per_week();
                    num_b++;
                }
        }
//        for(int i = 0;i<10;i++){
//            System.out.println(var1a[i]);
//        }
        //平均数和方差
        Av1[0] = Variance(var1a)[0]; Va1[0] = Variance(var1a)[1];
        Av1[1] = Variance(var3a)[0]; Va1[1] = Variance(var3a)[1];
        Av1[2] = Variance(var5a)[0]; Va1[2] = Variance(var5a)[1];
        Av1[3] = Variance(var11a)[0]; Va1[3] = Variance(var11a)[1];
        Av1[4] = Variance(var12a)[0]; Va1[4] = Variance(var12a)[1];
        Av1[5] = Variance(var13a)[0]; Va1[5] = Variance(var13a)[1];

        Av2[0] = Variance(var1b)[0]; Va2[0] = Variance(var1b)[1];
        Av2[1] = Variance(var3b)[0]; Va2[1] = Variance(var3b)[1];
        Av2[2] = Variance(var5b)[0]; Va2[2] = Variance(var5b)[1];
        Av2[3] = Variance(var11b)[0]; Va2[3] = Variance(var11b)[1];
        Av2[4] = Variance(var12b)[0]; Va2[4] = Variance(var12b)[1];
        Av2[5] = Variance(var13b)[0]; Va2[5] = Variance(var13b)[1];
//        for(int i = 0;i<6;i++){
//            System.out.println(i+": "+Av1[i]+" "+Va1[i]);
//            System.out.println(i+": "+Av2[i]+" "+Va2[i]);
//        }

        //获取最大最小值
//        System.out.println("a1:"+age1+" a2:"+age2);
//        System.out.println("b1:"+fnlwgt1+" b2:"+fnlwgt2);
//        System.out.println("c1:"+education_num1+" c2:"+education_num2);
//        System.out.println("d1:"+capital_gain1+" d2:"+capital_gain2);
//        System.out.println("e1:"+capital_loss1+" e2:"+capital_loss2);
//        System.out.println("f1:"+hours_per_week1+" f2:"+hours_per_week2);

        File file2 = new File("/Users/steven/Desktop/exp1/data1/test.txt");
        txt2String(file2,2);

        for(int i=0;i<list2.size();i++){
            Sample aa=list2.get(i);
            String aa_result = testData(aa.getAge(),aa.getWorkclass(),aa.getFnlwgt(),aa.getEducation(),aa.getEducation_num(),aa.getMarital_status()
            ,aa.getOccupation(),aa.getRelationship(),aa.getRace(),aa.getSex(),aa.getCapital_gain(),aa.getCapital_loss(),aa.getHours_per_week()
            ,aa.getNative_country());
            aa.setMy_result(aa_result);
//            int a = (int) (1 + Math.random() * (10 - 1 + 1));
//            String aa1_result;
//            if(a>10) aa1_result = ">50K.";
//                else aa1_result = "<=50K.";
            if(aa_result.equals(aa.getResult())){
                correct_result++;
                //System.out.println("正确："+i);
            }
        }
        double accuracy = 100.0*correct_result/list2.size();
        System.out.println("测试集的正确率为："+accuracy+"%");

    }
    // 读取样本数据
    public static void txt2String(File file,int cc) {

        try {
            BufferedReader br = new BufferedReader(new FileReader(file));// 构造一个BufferedReader类来读取文件
            String s = null;
            while ((s = br.readLine()) != null) {// 使用readLine方法，一次读一行
                if(cc == 1){
                    // 部分数据
                    int ap = (int) (1 + Math.random() * 100);
                    if(ap>5) continue;
                    data_length++;
//                    if(data_length>=32561*0.5)
//                        break;
                    splitt(s,1);}
                if(cc == 2){
                    data_length2++;
                    splitt(s,2);
                }
                if(cc == 3){
                    splitt2(s);
                }
            }
            br.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    // 存入ArrayList中
    public static void splitt(String str, int cc){

        String strr = str.trim();
        String[] abc = strr.split(",");
        // 连续值分类
//        int age=Integer.parseInt(abc[0]) / 20;
//        int fnlwgt=Integer.parseInt(abc[2]) / 200000;
//        int education_num=Integer.parseInt(abc[4]) / 2;
//        int capital_gain=Integer.parseInt(abc[10]) / 20000;
//        int capital_loss=Integer.parseInt(abc[11]) / 1000;
//        int hours_per_week=Integer.parseInt(abc[12]) / 20;

        int age=Integer.parseInt(abc[0]);
        int fnlwgt=Integer.parseInt(abc[2]);
        int education_num=Integer.parseInt(abc[4]);
        int capital_gain=Integer.parseInt(abc[10]);
        int capital_loss=Integer.parseInt(abc[11]);
        int hours_per_week=Integer.parseInt(abc[12]);

        // 以众数代替?值
//        if(abc[1].equals("?")) abc[1] = zz2[zzz2];
//        if(abc[3].equals("?")) abc[3] = zz4[zzz4];
//        if(abc[5].equals("?")) abc[5] = zz6[zzz6];
//        if(abc[6].equals("?")) abc[6] = zz7[zzz7];
//        if(abc[7].equals("?")) abc[7] = zz8[zzz8];
//        if(abc[8].equals("?")) abc[8] = zz9[zzz9];
//        if(abc[9].equals("?")) abc[9] = zz10[zzz10];
//        if(abc[13].equals("?")) abc[13] = zz14[zzz14];
        // 把?值去掉
//        if(cc ==1) {
//            if (abc[1].equals("?") || abc[3].equals("?") || abc[5].equals("?") || abc[6].equals("?") || abc[7].equals("?") || abc[8].equals("?") || abc[9].equals("?") || abc[13].equals("?")) {
//                data_length--;
//                return;
//            }
//        }
        Sample bean=new Sample(age, abc[1], fnlwgt, abc[3], education_num,abc[5],abc[6],abc[7],abc[8],abc[9],capital_gain,capital_loss,hours_per_week,abc[13],abc[14]);
        if(cc == 1){
            list.add(bean);
            //findMaxAndMin(bean);
        }
        if(cc == 2){
            list2.add(bean);
            //findMaxAndMin(bean);
        }

    }

    static int z2[] = new int[8] ,z4[] = new int[16],z6[] = new int[7],z7[] = new int[14],z8[] = new int[6],z9[] = new int[5],z10[] = new int[2], z14[] = new int[41]; //记录每个取值出现的数目
    static String[] zz2 = {"Private", "Self-emp-not-inc", "Self-emp-inc", "Federal-gov", "Local-gov", "State-gov", "Without-pay", "Never-worked"};
    static String[] zz4 = {"Bachelors", "Some-college", "11th", "HS-grad", "Prof-school", "Assoc-acdm", "Assoc-voc", "9th", "7th-8th", "12th", "Masters", "1st-4th", "10th", "Doctorate", "5th-6th", "Preschool"};
    static String[] zz6 = {"Married-civ-spouse", "Divorced", "Never-married", "Separated", "Widowed", "Married-spouse-absent", "Married-AF-spouse"};
    static String[] zz7 = {"Tech-support", "Craft-repair", "Other-service", "Sales", "Exec-managerial", "Prof-specialty", "Handlers-cleaners", "Machine-op-inspct", "Adm-clerical", "Farming-fishing", "Transport-moving", "Priv-house-serv", "Protective-serv", "Armed-Forces"};
    static String[] zz8 = {"Wife", "Own-child", "Husband", "Not-in-family", "Other-relative", "Unmarried"};
    static String[] zz9 = {"White", "Asian-Pac-Islander", "Amer-Indian-Eskimo", "Other", "Black"};
    static String[] zz10 = {"Female","Male"};
    static String[] zz14 = {"United-States", "Cambodia", "England", "Puerto-Rico", "Canada", "Germany", "Outlying-US(Guam-USVI-etc)", "India", "Japan",
            "Greece", "South", "China", "Cuba", "Iran", "Honduras", "Philippines", "Italy", "Poland", "Jamaica", "Vietnam",
            "Mexico", "Portugal", "Ireland", "France", "Dominican-Republic", "Laos", "Ecuador", "Taiwan", "Haiti", "Columbia",
            "Hungary", "Guatemala", "Nicaragua", "Scotland", "Thailand", "Yugoslavia", "El-Salvador", "Trinadad&Tobago", "Peru", "Hong", "Holand-Netherlands"};
    static int zzz2,zzz4,zzz6,zzz7,zzz8,zzz9,zzz10, zzz14; //记录众数所在位置
    static int[] non = {1,3,5,6,7,8,9,13};
    public static void splitt2(String str){
        String strr = str.trim();
        String[] abc = strr.split(",");
        for(int i = 0;i<8;i++){
            findMost(abc[non[i]],non[i]);
        }
    }

    public static void getMost(){
        int temp = z2[0];for(int i = 1;i<8;i++){if(z2[i]>temp){temp = z2[i];zzz2 = i;}}
        temp = z4[0];for(int i = 1;i<16;i++){if(z4[i]>temp){temp = z4[i];zzz4 = i;}}
        temp = z6[0];for(int i = 1;i<7;i++){if(z6[i]>temp){temp = z6[i];zzz6 = i;}}
        temp = z7[0];for(int i = 1;i<14;i++){if(z7[i]>temp){temp = z7[i];zzz7 = i;}}
        temp = z8[0];for(int i = 1;i<6;i++){if(z8[i]>temp){temp = z8[i];zzz8 = i;}}
        temp = z9[0];for(int i = 1;i<5;i++){if(z9[i]>temp){temp = z9[i];zzz9 = i;}}
        temp = z10[0];for(int i = 1;i<2;i++){if(z10[i]>temp){temp = z10[i];zzz10 = i;}}
        temp = z14[0];for(int i = 1;i<41;i++){if(z14[i]>temp){temp = z14[i];zzz14 = i;}}
    }

    public static void findMost(String z, int nn){
        switch (nn) {
            case 1:for (int i = 0; i < 8; i++) {if (z.equals(zz2[i])) z2[i]++;}break;
            case 3:for (int i = 0; i < 16; i++) {if (z.equals(zz4[i])) z4[i]++;}break;
            case 5:for (int i = 0; i < 7; i++) {if (z.equals(zz6[i])) z6[i]++;}break;
            case 6:for (int i = 0; i < 14; i++) {if (z.equals(zz7[i])) z7[i]++;}break;
            case 7:for (int i = 0; i < 6; i++) {if (z.equals(zz8[i])) z8[i]++;}break;
            case 8:for (int i = 0; i < 5; i++) {if (z.equals(zz9[i])) z9[i]++;}break;
            case 9:for (int i = 0; i < 2; i++) {if (z.equals(zz10[i])) z10[i]++;}break;
            case 13:for (int i = 0; i < 41; i++) {if (z.equals(zz14[i])) z14[i]++;}break;
        }
    }

    static int age1=100, age2, fnlwgt1=10000000, fnlwgt2,education_num1=100, education_num2, capital_gain1=100, capital_gain2, capital_loss1=100,capital_loss2, hours_per_week1=100,  hours_per_week2;

    public static void findMaxAndMin(Sample bean){
        if(bean.getAge()<age1) age1 = bean.getAge();
        if(bean.getAge()>age2) age2 = bean.getAge();
        if(bean.getFnlwgt()<fnlwgt1) fnlwgt1 = bean.getFnlwgt();
        if(bean.getFnlwgt()>fnlwgt2) fnlwgt2 = bean.getFnlwgt();
        if(bean.getEducation_num()<education_num1) education_num1 = bean.getEducation_num();
        if(bean.getEducation_num()>education_num2) education_num2 = bean.getEducation_num();
        if(bean.getCapital_gain()<capital_gain1) capital_gain1 = bean.getCapital_gain();
        if(bean.getCapital_gain()>capital_gain2) capital_gain2 = bean.getCapital_gain();
        if(bean.getCapital_loss()<capital_loss1) capital_loss1 = bean.getCapital_loss();
        if(bean.getCapital_loss()>capital_loss2) capital_loss2 = bean.getCapital_loss();
        if(bean.getHours_per_week()<hours_per_week1) hours_per_week1 = bean.getHours_per_week();
        if(bean.getHours_per_week()>hours_per_week2) hours_per_week2 = bean.getHours_per_week();
    }

    static double[] Av1 = new double[6];
    static double[] Va1 = new double[6];
    static double[] Av2 = new double[6];
    static double[] Va2 = new double[6];
    public static double[] Variance(int[] x) {
        int m=x.length;
        double sum=0;
        for(int i=0;i<m;i++){//求和
            sum+=x[i];
        }
        double dAve=1.0*sum/m;//求平均值
        //System.out.println("Ave: "+dAve);
        double dVar=0;
        for(int i=0;i<m;i++){//求方差
            dVar+=(x[i]-dAve)*(x[i]-dAve);
        }
        double[] d ={dAve,dVar};
        return d;
    }

    // 训练样本，测试
    public static String testData(int age,String workclass,int fnlwgt,String education,
                                int education_num,String marital_status,String occupation,
                                String relationship,String race,String sex,int capital_gain,int capital_loss,
                                int hours_per_week,String native_country){
        //训练样本
        int number_a=0;
        int number_b=0;

        // age
        int n1a=0;int n1b=0;
        // workclass
        int n2a=0;int n2b=0;
        // fnlwgt
        int n3a=0;int n3b=0;
        // education
        int n4a=0;int n4b=0;
        // education_num
        int n5a=0;int n5b=0;
        // marital_status
        int n6a=0;int n6b=0;
        // occupation
        int n7a=0;int n7b=0;
        // relationship
        int n8a=0;int n8b=0;
        // race
        int n9a=0;int n9b=0;
        // sex
        int n10a=0;int n10b=0;
        // capital_gain
        int n11a=0;int n11b=0;
        // capital_loss
        int n12a=0;int n12b=0;
        // hours_per_week
        int n13a=0;int n13b=0;
        // native_country
        int n14a=0;int n14b=0;

        //遍历List 获得数据
        for(int i=0;i<list.size();i++){
            Sample bb=list.get(i);
            if(bb.getResult().equals(">50K.")){
                number_a++;
                if(bb.getAge() == age){n1a++;}
                if(bb.getWorkclass().equals(workclass)){n2a++;}
                if(bb.getFnlwgt() == fnlwgt){n3a++;}
                if(bb.getEducation().equals(education)){n4a++;}
                if(bb.getEducation_num() == education_num){n5a++;}
                if(bb.getMarital_status().equals(marital_status)){n6a++;}
                if(bb.getOccupation().equals(occupation)){n7a++;}
                if(bb.getRelationship().equals(relationship)){n8a++;}
                if(bb.getRace().equals(race)){n9a++;}
                if(bb.getSex().equals(sex)){n10a++;}
                if(bb.getCapital_gain() == capital_gain){n11a++;}
                if(bb.getCapital_loss() == capital_loss){n12a++;}
                if(bb.getHours_per_week() == hours_per_week){n13a++;}
                if(bb.getNative_country().equals(native_country)){n14a++;}
            }else {
                number_b++;
                if(bb.getAge() == age){n1b++;}
                if(bb.getWorkclass().equals(workclass)){n2b++;}
                if(bb.getFnlwgt() == fnlwgt){n3b++;}
                if(bb.getEducation().equals(education)){n4b++;}
                if(bb.getEducation_num() == education_num){n5b++;}
                if(bb.getMarital_status().equals(marital_status)){n6b++;}
                if(bb.getOccupation().equals(occupation)){n7b++;}
                if(bb.getRelationship().equals(relationship)){n8b++;}
                if(bb.getRace().equals(race)){n9b++;}
                if(bb.getSex().equals(sex)){n10b++;}
                if(bb.getCapital_gain() == capital_gain){n11b++;}
                if(bb.getCapital_loss() == capital_loss){n12b++;}
                if(bb.getHours_per_week() == hours_per_week){n13b++;}
                if(bb.getNative_country().equals(native_country)){n14b++;}
            }
        }
        int num = number_a+number_b;
//        System.out.println("a:"+number_a);
//        System.out.println("b:"+number_b);

        // 概率判断
        double buy_yes=(number_a+1)*1.0/(data_length+2);
        double buy_no=(number_b+1)*1.0/(data_length+2);

        // 高斯分布概率计算
        double p1a = 1.0*Math.exp(-(1.0*(age-Av1[0])*(age-Av1[0]))/(2*Va1[0]))/Math.sqrt(2*Math.PI*Va1[0]);
        double p1b = 1.0*Math.exp(-(1.0*(age-Av2[0])*(age-Av2[0]))/(2*Va2[0]))/Math.sqrt(2*Math.PI*Va2[0]);
        double p3a = 1.0*Math.exp(-(1.0*(fnlwgt-Av1[1])*(fnlwgt-Av1[1]))/(2*Va1[1]))/Math.sqrt(2*Math.PI*Va1[1]);
        double p3b = 1.0*Math.exp(-(1.0*(fnlwgt-Av2[1])*(fnlwgt-Av2[1]))/(2*Va2[1]))/Math.sqrt(2*Math.PI*Va2[1]);
        double p5a = 1.0*Math.exp(-(1.0*(education_num-Av1[2])*(education_num-Av1[2]))/(2*Va1[2]))/Math.sqrt(2*Math.PI*Va1[2]);
        double p5b = 1.0*Math.exp(-(1.0*(education_num-Av2[2])*(education_num-Av2[2]))/(2*Va2[2]))/Math.sqrt(2*Math.PI*Va2[2]);
        double p11a = 1.0*Math.exp(-(1.0*(capital_gain-Av1[3])*(capital_gain-Av1[3]))/(2*Va1[3]))/Math.sqrt(2*Math.PI*Va1[3]);
        double p11b = 1.0*Math.exp(-(1.0*(capital_gain-Av2[3])*(capital_gain-Av2[3]))/(2*Va2[3]))/Math.sqrt(2*Math.PI*Va2[3]);
        double p12a = 1.0*Math.exp(-(1.0*(capital_loss-Av1[4])*(capital_loss-Av1[4]))/(2*Va1[4]))/Math.sqrt(2*Math.PI*Va1[4]);
        double p12b = 1.0*Math.exp(-(1.0*(capital_loss-Av2[4])*(capital_loss-Av2[4]))/(2*Va2[4]))/Math.sqrt(2*Math.PI*Va2[4]);
        double p13a = 1.0*Math.exp(-(1.0*(hours_per_week-Av1[5])*(hours_per_week-Av1[5]))/(2*Va1[5]))/Math.sqrt(2*Math.PI*Va1[5]);
        double p13b = 1.0*Math.exp(-(1.0*(hours_per_week-Av2[5])*(hours_per_week-Av2[5]))/(2*Va2[5]))/Math.sqrt(2*Math.PI*Va2[5]);

        double nb_buy_yes=Math.log10(p1a)+Math.log10(1.0*(n2a+1)/(number_a+8))+Math.log10(p3a)+
                Math.log10(1.0*(n4a+1)/(number_a+16))+Math.log10(p5a)+
                Math.log10(1.0*(n6a+1)/(number_a+7))+Math.log10(1.0*(n7a+1)/(number_a+14))+Math.log10(1.0*(n8a+1)/(number_a+6))+Math.log10(1.0*(n9a+1)/(number_a+5))+
                Math.log10 (1.0*(n10a+1)/(number_a+2))+Math.log10(p11a)+Math.log10(p12a)+Math.log10(p13a)+
                Math.log10(1.0*(n14a+1)/(number_a+41))+Math.log10(buy_yes);
        double nb_buy_no=Math.log10(p1b)+Math.log10(1.0*(n2b+1)/(number_b+8))+Math.log10(p3b)+
                Math.log10(1.0*(n4b+1)/(number_b+16))+Math.log10(p5b)+
                Math.log10(1.0*(n6b+1)/(number_b+7))+Math.log10(1.0*(n7b+1)/(number_b+14))+Math.log10(1.0*(n8b+1)/(number_b+6))+Math.log10(1.0*(n9b+1)/(number_b+5))+
                Math.log10 (1.0*(n10b+1)/(number_b+2))+Math.log10(p11b)+Math.log10(p12b)+Math.log10(p13b)+
                Math.log10(1.0*(n14b+1)/(number_b+41))+Math.log10(buy_no);

        //全部属性
//        double nb_buy_yes=Math.log10(1.0*(n1a+1)/(number_a+5))+Math.log10(1.0*(n2a+1)/(number_a+8))+Math.log10(1.0*(n3a+1)/(number_a+8))+
//                Math.log10(1.0*(n4a+1)/(number_a+16))+Math.log10(1.0*(n5a+1)/(number_a+9))+
//                Math.log10(1.0*(n6a+1)/(number_a+7))+Math.log10(1.0*(n7a+1)/(number_a+14))+Math.log10(1.0*(n8a+1)/(number_a+6))+Math.log10(1.0*(n9a+1)/(number_a+5))+
//                Math.log10 (1.0*(n10a+1)/(number_a+2))+Math.log10(1.0*(n11a+1)/(number_a+5))+Math.log10(1.0*(n12a+1)/(number_a+5))+Math.log10(1.0*(n13a+1)/(number_a+5))+
//                Math.log10(1.0*(n14a+1)/(number_a+41))+Math.log10(buy_yes);
//        double nb_buy_no=Math.log10(1.0*(n1b+1)/(number_b+5))+Math.log10(1.0*(n2b+1)/(number_b+8))+Math.log10(1.0*(n3b+1)/(number_b+8))+
//                Math.log10(1.0*(n4b+1)/(number_b+16))+Math.log10(1.0*(n5b+1)/(number_b+9))+
//                Math.log10(1.0*(n6b+1)/(number_b+7))+Math.log10(1.0*(n7b+1)/(number_b+14))+Math.log10(1.0*(n8b+1)/(number_b+6))+Math.log10(1.0*(n9b+1)/(number_b+5))+
//                Math.log10 (1.0*(n10b+1)/(number_b+2))+Math.log10(1.0*(n11b+1)/(number_b+5))+Math.log10(1.0*(n12b+1)/(number_b+5))+Math.log10(1.0*(n13b+1)/(number_b+5))+
//                Math.log10(1.0*(n14b+1)/(number_b+41))+Math.log10(buy_no);

        //舍去部分属性
//        double nb_buy_yes=Math.log10(1.0*(n1a+1)/(number_a+5))+Math.log10(1.0*(n2a+1)/(number_a+8))+Math.log10(1.0*(n3a+1)/(number_a+8))+
//                Math.log10(1.0*(n4a+1)/(number_a+16))+Math.log10(1.0*(n5a+1)/(number_a+9))+
//                Math.log10(1.0*(n6a+1)/(number_a+7))+Math.log10(1.0*(n7a+1)/(number_a+14))+Math.log10(1.0*(n8a+1)/(number_a+6))+Math.log10(1.0*(n9a+1)/(number_a+5))+
//                Math.log10 (1.0*(n10a+1)/(number_a+2))+Math.log10(1.0*(n11a+1)/(number_a+5))+Math.log10(1.0*(n12a+1)/(number_a+5))+Math.log10(1.0*(n13a+1)/(number_a+5))+
//                Math.log10(1.0*(n14a+1)/(number_a+41))+Math.log10(buy_yes);
//        double nb_buy_no=Math.log10(1.0*(n1b+1)/(number_b+5))+Math.log10(1.0*(n2b+1)/(number_b+8))+Math.log10(1.0*(n3b+1)/(number_b+8))+
//                Math.log10(1.0*(n4b+1)/(number_b+16))+Math.log10(1.0*(n5b+1)/(number_b+9))+
//                Math.log10(1.0*(n6b+1)/(number_b+7))+Math.log10(1.0*(n7b+1)/(number_b+14))+Math.log10(1.0*(n8b+1)/(number_b+6))+Math.log10(1.0*(n9b+1)/(number_b+5))+
//                Math.log10 (1.0*(n10b+1)/(number_b+2))+Math.log10(1.0*(n11b+1)/(number_b+5))+Math.log10(1.0*(n12b+1)/(number_b+5))+Math.log10(1.0*(n13b+1)/(number_b+5))+
//                Math.log10(1.0*(n14b+1)/(number_b+41))+Math.log10(buy_no);

//        double nb_buy_yes=(1.0*(n1a+1)/number_a)*(1.0*(n2a+1)/(number_a+8))*(1.0*(n3a+1)/number_a)*(1.0*(n4a+1)/(number_a+16))*(1.0*(n5a+1)/number_a)*
//                (1.0*(n6a+1)/(number_a+7))*(1.0*(n7a+1)/(number_a+14))*(1.0*(n8a+1)/(number_a+6))*(1.0*(n9a+1)/(number_a+5))*
//                (1.0*(n10a+1)/(number_a+2))*(1.0*(n11a+1)/number_a)*(1.0*(n12a+1)/number_a)*(1.0*(n13a+1)/number_a)*
//                (1.0*(n14a+1)/(number_a+41))*buy_yes;
//        double nb_buy_no=(1.0*(n1b+1)/number_b)*(1.0*(n2b+1)/(number_b+8))*(1.0*(n3b+1)/number_b)*(1.0*(n4b+1)/(number_b+16))*(1.0*(n5b+1)/number_b)*
//                (1.0*(n6b+1)/(number_b+7))*(1.0*(n7b+1)/(number_b+14))*(1.0*(n8b+1)/(number_b+6))*(1.0*(n9b+1)/(number_b+5))*
//                (1.0*(n10b+1)/(number_b+2))*(1.0*(n11b+1)/number_b)*(1.0*(n12b+1)/number_b)*(1.0*(n13b+1)/number_b)*
//                (1.0*(n14b+1)/(number_b+41))*buy_no;
//        System.out.println("概率a:"+nb_buy_yes);
//        System.out.println("概率b:"+nb_buy_no);
        if(nb_buy_yes>nb_buy_no){
            return ">50K.";
            //System.out.println(">50K的概率大");
        }else {
            return "<=50K.";
            //System.out.println("<=50K的概率大");
        }
    }
}
