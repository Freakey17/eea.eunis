package eionet.eunis.util;

/**
 * Utility class to hold id &lt;-&gt; value.
 * 
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
public class Pair <T,T1> {
	
	private T id;
	private T1 value;
	
	/**
	 * @param id
	 * @param value
	 */
	public Pair(T id, T1 value) {
		this.id = id;
		this.value = value;
	}
	/**
	 * @return the id
	 */
	public T getId() {
		return id;
	}
	/**
	 * @param id the id to set
	 */
	public void setId(T id) {
		this.id = id;
	}
	/**
	 * @return the value
	 */
	public T1 getValue() {
		return value;
	}
	/**
	 * @param value the value to set
	 */
	public void setValue(T1 value) {
		this.value = value;
	}
}
