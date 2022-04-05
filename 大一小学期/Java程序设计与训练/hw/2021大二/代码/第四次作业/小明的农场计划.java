import java.io.*;
import java.util.*;

class Main {
    static TreeMap<Integer, Integer> map = new TreeMap<Integer, Integer>();
    static long res = 0;

    public static void main(String[] args) {
        Scanner in = new Scanner(new BufferedInputStream(System.in));
        int N = in.nextInt();
        for (int i = 0; i < N; i++) {
            int a = in.nextInt(), b = in.nextInt();
            Integer c;
            if (res != -1) {
                switch (a) {
                    case 1:
                        map.compute(b, (key, value) -> value == null ? 1 : value + 1);
                        res += b;
                        break;
                    case 2:
                        c = map.floorKey(b);
                        proceed(c);
                        break;
                    case 3:
                        c = map.ceilingKey(b);
                        proceed(c);
                        break;
                }
            }
        }
        System.out.println(res);
        in.close();
    }

    private static void proceed(Integer c) {
        if (c == null)
            res = -1;
        else {
            res -= c;
            map.compute(c, (key, value) -> value - 1);
            if (map.get(c) == 0)
                map.remove(c);
        }
    }
}
