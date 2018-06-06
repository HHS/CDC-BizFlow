
/*
 * Copyright (C) BizFlow Corp - All Rights Reserved
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 *
 * Written by Tae Ho Lee <thlee@bizflow.com> <Taeho.BPM@gmail.com>, 3/2018
 *
 */

package com.bizflow.ps.drools.webservice;

import com.bizflow.ps.drools.document.model.*;
import com.bizflow.ps.drools.document.service.WorkflowDocumentRuleService;
import com.bizflow.ps.drools.framework.WSRuleProperties;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.*;


@Path("/rule/document")
public class WorkflowDocumentRuleWS {

    private static final Logger log = LoggerFactory.getLogger(WorkflowDocumentRuleWS.class);

    private WorkflowDocumentRuleService workflowDocumentService = new WorkflowDocumentRuleService();
    private static HashMap<String, List<WorkflowDocument>> ruleMap = new HashMap<>();
    private static HashMap<String, Date> ruleMapTimeGenerated = new HashMap<>();
    private static String RULE_GENERATED_TIME = "-RULE-GENERATED-TIME";
    private WSRuleProperties wsRuleProperties;

    private List<WorkflowDocument> getProcessDocumentList(WorkflowRuleSearch search) throws Exception {
        log.debug("search=" + search);
        List<WorkflowDocument> workflowDocuments = new ArrayList<>();
        List<WorkflowDocument> docList = workflowDocumentService.getDocumentList(search, workflowDocuments);
        return docList;
    }

    private static int minutesAgo(Date datetime) {
        long differenceInMinutes;
        try {
            Date dtCurrent = new Date();
            long differenceInMillis =  dtCurrent.getTime() - datetime.getTime(); //now.getTimeInMillis() - date.getTimeInMillis();
            differenceInMinutes = (differenceInMillis) / 1000L / 60L; // / 60L; // Divide by millis/sec, secs/min, mins/hr
        } catch (Exception e) {
            differenceInMinutes = 0;
        }
        return (int)differenceInMinutes;
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("flushRuleCache")
    public Response flushDocumentRuleCache(WorkflowRuleSearch search) throws Exception {
        log.debug("flushing a document rule cache. search=" + search);
        ruleMap.remove(search.toString());
        ruleMapTimeGenerated.remove(search.toString() + RULE_GENERATED_TIME);
        return Response.status(200).entity("{ \"Result\" : \"Rule Cache has been flushed successfully.\"").build();
    }

    @POST
    @Produces(MediaType.APPLICATION_JSON)
    @Path("flushRuleAllCaches")
    public Response flushDocumentRuleAllCaches() throws Exception {
        log.debug("flushing all document rule caches");
        ruleMap.clear();
        ruleMapTimeGenerated.clear();;
        return Response.status(200).entity("{ \"Result\" : \"Rule Caches have been flushed successfully.\" }").build();
    }

    private List<WorkflowDocument> getDocumentList(WorkflowRuleSearch search) throws Exception {
        log.debug("getDocumentList="+ search);
        List<WorkflowDocument> docList = ruleMap.get(search.toString());
        Date dtRuleGenerated = ruleMapTimeGenerated.get(search.toString() + RULE_GENERATED_TIME);
        int minAged = minutesAgo(dtRuleGenerated);
        int holdingInMins = 60; //default 60 minutes
        wsRuleProperties = WSRuleProperties.getInstance();
        String holdingInMinsStr = wsRuleProperties.getProperty("rule.holding.cache.in.minutes." + this.getClass().getSimpleName());
        if (holdingInMinsStr != null) {
            holdingInMins = Integer.parseInt(holdingInMinsStr);
        }
        log.debug("rule.holding.cache.in.minutes." + this.getClass().getSimpleName() + "=" + Integer.toString(holdingInMins));
        if ((minAged < holdingInMins) && (docList != null && docList.size() > 0)) {
            log.debug("found it from cache aged " + Long.toString(minAged) + " minutes!");
        } else {
            log.debug("get document list from rule engine");
            docList = getProcessDocumentList(search);
            log.debug("Number of documents found with the rule = " + docList.size());
            ruleMap.put(search.toString(), docList);
            ruleMapTimeGenerated.put(search.toString() + RULE_GENERATED_TIME, new Date());
        }
        return docList;
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("getDocumentList.json")
    public List<WorkflowDocument> getDocumentListInAFormJSON(WorkflowRuleSearch search) throws Exception {
        log.debug("getDocumentListInAFormJSON="+ search);
        return getDocumentList(search);
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_XML)
    @Path("getDocumentList.xml")
    public List<WorkflowDocument> getDocumentListInAFormXML(WorkflowRuleSearch search) throws Exception {
        log.debug("getDocumentListInAFormJSON="+ search);
        return getDocumentList(search);
    }

    //Return JSON to a URL request thru Get method
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("getDocumentList.json/{ruleName}/{tenantID}/{procName}/{actName}/{formName}/{userName}")
    public List<WorkflowDocument> getProcessDocuments(@PathParam("ruleName") String ruleName
                                                , @PathParam("tenantID") String tenantID
                                                , @PathParam("procName") String procName
                                                , @PathParam("actName") String actName
                                                , @PathParam("userName") String userName
                                                , @PathParam("formName") String formName
                                                , @QueryParam("fname") final List<String> fieldNames
                                                , @QueryParam("fvalue") final List<String> fieldValues) {


        WorkflowRuleSearch search = new WorkflowRuleSearch();
        search.setRuleName(ruleName);
        search.setTenantID(tenantID);
        search.setProcName(procName);
        search.setActName(actName);
        search.setUserName(userName);

        WorkflowField field = null;
        String fieldValue = null;
        String fieldName = null;
        for (int i=0; i<fieldNames.size(); i++) {
            fieldName = fieldNames.get(i);
            if (i < fieldNames.size()) {
                fieldValue = fieldValues.get(i);
            } else {
                fieldValue = "";
            }
            field = new WorkflowField();
            field.setFieldId(fieldName);
            field.setFieldValue(fieldValue);
            search.addField(field);
        }

        List<WorkflowDocument> workflowDocuments = new ArrayList<>();
        List<WorkflowDocument> docList = workflowDocumentService.getDocumentList(search, workflowDocuments);

        return docList;
    }

    //Return XML to a URL request thru Get method
    @GET
    @Produces(MediaType.APPLICATION_XML)
    @Path("getDocumentList.xml/{ruleName}/{tenantID}/{procName}/{actName}/{formName}/{userName}")
    public List<WorkflowDocument> getProcessDocumentsXML(@PathParam("ruleName") String ruleName
            , @PathParam("tenantID") String tenantID
            , @PathParam("procName") String procName
            , @PathParam("actName") String actName
            , @PathParam("userName") String userName
            , @PathParam("formName") String formName
            , @QueryParam("fname") final List<String> fieldNames
            , @QueryParam("fvalue") final List<String> fieldValues) throws Exception {

        WorkflowRuleSearch search = new WorkflowRuleSearch();
        search.setRuleName(ruleName);
        search.setTenantID(tenantID);
        search.setProcName(procName);
        search.setActName(actName);
        search.setUserName(userName);

        WorkflowField field = null;
        String fieldValue = null;
        String fieldName = null;
        for (int i=0; i<fieldNames.size(); i++) {
            fieldName = fieldNames.get(i);
            if (i < fieldNames.size()) {
                fieldValue = fieldValues.get(i);
            } else {
                fieldValue = "";
            }
            field = new WorkflowField();
            field.setFieldId(fieldName);
            field.setFieldValue(fieldValue);
            search.addField(field);
        }

        List<WorkflowDocument> workflowDocuments = new ArrayList<>();
        List<WorkflowDocument> docList = workflowDocumentService.getDocumentList(search, workflowDocuments);

        return docList;
    }





}
