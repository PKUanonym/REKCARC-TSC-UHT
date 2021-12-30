import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

import java.lang.Math;

public class ArithTest {
  @Test
  public void test_positive_decrease_positive() {
    Arith arith = new Arith();
    double result = arith.decrease(5.5, 3.3);
    assertEquals(2.2, result, 1e-10);
  }

  @Test
  public void test_positive_decrease_negative() {
    Arith arith = new Arith();
    double result = arith.decrease(5.5, -3.3);
    assertEquals(8.8, result, 1e-10);
  }

  @Test
  public void test_negative_decrease_negative() {
    Arith arith = new Arith();
    double result = arith.decrease(-5.5, -3.3);
    assertEquals(-2.2, result, 1e-10);
  }

  @Test
  public void test_positive_pow_positive() {
    Arith arith = new Arith();
    double result = arith.pow(2, 3);
    assertEquals(8, result, 1e-10);
  }

  @Test
  public void test_positive_pow_negative() {
    Arith arith = new Arith();
    double result = arith.pow(2, -1);
    assertEquals(0.5, result, 1e-10);
  }

  @Test
  public void test_negative_pow_positive_success() {
    Arith arith = new Arith();
    double result = arith.pow(-2, 2);
    assertEquals(4, result, 1e-10);
  }

  @Test
  public void test_negative_pow_positive_failure() {
    Arith arith = new Arith();
    double result = arith.pow(-2, 0.5);
    assertTrue(Double.isNaN(result));
  }

  @Test
  public void test_negative_pow_negative_success() {
    Arith arith = new Arith();
    double result = arith.pow(-2, -2);
    assertEquals(0.25, result, 1e-10);
  }

  @Test
  public void test_negative_pow_negative_failure() {
    Arith arith = new Arith();
    double result = arith.pow(-2, -0.5);
    assertTrue(Double.isNaN(result));
  }
}