<%@ include file="/WEB-INF/jsp/include.jsp" %>

<html>
  <head><title><fmt:message key="title"/></title></head>
  <body>
  <script>
  parent.AssetTree.monitorstat="tools";
  </script>
    <h1> Tools place holder </h1>
    <p> Operation: <c:out value="${model.now}"/></p>
  </body>
</html>