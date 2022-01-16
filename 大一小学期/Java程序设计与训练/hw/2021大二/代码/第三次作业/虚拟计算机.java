import java.io.*;
import java.util.*;

class Main {
    public static void main(String[] args) {
        Scanner in = new Scanner(new BufferedInputStream(System.in));
        Integer N = in.nextInt(),a,b,c;
        Integer mem[] = new Integer[N];
        while(in.hasNext()) {
            try {
                char o = in.next().charAt(0);
                a = in.nextInt();
                if(o=='?')
                    System.out.println(mem[a]);
                else {
                    b = in.nextInt();
                    c = in.nextInt();
                    switch (o) {
                        case '=':
                            for (int j = a; j < b; j++)
                                mem[j] = c;
                            break;
                        case '+':
                            mem[c] = mem[a]+mem[b];
                            break;
                        case '-':
                            mem[c] = mem[a]-mem[b];
                            break;
                        case '*':
                            mem[c] = mem[a]*mem[b];
                            break;
                        case '/':
                            mem[c] = mem[a]/mem[b];
                            break;
                        }
                }
            } catch (NullPointerException e) {
                System.out.println("Null Number");
            } catch (ArithmeticException e) {
                System.out.println("Divided By Zero");
            }catch (ArrayIndexOutOfBoundsException e) {
                System.out.println("Illegal Address");
            } catch(Exception e){}
        }
        in.close();
    }
}
