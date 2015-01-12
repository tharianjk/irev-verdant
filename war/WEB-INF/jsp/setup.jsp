<%@ include file="/WEB-INF/jsp/include.jsp" %>

<html>
  <head><title><fmt:message key="title"/></title></head>
  <body>
  <script>
  parent.AssetTree.monitorstat="setup";
  </script>
    <h1><fmt:message key="HdrSetup"/></h1>
    <p> Operation: <c:out value="${model.now}"/></p>
  </body>
</html>