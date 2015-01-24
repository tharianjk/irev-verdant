

    <html>  
    <head>  
  
    <script src="js/jquery.js"></script>
	<script src="js/jquery-ui.js"></script>
    <link rel="stylesheet" type="text/css" href="irev-style.css" />	
	<link rel="stylesheet" href="css/jquery-ui.css">
 
</head>
<body>
	<h2>Import Status</h2>
 
	
	"<strong> ${fileName} </strong>" 
 
 
  <script>
     $(document).ready(function () {
    	
    	 var url = '<%=request.getContextPath()%>/assettree.htm?treemode=view';     
            parent.frames['AssetTree'].location = url; 
  		 
  	});
     </script>
</body>
</html>