<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="javax.jdo.PersistenceManager"%>
<%@page import="com.phynx.itudimana.PMF"%>
<%@page import="java.util.List"%>
<%@page import="com.phynx.itudimana.server.dto.SavedPlace"%><html>
  <body>
<%
    PersistenceManager pm = PMF.get().getPersistenceManager();
    String query = "select from " + SavedPlace.class.getName();
    List<SavedPlace> places = (List<SavedPlace>) pm.newQuery(query).execute();
    if (places.isEmpty()) {
%>
<p>No places yet.</p>
<%
    } else {
        for (SavedPlace g : places) {

%><p><b>Name : <%= g.getName() %>:: Category <%= g.getCategory() %>, GPS <%= g.getGpsloclat() %>,<%= g.getGpsloclon() %>, Tags: <%= g.getTags() %></b></p>
<%
        }
    }
    pm.close();
%>
  </body>
</html>