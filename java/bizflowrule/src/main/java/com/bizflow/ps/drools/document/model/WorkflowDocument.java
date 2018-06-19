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
import java.util.ArrayList;
import java.util.List;
//import java.util.function.Predicate;

@XmlRootElement
@XmlAccessorType(XmlAccessType.FIELD)
public class WorkflowDocument {
    private int active = 1;
    private int id;
    private String label;
    private String ltype = "DocumentType";
    private String name;
    private int parentId = 0;
    private int dispOrder;
    private boolean isRequired;
    private List<WorkflowDocumentMetadata> metadataList = new ArrayList<>();

    public WorkflowDocument() {

    }

    public WorkflowDocument(int id, String name, int dispOrder, boolean isRequired) {
        this.id = id;
        this.name = name;
        this.label = name;
        this.dispOrder = dispOrder;
        this.isRequired = isRequired;
    }

    public WorkflowDocument(int active, int id, String label, String ltype, String name, int parentId, int dispOrder, boolean isRequired) {
        this.active = active;
        this.id = id;
        this.label = label;
        this.ltype = ltype;
        this.name = name;
        this.parentId = parentId;
        this.dispOrder = dispOrder;
        this.isRequired = isRequired;
    }

    @JsonProperty("ACTIVE")
    public int getActive() {
        return active;
    }

    @JsonProperty("ACTIVE")
    public void setActive(int active) {
        this.active = active;
    }

    @JsonProperty("ID")
    public int getId() {
        return id;
    }

    @JsonProperty("ID")
    public void setId(int id) {
        this.id = id;
    }

    @JsonProperty("LABEL")
    public String getLabel() {
        return label;
    }

    @JsonProperty("LABEL")
    public void setLabel(String label) {
        this.label = label;
    }

    @JsonProperty("LTYPE")
    public String getLtype() {
        return ltype;
    }

    @JsonProperty("LTYPE")
    public void setLtype(String ltype) {
        this.ltype = ltype;
    }

    @JsonProperty("NAME")
    public String getName() {
        return name;
    }

    @JsonProperty("NAME")
    public void setName(String name) {
        this.name = name;
    }

    @JsonProperty("PARENTID")
    public int getParentId() {
        return parentId;
    }

    @JsonProperty("PARENTID")
    public void setParentId(int parentId) {
        this.parentId = parentId;
    }

    @JsonProperty("DISPORDER")
    public int getDispOrder() {
        return dispOrder;
    }

    @JsonProperty("DISPORDER")
    public void setDispOrder(int dispOrder) {
        this.dispOrder = dispOrder;
    }

    @JsonProperty("REQUIRED")
    public boolean isRequired() {
        return isRequired;
    }

    @JsonProperty("REQUIRED")
    public void setRequired(boolean required) {
        isRequired = required;
    }

    @JsonProperty("METADATALIST")
    public List<WorkflowDocumentMetadata> getMetadataList() {
        return metadataList;
    }

    @JsonProperty("METADATALIST")
    public void setMetadataList(List<WorkflowDocumentMetadata> metadataList) {
        this.metadataList = metadataList;
    }

    public void addMetadata(WorkflowDocumentMetadata metadata) {
        this.metadataList.add(metadata);
    }

    public void removeMetadata(String metadataID) {
        /*
        --Java 1.8
        Predicate<WorkflowDocumentMetadata> medadataPredicate = m ->  m.getMetadataID().equals(metadataID);
        this.metadataList.removeIf(medadataPredicate);
        this.metadataList.removeIf(medadataPredicate);
        */

        if (this.metadataList != null && this.metadataList.size() > 0) {
            for (int i = 0; i<this.metadataList.size(); i++) {
                if (metadataID.equals(this.metadataList.get(i).getMetadataID())) {
                    this.metadataList.remove(i);
                    break;
                }
            }
        }
    }

    @Override
    public String toString() {
        return "{ \n" +
                "\"ACTIVE\" : \"" + active + "\" \n" +
                ", \"DISPORDER\" : \"" + dispOrder + "\" \n"+
                ", \"LABEL\" : \"" + label + "\" \n" +
                ", \"LTYPE\" : \"" + ltype + "\" \n" +
                ", \"NAME\" : \"" + name + "\" \n" +
                ", \"PARENTID\" : \"" + parentId + "\" \n" +
                ", \"REQUIRED\" : \"" + isRequired + "\" \n" +
                " } ";
    }

}
