package decaf.utils;

public final class MiscUtils {
	/**
	 * 返回带转义符格式的字符串
	 * 
	 * @param str
	 *            不带转义符的字符串（即内部表示）
	 * @return 带转义符的字符串（并加上双引号）
	 */
	public static String quote(String str) {
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < str.length(); ++i) {
			char c = str.charAt(i);
			switch (c) {
			case '"':
				sb.append("\\\"");
				break;
			case '\n':
				sb.append("\\n");
				break;
			case '\t':
				sb.append("\\t");
				break;
			case '\\':
				sb.append("\\\\");
				break;
			default:
				sb.append(c);
			}
		}
		return ('"' + sb.toString() + '"');
	}
}
