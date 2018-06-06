/*
 * Copyright (C) BizFlow Corp - All Rights Reserved
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 *
 * Written by Tae Ho Lee <thlee@bizflow.com> <Taeho.BPM@gmail.com>, 3/2018
 *
 */

package com.bizflow.ps.drools.document.model;

import org.junit.Before;
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.*;

public class WorkflowDocumentTest {

    private WorkflowDocument workflowDocument;
    private List<WorkflowDocumentMetadata> workflowDocumentMetadataList;

    @Before
    public void setUp() throws Exception {
        workflowDocument = new WorkflowDocument();
        workflowDocument.setActive(1);
        workflowDocument.setDispOrder(999);
        workflowDocument.setId(100);
        workflowDocument.setLabel("My Document Label");
        workflowDocument.setName("My Document Name");
        workflowDocument.setParentId(0);
        workflowDocument.setRequired(true);
        workflowDocument.setLtype("DOCUMENTTYPE");
        workflowDocumentMetadataList = new ArrayList<>();
        workflowDocumentMetadataList.add(new WorkflowDocumentMetadata("userid", "User ID", "STRING", "THLEE"));
        workflowDocumentMetadataList.add(new WorkflowDocumentMetadata("username", "User Name", "STRING", "Tae Ho Lee"));
        workflowDocument.setMetadataList(workflowDocumentMetadataList);
    }

    @Test
    public void getMetadataList() {
        assertEquals(2, workflowDocument.getMetadataList().size());
    }

    @Test
    public void setMetadataList() {
        WorkflowDocument bfDocument = new WorkflowDocument();
        List<WorkflowDocumentMetadata> bfmList = new ArrayList<>();
        bfmList.add(new WorkflowDocumentMetadata("userid", "User ID", "STRING", "THLEE"));
        bfmList.add(new WorkflowDocumentMetadata("username", "User Name", "STRING", "Tae Ho Lee"));
        bfmList.add(new WorkflowDocumentMetadata("gender", "Gender", "STRING", "Male"));
        bfDocument.setMetadataList(bfmList);
        assertEquals(3, bfDocument.getMetadataList().size());
        assertEquals("Male", bfDocument.getMetadataList().get(2).getMetadataValue());
    }

    @Test
    public void addMetadata() {
        WorkflowDocument bfDocument = new WorkflowDocument();
        bfDocument.addMetadata(new WorkflowDocumentMetadata("userid", "User ID", "STRING", "THLEE"));
        bfDocument.addMetadata(new WorkflowDocumentMetadata("username", "User Name", "STRING", "Tae Ho Lee"));
        bfDocument.addMetadata(new WorkflowDocumentMetadata("gender", "Gender", "STRING", "Male"));
        bfDocument.addMetadata(new WorkflowDocumentMetadata("dob", "Date of Birth", "DATE", "01/01/2000"));
        assertEquals(4, bfDocument.getMetadataList().size());
        assertEquals("01/01/2000", bfDocument.getMetadataList().get(3).getMetadataValue());
    }

    @Test
    public void removeMetadata() {
        WorkflowDocument bfDocument = new WorkflowDocument();
        bfDocument.addMetadata(new WorkflowDocumentMetadata("userid", "User ID", "STRING", "THLEE"));
        bfDocument.addMetadata(new WorkflowDocumentMetadata("username", "User Name", "STRING", "Tae Ho Lee"));
        bfDocument.addMetadata(new WorkflowDocumentMetadata("gender", "Gender", "STRING", "Male"));
        bfDocument.addMetadata(new WorkflowDocumentMetadata("dob", "Date of Birth", "DATE", "01/01/2000"));
        bfDocument.removeMetadata("dob");
        assertEquals(3, bfDocument.getMetadataList().size());
    }

    @Test
    public void getActive() {
        assertEquals(1, workflowDocument.getActive());
    }

    @Test
    public void setActive() {
        WorkflowDocument bfDocument = new WorkflowDocument();
        bfDocument.setActive(1);
        assertEquals(1, bfDocument.getActive());
    }

    @Test
    public void getId() {
        assertEquals(100, workflowDocument.getId());
    }

    @Test
    public void setId() {
        WorkflowDocument bfDocument = new WorkflowDocument();
        bfDocument.setId(200);
        assertEquals(200, bfDocument.getId());
    }

    @Test
    public void getLabel() {
        assertEquals("My Document Label", workflowDocument.getLabel());
    }

    @Test
    public void setLabel() {
        WorkflowDocument bfDocument = new WorkflowDocument();
        bfDocument.setLabel("My Label");
        assertEquals("My Label", bfDocument.getLabel());
    }

    @Test
    public void getLtype() {
        assertEquals("DOCUMENTTYPE", workflowDocument.getLtype());
    }

    @Test
    public void setLtype() {
        WorkflowDocument bfDocument = new WorkflowDocument();
        bfDocument.setLtype("NETDOCTYPE");
        assertEquals("NETDOCTYPE", bfDocument.getLtype());
    }

    @Test
    public void getName() {
        assertEquals("My Document Name", workflowDocument.getName());
    }

    @Test
    public void setName() {
        WorkflowDocument bfDocument = new WorkflowDocument();
        bfDocument.setName("NEWDOCNAME");
        assertEquals("NEWDOCNAME", bfDocument.getName());
    }

    @Test
    public void getParentId() {
        assertEquals(0, workflowDocument.getParentId());
    }

    @Test
    public void setParentId() {
        WorkflowDocument bfDocument = new WorkflowDocument();
        bfDocument.setParentId(2000);
        assertEquals(2000, bfDocument.getParentId());
    }

    @Test
    public void getDispOrder() {
        assertEquals(999, workflowDocument.getDispOrder());
    }

    @Test
    public void setDispOrder() {
        WorkflowDocument bfDocument = new WorkflowDocument();
        bfDocument.setDispOrder(12345);
        assertEquals(12345, bfDocument.getDispOrder());
    }

    @Test
    public void isRequired() {
        assertEquals(true, workflowDocument.isRequired());
    }

    @Test
    public void setRequired() {
        WorkflowDocument bfDocument = new WorkflowDocument();
        bfDocument.setRequired(false);
        assertEquals(false, bfDocument.isRequired());
    }
}