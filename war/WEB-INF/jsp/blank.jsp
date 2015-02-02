<%@ include file="/WEB-INF/jsp/include.jsp" %>

<html>
  <head><title><fmt:message key="title"/></title>
  <link rel="stylesheet" type="text/css" href="irev-style.css" />
  <link rel="stylesheet" type="text/css" href="css/jquery.dataTables.css">
  <link rel="stylesheet" href="css/jquery-ui.css">
  <script src="js/jquery.js"></script>
  <script src="js/jquery-ui.js"></script>
  <script type="text/javascript" charset="utf8" src="js/jquery.dataTables.js"></script>
  <script type='text/javascript' src="js/popupmessage.js" ></script>
  <link rel="stylesheet" href="css/popupmessage.css">	
  </head>
  <body>
  <script>
  var text='<%=request.getParameter("text")%>';
  if(text==null || text=="" || text=='null')
	  {
	  text='${model.text} ';
	  }
      $(document).ready( function () {
    	    treeEditflashMessenger.setText(text);
    	} );     
                      
   </script>
     
  
  </body>
</html>