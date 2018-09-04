<%@ page import="java.io.*" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="com.hs.bf.web.beans.*" %>
<%@ page import="com.hs.bf.web.xmlrs.*" %>
<%@ page import="com.hs.frmwk.json.JSONObject" %>
<%@ page import="com.hs.ja.web.servlet.ServletUtil" %>
<%@ page import="java.util.Properties" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/bizflow.tld" prefix="bf" %>
<jsp:useBean id="bizflowProps" class="com.hs.bf.web.props.Properties" scope="application"/>
<jsp:useBean id="hwSessionFactory" class="com.hs.bf.web.beans.HWSessionFactory" scope="application"/>
<jsp:useBean id="hwSessionInfo" class="com.hs.bf.web.beans.HWSessionInfo" scope="session"/>
<jsp:useBean id="hwiniSystem" class="com.hs.frmwk.common.ini.IniFile" scope="application"/>
<bf:parameter id="procId" name="procId" value="0" valuePattern="NoRiskyValue"/><%--madatory--%>
<bf:parameter id="sysDocDelMode" name="sysDocDelMode" value="" valuePattern="NoRiskyValue"/>
<%!
	static org.apache.log4j.Logger log = org.apache.log4j.Logger.getLogger("JSP");

	static Properties CDCProperties = null;

	void loadProperties(ServletContext application) {
		try
		{
			if (null == CDCProperties)
			{
				CDCProperties = new Properties();
				CDCProperties.load(new FileInputStream(ServletUtil.getRealPath(application, "/solutions/hhs/cdc/cdc.properties")));
			}
		}
		catch (Exception e)
		{
		}
	}

	XMLResultSet getAttachments(HWSession hwSession, HWSessionInfo hwSessionInfo, int processId) throws Exception {
		HWFilter filter = new HWFilter();
		filter.setName("HWATTACHMENT");
		filter.addFilter("SERVERID", "E", hwSessionInfo.getServerID());
		filter.addFilter("PROCESSID", "E", Integer.toString(processId));

		XMLResultSet xrs = new XMLResultSetImpl();
		xrs.setLookupField("ID");
		xrs.parse(hwSession.getAttachments(hwSessionInfo.toString(), filter.toByteArray()));
		return xrs;
	}

	XMLResultSet getProcess(HWSession hwSession, HWSessionInfo hwSessionInfo, int processId) throws Exception {
		HWFilter filter = new HWFilter();
		filter.setName("HWProcess");
		filter.addFilter("ServerID", "E", hwSessionInfo.getServerID());
		filter.addFilter("ID", "E", Integer.toString(processId));
		XMLResultSet xrs = new XMLResultSetImpl();
		xrs.parse(hwSession.getProcesses(hwSessionInfo.toString(), filter.toByteArray()));
		return xrs;
	}
%>
<%
	String errorMsg = null;
	JSONObject ret = new JSONObject();
	HWSession hwSession = hwSessionFactory.newInstance();
	String sessionInfoXML = null;

	String serverIp = null;
	String serverPort = null;
	int nServerPort = 0;
	String userIp = null;
	HWString userFilePath = new HWString();
	String loginId = null;
	String loginPwd = null;
	int nProcessId = -0;
	boolean bFilesToBeRemoved = false;

	String fileName = null;
	boolean success = false;

	XMLResultSet xrsAttachments = null;

	try {
		// Configuring application
		loadProperties(application);

		serverIp = CDCProperties.getProperty("bizflow.server.ip", "cdc.bizflow.com");
		serverPort = CDCProperties.getProperty("bizflow.server.port", "7201");
		nServerPort = Integer.parseInt(serverPort);
		userIp = request.getRemoteAddr();

		loginId = CDCProperties.getProperty("bizflow.agent.loginid", "thlee");
		loginPwd = CDCProperties.getProperty("bizflow.agent.loginpwd", "cdc");

		nProcessId = Integer.parseInt(procId);
		
		System.out.println("\nPROCESS_ID=" + procId);
		System.out.println("ETCINFO='" + sysDocDelMode + "'");
		//System.out.println("serverIp=" + serverIp);
		//System.out.println("serverPort=" + serverPort);
		//System.out.println("loginId=" + loginId);
		//System.out.println("loginPwd=" + loginPwd);
		

		sessionInfoXML = hwSession.logInWeb(serverIp, nServerPort, userIp, loginId,
												loginPwd, true, userFilePath);
		if (sessionInfoXML != null) {
			hwSessionInfo.reset(sessionInfoXML);
		}

		xrsAttachments = getAttachments(hwSession, hwSessionInfo, nProcessId);
		
		System.out.println("Attachment Count=" + xrsAttachments.getRowCount());

		String etcInfo = null;
		for (int i = xrsAttachments.getRowCount() - 1; i >= 0; i--) {
			etcInfo = xrsAttachments.getFieldValueAt(i, "ETCINFO");
			System.out.print("  [" + Integer.toString(i) + "] ETCINFO='" + etcInfo + "', ");

			if ("ALL".equals(sysDocDelMode)) {
                System.out.println("DELETE --> " + xrsAttachments.getFieldValueAt(i, "FILENAME"));
                xrsAttachments.remove(i);
                bFilesToBeRemoved = true;
			} else if (sysDocDelMode.equalsIgnoreCase(xrsAttachments.getFieldValueAt(i, "ETCINFO"))) {
                System.out.println("DELETE --> " + xrsAttachments.getFieldValueAt(i, "FILENAME"));
                xrsAttachments.remove(i);
                bFilesToBeRemoved = true;
			} else {
				System.out.println("NOT DELETE --> " + xrsAttachments.getFieldValueAt(i, "FILENAME"));
			}
		}

		if (bFilesToBeRemoved) {
			System.out.println("Deleting documents...");
			xrsAttachments.setFilter(XMLResultSet.FILTER_DELETED);
			hwSession.updateAttachments(hwSessionInfo.toString(),
										hwSessionInfo.get("SERVERID"),
										nProcessId,
										0,
										xrsAttachments.toByteArray(),
										null);
		} else  {
			System.out.println("Nothing to delete in Process ID=" + procId);
		}

	} catch(Exception e) {
		log.error(e);
		errorMsg = "Failed to remove attachment." + e.toString();
		success = false;
	}

	if(errorMsg != null)
	{
		ret.put("success", false);
		ret.put("message", errorMsg);
	}
	else
	{
		ret.put("success", true);
		ret.put("fileName", fileName);
	}
	out.clear();
	response.setContentType("application/json; charset=UTF-8");
	out.write(ret.toString());
%>