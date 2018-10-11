<%@ page import="java.io.*" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="com.hs.bf.web.beans.HWSessionInfo" %>
<%@ page import="com.hs.frmwk.json.JSONObject" %>
<%@ page import="com.hs.ja.web.servlet.ServletUtil" %>
<%@ page import="java.util.Properties" %>
<%@ page import="com.hs.bf.wf.jo.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/bizflow.tld" prefix="bf" %>
<jsp:useBean id="bizflowProps" class="com.hs.bf.web.props.Properties" scope="application"/>
<jsp:useBean id="hwSessionFactory" class="com.hs.bf.web.beans.HWSessionFactory" scope="application"/>
<jsp:useBean id="hwSessionInfo" class="com.hs.bf.web.beans.HWSessionInfo" scope="session"/>
<jsp:useBean id="hwiniSystem" class="com.hs.frmwk.common.ini.IniFile" scope="application"/>
<jsp:useBean id="res" class="com.hs.bf.web.xslt.resource.ResourceBag" scope="application"/>
<bf:parameter id="processid" name="processid" value="" valuePattern="NoRiskyValue"/><%--madatory--%>
<bf:parameter id="jrno" name="jrno" value="" valuePattern="NoRiskyValue"/><%--madatory--%>
<bf:parameter id="certno" name="certno" value="" valuePattern="NoRiskyValue"/><%--madatory--%>
<bf:parameter id="applicantname" name="applicantname" value="" valuePattern="NoRiskyValue"/><%--madatory--%>

<%@ include file="./sslinit.jsp" %>

<%!
	static org.apache.log4j.Logger log = org.apache.log4j.Logger.getLogger("JSP");

	static final String PROCESS_STATE_RUNNING = "R";
	static final String PROCESS_STATE_OVERDUE = "V";
    static final String BIZFLOW_FOLDER_DEFINITION_ROOT = "Process Definitions";
    static final String BIZFLOW_FOLDER_ID_PROCESS_DEFINITION_ROOT = "52";

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

	boolean findDuplicateProcess(HWSessionInfo hwSessionInfo, String jrno, String certno) throws HWException, Exception {
	    boolean bFound = false;
        System.out.println("[CDC] findDuplicateProcess----------------");

        HWFilters advFilters = new HWFilters();
        HWFilter advFilter = new HWFilter();
        HWFilters subAdvFilters = new HWFilters();

        advFilters.setName("HWProcess");
        advFilters.add("ID", HWConstant.FILTEROPERATOR_EQUAL, "25584");
        /*
        advFilters.add("STATE", HWConstant.FILTEROPERATOR_IN, "('R','E','V','S','D','N','J')");

        subAdvFilters = advFilter.addSubFilters();
        subAdvFilters.add("VARIABLENAME", HWConstant.FILTEROPERATOR_EQUAL, "procId");
        subAdvFilters.add("VARIABLETYPE", HWConstant.FILTEROPERATOR_EQUAL, HWConstant.PROCESSVARIABLETYPE_NUMBER);
        subAdvFilters.add("VARIABLESCOPE", HWConstant.FILTEROPERATOR_EQUAL, HWConstant.PROCESSVARIABLESCOPE_INSTANCE);
        subAdvFilters.add("VARIABLEVALUE", HWConstant.FILTEROPERATOR_EQUAL, "25584");
        */

        System.out.println("advFilters----------------");
        System.out.println(advFilters.toString());

        com.hs.bf.wf.jo.HWSessionFactory hwSessionFactory = new com.hs.bf.wf.jo.HWSessionFactory();
        com.hs.bf.wf.jo.HWSession hwSession = hwSessionFactory.newInstance();
        hwSession.setSessionInfoXML(hwSessionInfo.getSessionInfo());

        HWProcesses hwProcesses = hwSession.getProcesses(advFilters);
        System.out.println(hwProcesses);
        if (hwProcesses != null)
            bFound = true;

	    return bFound;
    }

    HWProcessDefinition getProcessDefinitionByName(HWSessionInfo hwSessionInfo, String folderName, String procDefName) throws HWException, Exception {
        if (folderName == null)
            throw new Exception("getProcessDefinitionByName:: Missing Process Definition Folder Name");

        if (procDefName == null)
            throw new Exception("getProcessDefinitionByName:: Process Definition Name not found");

        //Getting CDC folder ID
        HWFolders hwFolders = new HWFoldersImpl(hwSessionInfo.toString(), HWConstant.FOLDERTYPE_PROCESSDEFINITION);
        int folder_id_procdef_cdc = 0;
        for(int i=0; i<hwFolders.getCount(); i++) {
            HWFolder hwFolder = hwFolders.getItem(i);
            if (folderName.equalsIgnoreCase(hwFolder.getName())) {
                folder_id_procdef_cdc = hwFolder.getID();
                break;
            }
        }
        if (folder_id_procdef_cdc <= 0)
            throw new Exception("getProcessDefinitionByName:: Process Definition Folder ID not found");

        //Getting Appointment Process Definition ID
        HWProcessDefinitions hwProcDefs = new HWProcessDefinitionsImpl(hwSessionInfo.toString(), folder_id_procdef_cdc, HWConstant.ENVIRONMENT_OPERATIONAL);
        HWProcessDefinition hwProcDef = null;
        int procDefId;
        for(int i=0; i<hwProcDefs.getCount(); i++) {
            hwProcDef = hwProcDefs.getItem(i);
            if (procDefName.equalsIgnoreCase(hwProcDef.getName())) {
                procDefId = hwProcDef.getID();
                break;
            }
        }
        if (hwProcDef == null)
            throw new Exception("getProcessDefinitionByName:: Failed to find Process Definition");

        return hwProcDef;
    }

    HWProcess getProcessInstances(HWSessionInfo hwSessionInfo, int processId) throws HWException, Exception {
        if (processId <= 0)
            throw new Exception("getProcessInstances:: Missing Process ID");

        com.hs.bf.wf.jo.HWFilters hwFilters = new com.hs.bf.wf.jo.HWFilters();

        hwFilters.setName("HWProcess");
        hwFilters.add("SERVERID", HWConstant.FILTEROPERATOR_EQUAL, hwSessionInfo.getServerID());
        hwFilters.add("ID", HWConstant.FILTEROPERATOR_EQUAL, Integer.toString(processId));
        hwFilters.add("STATE", com.hs.bf.wf.jo.HWConstant.FILTEROPERATOR_IN, "('N','R','S','J','E','V','D')");

        com.hs.bf.wf.jo.HWSessionFactory hwSessionFactory = new com.hs.bf.wf.jo.HWSessionFactory();
        com.hs.bf.wf.jo.HWSession hwSession = hwSessionFactory.newInstance();
        hwSession.setSessionInfoXML(hwSessionInfo.getSessionInfo());

        com.hs.bf.wf.jo.HWProcesses hwProcesses = hwSession.getProcesses(hwFilters);

        HWProcess hwProcess = null;
        for(int i=0; i<hwProcesses.getCount(); i++)
        {
            hwProcess = hwProcesses.getItem(i);
            break;
        }

        if (null == hwProcess) {
            throw new Exception("Recruitment Process [" + processId + "] Not Found.");
        }

        return hwProcess;
    }

    HWWorkitem startProcess(HWSessionInfo hwSessionInfo
                            , HWProcessDefinition appointmentProcessDefinition
                            , HWProcess parentProcess
                            , HWComments parentProcessComments
                            , HWProcessVariables parentProcessVariables
                            , HWAttachments parentProcessAttachments
                            , String startActivityName
                            , String jrno
                            , String certno
                            , String applicantname) throws HWException, Exception {

	    if (appointmentProcessDefinition == null)
            throw new Exception("startProcess:: Missing Process Definition Info");

        if (parentProcess == null)
            throw new Exception("startProcess:: Missing Parent Process Info");

        if (parentProcessComments == null)
            throw new Exception("startProcess:: Missing Parent Process Comments");

        if (parentProcessVariables == null)
            throw new Exception("startProcess:: Missing Parent Process Variables");

        if (parentProcessAttachments == null)
            throw new Exception("startProcess:: Missing Parent Process Attachments");

	    int procid;
        HWWorkitem hwWorkitem = null;

        //copy PVs
        HWProcessVariables hwProcessVariables = new HWProcessVariablesImpl();
        if (parentProcessVariables.getCount() > 0) {
            for (int i=0; i<parentProcessVariables.getCount()-1; i++) {

                HWProcessVariable pv = parentProcessVariables.getItem(i);

                if (pv.getName().equalsIgnoreCase("wihmode")) {

                } else if (pv.getName().equalsIgnoreCase("parentProcId") ){
                    HWProcessVariable hwProcessVariable = hwProcessVariables.add();
                    hwProcessVariable.setValueType(HWConstant.RELDATATYPE_STRING);
                    hwProcessVariable.setScope(pv.getScope());
                    hwProcessVariable.setName("parentProcId");
                    hwProcessVariable.setValue(Integer.toString(parentProcess.getID()));
                } else if (pv.getName().equalsIgnoreCase("procId")) {

                } else {
                    HWProcessVariable hwProcessVariable = hwProcessVariables.add();
                    hwProcessVariable.setValueType(pv.getValueType());
                    hwProcessVariable.setScope(pv.getScope());
                    hwProcessVariable.setName(pv.getName());
                    hwProcessVariable.setValue(pv.getValue());
                }
            }
        }

        HWProcessVariable hwProcessVariable = hwProcessVariables.add();
        hwProcessVariable.setValueType(HWConstant.RELDATATYPE_STRING);
        hwProcessVariable.setScope(HWConstant.RELDATASCOPE_INSTANCE);
        hwProcessVariable.setName("usas_JRNo");
        hwProcessVariable.setValue(jrno);

        hwProcessVariable = hwProcessVariables.add();
        hwProcessVariable.setValueType(HWConstant.RELDATATYPE_STRING);
        hwProcessVariable.setScope(HWConstant.RELDATASCOPE_INSTANCE);
        hwProcessVariable.setName("usas_CertNo");
        hwProcessVariable.setValue(certno);

        hwProcessVariable = hwProcessVariables.add();
        hwProcessVariable.setValueType(HWConstant.RELDATATYPE_STRING);
        hwProcessVariable.setScope(HWConstant.RELDATASCOPE_INSTANCE);
        hwProcessVariable.setName("usas_ApplicantName");
        hwProcessVariable.setValue(applicantname);

        HWAttachments hwAttachments = new HWAttachmentsImpl();
        if (parentProcessAttachments != null && parentProcessAttachments.getCount() > 0) {
            for(int i=0; i<parentProcessAttachments.getCount(); i++) {
                HWAttachment hwAttch = parentProcessAttachments.getItem(i);
                if ("OF-8".equalsIgnoreCase(hwAttch.getCategory())
                    && "INITIAL-OF8".equalsIgnoreCase(hwAttch.getExtraInformation())) {
                    System.out.println("\t\t\tETCINFO=" + hwAttch.getExtraInformation());
                } else {
                    String path = hwAttch.download();
                    System.out.println("\t\t\tFile [" + Integer.toString(i) + "]=" + path);
                    File attachFile = new File (path);
                    long fileSize = attachFile.length();
                    HWAttachment hwAttachment = hwAttachments.add();
                    hwAttachment.setSize(fileSize);
                    hwAttachment.setDisplayName(hwAttch.getDisplayName());
                    hwAttachment.setFileName(hwAttch.getFileName());
                    hwAttachment.setExtraInformation(hwAttch.getExtraInformation());
                    hwAttachment.setOutType(hwAttch.getOutType());
                    hwAttachment.setDescription(hwAttch.getDescription());
                    hwAttachment.setCategory(hwAttch.getCategory());
                    hwAttachment.setFilePath(path);
                }
            }
        }

        HWProcessDefinition hwProcDef = new HWProcessDefinitionImpl(hwSessionInfo.toString(), appointmentProcessDefinition.getID());
        System.out.println("\t\tProcess Definition name=" + hwProcDef.getName());
        HWVariant outProcessID = new HWVariant();

        hwWorkitem = hwProcDef.createInstance(hwProcDef.getName()
                                    ,"Started from Selection Made in USA Staffing"
                                    ,false
                                    ,true
                                    ,true
                                    ,hwProcDef.getInstanceFolderID()
                                    ,hwProcDef.getArchiveFolderID()
                                    ,""
                                    ,startActivityName
                                    ,hwAttachments
                                    , hwProcessVariables
                                    , outProcessID);

        procid = hwWorkitem.getProcessID();

        //Adding Comments
        if (procid > 0) {
            HWComments hwComments = new HWCommentsImpl(hwSessionInfo.toString(), procid, false);
            for (int i = 0; i < parentProcessComments.getCount(); i++) {
                HWComment hwCmt = parentProcessComments.getItem(i);
                HWComment newComment = hwComments.add();
                newComment.setContents(hwCmt.getContents());
            }

            if (hwComments.getCount() > 0) {
                hwComments.update();
            }
        }

        return hwWorkitem;
    }
%>
<%
    System.out.println("[CDC] Starting an Appointment ---------------------");
    boolean success = true;
    int errorCode = 0;
    String errorMsg = null;
	JSONObject jsonObject = new JSONObject();
	com.hs.bf.web.beans.HWSession hwSession = hwSessionFactory.newInstance();

	int nProcessId = -1;
    HWWorkitem hwWorkitem = new HWWorkitemImpl();

	try {

        if (null == processid || "".equals(processid)) {
            throw new Exception("Missing Process ID parameter.");
        }

        if (null == jrno || "".equals(jrno)) {
            throw new Exception("Missing JR Number parameter.");
        }

        if (null == certno || "".equals(certno)) {
            throw new Exception("Missing Certificate Number parameter");
        }

		// Configuring application
		loadProperties(application);

        String cdcFolderName = CDCProperties.getProperty("usas.process.definition.folder.name", "CDC");
        String processDefName = CDCProperties.getProperty("usas.process.appointment.name", "Appointment");
        String startActivityName = CDCProperties.getProperty("usas.process.appointment.start.act.name", "Start From Recruitment");

		// Validating parameters
		nProcessId = Integer.parseInt(processid);

        boolean bFound = findDuplicateProcess(hwSessionInfo, null, null);

        System.out.println("\n\n\n[CDC] Retrieving Parent Process ------------------------------");
        HWProcess hwProcess = getProcessInstances(hwSessionInfo,  nProcessId);
        if (!"Recruitment".equalsIgnoreCase(hwProcess.getName())) {
            throw new Exception("Parent Process is not a Recruitment Process.");
        }
        System.out.println("\tParent Process '" + Integer.toString(hwProcess.getID()) + "' was initiated by " + hwProcess.getInitiatorName());

        System.out.println("[CDC] Retrieving Parent Process Comments------------------------------");
        HWComments hwComments = hwProcess.getComments();
        for(int i=0; i<hwComments.getCount(); i++) {
            System.out.println("\t[" + Integer.toString(i) + "] " + hwComments.getItem(i).getContents());
        }

        System.out.println("[CDC] Retrieving Parent Process Variables------------------------------");
        HWProcessVariables hwProcVars = new HWProcessVariablesImpl(hwSessionInfo.toString(), nProcessId, false);
        for(int i=0; i<hwProcVars.getCount(); i++) {
            HWProcessVariable pv = hwProcVars.getItem(i);
            System.out.println("\t[" + Integer.toString(i) + "] " + pv.getName() + "=" + pv.getValue());
        }

        System.out.println("Parent Process Attachments------------------------------");
        HWAttachments hwAttchs = new HWAttachmentsImpl(hwSessionInfo.toString(), nProcessId);
        for(int i=0; i<hwAttchs.getCount(); i++) {
            HWAttachment hwAttch = hwAttchs.getItem(i);
            System.out.println("\t[" + Integer.toString(i) + "] " + hwAttch.getFileName());
        }

        System.out.println("Process Definitions------------------------------");
        HWProcessDefinition hwProdDef = getProcessDefinitionByName (hwSessionInfo, cdcFolderName, processDefName);
        System.out.println("\tProcess Definition =" + hwProdDef.toString());

        System.out.println("Start a new Appointment Process------------------------------");
        hwWorkitem = startProcess(hwSessionInfo, hwProdDef, hwProcess, hwComments, hwProcVars, hwAttchs, startActivityName, jrno, certno, applicantname); //( hwProdDef,  hwProcess,  hwComments,  hwProcVars,  hwAttchs, params);

    }
    catch (com.hs.bf.web.beans.HWException e)
    {
        success = false;
        log.error(e);
        //e.printStackTrace();
        errorCode = e.getNumber();
        errorMsg = res.getString("en", "exception", String.valueOf(errorCode));

    }
    catch (Exception e)
    {
        success = false;
        log.error(e);
        //e.printStackTrace();
        errorCode = 99999;
        errorMsg = e.getMessage();
    }

	if(errorMsg != null)
	{
        jsonObject.put("success", false);
        jsonObject.put("message", errorMsg);
        jsonObject.put("errorcode", Integer.toString(errorCode));
	}
	else
	{
        jsonObject.put("success", true);
        jsonObject.put("message", Integer.toString(hwWorkitem.getProcessID()));
	}
	out.clear();
	response.setContentType("application/json; charset=UTF-8");
	out.write(jsonObject.toString());
	out.flush();
%>