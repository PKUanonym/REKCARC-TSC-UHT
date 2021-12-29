import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

public class SplayTest {
  @Test
  public void test1() {
    Splay s1 = new Splay();
    BinNode n1 = new BinNode(null,1);
    s1.splay(n1);

    Splay s2 = new Splay();
    BinNode n2 = null;
    s2.splay(n2);

    Splay s3 = new Splay();
    BinNode n301 = new BinNode(null,1);
    BinNode n302 = new BinNode(n301,2);
    BinNode n303 = new BinNode(n302,3);
    BinNode n304 = new BinNode(n303,4);
    s3.splay(n304);

    Splay s4 = new Splay();
    BinNode n401 = null;
    BinNode n402 = new BinNode(n401,2);
    BinNode n403 = new BinNode(n402,3);
    BinNode n404 = new BinNode(n403,4);
    n403.set_lc(n404);
    s4.splay(n404);
    n402.set_lc(n403);
    s4.splay(n404);

    Splay s5 = new Splay();
    BinNode n501 = null;
    BinNode n502 = new BinNode(n501,2);
    BinNode n503 = new BinNode(n502,3);
    BinNode n504 = new BinNode(n503,4);
    n502.set_lc(n503);
    s5.splay(n504);

    Splay s6 = new Splay();
    BinNode n601 = null;
    BinNode n602 = new BinNode(n601,2);
    BinNode n603 = new BinNode(n602,3);
    BinNode n604 = new BinNode(n603,4);
    n602.set_rc(n603);
    s6.splay(n604);

    Splay s7 = new Splay();
    BinNode n701 = null;
    BinNode n702 = new BinNode(n701,2);
    BinNode n703 = new BinNode(n702,3);
    BinNode n704 = new BinNode(n703,4);
    n703.set_lc(n704);
    s7.splay(n704);

  }
}
