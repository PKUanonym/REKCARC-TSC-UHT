package decaf.tacvm.exec;

public class ExecuteException extends RuntimeException {

	private static final long serialVersionUID = -1595578849522351486L;

	public ExecuteException(String message, Throwable cause) {
		super(message, cause);
	}

	public ExecuteException(String message) {
		super(message);
	}

	public ExecuteException(Throwable cause) {
		super(cause);
	}

}
