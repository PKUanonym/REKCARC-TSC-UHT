package decaf;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import decaf.tree.Tree;
import decaf.error.DecafError;
import decaf.frontend.Lexer;
import decaf.frontend.Parser;
import decaf.utils.IndentPrintWriter;

public final class Driver {

	private static Driver driver;

	private Option option;

	private List<DecafError> errors;

	private Lexer lexer;

	private Parser parser;

	public static Driver getDriver() {
		return driver;
	}

	public void issueError(DecafError error) {
		errors.add(error);
	}

	public void checkPoint() {
		if (errors.size() > 0) {
			Collections.sort(errors, new Comparator<DecafError>() {

				@Override
				public int compare(DecafError o1, DecafError o2) {
					return o1.getLocation().compareTo(o2.getLocation());
				}

			});
			for (DecafError error : errors) {
				option.getErr().println(error);
			}
			System.exit(1);
		}
	}

	private void init() {
		lexer = new Lexer(option.getInput());
		parser = new Parser();
		lexer.setParser(parser);
		parser.setLexer(lexer);
		errors = new ArrayList<DecafError>();
	}

	private void compile() {

		Tree.TopLevel tree = parser.parseFile();
		checkPoint();
		if (option.getLevel() == Option.Level.LEVEL0) {
			IndentPrintWriter pw = new IndentPrintWriter(option.getOutput(), 4);
			tree.printTo(pw);
			pw.close();
			return;
		}
	}

	public static void main(String[] args) throws IOException {
		driver = new Driver();
		driver.option = new Option(args);
		driver.init();
		driver.compile();
	}

	public Option getOption() {
		return option;
	}
}
