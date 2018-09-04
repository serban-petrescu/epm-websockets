package init;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

import javax.persistence.EntityManager;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import db.Category;
import db.Currency;
import db.Product;
import db.WeightUnit;
import odata.ODataServiceFactory;

/**
 * Application Lifecycle Listener implementation class Initializer
 *
 */
@WebListener
public class Initializer implements ServletContextListener {

	/**
	 * @see ServletContextListener#contextInitialized(ServletContextEvent)
	 */
	public void contextInitialized(ServletContextEvent arg0) {
		try {
			EntityManager em = ODataServiceFactory.getEmf()
					.createEntityManager();
			if (em.find(Currency.class, "USD") == null) {
				em.getTransaction().begin();
				List<Currency> currencies = new ArrayList<Currency>();
				List<WeightUnit> weightUnits = new ArrayList<WeightUnit>();
				Map<String, Category> categories = new HashMap<String, Category>();

				Scanner in = new Scanner(
						Initializer.class.getResourceAsStream("currency.txt"));
				while (in.hasNextLine()) {
					String[] s = in.nextLine().split("\t");
					Currency c = new Currency(s[0], s[1]);
					currencies.add(c);
					em.persist(c);
				}
				in.close();

				in = new Scanner(
						Initializer.class
								.getResourceAsStream("weight_unit.txt"));
				while (in.hasNextLine()) {
					String[] s = in.nextLine().split("\t");
					WeightUnit u = new WeightUnit(s[0], s[1]);
					weightUnits.add(u);
					em.persist(u);
				}
				in.close();

				in = new Scanner(
						Initializer.class.getResourceAsStream("category.txt"));
				while (in.hasNextLine()) {
					String[] s = in.nextLine().split("\t");
					Category c = new Category(s[0]);
					categories.put(s[0], c);
					em.persist(c);
				}
				in.close();

				in = new Scanner(
						Initializer.class.getResourceAsStream("product.txt"));
				while (in.hasNextLine()) {
					String[] s = in.nextLine().split("\t");
					em.persist(new Product(s[0], categories.get(s[1]),
							truncate(s[2], 128), new BigDecimal(s[3]),
							currencies.get((int) (Math.random() * currencies
									.size())), new BigDecimal(s[4]),
							weightUnits.get((int) (Math.random() * weightUnits
									.size())), s[5]));
				}
				em.flush();
				em.getTransaction().commit();
				in.close();
				em.close();
			}

		} catch (Exception e) {
			// init failed :(
		}
	}

	private static String truncate(String s, int length) {
		if (s.length() > length) {
			return s.substring(0, length);
		} else {
			return s;
		}
	}

	/**
	 * @see ServletContextListener#contextDestroyed(ServletContextEvent)
	 */
	public void contextDestroyed(ServletContextEvent arg0) {
		// nothing to do
	}

}
