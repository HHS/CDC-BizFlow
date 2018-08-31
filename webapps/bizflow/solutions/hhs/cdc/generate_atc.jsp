<%@ page import="java.io.*" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="com.hs.bf.web.xmlrs.XMLResultSet" %>
<%@ page import="com.hs.bf.web.xmlrs.XMLResultSetImpl" %>
<%@ page import="com.hs.bf.web.beans.HWSession" %>
<%@ page import="com.hs.bf.web.beans.HWSessionInfo" %>
<%@ page import="com.hs.bf.web.beans.HWFilter" %>
<%@ page import="com.hs.frmwk.json.JSONObject" %>
<%@ page import="com.hs.ja.web.servlet.ServletUtil" %>
<%@ page import="java.util.Properties" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/bizflow.tld" prefix="bf" %>
<jsp:useBean id="bizflowProps" class="com.hs.bf.web.props.Properties" scope="application"/>
<jsp:useBean id="hwSessionFactory" class="com.hs.bf.web.beans.HWSessionFactory" scope="application"/>
<jsp:useBean id="hwSessionInfo" class="com.hs.bf.web.beans.HWSessionInfo" scope="session"/>
<jsp:useBean id="hwiniSystem" class="com.hs.frmwk.common.ini.IniFile" scope="application"/>
<bf:parameter id="processid" name="processid" value="" valuePattern="NoRiskyValue"/><%--madatory--%>
<bf:parameter id="activityid" name="activityid" value="" valuePattern="NoRiskyValue"/><%--madatory--%>
<bf:parameter id="workitemseq" name="workitemseq" value="" valuePattern="NoRiskyValue"/><%--madatory--%>

<%@ include file="./sslinit.jsp" %>

<%!
	static final String DEFAULT_DOCUMENT_TYPE = "Approval To Commit";
	static final String DEFAULT_FILE_NAME = "Approval To Commit.pdf";
	static final String PROCESS_DEFINITION_NAME = "Appointment";
	static final String PROCESS_STATE_RUNNING = "R";
	static final String PROCESS_STATE_OVERDUE = "V";
	static Properties CDCProperties = null;

	static final String REPORT_URL = "{REPORTSERVERURL}/rest_v2/reports{PATH}.{FILEFORMAT}?j_memberid={J_MEMBERID}&j_username={J_USERNAME}&caseID={CASEID}";

	static org.apache.log4j.Logger log = org.apache.log4j.Logger.getLogger("JSP");

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

	File downloadWorksheet(boolean useSSL, HttpServletRequest request, String reportServerURL, String path, String fileFormat, String jMemberId, String jUserName, int caseId) {
		File fp = null;
		try{
			if (useSSL)
				initSSLEx(request, reportServerURL);

			String url = REPORT_URL;
			url = StringUtils.replace(url, "{REPORTSERVERURL}", reportServerURL);
			url = StringUtils.replace(url, "{PATH}", path);
			url = StringUtils.replace(url, "{FILEFORMAT}", fileFormat);
			url = StringUtils.replace(url, "{J_MEMBERID}", jMemberId);
			url = StringUtils.replace(url, "{J_USERNAME}", jUserName);
			url = StringUtils.replace(url, "{CASEID}", String.valueOf(caseId));
			
			java.net.URL agent = new java.net.URL(url);
			InputStream inputStream = null;
			FileOutputStream fos = null;
			fp = File.createTempFile("cdc_", ".pdf");

			try
			{
				inputStream = new BufferedInputStream(agent.openStream());
				fos = new FileOutputStream(fp);
				byte[] buffer = new byte[1024];
				int len = 0;
				while ((len = inputStream.read(buffer)) != -1) {
					fos.write(buffer, 0, len);
				}
			}
			catch (IOException e)
			{
				log.error("Error during the downloading the Worksheet report file. (url=" + url +")", e);
				fp = null;
			}
			finally
			{
				if (inputStream != null) try { inputStream.close(); } catch (Exception be) {};
				if (fos != null) try { fos.close(); } catch (Exception we) {};
			}
		}catch(Exception e){
			log.error(e);
		}

		return fp;
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
	log.debug("[PDF]generate_atc.jsp---------------------");

	String errorMsg = null;
	JSONObject ret = new JSONObject();
	HWSession hwSession = hwSessionFactory.newInstance();
	XMLResultSet loginUser = null;
	XMLResultSet xrsAttachments = null;
	int nProcessId = -1;
	int nWorkitemSeq = -1;
	int nActivityId = -1;
	boolean success = true;
	boolean documentTypeAlreadyAttached = false;
	String documentType = null;
	String fileName = null;
	String validProcessDefinitionName = null;
	String reportPath = null;
	String fileFormat = "pdf";
	String reportServerURL = null;
	String reportProtocol = null;
	boolean useSSL = false;

	boolean initialDocumentExist = false;

	try {
		// Configuring application
		loadProperties(application);

		// Validating parameters
		loginUser = (XMLResultSet) session.getAttribute("LoginUser");
		nProcessId = Integer.parseInt(processid);
		nWorkitemSeq = Integer.parseInt(workitemseq);
		nActivityId = Integer.parseInt(activityid);
		reportProtocol = CDCProperties.getProperty("report.protocol", "http");
		validProcessDefinitionName = CDCProperties.getProperty("report.ATC.processName",PROCESS_DEFINITION_NAME);
		reportServerURL = CDCProperties.getProperty("report.server.url", "https://localhost/bizflowadvreport");
		documentType = CDCProperties.getProperty("report.ATC.documentType",DEFAULT_DOCUMENT_TYPE);
		fileName = CDCProperties.getProperty("report.ATC.fileName",DEFAULT_FILE_NAME);
		reportPath = CDCProperties.getProperty("report.ATC.path");
		useSSL = "https".equalsIgnoreCase(reportProtocol);

		log.debug("[PDF]\treportPath=" + reportPath);
		log.debug("[PDF]\tdocumentType=" + documentType);
		log.debug("[PDF]\tprocessid=" + processid);

		// Validating status of the process instance
		XMLResultSet xrsProcess = getProcess(hwSession, hwSessionInfo, nProcessId);
		int cnt = xrsProcess.getRowCount();
		if(cnt == 0
			|| !validProcessDefinitionName.equals(xrsProcess.getFieldValueAt(0, "PROCESSDEFINITIONNAME"))
			|| !(PROCESS_STATE_RUNNING.equals(xrsProcess.getFieldValueAt(0, "STATE")) || PROCESS_STATE_OVERDUE.equals(xrsProcess.getFieldValueAt(0, "STATE")))
		  ){
			success = false;
			errorMsg = "Invalid Request - either process name or process status.";
		}

	} catch(Exception e) {
		log.error(e);
		errorMsg = "Invalid parameters." + e.toString();
		success = false;
	}

	if(success) {
		try {
			log.debug("[PDF]\tprocess is in running state");

			// download Worksheet report file
			String jMemberID = loginUser.getFieldValueAt(0, "ID");
			String jUserName = loginUser.getFieldValueAt(0, "LOGINID");

			// get existing attachments of the current process.
			xrsAttachments = getAttachments(hwSession, hwSessionInfo, nProcessId);
			log.debug("[PDF]\tnumber of existing attachments=" + xrsAttachments.getRowCount());

			// find files to be deleted.
			boolean bFilesToBeRemoved = false;
			for (int i = xrsAttachments.getRowCount() - 1; i >= 0; i--) {
				if (documentType.equalsIgnoreCase(xrsAttachments.getFieldValueAt(i, "CATEGORY"))
					&& !"".equalsIgnoreCase(xrsAttachments.getFieldValueAt(i, "ETCINFO"))) {
	                log.debug("[PDF]\tmarking deleting file [" + Integer.toString(i) + "] " + xrsAttachments.getFieldValueAt(i, "FILENAME"));
	                xrsAttachments.remove(i);
	                bFilesToBeRemoved = true;
				}
			}

			// delete files.
			if (!bFilesToBeRemoved) {
				log.debug("[PDF]\tno need to delete files");
			} else {
				log.debug("[PDF]\tdeleting files...");
				xrsAttachments.setFilter(XMLResultSet.FILTER_DELETED);
				hwSession.updateAttachments(hwSessionInfo.toString(),
											hwSessionInfo.get("SERVERID"),
											nProcessId,
											0,
											xrsAttachments.toByteArray(),
											null);
			}

			int fileLength = 1;
			File worksheetFiles[] = null;
			String fileNames[] = null;
			worksheetFiles = new File[fileLength];
			fileNames = new String[fileLength];
			for (int i=0; i<fileLength; i++) {
				worksheetFiles[i] = downloadWorksheet(useSSL, request, reportServerURL, reportPath, fileFormat, jMemberID, jUserName, nProcessId);
				log.debug("[PDF]\tdownloading a report=" + worksheetFiles[i].getAbsolutePath());
				fileNames[i] = fileName;
				fileNames[i] = fileNames[i].replaceAll("[^a-zA-Z0-9 \\.\\-]", "_"); //replace illegal character in file name
				log.debug("[PDF]\tgenerating a pdf file=" + fileNames[i]);
			}

			log.debug("[PDF]\tpreparing BizFlow attachment...");
			// Attach to process
			xrsAttachments = new XMLResultSetImpl();
			xrsAttachments.createResultSet("HWAttachments", "HWATTACHMENT");
			String[] attachFiles = new String[worksheetFiles.length];
			for (int i=0; i<worksheetFiles.length; i++) {
				int r = xrsAttachments.add();
				xrsAttachments.setFieldValueAt(r, "SERVERID", hwSessionInfo.getServerID());
				xrsAttachments.setFieldValueAt(r, "PROCESSID", processid);
				xrsAttachments.setFieldValueAt(r, "ACTIVITYSEQUENCE", activityid);
				xrsAttachments.setFieldValueAt(r, "ID", String.valueOf(r));
				xrsAttachments.setFieldValueAt(r, "WORKITEMSEQUENCE", workitemseq);
				xrsAttachments.setFieldValueAt(r, "TYPE", "G");
				xrsAttachments.setFieldValueAt(r, "OUTTYPE", "B");
				xrsAttachments.setFieldValueAt(r, "INTYPE", "C");
				xrsAttachments.setFieldValueAt(r, "DIGITALSIGNATURE", "N");
				xrsAttachments.setFieldValueAt(r, "MAPID", String.valueOf(r));
				xrsAttachments.setFieldValueAt(r, "DMDOCRTYPE", "N");
				xrsAttachments.setFieldValueAt(r, "ETCINFO", "AUTO-ATC");
				xrsAttachments.setFieldValueAt(r, "DESCRIPTION", "AUTO");
				xrsAttachments.setFieldValueAt(r, "DISPLAYNAME", fileNames[i]);
				xrsAttachments.setFieldValueAt(r, "FILENAME", fileNames[i]);
				xrsAttachments.setFieldValueAt(r, "CATEGORY", documentType);
				xrsAttachments.setFieldValueAt(r, "SIZE", String.valueOf(worksheetFiles[i].length()));
				attachFiles[i] = worksheetFiles[i].getAbsolutePath();
				log.debug("[PDF]\txrsAttachments=" + xrsAttachments.toString());
			}
			log.debug("[PDF]\tattaching pdf file(s) to process...");
			
			hwSession.updateAttachments(hwSessionInfo.toString(),
					hwSessionInfo.getServerID(),
					nProcessId,
					nActivityId,
					xrsAttachments.toByteArray(),
					attachFiles);			
			
			log.debug("[PDF]\tpdf has been attached.");

			// delete temporary files
			for (int i=0; i<worksheetFiles.length; i++) {
				try {
					log.debug("deleting temporary file " + worksheetFiles[i].getAbsolutePath());
					//worksheetFiles[i].delete();
				} catch (Exception e) {
					log.debug(e.toString());
				}
			}


		} catch (Exception e) {
			errorMsg = "[Internal Error] " + e.getMessage();
			log.debug(errorMsg);
			log.error(e);
		}
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