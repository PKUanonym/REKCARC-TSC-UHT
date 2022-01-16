import java.util.Scanner;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;

public class Main {
	private static MachinePhilosopher[] p;
	private static Thread[] t;
	private static boolean[] boot;

	static class C extends Com {
		private static AtomicInteger number;
		private static AtomicBoolean[] star;
		private static volatile CountDownLatch bootlatch, latch;

		@Override
		public int getNumber() {
			if (bootlatch.getCount() != 0) {
				final Thread thread = Thread.currentThread();
				for (int i = 0; i != t.length; ++i)
					if (t[i] == thread) {
						if (!boot[i]) {
							boot[i] = true;
							bootlatch.countDown();
						}
						break;
					}
			}
			return number.get();
		}

		@Override
		public void star(final int number, final int userId) {
			if (number == C.number.get() && userId >= 0 && userId < star.length && !star[userId].get()
					&& t[userId] == Thread.currentThread() && latch != null) {
				star[userId].set(true);
				latch.countDown();
			} else
				throw new IllegalArgumentException("Com: bad call: star(" + number + ", " + userId + ")");
		}

		private static boolean checkStar() {
			for (int i = 0; i != star.length; ++i)
				if (!star[i].get())
					return false;
			for (int i = 0; i != star.length; ++i)
				star[i].set(false);
			return true;
		}

		static final Com com = new C();
	}

	private static int nextNumber(final int number) {
		return number + 1;
	}

	private static boolean nozuonodie() {
		for (int i = 0; i != t.length; ++i)
			if (!t[i].isAlive()) {
				System.out.println("Machine " + i + " whozuowhodie");
				return true;
			}
		return false;
	}

	private static boolean finish(final CountDownLatch latch) {
		for (;;) {
			try {
				if (latch.await(100, TimeUnit.MICROSECONDS))
					return true;
			} catch (final InterruptedException e) {
			}
			if (nozuonodie())
				return false;
		}
	}

	public static void main(final String[] args) {
		final int n, m;
		try (final Scanner cin = new Scanner(System.in)) {
			n = cin.nextInt();
			m = cin.nextInt();
			C.number = new AtomicInteger(cin.nextInt());
		}
		p = new MachinePhilosopher[n];
		t = new Thread[n];
		boot = new boolean[n];
		C.star = new AtomicBoolean[n];
		C.bootlatch = new CountDownLatch(n);
		for (int i = 0; i != n; ++i) {
			p[i] = new MachinePhilosopher(i);
			t[i] = new Thread(p[i]);
			t[i].setDaemon(true);
			C.star[i] = new AtomicBoolean(true); // first number will not be starred
			t[i].start();
		}
		if (!finish(C.bootlatch))
			return;
		if (C.checkStar())
			System.out.println("All machine finish booting");
		else {
			System.out.println("Boot Error");
			return;
		}
		for (int round = 0; round != m; ++round) {
			synchronized (C.com) {
				C.latch = new CountDownLatch(n);
				C.number.set(nextNumber(C.number.get()));
				C.com.notifyAll();
			}
			if (!finish(C.latch))
				return;
			if (C.checkStar())
				System.out.println("All machine finish starring " + C.number.get());
			else {
				System.out.println("Star Error");
				return;
			}
			// if (round % 10 == 9)
			// t[round % n].interrupt(); // play a trick
		}
		nozuonodie();
	}
}
