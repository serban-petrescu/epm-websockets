package db;

import java.io.Serializable;
import java.lang.String;
import javax.persistence.*;

/**
 * Entity implementation class for Entity: Currency
 *
 */
@Entity

public class Currency implements Serializable {


	@Id @Column(length=3)
	private String code;
	@Column(length=128)
	private String description;
	private static final long serialVersionUID = 1L;

	public Currency() {
		super();
	}
	public String getCode() {
		return this.code;
	}

	public void setCode(String code) {
		this.code = code;
	}
	public String getDescription() {
		return this.description;
	}

	public void setDescription(String description) {
		this.description = description;
	}
	public Currency(String code, String description) {
		super();
		this.code = code;
		this.description = description;
	}

}
