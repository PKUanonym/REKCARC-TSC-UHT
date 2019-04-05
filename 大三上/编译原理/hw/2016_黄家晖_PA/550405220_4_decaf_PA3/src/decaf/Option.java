package decaf;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.PrintStream;

public final class Option {

	public enum Level {
		LEVEL0, LEVEL1, LEVEL2, LEVEL3, LEVEL4
	}

	private String srcFileName;

	private String dstFileName;

	private InputStream input = System.in;

	private PrintStream output = System.out;

	private PrintStream err = System.err;

	private Level level = Level.LEVEL4;

	private static final String mainClassName = "Main";

	private static final String mainFuncName = "main";

	public String getMainFuncName() {
		return mainFuncName;
	}

	public String getMainClassName() {
		return mainClassName;
	}

	public Option(String[] args) {
		if (args.length == 0) {
			output.println(usage());
			System.exit(0);
		}
		for (int i = 0; i < args.length; i++) {
			if (args[i].equals("-o")) {
				dstFileName = args[++i];
				try {
					output = new PrintStream(new FileOutputStream(dstFileName));
				} catch (FileNotFoundException e) {
					err.println("Can not open file " + dstFileName
							+ " for write");
					System.exit(1);
				}
			} else if (args[i].equals("-l")) {
				level = Level.valueOf("LEVEL" + args[++i]);
			} else {
				srcFileName = args[i];
				try {
					input = new BufferedInputStream(new FileInputStream(
							srcFileName));
				} catch (FileNotFoundException e) {
					err.println("File " + srcFileName + " not found");
					System.exit(1);
				}
			}
		}
	}

	private String usage() {
		return ("\n"
				+ "Usage:  java -jar decaf.jar [-l LEVEL] [-o OUTPUT] SOURCE\n"
				+ "Options:\n"
				+ "    -l  Developing level of the compiler, values of LEVEL are:  \n"
				+ "        0  AST Construction                                     \n"
				+ "        1  Type Check                                           \n"
				+ "        2  TAC Generation                                       \n"
				+ "        3  Dataflow Analysis                                    \n"
				+ "        4  Final Ouput (Mips Assembly, default)                 \n"
				+ "                                                                \n"
				+ "    -o  Specifying the output file name. stdout if omitted.     \n"
				+ "                                                                \n"
				+ "\n");
	}

	public String getSrcFileName() {
		return srcFileName;
	}

	public String getDstFileName() {
		return dstFileName;
	}

	public InputStream getInput() {
		return input;
	}

	public Level getLevel() {
		return level;
	}

	public PrintStream getOutput() {
		return output;
	}

	public PrintStream getErr() {
		return err;
	}
}
