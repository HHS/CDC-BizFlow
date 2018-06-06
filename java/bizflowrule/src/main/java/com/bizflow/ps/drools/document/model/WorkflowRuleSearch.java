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

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;
import java.util.ArrayList;
import java.util.Objects;

@XmlRootElement
@XmlAccessorType(XmlAccessType.FIELD)
public class WorkflowRuleSearch {

    private String ruleName;
    private String tenantID;
    private String procName;
    private String actName;
    private String userName;
    private String formName;
    private ArrayList<WorkflowField> fields;

    public String getRuleName() {
        return ruleName;
    }

    public void setRuleName(String ruleName) {
        this.ruleName = ruleName;
    }

    public String getTenantID() {
        return tenantID;
    }

    public void setTenantID(String tenantID) {
        this.tenantID = tenantID;
    }

    public String getProcName() {
        return procName;
    }

    public void setProcName(String procName) {
        this.procName = procName;
    }

    public String getActName() {
        return actName;
    }

    public void setActName(String actName) {
        this.actName = actName;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getFormName() {
        return formName;
    }

    public void setFormName(String formName) {
        this.formName = formName;
    }

    public ArrayList<WorkflowField> getFields() {
        return fields;
    }

    public void setFields(ArrayList<WorkflowField> fields) {
        this.fields = fields;
    }

    public void addField(WorkflowField field) {
        this.fields.add(field);
    }

    @Override
    public String toString() {
        return "WorkflowRuleSearch{" +
                "ruleName='" + ruleName + '\'' +
                ", tenantID='" + tenantID + '\'' +
                ", procName='" + procName + '\'' +
                ", actName='" + actName + '\'' +
                ", userName='" + userName + '\'' +
                ", formName='" + formName + '\'' +
                ", fields=" + fields +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof WorkflowRuleSearch)) return false;
        WorkflowRuleSearch that = (WorkflowRuleSearch) o;
        return Objects.equals(ruleName, that.ruleName) &&
                Objects.equals(tenantID, that.tenantID) &&
                Objects.equals(procName, that.procName) &&
                Objects.equals(actName, that.actName) &&
                Objects.equals(userName, that.userName) &&
                Objects.equals(formName, that.formName) &&
                Objects.equals(fields, that.fields);
    }

    @Override
    public int hashCode() {

        return Objects.hash(ruleName, tenantID, procName, actName, userName, formName, fields);
    }
}
