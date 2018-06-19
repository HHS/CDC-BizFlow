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

import com.bizflow.ps.drools.document.model.WorkflowRuleSearch;
import com.bizflow.ps.drools.document.model.WorkflowResource;
import com.bizflow.ps.drools.document.service.WorkflowResourceRuleService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Path("/rule/resource")
public class WorkflowResourceRuleWS {

    private static final Logger log = LoggerFactory.getLogger(WorkflowResourceRuleWS.class);

    private WorkflowResourceRuleService workflowResourceRuleService = new WorkflowResourceRuleService();
    private static HashMap<String, List<WorkflowResource>> ruleMap = new HashMap<>();

    private List<WorkflowResource> getProcessResourceList(WorkflowRuleSearch search) throws Exception {
        log.debug("search=" + search);
        List<WorkflowResource> workflowResources = new ArrayList<>();
        List<WorkflowResource> resourceList = workflowResourceRuleService.getResourceList(search, workflowResources);
        return resourceList;
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("flushRuleCache")
    public Response flushResourceRuleCache(WorkflowRuleSearch search) throws Exception {
        log.debug("flushing a resource rule cache. search=" + search);
        ruleMap.remove(search.toString());
        return Response.status(200).entity("{ \"Result\"} : \"Success\"").build();
    }

    @POST
    @Produces(MediaType.APPLICATION_JSON)
    @Path("flushRuleAllCaches")
    public Response flushResourceAllRuleCaches() throws Exception {
        log.debug("flushing all resource rule caches");
        ruleMap.clear();
        return Response.status(200).entity("{ \"Result\"} : \"Success\"").build();
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("getResourceList.json")
    public List<WorkflowResource> getResourceListJSON(WorkflowRuleSearch search) throws Exception {
        log.debug("search="+ search);
        List<WorkflowResource> resourceList = ruleMap.get(search.toString());
        if (resourceList != null && resourceList.size() > 0) {
            log.debug("found it from cache!");
        } else {
            resourceList = getProcessResourceList(search);
            ruleMap.put(search.toString(), resourceList);
        }
        return resourceList;
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_XML)
    @Path("getResourceList.xml")
    public List<WorkflowResource> getResourceListXML(WorkflowRuleSearch search) throws Exception {
        log.debug("search="+ search);
        List<WorkflowResource> resourceList = ruleMap.get(search.toString());
        if (resourceList != null && resourceList.size() > 0) {
            log.debug("found it from cache!");
        } else {
            resourceList = getProcessResourceList(search);
            ruleMap.put(search.toString(), resourceList);
        }
        return resourceList;
    }
}
