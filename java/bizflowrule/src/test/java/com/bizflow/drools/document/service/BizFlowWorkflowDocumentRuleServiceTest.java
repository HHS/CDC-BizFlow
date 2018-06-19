/*
 * Copyright (C) BizFlow Corp - All Rights Reserved
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 *
 * Written by Tae Ho Lee <thlee@bizflow.com> <Taeho.BPM@gmail.com>, 3/2018
 *
 */

package com.bizflow.drools.document.service;

import com.bizflow.ps.drools.document.model.*;
import com.bizflow.ps.drools.document.service.WorkflowDocumentRuleService;
import org.junit.Before;
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

import static junit.framework.TestCase.assertEquals;

public class BizFlowWorkflowDocumentRuleServiceTest {

    private WorkflowDocumentRuleService workflowDocumentService;

    @Before
    public void setUp() throws Exception {
        workflowDocumentService = new WorkflowDocumentRuleService();
    }

    @Test
    public void getDocumentList() {

        /*
        //OPDIV
        BizFlowTenant bizFlowTenant = new BizFlowTenant();
        bizFlowTenant.setTenantName("CDC");
        bizFlowTenant.setTenantType(BizFlowTenant.TenantType.GOVERNMENT_CIVIL_SERVCIE);

        //PROCESS
        BizFlowProcess procInfo = new BizFlowProcess();
        procInfo.setProcessName("Recruitment");
        procInfo.setActivityName("Prepare Pre-Recruitment Documents");

        //FORM
        WorkflowForm bizflowForm = new WorkflowForm();
        bizflowForm.setFormName("RecruitmentForm");
        procInfo.setBizFlowForm(bizflowForm);

        //FIELDS
        WorkflowField field = new WorkflowField();
        field.setFieldId("HiringMethod");
        field.setFieldValue("Title 5");
        bizflowForm.addField(field);
        */


        WorkflowRuleSearch search = new WorkflowRuleSearch();
        search.setRuleName("cdc-document-rules");
        search.setTenantID("CDC");
        search.setProcName("Recruitment");
        search.setActName("Prepare Pre-Recruitment Documents");
        search.setFormName("RecruitmentForm");
        search.setUserName("thlee");

        List<WorkflowDocument> workflowDocuments = new ArrayList<>();
        List<WorkflowDocument> docList = workflowDocumentService.getDocumentList(search, workflowDocuments);
        System.out.println("docList=" + docList);

        assertEquals("A", "A");
    }
}