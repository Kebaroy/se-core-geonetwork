package org.fao.geonet.services;

import jeeves.exceptions.ServiceNotAllowedEx;
import jeeves.server.ServiceConfig;
import jeeves.server.context.ServiceContext;
import org.fao.geonet.util.CSRFUtil;
import org.jdom.Element;

/**
 * Base jeeves service class for services that require CSRF (Cross Site Request Forgery) tokens.
 *
 * @author Jose García
 */
public abstract class BaseSecureService extends MailSendingService {

    public abstract void init(String appPath, ServiceConfig params) throws Exception;

    /** Services that require CSRF tokens must implement doExec instead of exec **/
    protected abstract Element doExec(Element params, ServiceContext context) throws Exception;

    /**
     * Checks the CSRF token, throwing an exception if it's not valid.
     * If it's valid call specific service implementation.
     *
     * @param params
     * @param context
     * @return
     * @throws jeeves.exceptions.ServiceNotAllowedEx
     */
    public final Element exec(Element params, ServiceContext context) throws Exception {
        if (!CSRFUtil.isValidToken(params, context)) {
            throw new ServiceNotAllowedEx("Service not allowed. CSRF Token is not valid");
        }

        return doExec(params, context);
    }

}