public class Test {
  public static void main(String[] args) {

    Splay s6 = new Splay();
    BinNode n601 = null;
    BinNode n602 = new BinNode(n601,2);
    BinNode n603 = new BinNode(n602,3);
    BinNode n604 = new BinNode(n603,4);
    n602.set_rc(n603);
    
    
    System.out.println(s6.splay(n604));
  }
}
