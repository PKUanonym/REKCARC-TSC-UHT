/**
 * Created by NitreExplosion on 2017/5/23.
 */
public class Test {
    public static void main(String[] args) {
        Pipeline test = new Pipeline();

        test.addCmd("LD F2,120(R4)");
        test.addCmd("LD F2,120(R4)");
        test.addCmd("LD F2,120(R4)");
        test.addCmd("LD F2,120(R4)");
        test.addCmd("LD F2,120(R4)");
        //test.addCmd("");
        test.parser();
        test.run();
        System.out.print(test.nextStep(10));
    }
}
