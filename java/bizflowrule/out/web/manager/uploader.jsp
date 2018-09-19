<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="Author" content="Taeho Lee">
	<meta name="Keywords" content="Rule File Upload">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
	<title>Rule File uploader</title>
	<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
	<script src="../components/jquery/jquery-3.3.1.js"></script>
	<!-- Bootstrap core CSS -->
	<link href="../components/bootstrap/css/bootstrap.min.css" rel="stylesheet">

	<!-- Include all compiled plugins (below), or include individual files as needed -->
</head>
<body>
<div class="container">
	<img src="../bizflow.jpg" class="rounded float-left" style="width:160px;height:80px;"/>

	<h2>BizFlow Rule Microservice</h2>

	<div> &nbsp; </div>
	<p class="lead">This is a business rule management microservice with Drools rule engine.
		You can add or replace an existing rule with a new file written in Drool rule lanaguage.
		Purpose of this service to help devleoper not to hard-code business logic which can be changed often.
	</p>

<%
/**
 * uploader.jsp
 *
 * Company: BizFlow Corp
 *
 * Example of file uploading
 *
 * @author Taeho Lee
 * @version 1.0
 * @created: May 14, 2013
 * @modification history
 * @modified:
 *
 */
	System.out.println("[uploader.jsp] >>>>>");

	String errorMessage = null;
	File file ;
	int fileCount = 0;
	int fieldCount = 0;
	int maxFileSize = 1024;
	int maxMemSize = 1024;

	System.out.println("[uploader.jsp] loading configuration...");
	ServletContext context = pageContext.getServletContext();
	String filePath = context.getInitParameter("file-upload-data");
	String tempPath = context.getInitParameter("file-upload-temp");

	String rootPath = application.getRealPath("/").replace('\\', '/');
	filePath = rootPath + filePath;
	tempPath = rootPath + tempPath;

	String maxFileSizeStr = context.getInitParameter("file-upload-max-filesize");
	String maxMemSizeStr = context.getInitParameter("file-upload-max-memsize");
	if (null == maxFileSizeStr || "".equals(maxFileSizeStr)) { maxFileSizeStr = "5000"; }
	if (null == maxMemSizeStr || "".equals(maxMemSizeStr)) { maxMemSizeStr = "500"; }
	maxFileSize = maxFileSize * Integer.parseInt(maxFileSizeStr);
	maxFileSize = maxMemSize * Integer.parseInt(maxMemSizeStr);
	System.out.println("[uploader.jsp] filePath=" + filePath + ", tempPath=" + tempPath);

	System.out.println("[uploader.jsp]  verifing the content type...");
	String contentType = request.getContentType();
	if ((contentType.indexOf("multipart/form-data") >= 0))
	{
		DiskFileItemFactory factory = new DiskFileItemFactory();
		System.out.println("[uploader.jsp] setting maximum size that will be stored in memory");
		factory.setSizeThreshold(maxMemSize);
		System.out.println("[uploader.jsp] setting temp path if file size is larger than maxMemSize.");
		factory.setRepository(new File(tempPath));

		System.out.println("[uploader.jsp] creating a new file upload handler...");
		ServletFileUpload upload = new ServletFileUpload(factory);
		upload.setSizeMax(maxFileSize);
		try{
			System.out.println("[uploader.jsp] parsing the request to get file items.");
			List fileItems = upload.parseRequest(request);

			System.out.println("[uploader.jsp] process the uploaded field items.");
			Iterator i = fileItems.iterator();

			String paramName = null;
			String paramValue = null;
			while (i.hasNext())
			{
				FileItem fi = (FileItem)i.next();
				if (fi.isFormField())
				{
					paramName = fi.getFieldName();
					paramValue = fi.getString();
					System.out.println("[uploader.jsp] \t (field) " + paramName + "=" + paramValue);
					out.println("Field [" + Integer.toString(fieldCount++) + "] : " + paramName + "=" + paramValue + "<br>");
				}
				else
				{
					String fieldName = fi.getFieldName();
					System.out.println("[uploader.jsp] \t (file) fieldName=" + fieldName);
					String fileName = fi.getName();
					System.out.println("[uploader.jsp] \t (file) fileName=" + fileName);
					boolean isInMemory = fi.isInMemory();
					long sizeInBytes = fi.getSize();
					System.out.println("[uploader.jsp] \t (file) writing the file...");
					if (sizeInBytes > 0) {
						// Write the file
						if( fileName.lastIndexOf("\\") >= 0 ){
							file = new File( filePath +
							fileName.substring( fileName.lastIndexOf("\\"))) ;
						}else{
							file = new File( filePath +
							fileName.substring(fileName.lastIndexOf("\\")+1)) ;
						}
							fi.write( file ) ;
							out.println("File [" + Integer.toString(fileCount++) + "] : <b>" + filePath + fileName + "</b> has been uploaded sucessfully.<br>");
					}
				}
			 }
			 out.println("</body>");
			 out.println("</html>");
		}
		catch(Exception ex)
		{
			System.out.println(ex);
			errorMessage = ex.toString();
		}
	}
	else
	{
	  out.println("<p>No file uploaded</p>");
	}

	if (null != errorMessage && !"".equals(errorMessage)) {
		out.println("<h3>Fail to upload file.</h3>");
		out.println("<p>Error Details:</p>");
		out.println("<p>" + errorMessage + "</p>");
	}
	System.out.println("[uploader.jsp] <<<<<");
%>
	<div> <hr/> </div>
	<div>
		<button type="button" class="btn btn-success" onclick="history.back();">Back</button>
	</div>
</div>
</body>
<script src="../components/bootstrap/js/bootstrap.min.js"></script>
</html>
