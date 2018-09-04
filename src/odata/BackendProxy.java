package odata;

import static java.net.HttpURLConnection.HTTP_OK;

import java.io.IOException;
import java.io.InputStream;
import java.util.Enumeration;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.Header;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpDelete;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.client.methods.HttpRequestBase;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.sap.core.connectivity.api.DestinationFactory;
import com.sap.core.connectivity.api.http.HttpDestination;

public class BackendProxy extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final int COPY_CONTENT_BUFFER_SIZE = 1024;
	private static final Logger LOGGER = LoggerFactory
			.getLogger(BackendProxy.class);
	//Replace DEST with the backend destination (for OData)
	private static final String BACKEND_DEST = "DEST";
	private static final String BACKEND_PATH = "/sap/opu/odata/SAP/Z<GW_SERVICE_NAME>";

	private static final int METHOD_GET = 0;
	private static final int METHOD_POST = 1;
	private static final int METHOD_PUT = 2;
	private static final int METHOD_DELETE = 3;

	/** {@inheritDoc} */
	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doRequest(request, response, METHOD_GET);
	}

	@Override
	protected void doDelete(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doRequest(req, resp, METHOD_DELETE);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doRequest(req, resp, METHOD_POST);
	}

	@Override
	protected void doPut(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doRequest(req, resp, METHOD_PUT);
	}

	public void doRequest(HttpServletRequest request,
			HttpServletResponse response, int method) throws ServletException,
			IOException {
		HttpClient httpClient = null;
		try {
			// Get HTTP destination
			Context ctx = new InitialContext();
			// The default request to the Servlet will use the BACKEND Destination
			HttpDestination destination = (HttpDestination) ctx
					.lookup("java:comp/env/" + BACKEND_DEST);
			// Create HTTP client
			httpClient = destination.createHttpClient();

			String url = destination.getURI().toURL()
					+ BACKEND_PATH
					+ request.getRequestURI().substring(
							request.getContextPath().length()
									+ request.getServletPath().length())
					+ (request.getQueryString() == null ? "" : "?"
							+ request.getQueryString());

			HttpRequestBase httpRequest = null;

			switch (method) {
			case METHOD_DELETE:
				httpRequest = new HttpDelete(url);
				break;
			case METHOD_POST:
				httpRequest = new HttpPost(url);
				break;
			case METHOD_PUT:
				httpRequest = new HttpPut(url);
				break;
			default:
				httpRequest = new HttpGet(url);
				break;

			}

			Enumeration<String> headerNames = request.getHeaderNames();
			while (headerNames.hasMoreElements()) {
				String header = headerNames.nextElement();
				String value = request.getHeader(header);
				httpRequest.setHeader(header, value);
			}

			HttpResponse httpResponse = httpClient.execute(httpRequest);

			response.setStatus(httpResponse.getStatusLine().getStatusCode());
			if (httpResponse.getStatusLine().getStatusCode() == HTTP_OK) {
				Header[] headers = httpResponse.getAllHeaders();
				for (Header h : headers) {
					response.setHeader(h.getName(), h.getValue());
				}

			}

			// Copy content from the incoming response to the outgoing response
			HttpEntity entity = httpResponse.getEntity();
			if (entity != null) {
				InputStream instream = entity.getContent();
				try {
					byte[] buffer = new byte[COPY_CONTENT_BUFFER_SIZE];
					int len;
					while ((len = instream.read(buffer)) != -1) {
						response.getOutputStream().write(buffer, 0, len);
					}
				} catch (IOException e) {
					// In case of an IOException the connection will be released
					// back to the connection manager automatically
					throw e;
				} catch (RuntimeException e) {
					// In case of an unexpected exception you may want to abort
					// the HTTP request in order to shut down the underlying
					// connection immediately.
					httpRequest.abort();
					throw e;
				} finally {
					// Closing the input stream will trigger connection release
					try {
						instream.close();
					} catch (Exception e) {
						// Ignore
					}
				}
			}
		} catch (NamingException e) {
			// Lookup of destination failed
			String errorMessage = "Lookup of destination failed with reason: "
					+ e.getMessage()
					+ ". See "
					+ "logs for details. Hint: Make sure to have the destination "
					+ BACKEND_DEST + " configured.";
			LOGGER.error("Lookup of destination failed", e);
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
					errorMessage);
		} catch (Exception e) {
			// Connectivity operation failed
			String errorMessage = "Connectivity operation failed with reason: "
					+ e.getMessage() + ". See " + "logs for details.";
			LOGGER.error("Connectivity operation failed", e);
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
					errorMessage);
		} finally {
			// When HttpClient instance is no longer needed, shut down the
			// connection manager to ensure immediate
			// deallocation of all system resources
			if (httpClient != null) {
				httpClient.getConnectionManager().shutdown();
			}
		}
	}
}
