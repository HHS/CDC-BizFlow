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

import java.util.Date;

public class WorkflowDocumentMetadata {

    private String metadataID;
    private String metadataName;
    private String metadataType;
    private String metadataValue;

    public WorkflowDocumentMetadata() {
    }

    public WorkflowDocumentMetadata(String metadataID, String metadataName, String metadataType, String metadataValue) {
        this.metadataID = metadataID;
        this.metadataName = metadataName;
        this.metadataType = metadataType;
        this.metadataValue = metadataValue;
    }

    public String getMetadataID() {
        return metadataID;
    }

    public void setMetadataID(String metadataID) {
        this.metadataID = metadataID;
    }

    public String getMetadataName() {
        return metadataName;
    }

    public void setMetadataName(String metadataName) {
        this.metadataName = metadataName;
    }

    public String getMetadataType() {
        return metadataType;
    }

    public void setMetadataType(String metadataType) {
        this.metadataType = metadataType;
    }

    public String getMetadataValue() {
        return metadataValue;
    }

    public void setMetadataValue(String metadataValue) {
        this.metadataValue = metadataValue;
    }

    @Override
    public String toString() {
        return "WorkflowDocumentMetadata : {" +
                " \"metadataID\" : \"" + metadataID + "\"" +
                ", \"metadataName\" : \"" + metadataName + "\"" +
                ", \"metadataType=\" : \"" + metadataType + "\"" +
                ", \"metadataValue\" : \"" + metadataValue + "\"" +
                '}';
    }
}
