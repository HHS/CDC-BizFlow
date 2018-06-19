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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;


public class WorkflowForm {

    private String formName;
    private HashMap<String, WorkflowField> fields = new HashMap<>();
    private List<WorkflowField> fieldList = new ArrayList<>();

    public String getFormName() {
        return formName;
    }

    public void setFormName(String formName) {
        this.formName = formName;
    }

    public HashMap<String, WorkflowField> getFields() {
        return fields;
    }

    public void setFields(HashMap<String, WorkflowField> fields) {
        this.fields = fields;
    }

    public WorkflowField getField(String fieldId) {
        return this.fields.get(fieldId);
    }

    public List<WorkflowField> getFieldList() {
        return fieldList;
    }

    public void setFieldList(List<WorkflowField> fieldList) {
        this.fieldList = fieldList;
    }

    public void addField(WorkflowField field) {
        this.fields.put(field.getFieldId(), field);
        this.fieldList.add(field);
    }

}
