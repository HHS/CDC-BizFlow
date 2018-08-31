<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.*" %>

<%
//Context ctx = new InitialContext();
//DataSource dataSource = ctx.lookup("java:jdbc/workflowdb");
//Connection conn = dataSource.getConnection();
// use the connections
//conn.close();

	String errorMsg = null;

    //String DATASOURCE_CONTEXT = "java:comp/env/jdbc/blah";
    String DATASOURCE_CONTEXT = "java:comp/env/jdbc/workflowdb";

    Connection conn = null;
    try {
      Context initialContext = new InitialContext();
      if ( initialContext == null){
        errorMsg = "JNDI problem. Cannot get InitialContext.";
      }
      DataSource datasource = (DataSource)initialContext.lookup(DATASOURCE_CONTEXT);
      if (datasource != null) {
        conn = datasource.getConnection();
      }
      else {
        errorMsg = "Failed to lookup datasource.";
      }
    }
    catch ( NamingException ex ) {
      errorMsg = "Cannot get connection 1: " + ex;
    }
    catch(SQLException ex){
      errorMsg = "Cannot get connection 2: " + ex;
    }

    //select bizflow databases instance and archive to search Job Requisition Number in process variables
    /*
    	TODO: consider adding a new table to store process id and process type with JobReqNumber
    	SELECT PROCID
		  FROM WORKFLOW.RLVNTDATA R
		 WHERE R.RLVNTDATANAME = 'JOBREQNUMBER'
		   AND   
	*/

    errorMsg = conn.toString();

    conn.close();
%>
<html>
<body>
<h1>USA Staffing Service</h1>
<div>
Error Message=<%= errorMsg %>.<br/>
</div>	
</body>
</html>