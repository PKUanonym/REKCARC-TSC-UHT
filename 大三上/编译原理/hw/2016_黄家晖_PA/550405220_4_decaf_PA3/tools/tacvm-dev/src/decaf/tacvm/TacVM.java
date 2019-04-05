package decaf.tacvm;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.PrintWriter;

import decaf.tacvm.exec.Executor;
import decaf.tacvm.parser.Errs;
import decaf.tacvm.parser.Lexer;
import decaf.tacvm.parser.Parser;

public final class TacVM {
	private InputStream input = System.in;

	private int maxRunInsts = 100000;

	public TacVM(String[] args) {
		for (int i = 0; i < args.length; i++) {
			if (args[i].equals("-m")) {
				maxRunInsts = Integer.parseInt(args[++i]);
			} else {
				try {
					input = new BufferedInputStream(
							new FileInputStream(args[i]));
				} catch (FileNotFoundException e) {
					System.err.println("File " + args[0] + " not found");
					System.exit(1);
				}
			}
		}
	}

	public void run() {
		Lexer lexer = new Lexer(input);
		Parser parser = new Parser();
		lexer.setParser(parser);
		parser.setLexer(lexer);
		parser.parse();
		Errs.checkPoint(new PrintWriter(System.err));
		Executor executor = new Executor();
		executor.setMaxRunInsts(maxRunInsts);
		executor.init(parser.getStringTable(), parser.getTacs(), parser
				.getVTables(), parser.getEnterPoint());
		//executor.dumpInsts();
		executor.exec();
	}

	public static void main(String[] args) {
		//args = new String[]{"D:/test.tac"};
		TacVM vm = new TacVM(args);
		vm.run();
	}
}
