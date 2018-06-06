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

public class WorkflowField {

    public enum FieldType {
        STRING, NUMBER, DATE
    };

    private String fieldId;
    private String fieldName;
    private FieldType fieldType = FieldType.STRING;
    private String fieldValue;
    private boolean fieldEnabled = true;
    private boolean fieldRequired = false;

    public WorkflowField() {
    }

    public WorkflowField(String fieldId, String fieldValue) {
        this.fieldId = fieldId;
        this.fieldValue = fieldValue;
    }

    public WorkflowField(String fieldId, String fieldValue, boolean fieldRequired) {
        this.fieldId = fieldId;
        this.fieldValue = fieldValue;
        this.fieldRequired = fieldRequired;
    }

    public String getFieldId() {
        return fieldId;
    }

    public void setFieldId(String fieldId) {
        this.fieldId = fieldId;
    }

    public String getFieldName() {
        return fieldName;
    }

    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }

    public FieldType getFieldType() {
        return fieldType;
    }

    public void setFieldType(FieldType fieldType) {
        this.fieldType = fieldType;
    }

    public String getFieldValue() {
        return fieldValue;
    }

    public void setFieldValue(String fieldValue) {
        this.fieldValue = fieldValue;
    }

    public boolean isFieldEnabled() {
        return fieldEnabled;
    }

    public void setFieldEnabled(boolean fieldEnabled) {
        this.fieldEnabled = fieldEnabled;
    }

    public boolean isFieldRequired() {
        return fieldRequired;
    }

    public void setFieldRequired(boolean fieldRequired) {
        this.fieldRequired = fieldRequired;
    }

    @Override
    public String toString() {
        return "WorkflowField{" +
                "fieldId='" + fieldId + '\'' +
                ", fieldName='" + fieldName + '\'' +
                ", fieldType=" + fieldType +
                ", fieldValue='" + fieldValue + '\'' +
                ", fieldEnabled=" + fieldEnabled +
                ", fieldRequired=" + fieldRequired +
                '}';
    }
}
