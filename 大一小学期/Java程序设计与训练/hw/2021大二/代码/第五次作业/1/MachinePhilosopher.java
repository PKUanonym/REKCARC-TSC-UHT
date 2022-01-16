class MachinePhilosopher implements Runnable {
	public final int id;

	MachinePhilosopher(final int id) {
		this.id = id;
	}

	@Override
	public void run() {
		Com com = Com.getInstance();
		int num, tmp;
		synchronized (com) {
			num = com.getNumber();
		}
		while (true) {
			try {
				synchronized (com) {
					com.wait();
				}
			} catch (Exception e) {
			}
			synchronized (com) {
				tmp = com.getNumber();
			}
			if (num != tmp) {
				num = tmp;
				synchronized (com) {
					com.star(num, id);
				}
			}
		}
	}
}
