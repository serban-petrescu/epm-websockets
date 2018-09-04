package ws;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoDestinationManager;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoRepository;

public enum RFCPoller {
	INSTANCE;
	private static final Logger LOGGER = LoggerFactory
			.getLogger(RFCPoller.class);

	private RFCPoller() {}

	public void start() {
		try {
			// access the RFC Destination; Replace RFC_DEST with your own destination
			JCoDestination destination = JCoDestinationManager
					.getDestination("REF_DEST");

			// make an invocation of STFC_CONNECTION in the backend;
			JCoRepository repo = destination.getRepository();
			Caller c = new Caller(destination,
					repo.getFunction("ZDEMO_FM_REFRESH"));
			c.start();
		} catch (JCoException e) {
			LOGGER.error("JCo Exception: " + e.getMessage());
		}
	}

	private static class Caller extends Thread {
		private JCoFunction f;
		private JCoDestination d;

		public Caller(JCoDestination d, JCoFunction f) {
			this.d = d;
			this.f = f;
		}

		@Override
		public void run() {
			try {
			do {
				f.execute(d);
				JCoParameterList exports = f.getExportParameterList();
				String timeout = exports.getString("EF_TIMEOUT");
				if (timeout.trim().length() == 0) {
					BackendEndpoint.sendRefresh();
				}
			}while(true);
			} catch (JCoException e) {
				LOGGER.error("JCo Exception: " + e.getMessage());
			}
		}
	}
}
