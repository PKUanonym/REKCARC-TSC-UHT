import java.io.*;
import java.util.*;

class Main {
    public static void main(String[] args) {
        Scanner in = new Scanner(new BufferedInputStream(System.in));
        String str = in.next().toLowerCase();
        Arrays.asList(new File("./input/test/case")
        .listFiles(new FilenameFilter() {
            @Override
            public boolean accept(File file, String name) {
                return name.toLowerCase().contains(str);
            }
        })).stream().filter(File::isFile).map(File::getName)
        .sorted().forEach(System.out::println);
        in.close();
    }
}
