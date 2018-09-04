package odata;

import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

import org.apache.olingo.odata2.api.ODataService;
import org.apache.olingo.odata2.api.edm.provider.EdmProvider;
import org.apache.olingo.odata2.api.processor.ODataSingleProcessor;
import org.apache.olingo.odata2.jpa.processor.api.ODataJPAContext;
import org.apache.olingo.odata2.jpa.processor.api.ODataJPAServiceFactory;
import org.apache.olingo.odata2.jpa.processor.api.exception.ODataJPARuntimeException;
import org.eclipse.persistence.config.PersistenceUnitProperties;

public class ODataServiceFactory extends ODataJPAServiceFactory {

	public static final String PUNIT_NAME = "scnEpmWebsockets";

	public static final EntityManagerFactory getEmf() throws NamingException {
		InitialContext ctx = new InitialContext();
		DataSource ds = (DataSource) ctx
				.lookup("java:comp/env/jdbc/DefaultDB");

		Map<String, Object> properties = new HashMap<String, Object>();
		properties.put(PersistenceUnitProperties.NON_JTA_DATASOURCE, ds);
		return Persistence.createEntityManagerFactory(PUNIT_NAME, properties);
	}

	@Override
	public ODataJPAContext initializeODataJPAContext()
			throws ODataJPARuntimeException {
		try {

			ODataJPAContext oDataJPAContext = getODataJPAContext();
			oDataJPAContext.setEntityManagerFactory(getEmf());
			oDataJPAContext.setPersistenceUnitName(PUNIT_NAME);
			return oDataJPAContext;
		} catch (NamingException e) {
			throw ODataJPARuntimeException.throwException(
					ODataJPARuntimeException.ENTITY_MANAGER_NOT_INITIALIZED, e);
		}
	}

	@Override
	public ODataService createODataSingleProcessorService(EdmProvider provider,
			ODataSingleProcessor processor) {
		return super.createODataSingleProcessorService(provider, new ODataSingleProcessorWrapper(processor));
	}
}
