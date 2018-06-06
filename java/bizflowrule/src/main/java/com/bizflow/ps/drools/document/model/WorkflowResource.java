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

import org.codehaus.jackson.annotate.JsonProperty;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
@XmlAccessorType(XmlAccessType.FIELD)
public class WorkflowResource {

    public enum RESOURCE_TYPE {
        URL, FILE
    }

    private String resourceName;
    private RESOURCE_TYPE resourceType;
    private String resoruceURI;
    private String resourceDescription;
    private int dispOrder;

    public WorkflowResource() {
    }

    public WorkflowResource(String resourceName, RESOURCE_TYPE resourceType, String resoruceURI, String resourceDescription, int dispOrder) {
        this.resourceName = resourceName;
        this.resourceType = resourceType;
        this.resoruceURI = resoruceURI;
        this.resourceDescription = resourceDescription;
        this.dispOrder = dispOrder;
    }

    public String getResourceName() {
        return resourceName;
    }

    public void setResourceName(String resourceName) {
        this.resourceName = resourceName;
    }

    public RESOURCE_TYPE getResourceType() {
        return resourceType;
    }

    public void setResourceType(RESOURCE_TYPE resourceType) {
        this.resourceType = resourceType;
    }

    public String getResoruceURI() {
        return resoruceURI;
    }

    public void setResoruceURI(String resoruceURI) {
        this.resoruceURI = resoruceURI;
    }

    public String getResourceDescription() {
        return resourceDescription;
    }

    public void setResourceDescription(String resourceDescription) {
        this.resourceDescription = resourceDescription;
    }

    public int getDispOrder() {
        return dispOrder;
    }

    public void setDispOrder(int dispOrder) {
        this.dispOrder = dispOrder;
    }
}
