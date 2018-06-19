/*
 * Copyright (C) BizFlow Corp - All Rights Reserved
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 *
 * Written by Tae Ho Lee <thlee@bizflow.com> <Taeho.BPM@gmail.com>, 3/2018
 *
 */

package com.bizflow.ps.drools.document.service;

import com.bizflow.ps.drools.document.config.DroolsBeanFactory;
import com.bizflow.ps.drools.document.model.*;
import org.kie.api.runtime.KieSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

public class WorkflowDocumentRuleService {

    private KieSession kieSession;

    private static final Logger log = LoggerFactory.getLogger(WorkflowDocumentRuleService.class);

    public List<WorkflowDocument> getDocumentList(WorkflowRuleSearch search, List<WorkflowDocument> workflowDocuments) {

        log.debug("search=" + search);
        kieSession = new DroolsBeanFactory().getKieSession(search.getRuleName() + ".drl");
        kieSession.insert(search);
        kieSession.insert(workflowDocuments);
        kieSession.fireAllRules();

        return workflowDocuments;
    }

}


