import java.io.*;
import java.util.*;

class Main {
    public static void main(String[] args) {
        Scanner in = new Scanner(new BufferedInputStream(System.in));
        int N = in.nextInt();
        String res = "YES";
        Union u = new Union(N);
        for (int i = 0; i < N - 1; i++) {
            int a = in.nextInt() - 1, b = in.nextInt() - 1;
            if (u.connected(a, b))
                res = "NO";
            else
                u.union(a, b);
        }
        System.out.println(res);
        in.close();
    }
}

class Union {
    private int[] id;

    public Union(int N) {
        id = new int[N];
        for (int i = 0; i < N; i++) {
            id[i] = i;
        }
    }

    private int root(int i) {
        while (i != id[i]) {
            i = id[i];
        }
        return i;
    }

    public boolean connected(int p, int q) {
        return root(p) == root(q);
    }

    public void union(int p, int q) {
        int qroot = root(q);
        int proot = root(p);
        id[proot] = qroot;
    }
}