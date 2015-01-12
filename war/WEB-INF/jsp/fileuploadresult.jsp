
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
 
<html>
<body>
	<h2>Import Status</h2>
 
	FileName : "
	<strong> ${fileName} </strong>" 
 
 
  <script>
     $(document).ready(function () {
    	
   	         var url = '<%=request.getContextPath()%>/assettree.htm?treemode=edit';     
   	                       parent.frames['AssetTree'].location = url; 
  		 
  	});
     </script>
</body>
</html>