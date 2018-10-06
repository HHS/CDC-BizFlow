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
<bf:parameter id="processid" name="processid" value="" valuePattern="NoRiskyValue"/><%--madatory--%>
<bf:parameter id="jrno" name="jrno" value="" valuePattern="NoRiskyValue"/><%--madatory--%>
<bf:parameter id="certno" name="certno" value="" valuePattern="NoRiskyValue"/><%--madatory--%>

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

    HWProcessDefinition getProcessDefinitionByName(HWSessionInfo hwSessionInfo, String folderName, String procDefName) throws Exception {
        if (procDefName == null)
            throw new IllegalArgumentException("Process Definition Name not found");

        //Getting CDC folder ID
        HWFolders hwFolders = new HWFoldersImpl(hwSessionInfo.toString(), HWConstant.FOLDERTYPE_PROCESSDEFINITION);
        int folder_id_procdef_cdc = -1;
        for(int i=0; i<hwFolders.getCount(); i++) {
            HWFolder hwFolder = hwFolders.getItem(i);
            if (folderName.equalsIgnoreCase(hwFolder.getName())) {
                folder_id_procdef_cdc = hwFolder.getID();
                break;
            }
        }

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
        return hwProcDef;
    }

    HWProcess getProcessInstances(HWSessionInfo hwSessionInfo, int processId) throws Exception {
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
        return hwProcess;
    }

    HWWorkitem startProcess(HWSessionInfo hwSessionInfo, HWProcessDefinition hwProdDef, HWProcess hwProcess, HWComments hwCmts, HWProcessVariables hwProcVars, HWAttachments hwAttchs, String startActName) throws Exception {

        System.out.println("\tDEBUG-0");
	    int procid;
        HWWorkitem hwWorkitem = null;

        if (hwProdDef != null) {

            //copy PVs
            HWProcessVariables hwProcessVariables = new HWProcessVariablesImpl();

            if (hwProcVars != null && hwProcVars.getCount() > 0) {
                for (int i=0; i<hwProcVars.getCount()-1; i++) {

                    HWProcessVariable pv = hwProcVars.getItem(i);

                    if (pv.getName().equalsIgnoreCase("wihmode")) {

                    } else if (pv.getName().equalsIgnoreCase("parentProcId") ){
                        HWProcessVariable hwProcessVariable = hwProcessVariables.add();
                        hwProcessVariable.setValueType(HWConstant.RELDATATYPE_STRING);
                        hwProcessVariable.setScope(pv.getScope());
                        hwProcessVariable.setName("parentProcId");
                        hwProcessVariable.setValue(Integer.toString(hwProcess.getID()));
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

            HWAttachments hwAttachments = new HWAttachmentsImpl();
	        if (hwAttchs != null && hwAttchs.getCount() > 0) {
                for(int i=0; i<hwAttchs.getCount(); i++) {
                    HWAttachment hwAttch = hwAttchs.getItem(i);
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

            HWProcessDefinition hwProcDef = new HWProcessDefinitionImpl(hwSessionInfo.toString(), hwProdDef.getID());
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
                                        ,startActName
                                        ,hwAttachments
                                        , hwProcessVariables
                                        , outProcessID);

            procid = hwWorkitem.getProcessID();

            //Adding Comments
            if (procid > 0) {
                HWComments hwComments = new HWCommentsImpl(hwSessionInfo.toString(), procid, false);
                for (int i = 0; i < hwCmts.getCount(); i++) {
                    HWComment hwCmt = hwCmts.getItem(i);
                    HWComment newComment = hwComments.add();
                    newComment.setContents(hwCmt.getContents());
                }

                if (hwComments.getCount() > 0) {
                    hwComments.update();
                }
            }

        }

        return hwWorkitem;
    }

%>
<%
    System.out.println("\n\nstart_appointments.jsp---------------------");
    boolean success = true;
    String errorMsg = null;
	JSONObject ret = new JSONObject();
	com.hs.bf.web.beans.HWSession hwSession = hwSessionFactory.newInstance();

	int nProcessId = -1;
    HWWorkitem hwWorkitem = new HWWorkitemImpl();

	try {
		// Configuring application
		loadProperties(application);

        String cdcFolderName = CDCProperties.getProperty("usas.process.definition.folder.name", "CDC");
        String processDefName = CDCProperties.getProperty("usas.process.appointment.name", "Appointment");
        String startActivityName = CDCProperties.getProperty("usas.process.appointment.start.act.name", "Start From Recruitment");

		// Validating parameters
		nProcessId = Integer.parseInt(processid);

        System.out.println("Parent Process Instance------------------------------");
        HWProcess hwProcess = getProcessInstances(hwSessionInfo,  nProcessId);
        System.out.println("\tProcess[" + Integer.toString(hwProcess.getID()) + "] was initiated by " + hwProcess.getInitiatorName());

        System.out.println("Parent Process Comments------------------------------");
        HWComments hwComments = hwProcess.getComments();
        for(int i=0; i<hwComments.getCount(); i++) {
            System.out.println("\t[" + Integer.toString(i) + "] " + hwComments.getItem(i).getContents());
        }

        System.out.println("Parent Process Variables------------------------------");
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
        hwWorkitem = startProcess(hwSessionInfo, hwProdDef, hwProcess, hwComments, hwProcVars, hwAttchs, startActivityName); //( hwProdDef,  hwProcess,  hwComments,  hwProcVars,  hwAttchs, params);

    } catch(Exception e) {
        log.error(e);
        e.printStackTrace();
        errorMsg = "Invalid parameters." + e.toString();
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
		ret.put("message", Integer.toString(hwWorkitem.getProcessID()));
	}
	out.clear();
	response.setContentType("application/json; charset=UTF-8");
	out.write(ret.toString());
%>