import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.charset.StandardCharsets;
import java.util.Scanner;
import java.util.concurrent.CountDownLatch;

class Main {
	private static class C extends Cloud implements Runnable {
		private static int defense;
		private int seed;
		public final CountDownLatch latch;
		public volatile Throwable error;
		private final ServerSocket server;

		private C(final int seed) {
			this.seed = seed | 1;
			latch = new CountDownLatch(1);
			renewData();
			ServerSocket s = null;
			try {
				s = new java.net.ServerSocket(11111, 1, InetAddress.getLoopbackAddress());
			} catch (final Exception e) {
			}
			server = s;
		}

		private int newInt() {
			seed = seed * 3;
			return Integer.remainderUnsigned(seed, 1234567);
		}

		private void renewData() {
			final int v1 = newInt(), v2 = newInt();
			setData(Integer.reverse(v1) ^ v2);
		}

		@Override
		public void run() {
			try (final ServerSocket server = this.server) {
				latch.countDown();
				for (; defense != 0; --defense) {
					final String message;
					try (final Socket client = server.accept()) {
						System.out.println("Client");
						message = getMessage(client);
						System.out.println(message);
					}
					if (Cloud.test(Integer.parseInt(message))) {
						System.out.println("Cloud is hacked, loss data " + data + "!");
						renewData();
					} else
						throw new Exception();
				}
				System.out.println("Hacker wins!");
			} catch (final Exception e) {
				System.out.println("Game is over!");
				error = e;
				latch.countDown();
			}
		}

		public String getMessage(final Socket client) {
			try (final BufferedReader br = new BufferedReader(
					new InputStreamReader(client.getInputStream(), StandardCharsets.US_ASCII))) {
				return br.readLine();
			} catch (final IOException e) {

			}
			return null;
		}
	}

	public static void main(final String[] args) throws InterruptedException {
		final int seed;
		try (final Scanner cin = new Scanner(System.in, "UTF-8")) {
			C.defense = cin.nextInt();
			seed = cin.nextInt();
		}
		final C c = new C(seed);
		final Thread cloud = new Thread(c, "cloud");
		cloud.start();
		c.latch.await();
		if (c.error == null) {
			final Thread hacker = new Thread(new Hacker(), "hacker");
			hacker.setDaemon(true);
			hacker.start();
			cloud.join();
		}
		if (c.error != null)
			System.out.println("An error: " + c.error);
	}
}
