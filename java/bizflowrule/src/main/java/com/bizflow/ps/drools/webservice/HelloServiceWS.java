/*
 * Copyright (C) BizFlow Corp - All Rights Reserved
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 *
 * Written by Tae Ho Lee <thlee@bizflow.com> <Taeho.BPM@gmail.com>, 3/2018
 *
 */

package com.bizflow.ps.drools.webservice;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.core.Response;

@Path("/hello")
public class HelloServiceWS {

    private static final Logger log = LoggerFactory.getLogger(HelloServiceWS.class);

    @GET
    @Path("/{param}")
    public Response getMsg(@PathParam("param") String msg) {

        log.debug("msg=" + msg);

        String output = "Jersey say : " + msg;

        return Response.status(200).entity(output).build();

    }

}
