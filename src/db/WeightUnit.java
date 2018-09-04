package db;

import java.io.Serializable;
import java.lang.String;
import javax.persistence.*;

/**
 * Entity implementation class for Entity: WeightUnit
 *
 */
@Entity

public class WeightUnit implements Serializable {


	@Id @Column(length=5)
	private String symbol;
	@Column(length=128)
	private String description;
	private static final long serialVersionUID = 1L;

	public WeightUnit() {
		super();
	}
	public String getSymbol() {
		return this.symbol;
	}

	public void setSymbol(String symbol) {
		this.symbol = symbol;
	}
	public String getDescription() {
		return this.description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public WeightUnit(String symbol, String description) {
		super();
		this.symbol = symbol;
		this.description = description;
	}

}
