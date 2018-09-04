package db;

import java.io.Serializable;
import java.lang.String;
import java.math.BigDecimal;

import javax.persistence.*;

/**
 * Entity implementation class for Entity: Product
 *
 */
@Entity

public class Product implements Serializable {


	@Id @GeneratedValue
	private int id;
	@Column(length=32, unique=true)
	private String name;
	@ManyToOne(fetch=FetchType.EAGER, optional=false)
	private Category category;
	@Column(length=128)
	private String description;
	private BigDecimal price;
	@ManyToOne(fetch=FetchType.EAGER, optional=false)
	private Currency currency;
	private BigDecimal weight;
	@ManyToOne(fetch=FetchType.EAGER, optional=false)
	private WeightUnit weightUnit;
	@Column(length=64)
	private String pictureUrl;

	private static final long serialVersionUID = 1L;

	public Product() {
		super();
	}
	public int getId() {
		return this.id;
	}

	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}
	public String getDescription() {
		return this.description;
	}

	public void setDescription(String description) {
		this.description = description;
	}
	public BigDecimal getPrice() {
		return this.price;
	}

	public void setPrice(BigDecimal price) {
		this.price = price;
	}
	public BigDecimal getWeight() {
		return this.weight;
	}

	public void setWeight(BigDecimal weight) {
		this.weight = weight;
	}
	public String getPictureUrl() {
		return this.pictureUrl;
	}

	public void setPictureUrl(String pictureUrl) {
		this.pictureUrl = pictureUrl;
	}
	public Currency getCurrency() {
		return currency;
	}

	public void setCurrency(Currency currency) {
		this.currency = currency;
	}

	public WeightUnit getWeightUnit() {
		return weightUnit;
	}

	public void setWeightUnit(WeightUnit weightUnit) {
		this.weightUnit = weightUnit;
	}

	public Category getCategory() {
		return category;
	}

	public void setCategory(Category category) {
		this.category = category;
	}

	public Product(String name, Category category, String description,
			BigDecimal price, Currency currency, BigDecimal weight,
			WeightUnit weightUnit, String pictureUrl) {
		super();
		this.name = name;
		this.category = category;
		this.description = description;
		this.price = price;
		this.currency = currency;
		this.weight = weight;
		this.weightUnit = weightUnit;
		this.pictureUrl = pictureUrl;
	}

}
