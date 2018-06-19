/*
 * Copyright (C) BizFlow Corp - All Rights Reserved
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 *
 * Written by Tae Ho Lee <thlee@bizflow.com> <Taeho.BPM@gmail.com>, 3/2018
 *
 */

package com.bizflow.ps.drools.framework;

import com.bizflow.ps.drools.webservice.WorkflowDocumentRuleWS;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;


public class WSRuleLoader extends HttpServlet {

    private static final Logger log = LoggerFactory.getLogger(WorkflowDocumentRuleWS.class);

    private static String DEFAULT_RULE_FILE_NAME = "WEB-INF/bizflowrule.properties";
    private static String PARAM_RULE_PROPERTY_FILENAME = "rule.property.filename";

    private WSRuleProperties wsRuleProperties = null;
    private String ruleFileName;

    public WSRuleLoader() throws IOException {
        super();
        log.debug("WSRuleLoader !!!!!!!!!!");
    }

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        try {
            log.debug("Initializing WSRuleLoader...");
            ruleFileName = config.getInitParameter(PARAM_RULE_PROPERTY_FILENAME);
            wsRuleProperties = WSRuleProperties.getInstance();
            log.debug("Initializing WSRuleLoader file=" + ruleFileName);
            this.loadProperties(ruleFileName);
            log.debug("WSRuleLoader has been initialized.");
        } catch (Exception e) {
            e.printStackTrace();
            log.debug("WSRuleLoader has failed to initialize. reason=" + e.getMessage());
        }

    }

    public String getRuleFileName() {
        return ruleFileName;
    }

    public void setRuleFileName(String ruleFileName) {
        this.ruleFileName = ruleFileName;
    }

    private void loadProperties(String fileName) throws IOException {
        log.debug("Initializing WSRuleLoader...");
        wsRuleProperties.load(fileName);
        log.debug("Initializing WSRuleLoader size=" + wsRuleProperties.getProperties().size());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        log.debug("WSRuleLoader.doGet received a request");
        resp.setStatus(200);
        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();
        StringBuffer sb = new StringBuffer();

        String paramPrint = req.getParameter("print");
        if ("yes".equals(paramPrint)) {
            sb.append(wsRuleProperties.getProperties().toString());
        } else {
            sb.append("{ \"BizFlowRuleService\" : \"");
            if (ruleFileName == null) {
                sb.append(" Failed to initialize with properties file. Please ask system administrator to check rule.property.filename init-param in the web.xml file.\" }");
            } else if (wsRuleProperties.getProperties() == null) {
                sb.append(" Failed to initialize with " + ruleFileName + " properties file.\" }");
            } else if (wsRuleProperties.getProperties().size() > 0) {
                sb.append(" There is no property defined in " + ruleFileName + " properties file.\" }");
            } else {
                sb.append(ruleFileName);
                sb.append(" configuration file has been successfully loaded\" }");
            }
        }
        log.debug(sb.toString());
        out.print(sb.toString());
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        log.debug("WSRuleLoader.doPost received a request");
        resp.setStatus(200);
        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();
        StringBuffer sb = new StringBuffer();

        String paramPrint = req.getParameter("print");
        if ("yes".equals(paramPrint)) {
            sb.append(wsRuleProperties.getProperties().toString());
        } else {
            sb.append("{ \"BizFlowRuleService\" : \"");
            if (ruleFileName == null) {
                sb.append(" Failed to initialize with properties file. Please ask system administrator to check rule.property.filename init-param in the web.xml file.\" }");
            } else if (wsRuleProperties.getProperties() == null) {
                sb.append(" Failed to initialize with " + ruleFileName + " properties file.\" }");
            } else if (wsRuleProperties.getProperties().size() > 0) {
                sb.append(" There is no property defined in " + ruleFileName + " properties file.\" }");
            } else {
                sb.append(ruleFileName);
                sb.append(" configuration file has been successfully loaded\" }");
            }
        }
        log.debug(sb.toString());
        out.print(sb.toString());
    }
}
