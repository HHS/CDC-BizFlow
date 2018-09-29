<%
/**
 * index.jsp
 *
 * Company: BizFlow Corp
 *
 * Manager page to load a rule (.drl) flle, and refresh the rule caches from BizFlow Rule Service
 *
 * @author Taeho Lee
 * @version 1.0
 * @created: April 4th, 2018
 * @modification history
 * @modified:
 *
 */
%>
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
  <script language="JavaScript">
      $(document).ready(function() {
          $("#btnFlushCaches").click(function () {

              $.post( "../rest/rule/document/flushRuleAllCaches", function( data ) {
                  if (null != data) {
                      $( "#result" ).text( data.Result );
                  }
              });
              /*
              $.ajax({
                  url: "../rest/rule/document/flushRuleAllCaches", success: function (result) {
                      alert("Caches have been flushed.");
                  }
              });
              */
          });
      });
  </script>
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

    <form action="uploader.jsp" method="post" enctype="multipart/form-data">
        <div class="lead">Upload your rule (.drl) file:</div>
        <div> <input type="file" name="file1" size="50" /> </div>
        <div> <hr/> </div>
        <div>
            <button type="submit" class="btn btn-success">Upload</button>
            <button type="button" class="btn btn-success" id="btnFlushCaches">Flush Rule Caches</button>
            <button type="reset" class="btn btn-danger">Rest</button>
        </div>
    </form>

    <div> &nbsp; </div>
    <div id="result"></div>

</div>

</body>
<script src="../components/bootstrap/js/bootstrap.min.js"></script>
</html>
