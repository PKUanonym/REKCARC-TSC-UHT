/**
 * Created by NitreExplosion on 2017/5/26.
 */
public class Cmd {
    int length;
    int[] code;
    int state;
    String text;

    public Cmd() {
        length = 0;
        code = new int[4];
        state = -1;
    }
}
