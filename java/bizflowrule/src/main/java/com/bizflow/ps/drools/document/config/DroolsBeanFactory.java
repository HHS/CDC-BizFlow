/*
 * Copyright (C) BizFlow Corp - All Rights Reserved
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 *
 * Written by Tae Ho Lee <thlee@bizflow.com> <Taeho.BPM@gmail.com>, 3/2018
 *
 */

package com.bizflow.ps.drools.document.config;

import org.kie.api.KieServices;
import org.kie.api.builder.*;
import org.kie.api.io.Resource;
import org.kie.api.runtime.KieContainer;
import org.kie.api.runtime.KieSession;
import org.kie.internal.io.ResourceFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

public class DroolsBeanFactory {

    private static final Logger log = LoggerFactory.getLogger(DroolsBeanFactory.class);

    private static final String RULES_PATH = ""; //"com/bizflow/drools/ps/rules/";
    private KieServices kieServices = KieServices.Factory.get();

    private KieFileSystem getKieFileSystem() throws IOException {
        log.debug("getKieFileSystem - 1");
        KieFileSystem kieFileSystem = kieServices.newKieFileSystem();
        List<String> rules= Arrays.asList("document_rules.drl");
        for(String rule:rules){
            kieFileSystem.write(ResourceFactory.newClassPathResource(rule));
        }
        return kieFileSystem;
    }

    public KieContainer getKieContainer() throws IOException {
        getKieRepository();

        KieBuilder kb = kieServices.newKieBuilder(getKieFileSystem());
        kb.buildAll();

        KieModule kieModule = kb.getKieModule();
        KieContainer kContainer = kieServices.newKieContainer(kieModule.getReleaseId());

        return kContainer;
    }

    private void getKieRepository() {
        log.debug("getting KieRepository");
        final KieRepository kieRepository = kieServices.getRepository();
        kieRepository.addKieModule(new KieModule() {
            public ReleaseId getReleaseId() {
                return kieRepository.getDefaultReleaseId();
            }
        });
    }

    public KieSession getKieSession(String ruleFileName){

        log.debug("Rule name=" + ruleFileName);

        getKieRepository();

        KieFileSystem kieFileSystem = kieServices.newKieFileSystem();

        log.debug("Rule File Path=" + RULES_PATH + ruleFileName);
        kieFileSystem.write(ResourceFactory.newClassPathResource(RULES_PATH + ruleFileName));
        //kieFileSystem.write(ResourceFactory.newClassPathResource("com/bizflow/drools/document/rules/document_rules.xls"));

        log.debug("creating new KieBuilder");
        KieBuilder kb = kieServices.newKieBuilder(kieFileSystem);

        log.debug("building all");
        kb.buildAll();

        log.debug("getting KieModule");
        KieModule kieModule = kb.getKieModule();

        log.debug("creating a new KieContainer");
        KieContainer kContainer = kieServices.newKieContainer(kieModule.getReleaseId());

        return kContainer.newKieSession();

    }

    public KieSession getKieSession(Resource dt) {

        KieFileSystem kieFileSystem = kieServices.newKieFileSystem().write(dt);

        KieBuilder kieBuilder = kieServices.newKieBuilder(kieFileSystem).buildAll();

        KieRepository kieRepository = kieServices.getRepository();

        ReleaseId krDefaultReleaseId = kieRepository.getDefaultReleaseId();

        KieContainer kieContainer = kieServices.newKieContainer(krDefaultReleaseId);

        KieSession ksession = kieContainer.newKieSession();

        return ksession;
    }

    /*
     * Can be used for debugging
     * Input excelFile example: com/bizflow/drools/document/rules/document_rules.xls
     */
    public String getDrlFromExcel(String excelFile) throws Exception {

        /*
        DecisionTableConfiguration configuration = KnowledgeBuilderFactory.newDecisionTableConfiguration();

        configuration.setInputType(DecisionTableInputType.XLS);

        Resource dt = ResourceFactory.newClassPathResource(excelFile, getClass());

        DecisionTableProviderImpl decisionTableProvider = new DecisionTableProviderImpl();

        InputStream is = new FileInputStream(excelFile);
        DecisionTableConfiguration configuration)

        String drl = decisionTableProvider.loadFromInputStream (is, configuration) //.loadFromResource(dt, null);

        return drl;
        */
        throw new Exception("getDrlFromExcel method has not been supported.");
    }
}
