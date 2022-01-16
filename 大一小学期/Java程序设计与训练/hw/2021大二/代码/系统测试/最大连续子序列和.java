import java.io.BufferedInputStream;
import java.util.*;

class Main {
    public static void main(String[] args) {
        Scanner in = new Scanner(new BufferedInputStream(System.in));
        int N = in.nextInt();
        int res = Integer.MIN_VALUE;
        int cur = 0;
        for (int i = 0; i < N; i++) {
            int num = in.nextInt();
            cur = Integer.max(num + cur, num);
            res = Integer.max(res, cur);
        }
        System.out.println(res);
        in.close();
    }

}