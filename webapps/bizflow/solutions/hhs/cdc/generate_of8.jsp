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
<bf:parameter id="generationmode" name="generationmode" value="" valuePattern="NoRiskyValue"/><%--madatory--%>
<bf:parameter id="admincode" name="admincode" value="" valuePattern="NoRiskyValue"/>
<bf:parameter id="positiontitleseries" name="positiontitleseries" value="" valuePattern="NoRiskyValue"/>
<bf:parameter id="payplan" name="payplan" value="" valuePattern="NoRiskyValue"/>
<bf:parameter id="grades" name="grades" value="" valuePattern="NoRiskyValue"/><%--madatory--%>
<bf:parameter id="gradetexts" name="gradetexts" value="" valuePattern="NoRiskyValue"/><%--madatory--%>
<bf:parameter id="pdnumber" name="pdnumber" value="" valuePattern="NoRiskyValue"/>
<bf:parameter id="supervisorname" name="supervisorname" value="" valuePattern="NoRiskyValue"/>

<%@ include file="./sslinit.jsp" %>
<%!
	static final String DEFAULT_DOCUMENT_TYPE = "OF-8";
	static final String DEFAULT_FILE_NAME = "OF-8.pdf";
	static final String PROCESS_DEFINITION_NAME = "Classification";
	static final String PROCESS_STATE_RUNNING = "R";
	static final String PROCESS_STATE_OVERDUE = "V";
	static Properties CDCProperties = null;

	static final String REPORT_URL = "{REPORTSERVERURL}/rest_v2/reports{PATH}.{FILEFORMAT}?j_memberid={J_MEMBERID}&j_username={J_USERNAME}&caseID={CASEID}&Grade={GRADE}";

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

	File downloadWorksheet(boolean useSSL, HttpServletRequest request, String reportServerURL, String path, String fileFormat, String jMemberId, String jUserName, int caseId, String grade) {
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
			url = StringUtils.replace(url, "{GRADE}", grade);
			log.debug("REPORT URL=" + url);
			java.net.URL agent = new java.net.URL(url);
			System.out.println("REPORT URL=" + url);
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

	String positiontitle = null;
	String series = null;
	String gradeItems[] = grades.split("::");
	String gradetextItems[] = gradetexts.split("::");
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
		validProcessDefinitionName = CDCProperties.getProperty("report.OF8.processName",PROCESS_DEFINITION_NAME);
		reportServerURL = CDCProperties.getProperty("report.server.url", "https://localhost/bizflowadvreport");
		documentType = CDCProperties.getProperty("report.OF8.documentType",DEFAULT_DOCUMENT_TYPE);
		fileName = CDCProperties.getProperty("report.OF8.fileName",DEFAULT_FILE_NAME);

		if ("initial".equals(generationmode)) {
			reportPath = CDCProperties.getProperty("report.OF8.Initial.path");
		} else {
			reportPath = CDCProperties.getProperty("report.OF8.path");
		}
		
		useSSL = "https".equalsIgnoreCase(reportProtocol);

		if (positiontitleseries != null) {
			System.out.println("positiontitleseries=" + positiontitleseries);
			String[] concatinatedPositionTitleSeries = positiontitleseries.split("::");
			concatinatedPositionTitleSeries = concatinatedPositionTitleSeries[0].split("%%");
			if (concatinatedPositionTitleSeries.length > 0)	{
				positiontitle = concatinatedPositionTitleSeries[0];
			}
			if (concatinatedPositionTitleSeries.length > 1)	{
				series = concatinatedPositionTitleSeries[1];
			}
		}

System.out.println("\n\n");
System.out.println("\tgenerationmode=" + generationmode);
System.out.println("\treportPath=" + reportPath);
System.out.println("\tadmincode=" + admincode);
System.out.println("\tpositiontitle=" + positiontitle);
System.out.println("\tpayplan=" + payplan);
System.out.println("\tseries=" + series);
System.out.println("\tpdnumber=" + pdnumber);
System.out.println("\tsupervisorname=" + supervisorname);
System.out.println("\tgrades=" + grades);
System.out.println("\tgradetexts=" + gradetexts);
System.out.println("\n\n");

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
		/*
		if(success) {
			xrsAttachments = getAttachments(hwSession, hwSessionInfo, nProcessId);
			for (int i = 0; i < xrsAttachments.getRowCount(); i++) {
				if (documentType.equalsIgnoreCase(xrsAttachments.getFieldValueAt(i, "CATEGORY"))) {
					documentTypeAlreadyAttached = true;
					if ("onlyone".equalsIgnoreCase(attachmode)) {
						errorMsg = "Requested document type (" + documentType + ") has already been attached.";
					}	
					break;
				}
			}
		}
		*/

	} catch(Exception e) {
		log.error(e);
		errorMsg = "Invalid parameters." + e.toString();
		success = false;
	}

	if(success) {
		try {
	
			// download Worksheet report file
			String jMemberID = loginUser.getFieldValueAt(0, "ID");
			String jUserName = loginUser.getFieldValueAt(0, "LOGINID");

			// get existing attachments of the current process.
			xrsAttachments = getAttachments(hwSession, hwSessionInfo, nProcessId);
			System.out.println("xrsAttachments.getRowCount()=" + xrsAttachments.getRowCount());

			// find files to be deleted.
			boolean bFilesToBeRemoved = false;
			for (int i = xrsAttachments.getRowCount() - 1; i >= 0; i--) {
				if (documentType.equalsIgnoreCase(xrsAttachments.getFieldValueAt(i, "CATEGORY")) 
					&& !"INITIAL-OF8".equalsIgnoreCase(xrsAttachments.getFieldValueAt(i, "ETCINFO"))
					&& !"".equalsIgnoreCase(xrsAttachments.getFieldValueAt(i, "ETCINFO"))) {
	                
	                System.out.println("deleting an existing file [" + Integer.toString(i) + "] " + xrsAttachments.getFieldValueAt(i, "FILENAME"));
	                xrsAttachments.remove(i);
	                bFilesToBeRemoved = true;
				}

				if (documentType.equalsIgnoreCase(xrsAttachments.getFieldValueAt(i, "CATEGORY"))
					&& "INITIAL-OF8".equalsIgnoreCase(xrsAttachments.getFieldValueAt(i, "ETCINFO"))) {
					initialDocumentExist = true;
				}
			}

			// delete files.
			if (bFilesToBeRemoved) {
				System.out.println("initialDocumentExist=" + initialDocumentExist);
				xrsAttachments.setFilter(XMLResultSet.FILTER_DELETED);
				hwSession.updateAttachments(hwSessionInfo.toString(),
											hwSessionInfo.get("SERVERID"),
											nProcessId,
											0,
											xrsAttachments.toByteArray(),
											null);
			}

			boolean bFilesToBeUpdated = false;

			if ("initial".equalsIgnoreCase(generationmode) 
				&& initialDocumentExist) {
				bFilesToBeUpdated = false; //The initial file should not be updated once it had been created at the first step of Classificaiton process.
 			} else {
				bFilesToBeUpdated = true;
			}

			File worksheetFiles[] = null;
			String fileNames[] = null;

			if (bFilesToBeUpdated) {
				int fileLength = 1;
				if (!"initial".equalsIgnoreCase(generationmode)) {
					fileLength = gradetextItems.length;
				}

				worksheetFiles = new File[fileLength];
				fileNames = new String[fileLength];
				//OF-8 file per Grade level except initial file. Initial file is per Classification level.
				if ("initial".equalsIgnoreCase(generationmode)) {
					for (int i=0; i<gradetextItems.length; i++) {
						worksheetFiles[i] = downloadWorksheet(useSSL, request, reportServerURL, reportPath, fileFormat, jMemberID, jUserName, nProcessId, gradetextItems[i]);					
						fileNames[i] = admincode + "-OF8-" + positiontitle + "-" + payplan + "-" + series + "-" + gradetexts.replace("::", ",") + "-" + pdnumber + ".pdf";
						fileNames[i] = fileNames[i].replaceAll("[^a-zA-Z0-9 \\.\\-]", "_"); //replace illegal character in file name
						System.out.println(worksheetFiles[i].getAbsolutePath());
						System.out.println(fileNames[i]);
						break; //only one file. not per grade TODO: change downloadWorksheet to call different URL.
					}	
				} else {
					for (int i=0; i<gradetextItems.length; i++) {
						worksheetFiles[i] = downloadWorksheet(useSSL, request, reportServerURL, reportPath, fileFormat, jMemberID, jUserName, nProcessId, gradetextItems[i]);
						System.out.println(worksheetFiles[i].getAbsolutePath());
						fileNames[i] = admincode + "-OF8-" + positiontitle + "-" + payplan + "-" + series + "-" + gradetextItems[i] + "-" + pdnumber + ".pdf";
						fileNames[i] = fileNames[i].replaceAll("[^a-zA-Z0-9 \\.\\-]", "_"); //replace illegal character in file name
						System.out.println(fileNames[i]);
					}
				}

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
					if ("initial".equalsIgnoreCase(generationmode)) {
						xrsAttachments.setFieldValueAt(r, "ETCINFO", "INITIAL-OF8");
						xrsAttachments.setFieldValueAt(r, "DESCRIPTION", "Initial | Admin Code=" + admincode + " | Grade=" + gradetexts.replace("::", ",") + " | Pd Number=" + pdnumber);
						xrsAttachments.setFieldValueAt(r, "DISPLAYNAME", fileNames[i]);
						xrsAttachments.setFieldValueAt(r, "FILENAME", "INITIAL-" + fileNames[i]);
					} else if ("manual".equalsIgnoreCase(generationmode)) {
						xrsAttachments.setFieldValueAt(r, "ETCINFO", "MANUAL-OF8");
						xrsAttachments.setFieldValueAt(r, "DESCRIPTION", "Manual | Admin Code=" + admincode + " | Grade=" + gradetextItems[i] + " | Pd Number=" + pdnumber);
						xrsAttachments.setFieldValueAt(r, "DISPLAYNAME", fileNames[i]);
						xrsAttachments.setFieldValueAt(r, "FILENAME", fileNames[i]);
					} else if ("auto".equalsIgnoreCase(generationmode)) {
						xrsAttachments.setFieldValueAt(r, "ETCINFO", "AUTO-OF8");
						xrsAttachments.setFieldValueAt(r, "DESCRIPTION", "Auto | Admin Code=" + admincode + " | Grade=" + gradetextItems[i] + " | Pd Number=" + pdnumber);
						xrsAttachments.setFieldValueAt(r, "DISPLAYNAME", fileNames[i]);
						xrsAttachments.setFieldValueAt(r, "FILENAME", fileNames[i]);
					} else {
						xrsAttachments.setFieldValueAt(r, "ETCINFO", "AUTO-OF8");
						xrsAttachments.setFieldValueAt(r, "DESCRIPTION", "Auto | Admin Code=" + admincode + " | Grade=" + gradetextItems[i] + " | Pd Number=" + pdnumber);
						xrsAttachments.setFieldValueAt(r, "DISPLAYNAME", fileNames[i]);
						xrsAttachments.setFieldValueAt(r, "FILENAME", fileNames[i]);
					}											
					xrsAttachments.setFieldValueAt(r, "CATEGORY", documentType);
					xrsAttachments.setFieldValueAt(r, "SIZE", String.valueOf(worksheetFiles[i].length()));
					attachFiles[i] = worksheetFiles[i].getAbsolutePath();
				}
				hwSession.updateAttachments(hwSessionInfo.toString(),
						hwSessionInfo.getServerID(),
						nProcessId,
						nActivityId,
						xrsAttachments.toByteArray(),
						attachFiles);			

				// delete temporary files
				for (int i=0; i<worksheetFiles.length; i++) {
					try {
						System.out.println("deleting temporary file " + worksheetFiles[i].getAbsolutePath());
						//worksheetFiles[i].delete();
					} catch (Exception e) {
						System.out.println(e.toString());
					}
				}
			}

		} catch (Exception e) {
			errorMsg = "[Internal Error] " + e.getMessage();
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