import java.io.BufferedInputStream;
import java.util.*;

class Main {
    public static void main(String[] args) {
        Scanner in = new Scanner(new BufferedInputStream(System.in));
        int N = in.nextInt();
        int size = N * N;
        int[][] row = new int[size][size];
        int[][] col = new int[size][size];
        int[][] box = new int[size][size];
        String res = "yes";
        for (int i = 0; i < size; i++)
            for (int j = 0; j < size; j++) {
                int num = in.nextInt();
                int index = (i / N) * N + j / N;
                if (row[num - 1][i] + col[num - 1][j] + box[num - 1][index] > 0)
                    res = "no";
                row[num - 1][i] = col[num - 1][j] = box[num - 1][index] = 1;
            }
        in.close();
        System.out.println(res);
    }

}