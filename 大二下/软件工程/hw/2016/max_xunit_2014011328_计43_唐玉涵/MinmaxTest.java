import static org.junit.Assert.assertEquals;

import org.junit.Test;

public class MinmaxTest {
  @Test
  public void test_abc() {
    Minmax minmax = new Minmax();
    double result = minmax.get_max(1, 2, 3);
    assertEquals(3, result, 1e-10);
  }

  @Test
  public void test_acb() {
    Minmax minmax = new Minmax();
    double result = minmax.get_max(1, 3, 2);
    assertEquals(3, result, 1e-10);
  }

  @Test
  public void test_bac() {
    Minmax minmax = new Minmax();
    double result = minmax.get_max(2, 1, 3);
    assertEquals(3, result, 1e-10);
  }

  @Test
  public void test_bca() {
    Minmax minmax = new Minmax();
    double result = minmax.get_max(2, 3, 1);
    assertEquals(3, result, 1e-10);
  }

  @Test
  public void test_cab() {
    Minmax minmax = new Minmax();
    double result = minmax.get_max(3, 1, 2);
    assertEquals(3, result, 1e-10);
  }

  @Test
  public void test_cba() {
    Minmax minmax = new Minmax();
    double result = minmax.get_max(3, 2, 1);
    assertEquals(3, result, 1e-10);
  }
  
}