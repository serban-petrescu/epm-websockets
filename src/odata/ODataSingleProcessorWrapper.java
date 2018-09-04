package odata;

import java.io.InputStream;
import java.util.List;

import org.apache.olingo.odata2.api.batch.BatchHandler;
import org.apache.olingo.odata2.api.batch.BatchResponsePart;
import org.apache.olingo.odata2.api.exception.ODataException;
import org.apache.olingo.odata2.api.processor.ODataContext;
import org.apache.olingo.odata2.api.processor.ODataProcessor;
import org.apache.olingo.odata2.api.processor.ODataRequest;
import org.apache.olingo.odata2.api.processor.ODataResponse;
import org.apache.olingo.odata2.api.processor.ODataSingleProcessor;
import org.apache.olingo.odata2.api.uri.info.DeleteUriInfo;
import org.apache.olingo.odata2.api.uri.info.GetComplexPropertyUriInfo;
import org.apache.olingo.odata2.api.uri.info.GetEntityCountUriInfo;
import org.apache.olingo.odata2.api.uri.info.GetEntityLinkCountUriInfo;
import org.apache.olingo.odata2.api.uri.info.GetEntityLinkUriInfo;
import org.apache.olingo.odata2.api.uri.info.GetEntitySetCountUriInfo;
import org.apache.olingo.odata2.api.uri.info.GetEntitySetLinksCountUriInfo;
import org.apache.olingo.odata2.api.uri.info.GetEntitySetLinksUriInfo;
import org.apache.olingo.odata2.api.uri.info.GetEntitySetUriInfo;
import org.apache.olingo.odata2.api.uri.info.GetEntityUriInfo;
import org.apache.olingo.odata2.api.uri.info.GetFunctionImportUriInfo;
import org.apache.olingo.odata2.api.uri.info.GetMediaResourceUriInfo;
import org.apache.olingo.odata2.api.uri.info.GetMetadataUriInfo;
import org.apache.olingo.odata2.api.uri.info.GetServiceDocumentUriInfo;
import org.apache.olingo.odata2.api.uri.info.GetSimplePropertyUriInfo;
import org.apache.olingo.odata2.api.uri.info.PostUriInfo;
import org.apache.olingo.odata2.api.uri.info.PutMergePatchUriInfo;

import ws.Endpoint;

public class ODataSingleProcessorWrapper extends ODataSingleProcessor {

	private ODataSingleProcessor delegate;

	public ODataSingleProcessorWrapper(ODataSingleProcessor delegate) {
		this.delegate = delegate;
	}

	@Override
	public void setContext(ODataContext context) {
		delegate.setContext(context);
	}

	@Override
	public ODataContext getContext() {
		return delegate.getContext();
	}

	@Override
	public ODataResponse executeBatch(BatchHandler handler, String contentType,
			InputStream content) throws ODataException {
		return onChange(delegate.executeBatch(handler, contentType, content));
	}

	@Override
	public BatchResponsePart executeChangeSet(BatchHandler handler,
			List<ODataRequest> requests) throws ODataException {
		return onChange(delegate.executeChangeSet(handler, requests));
	}

	@Override
	public ODataResponse executeFunctionImport(
			GetFunctionImportUriInfo uriInfo, String contentType)
			throws ODataException {
		return delegate.executeFunctionImport(uriInfo, contentType);
	}

	@Override
	public ODataResponse executeFunctionImportValue(
			GetFunctionImportUriInfo uriInfo, String contentType)
			throws ODataException {
		return delegate.executeFunctionImportValue(uriInfo, contentType);
	}

	@Override
	public ODataResponse readEntitySimplePropertyValue(
			GetSimplePropertyUriInfo uriInfo, String contentType)
			throws ODataException {
		return delegate.readEntitySimplePropertyValue(uriInfo, contentType);
	}

	@Override
	public ODataResponse updateEntitySimplePropertyValue(
			PutMergePatchUriInfo uriInfo, InputStream content,
			String requestContentType, String contentType)
			throws ODataException {
		return onChange(delegate.updateEntitySimplePropertyValue(uriInfo, content,
				requestContentType, contentType));
	}

	@Override
	public ODataResponse deleteEntitySimplePropertyValue(DeleteUriInfo uriInfo,
			String contentType) throws ODataException {
		return onChange(delegate.deleteEntitySimplePropertyValue(uriInfo, contentType));
	}

	@Override
	public ODataResponse readEntitySimpleProperty(
			GetSimplePropertyUriInfo uriInfo, String contentType)
			throws ODataException {
		return delegate.readEntitySimpleProperty(uriInfo, contentType);
	}

	@Override
	public ODataResponse updateEntitySimpleProperty(
			PutMergePatchUriInfo uriInfo, InputStream content,
			String requestContentType, String contentType)
			throws ODataException {
		return onChange(delegate.updateEntitySimpleProperty(uriInfo, content,
				requestContentType, contentType));
	}

	@Override
	public ODataResponse readEntityMedia(GetMediaResourceUriInfo uriInfo,
			String contentType) throws ODataException {
		return delegate.readEntityMedia(uriInfo, contentType);
	}

	@Override
	public ODataResponse updateEntityMedia(PutMergePatchUriInfo uriInfo,
			InputStream content, String requestContentType, String contentType)
			throws ODataException {
		return onChange(delegate.updateEntityMedia(uriInfo, content, requestContentType,
				contentType));
	}

	@Override
	public ODataResponse deleteEntityMedia(DeleteUriInfo uriInfo,
			String contentType) throws ODataException {
		return onChange(delegate.deleteEntityMedia(uriInfo, contentType));
	}

	@Override
	public ODataResponse readEntityLinks(GetEntitySetLinksUriInfo uriInfo,
			String contentType) throws ODataException {
		return delegate.readEntityLinks(uriInfo, contentType);
	}

	@Override
	public ODataResponse countEntityLinks(
			GetEntitySetLinksCountUriInfo uriInfo, String contentType)
			throws ODataException {
		return delegate.countEntityLinks(uriInfo, contentType);
	}

	@Override
	public ODataResponse createEntityLink(PostUriInfo uriInfo,
			InputStream content, String requestContentType, String contentType)
			throws ODataException {
		return onChange(delegate.createEntityLink(uriInfo, content, requestContentType,
				contentType));
	}

	@Override
	public ODataResponse readEntityLink(GetEntityLinkUriInfo uriInfo,
			String contentType) throws ODataException {
		return delegate.readEntityLink(uriInfo, contentType);
	}

	@Override
	public ODataResponse existsEntityLink(GetEntityLinkCountUriInfo uriInfo,
			String contentType) throws ODataException {
		return delegate.existsEntityLink(uriInfo, contentType);
	}

	@Override
	public ODataResponse updateEntityLink(PutMergePatchUriInfo uriInfo,
			InputStream content, String requestContentType, String contentType)
			throws ODataException {
		return onChange(delegate.updateEntityLink(uriInfo, content, requestContentType,
				contentType));
	}

	@Override
	public ODataResponse deleteEntityLink(DeleteUriInfo uriInfo,
			String contentType) throws ODataException {
		return onChange(delegate.deleteEntityLink(uriInfo, contentType));
	}

	@Override
	public ODataResponse readEntityComplexProperty(
			GetComplexPropertyUriInfo uriInfo, String contentType)
			throws ODataException {
		return delegate.readEntityComplexProperty(uriInfo, contentType);
	}

	@Override
	public ODataResponse updateEntityComplexProperty(
			PutMergePatchUriInfo uriInfo, InputStream content,
			String requestContentType, boolean merge, String contentType)
			throws ODataException {
		return onChange(delegate.updateEntityComplexProperty(uriInfo, content,
				requestContentType, merge, contentType));
	}

	@Override
	public ODataResponse readEntitySet(GetEntitySetUriInfo uriInfo,
			String contentType) throws ODataException {
		return delegate.readEntitySet(uriInfo, contentType);
	}

	@Override
	public ODataResponse countEntitySet(GetEntitySetCountUriInfo uriInfo,
			String contentType) throws ODataException {
		return delegate.countEntitySet(uriInfo, contentType);
	}

	@Override
	public ODataResponse createEntity(PostUriInfo uriInfo, InputStream content,
			String requestContentType, String contentType)
			throws ODataException {
		return onChange(delegate.createEntity(uriInfo, content, requestContentType,
				contentType));
	}

	@Override
	public ODataResponse readEntity(GetEntityUriInfo uriInfo, String contentType)
			throws ODataException {
		return delegate.readEntity(uriInfo, contentType);
	}

	@Override
	public ODataResponse existsEntity(GetEntityCountUriInfo uriInfo,
			String contentType) throws ODataException {
		return delegate.existsEntity(uriInfo, contentType);
	}

	@Override
	public ODataResponse updateEntity(PutMergePatchUriInfo uriInfo,
			InputStream content, String requestContentType, boolean merge,
			String contentType) throws ODataException {
		return onChange(delegate.updateEntity(uriInfo, content, requestContentType,
				merge, contentType));
	}

	@Override
	public ODataResponse deleteEntity(DeleteUriInfo uriInfo, String contentType)
			throws ODataException {
		return onChange(delegate.deleteEntity(uriInfo, contentType));
	}

	@Override
	public ODataResponse readServiceDocument(GetServiceDocumentUriInfo uriInfo,
			String contentType) throws ODataException {
		return delegate.readServiceDocument(uriInfo, contentType);
	}

	@Override
	public ODataResponse readMetadata(GetMetadataUriInfo uriInfo,
			String contentType) throws ODataException {
		return delegate.readMetadata(uriInfo, contentType);
	}

	@Override
	public List<String> getCustomContentTypes(
			Class<? extends ODataProcessor> processorFeature)
			throws ODataException {
		return delegate.getCustomContentTypes(processorFeature);
	}

	private<T> T onChange(T t) {
		Endpoint.sendRefresh();
		return t;
	}

}
