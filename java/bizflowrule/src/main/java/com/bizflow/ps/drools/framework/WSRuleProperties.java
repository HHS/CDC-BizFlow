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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class WSRuleProperties {

    private static final Logger log = LoggerFactory.getLogger(WSRuleProperties.class);

    private static WSRuleProperties instance = null;
    private static Properties prop = null;

    protected WSRuleProperties() {
        //exists only to defeat instantiation
    }

    public static WSRuleProperties getInstance() {
        if (null == instance) {
            instance = new WSRuleProperties();
            instance.prop = new Properties();
        }
        return instance;
    }

    public void load(String proprtiesFileName) throws IOException {
        log.debug("WSRuleProperties.load");
        if (prop == null)
            prop = new Properties();
        InputStream in = WSRuleProperties.class.getClassLoader().getResourceAsStream(proprtiesFileName);
        prop.load(in);
        in.close();
        log.debug("prop=" + prop.toString());
        /*
        WorkflowRuleSearch search = new WorkflowRuleSearch();
        search.setRuleName(prop.getProperty("rules.cdc.document.ruleName"));
        search.setTenantID(prop.getProperty("rules.cdc.document.tenantID"));
        search.setProcName(prop.getProperty("rules.cdc.document.processName"));
        search.setActName(prop.getProperty("rules.cdc.document.actName"));
        search.setUserName(prop.getProperty("rules.cdc.document.userName"));
        search.setFormName(prop.getProperty("rules.cdc.document.formName"));
        String fieldsString = prop.getProperty("rules.cdc.document.fields");

        String[] fields = fieldsString.split("|||");
        String[] fieldInfo;
        for (int i=0; i<fields.length; i++) {
            fieldInfo = fields[i].split("--->");
            search.addField(new WorkflowField(fieldInfo[0], fieldInfo[1]));
        }

        WorkflowDocumentRuleService workflowDocumentRuleService = new WorkflowDocumentRuleService();
        List<WorkflowDocument> docList = new ArrayList<>();
        workflowDocumentRuleService.getDocumentList(search, docList);

        log.debug("configured rules have been loaded. " + search);
        return Response.status(200).entity("{ \"Result\"} : \"Success\"").build();
        */
    }

    public Properties getProperties() {
        return this.prop;
    }

    public String getProperty(String propName) {
        String val = null;
        if (this.prop != null) {
            val = this.prop.getProperty(propName);
        }
        return val;
    }
}
