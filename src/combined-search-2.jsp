<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Step 2 of 'Combined search' function - Selection of 2nd nature object filter.
  - Request params :
      * previousnatureobject -
      * natureobject -
      * idsession -
      * nextnatureobject -
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement" %>
<%@ page import="java.sql.*" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,combined_search#combined-search.jsp,combined_search_location_2";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=request.getParameter("previousnatureobject") != null ? request.getParameter("previousnatureobject") : ""%>
      <%=cm.cms("combined_search")%>
    </title>
    <script language="JavaScript" type="text/javascript">
    <!--
      var current_selected = "";
    //-->
    </script>
<script language="JavaScript" type="text/javascript">
<!--
  function MM_jumpMenu(targ,selObj,restore){ //v3.0
    eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
    if (restore) selObj.selectedIndex=0;
  }

  function setCurrentSelected(val) {
    current_selected = val;
    return true;
  }

  function choice(ctl, lov, natureobject, oper) {
    var cur_ctl = "window.document.criteria['"+ctl+"'].value";
    var val = eval(cur_ctl);
    URL = 'advanced-search-lov.jsp' + '?ctl=' + ctl + '&lov=' + lov + '&natureobject=' + natureobject + '&val=' + val + '&oper=' + oper;
    eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=400,height=500,left=490,top=0');");
  }

  function getkey(e)
  {
    if (window.event)
       return window.event.keyCode;
    else if (e)
       return e.which;
    else
       return null;
  }

  function textChanged(e)
  {
    var key, keychar;
    key = getkey(e);
    if (key == null) return true;

    // get character
    keychar = String.fromCharCode(key);
    keychar = keychar.toLowerCase();

    // control keys
    if ( key==null || key==0 || key==8 || key==9 || key==13 || key==27 ) {
      return false;
    }

    enableSaveButton();
    return true;
  }

  // action specifies what to do (how to modify the submited url...
  function submitCriteriaForm(criteria, idnode) {
    document.criteria.criteria.value=criteria.value;
    document.criteria.attribute.value="";
    document.criteria.operator.value="";
    document.criteria.firstvalue.value="";
    document.criteria.lastvalue.value="";
    document.criteria.idnode.value=idnode;
    document.criteria.action.value="";
    document.criteria.submit();
  }

  function enableSaveButton() {
    document.criteria.Save.disabled=false;
    document.criteria.Search.disabled=true;
    document.getElementById("status").innerHTML="<span style=\"color:Red\"><%=cm.cms("press_save_to_save_criteria")%></span>"
  }

  function disableSaveButton() {
    document.criteria.Save.disabled=true;
    document.criteria.Search.disabled=false;
    document.getElementById("status").innerHTML="<span style=\"color:Red\"><%=cm.cms("criteria_saved")%></span>"
  }

  function submitAttributeForm(attribute, idnode) {
    document.criteria.criteria.value="";
    document.criteria.attribute.value=attribute.value;
    document.criteria.operator.value="";
    document.criteria.firstvalue.value="";
    document.criteria.lastvalue.value="";
    document.criteria.idnode.value=idnode;
    document.criteria.action.value="";
    document.criteria.submit();
  }

  function submitOperatorForm(operator, idnode) {
    document.criteria.criteria.value="";
    document.criteria.attribute.value="";
    document.criteria.operator.value=operator.value;
    document.criteria.firstvalue.value="";
    document.criteria.lastvalue.value="";
    document.criteria.idnode.value=idnode;
    document.criteria.action.value="";
    document.criteria.submit();
  }

  function submitFirstValueForm(firstvalue, idnode) {
    if(firstvalue.value == "") {
      firstvalue.value = document.criteria.oldfirstvalue.value;
      alert('<%=cm.cms("previous_values_was_restored")%>');
      firstvalue.focus();
		  return(false);
    }

    document.criteria.criteria.value="";
    document.criteria.attribute.value="";
    document.criteria.operator.value="";
    document.criteria.firstvalue.value=firstvalue.value;
    document.criteria.lastvalue.value="";
    document.criteria.idnode.value=idnode;
    document.criteria.action.value="";
    var ofv = document.criteria.oldfirstvalue.value;
    var fv = document.criteria.firstvalue.value;
    if(ofv != fv) {
      if(current_selected == "first_binocular") {
        var lov="";
        var natureobject="<%=request.getParameter("natureobject")%>";
        var oper="";
        lov = eval("window.document.criteria['Attribute"+idnode+"'].value");
        choice("First_Value"+idnode, lov, natureobject, oper);
      }
      document.criteria.submit();
    }
  }

  function submitLastValueForm(lastvalue, idnode) {
    if(lastvalue.value == "") {
      lastvalue.value = document.criteria.oldlastvalue.value;
      alert('<%=cm.cms("previous_values_was_restored")%>');
      firstvalue.focus();
		  return false;
    }

    document.criteria.criteria.value="";
    document.criteria.attribute.value="";
    document.criteria.operator.value="";
    document.criteria.firstvalue.value="";
    document.criteria.lastvalue.value=lastvalue.value;
    document.criteria.idnode.value=idnode;
    document.criteria.action.value="";
    var olv = document.criteria.oldlastvalue.value;
    var lv = document.criteria.lastvalue.value;
    if(olv != lv) {
      if(current_selected == "last_binocular") {
        var lov="";
        var natureobject="<%=request.getParameter("natureobject")%>";
        var oper="";
        lov = eval("window.document.criteria['Attribute"+idnode+"'].value");
        choice("Last_Value"+idnode, lov, natureobject, oper);
      }
      document.criteria.submit();
    }
  }

  function submitButtonForm(action, idnode) {
    document.criteria.criteria.value="";
    document.criteria.attribute.value="";
    document.criteria.operator.value="";
    document.criteria.firstvalue.value="";
    document.criteria.lastvalue.value="";
    document.criteria.idnode.value=idnode;
    document.criteria.action.value=action;
    document.criteria.submit();
  }

  function saveFirstValue(val) {
    document.criteria.oldfirstvalue.value=val.value;
  }

  function saveLastValue(val) {
    document.criteria.oldlastvalue.value=val.value;
  }

  function submitClearData() {
    document.criteria.criteria.value="";
    document.criteria.attribute.value="";
    document.criteria.operator.value="";
    document.criteria.firstvalue.value="";
    document.criteria.lastvalue.value="";
    document.criteria.idnode.value="";
    document.criteria.action.value="clear";
    document.criteria.submit();
  }

  function submitKeepData(natureobject) {
    document.criteria.criteria.value="";
    document.criteria.attribute.value="";
    document.criteria.operator.value="";
    document.criteria.firstvalue.value="";
    document.criteria.lastvalue.value="";
    document.criteria.idnode.value="";
    if (document.criteria.natureobject != null && natureobject != null)
       document.criteria.natureobject.value=natureobject;
    document.criteria.action.value="keep";
    document.criteria.submit();
  }

  function changeNatureObject(action) {
    document.criteria.action.value=action;
    document.criteria.submit();
  }
//-->
</script>

  </head>
  <body>
    <div id="visual-portal-wrapper">
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_HEADER" ) )%>
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns" class="visualColumnHideTwo">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
              	<jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value="<%=btrail%>" />
                  <jsp:param name="helpLink" value="combined-help.jsp" />
                </jsp:include>
                <a name="documentContent"></a>
                <div class="documentActions">
                  <h5 class="hiddenStructure">Document Actions</h5>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="Print this page"
                            title="Print this page" /></a>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="Toggle full screen mode"
                             title="Toggle full screen mode" /></a>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
                <%=cm.cmsText("generic_combined-search-step2_01")%>
                <br />
                <table summary="layout" border="0">
                  <tr>
                    <td id="status">
                      <%=cm.cmsText("specify_the_search_criteria")%>
                    </td>
                  </tr>
                </table>
                <%
                  if(request.getParameter("combinednatureobject1") != null && SessionManager.getCombinednatureobject1() == null) {
                    SessionManager.setCombinednatureobject1(request.getParameter("combinednatureobject1"));
                    SessionManager.setCombinedlistcriteria1(request.getParameter("combinedlistcriteria1"));
                    SessionManager.setCombinedexplainedcriteria1(request.getParameter("combinedexplainedcriteria1"));
                  }
                  if(request.getParameter("sourcedbcriteria") != null && SessionManager.getSourcedb() == null) {
                    SessionManager.setSourcedb(request.getParameter("sourcedbcriteria"));
                  }

                  String combinednatureobject2 = "";
                  String combinedlistcriteria2 = "";
                  String combinedexplainedcriteria2 = "";
                  String sourcedbcriteria = "";

                  String IdSession = request.getParameter("idsession");
                  String NatureObject = request.getParameter("natureobject");
                  String PreviousNatureObject = request.getParameter("previousnatureobject");
                  String NextNatureObject = request.getParameter("nextnatureobject");
                  //  System.out.println("NatureObject = " + NatureObject);
                  if(IdSession == null || IdSession.length() == 0 || IdSession.equalsIgnoreCase("undefined")) {
                    IdSession = request.getSession().getId();
                  }
                  if(NatureObject == null || NatureObject.length() == 0 || NatureObject.equalsIgnoreCase("undefined")) {
                    System.out.println("No nature object found - Default to Habitats");
                    PreviousNatureObject = "Species";
                    NatureObject = "Habitat";
                    NextNatureObject = "Sites";
                  }

                  String SourceDB = "";
                  if(request.getParameter("DIPLOMA") != null) SourceDB += ",'DIPLOMA'";
                  if(request.getParameter("CDDA_NATIONAL") != null) SourceDB += ",'CDDA_NATIONAL'";
                  if(request.getParameter("CDDA_INTERNATIONAL") != null) SourceDB += ",'CDDA_INTERNATIONAL'";
                  if(request.getParameter("BIOGENETIC") != null) SourceDB += ",'BIOGENETIC'";
                  if(request.getParameter("NATURA2000") != null) SourceDB += ",'NATURA2000'";
                  if(request.getParameter("NATURENET") != null) SourceDB += ",'NATURENET'";
                  if(request.getParameter("EMERALD") != null) SourceDB += ",'EMERALD'";
                  if(request.getParameter("CORINE") != null) SourceDB += ",'CORINE'";

                  if(SourceDB.equalsIgnoreCase("")) {
                    SourceDB = "''";
                  } else {
                    if(SourceDB.length() > 1) {
                      SourceDB = SourceDB.substring(1, SourceDB.length());
                    }
                  }
                  sourcedbcriteria = SourceDB;
                %>
                <form method="post" action="combined-search-2.jsp" name="criteria">
                <strong><%=cm.cmsText("step_2")%></strong>
                <%
                  if(PreviousNatureObject.equalsIgnoreCase("Species")) {
                %>
                <%=cm.cmsText("generic_combined-search-step2_03")%>
                <%
                  }
                  if(PreviousNatureObject.equalsIgnoreCase("Habitat")) {
                %>
                <%=cm.cmsText("generic_combined-search-step2_04")%>
                <%
                  }
                  if(PreviousNatureObject.equalsIgnoreCase("Sites")) {
                %>
                <%=cm.cmsText("generic_combined-search-step2_05")%>
                <%
                  }
                %>
                <hr width="100%" size="1" align="left" />
                <input type="hidden" name="criteria" value="" />
                <input type="hidden" name="attribute" value="" />
                <input type="hidden" name="operator" value="" />
                <input type="hidden" name="firstvalue" value="" />
                <input type="hidden" name="lastvalue" value="" />
                <input type="hidden" name="oldfirstvalue" value="" />
                <input type="hidden" name="oldlastvalue" value="" />
                <input type="hidden" name="action" value="" />
                <input type="hidden" name="idnode" value="" />
                <input type="hidden" name="natureobject" value="<%=NatureObject%>" />
                <input type="hidden" name="previousnatureobject" value="<%=PreviousNatureObject%>" />
                <input type="hidden" name="nextnatureobject" value="<%=NextNatureObject%>" />
                <input type="hidden" name="idsession" value="<%=IdSession%>" />
                <%
                  //  System.out.println("NatureObject = " + NatureObject);
                  //  System.out.println("IdSession = " + IdSession);
                  int SQL_LIMIT = Integer.parseInt(application.getInitParameter("SQL_LIMIT"));

                  String SQL_DRV = application.getInitParameter("JDBC_DRV");
                  String SQL_URL = application.getInitParameter("JDBC_URL");
                  String SQL_USR = application.getInitParameter("JDBC_USR");
                  String SQL_PWD = application.getInitParameter("JDBC_PWD");

                  //Utilities.dumpRequestParams(request);
                  String p_action = request.getParameter("action");
                  if(p_action == null) p_action = "";
                  String p_idnode = request.getParameter("idnode");
                  if(p_idnode == null) p_idnode = "";
                  String p_criteria = request.getParameter("criteria");
                  if(p_criteria == null) p_criteria = "";
                  String p_attribute = request.getParameter("attribute");
                  if(p_attribute == null) p_attribute = "";
                  String p_operator = request.getParameter("operator");
                  if(p_operator == null) p_operator = "";
                  String p_firstvalue = request.getParameter("firstvalue");
                  if(p_firstvalue == null) p_firstvalue = "";
                  String p_lastvalue = request.getParameter("lastvalue");
                  if(p_lastvalue == null) p_lastvalue = "";

                  ro.finsiel.eunis.search.CombinedSearch tas = new ro.finsiel.eunis.search.CombinedSearch();
                  tas.SetSQLLimit(SQL_LIMIT);

                  tas.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);

                  //prelucram actiunea curenta
                  if(p_action.equalsIgnoreCase("reset")) {
                    ro.finsiel.eunis.search.CombinedSearch tsas;
                    tsas = new ro.finsiel.eunis.search.CombinedSearch();
                    tsas.SetSQLLimit(SQL_LIMIT);
                    tsas.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);
                    String attribute = "ScientificName";
                    if(NatureObject.equalsIgnoreCase("Sites")) {
                      attribute = "Name";
                    }
                    tsas.DeleteRoot(IdSession, NatureObject, attribute);
                  }

                  if(p_action.equalsIgnoreCase("deleteroot")) {
                    //out.println("Delete root");
                    String attribute = "ScientificName";
                    if(NatureObject.equalsIgnoreCase("Sites")) {
                      attribute = "Name";
                    }
                    if(!tas.DeleteRootNoInitialize(IdSession, NatureObject, attribute)) {
                      System.out.println("Error deleting root!");
                      %>
                      <script language="JavaScript" type="text/javascript">
                      <!--
                      alert('<%=cm.cms("error_deleting_root")%>');
                      //-->
                      </script>
                      <%
                    }
                  }

                  if(p_action.equalsIgnoreCase("addroot")) {
                    //out.println("Add root");
                    String attribute = "ScientificName";
                    if(NatureObject.equalsIgnoreCase("Sites")) {
                      attribute = "Name";
                    }
                    tas.CreateInitialBranch(IdSession, NatureObject, attribute);
                  }

                  if(p_action.equalsIgnoreCase("add")) {
                    //out.println("Add branch for node: "+p_idnode);
                    String attribute = "ScientificName";
                    if(NatureObject.equalsIgnoreCase("Sites")) {
                      attribute = "Name";
                    }
                    if(!tas.InsertBranch(p_idnode, IdSession, NatureObject, attribute)) {
                %>
                <script language="JavaScript" type="text/javascript">
                <!--
                  alert('<%=cm.cms("error_adding_branch")%>');
                //-->
                </script>
                <%
                    }
                  }

                  if(p_action.equalsIgnoreCase("delete")) {
                    //out.println("Delete branch for node: "+p_idnode);
                    if(!tas.DeleteBranch(p_idnode, IdSession, NatureObject)) {
                      System.out.println("Error deleting branch!");
                      %>
                      <script language="JavaScript" type="text/javascript">
                      <!--
                      alert('<%=cm.cms("error_deleting_branch")%>');
                      //-->
                      </script>
                <%
                    }
                  }

                  if(p_action.equalsIgnoreCase("compose")) {
                    //out.println("Compose branch for node: "+p_idnode);
                    if(!tas.ComposeBranch(p_idnode, IdSession, NatureObject)) {
                      System.out.println("Error composing branch!");
                      %>
                      <script language="JavaScript" type="text/javascript">
                      <!--
                      alert('<%=cm.cms("error_composing_branch")%>');
                      //-->
                      </script>
                      <%
                    }
                  }

                  if(p_action.length() == 0) {
                    if(p_criteria.length() != 0) {
                      //out.println("New criteria: "+p_criteria+" for node: "+p_idnode);
                      tas.ChangeCriteria(p_idnode, IdSession, NatureObject, p_criteria);
                    }
                    if(p_attribute.length() != 0) {
                      //out.println("New attribute: "+p_attribute+" for node: "+p_idnode);
                      tas.ChangeAttribute(p_idnode, IdSession, NatureObject, p_attribute);
                    }
                    if(p_operator.length() != 0) {
                      //out.println("New operator: "+p_operator+" for node: "+p_idnode);
                      tas.ChangeOperator(p_idnode, IdSession, NatureObject, p_operator);
                    }
                    if(p_firstvalue.length() != 0) {
                      //out.println("New first value: "+p_firstvalue+" for node: "+p_idnode);
//      System.out.println("first value:" + p_firstvalue);
                      tas.ChangeFirstValue(p_idnode, IdSession, NatureObject, p_firstvalue);
                    }
                    if(p_lastvalue.length() != 0) {
                      //out.println("New last value: "+p_lastvalue+" for node: "+p_idnode);
//      System.out.println("last value:" + p_lastvalue);
                      tas.ChangeLastValue(p_idnode, IdSession, NatureObject, p_lastvalue);
                    }
                  }

                  String SQL = "";
                  String NodeType = "";
                  String IdNode = "";
                  String val = "";
                  String selected = "";
                  String currentAttribute = "";
                  String currentOperator = "";
                  String currentValue = "";

                  Connection con = null;
                  PreparedStatement ps = null;
                  ResultSet rs = null;

                  try {
                    Class.forName(SQL_DRV);
                    con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
                  }
                  catch(Exception e) {
                    e.printStackTrace();
                    return;
                  }

                  SQL = "SELECT ";
                  SQL += "EUNIS_COMBINED_SEARCH.ID_NODE,";
                  SQL += "EUNIS_COMBINED_SEARCH.NODE_TYPE,";
                  SQL += "EUNIS_COMBINED_SEARCH_CRITERIA.ATTRIBUTE,";
                  SQL += "EUNIS_COMBINED_SEARCH_CRITERIA.OPERATOR,";
                  SQL += "EUNIS_COMBINED_SEARCH_CRITERIA.FIRST_VALUE,";
                  SQL += "EUNIS_COMBINED_SEARCH_CRITERIA.LAST_VALUE ";
                  SQL += "FROM ";
                  SQL += "EUNIS_COMBINED_SEARCH ";
                  SQL += "LEFT OUTER JOIN EUNIS_COMBINED_SEARCH_CRITERIA ON (EUNIS_COMBINED_SEARCH.ID_SESSION = EUNIS_COMBINED_SEARCH_CRITERIA.ID_SESSION) AND (EUNIS_COMBINED_SEARCH.NATURE_OBJECT = EUNIS_COMBINED_SEARCH_CRITERIA.NATURE_OBJECT) AND (EUNIS_COMBINED_SEARCH.ID_NODE = EUNIS_COMBINED_SEARCH_CRITERIA.ID_NODE) ";
                  SQL += "WHERE (EUNIS_COMBINED_SEARCH.ID_SESSION='" + IdSession + "') ";
                  SQL += "AND (EUNIS_COMBINED_SEARCH.NATURE_OBJECT='" + NatureObject + "') ";
                  SQL += "ORDER BY ";
                  SQL += "EUNIS_COMBINED_SEARCH.ID_NODE ";

                  try {
                    ps = con.prepareStatement(SQL);
                  } catch(SQLException e) {
                    e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
                  }
                  try {
                    rs = ps.executeQuery();
                  } catch(SQLException e) {
                    e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
                  }
                  if(rs.isBeforeFirst()) {
                    //if(1==1){
                    while(rs.next()) {
                      IdNode = rs.getString("ID_NODE");
                      NodeType = rs.getString("NODE_TYPE");
                      if(!IdNode.equalsIgnoreCase("0")) {
                        out.println("&nbsp;");
                        out.println("&nbsp;");
                      }
                      for(int i = 1; i <= IdNode.length() * 3; i++) {
                        if(!IdNode.equalsIgnoreCase("0")) {
                          out.println("&nbsp;");
                        }
                      }

                      if(!IdNode.equalsIgnoreCase("0")) {
                        if(IdNode.length() <= 3) {
                %>
                          <a title="<%=cm.cms("add_criterion")%>" href="javascript:submitButtonForm('add','<%=IdNode%>');"><img alt="<%=cm.cms("add_criterion")%>" border="0" src="images/mini/add.gif" width="13" height="13" title="<%=cm.cms("add_criterion")%>" /></a><%=cm.cmsTitle("add_criterion")%>
                  <%
                    }
                    if(IdNode.equalsIgnoreCase("1")) {
                  %>
                  <img alt="" border="0" src="images/mini/space.gif" />
                  <%
                    } else {
                  %>
                      <a title="<%=cm.cms("delete_criterion")%>" href="javascript:submitButtonForm('delete','<%=IdNode%>');"><img border="0" src="images/mini/delete.gif" alt="<%=cm.cms("delete_criterion")%>" width="13" height="13" title="<%=cm.cms("delete_criterion")%>" /></a><%=cm.cmsTitle("delete_criterion")%>
                  <%
                    }
                    if(IdNode.length() < 3) {
                      if(NodeType.equalsIgnoreCase("Criteria")) {
                      %>
                        <a title="<%=cm.cms("compose_criterion")%>" href="javascript:submitButtonForm('compose','<%=IdNode%>');"><img alt="<%=cm.cms("compose_criterion")%>" border="0" src="images/mini/compose.gif" width="13" height="13" title="<%=cm.cms("compose_criterion")%>" /></a><%=cm.cmsTitle("compose_criterion")%>
                      <%
                      }
                    }
                    out.println(" " + IdNode);
                  } else {
                    %>
                    <a title="<%=cm.cms("delete_root_criterion")%>" href="javascript:submitButtonForm('deleteroot','<%=IdNode%>');"><img alt="<%=cm.cms("delete_root_criterion")%>" border="0" src="images/mini/delete.gif" width="13" height="13" title="<%=cm.cms("delete_root_criterion")%>" /></a><%=cm.cmsTitle("delete_root_criterion")%>
                    <%
                  }

                  String cmsCriteria = cm.cms("criteria");
                  String cmsAttribute = cm.cms("advanced_attribute");
                  String cmsOperator = cm.cms("operator");
                  String cmsAll = cm.cms("all");
                  String cmsAny = cm.cms("any");
                  String cmsFollowingCriteria = cm.cms("of_following_criteria_are_met");

                  if (!NodeType.equalsIgnoreCase("Criteria")) {
                    out.println("<label for=\"Criteria" + IdNode + "\" class=\"noshow\">"+cmsCriteria+"</label>");
                    out.println("<select name=\"Criteria" + IdNode + "\" onchange=\"submitCriteriaForm(this,'" + IdNode + "','" + IdSession + "','" + NatureObject + "')\" title=\""+cmsCriteria+"\" id=\"Criteria"+ IdNode + "\">");
                    if (NodeType.equalsIgnoreCase("All")) {
                      selected = " selected=\"selected\"";
                    } else {
                      selected = "";
                    }
                    out.println("<option" + selected + " value=\"All\">"+cmsAll+"</option>");
                    if (NodeType.equalsIgnoreCase("Any")) {
                      selected = " selected=\"selected\"";
                    } else {
                      selected = "";
                    }
                    out.println("<option" + selected + " value=\"Any\">"+cmsAny+"</option>");
                    out.println("</select> " + cmsFollowingCriteria + ":");
                    out.println("<br />");
                  } else {
                    val = rs.getString("ATTRIBUTE");
                    currentAttribute = val;
                    out.println("<label for=\"Attribute" + IdNode + "\" class=\"noshow\">"+cmsAttribute+"</label>");
                    out.println("<select name=\"Attribute" + IdNode + "\" onchange=\"submitAttributeForm(this,'" + IdNode + "','" + IdSession + "','" + NatureObject + "')\" title=\""+cmsAttribute+"\" id=\"Attribute" + IdNode + "\">");

                    if (NatureObject.equalsIgnoreCase("Habitat")) {
                      if (val.equalsIgnoreCase("ScientificName")) { selected = " selected=\"selected\""; } else { selected = ""; }
                      out.println("<option" + selected + " value=\"ScientificName\">" + cm.cms("name") + "</option>");
                      if (val.equalsIgnoreCase("Code")) { selected = " selected=\"selected\""; } else { selected = ""; }
                      out.println("<option" + selected + " value=\"Code\">" + cm.cms("code_eunis_annex") + "</option>");
                      if (val.equalsIgnoreCase("LegalInstruments")) { selected = " selected=\"selected\""; } else { selected = ""; }
                      out.println("<option" + selected + " value=\"LegalInstruments\">" + cm.cms("legal_instruments") + "</option>");
                      if (val.equalsIgnoreCase("SourceDatabase")) { selected = " selected=\"selected\""; } else { selected = ""; }
                      out.println("<option" + selected + " value=\"SourceDatabase\">" + cm.cms("source_database") + "</option>");
                      if (val.equalsIgnoreCase("Country")) { selected = " selected=\"selected\""; } else { selected = ""; }
                      out.println("<option" + selected + " value=\"Country\">" + cm.cms("country") + "</option>");
                      if (val.equalsIgnoreCase("Biogeoregion")) { selected = " selected=\"selected\""; } else { selected = ""; }
                      out.println("<option" + selected + " value=\"Biogeoregion\">" + cm.cms("biogeographic_region") + "</option>");
                      if (val.equalsIgnoreCase("Author")) { selected = " selected=\"selected\""; } else { selected = ""; }
                      out.println("<option" + selected + " value=\"Author\">" + cm.cms("reference_author") + "</option>");
                      if (val.equalsIgnoreCase("Title")) { selected = " selected=\"selected\""; } else { selected = ""; }
                      out.println("<option" + selected + " value=\"Title\">" + cm.cms("reference_title") + "</option>");
                      if (val.equalsIgnoreCase("Altitude")) { selected = " selected=\"selected\""; } else { selected = ""; }
                      out.println("<option" + selected + " value=\"Altitude\">" + cm.cms("altitude") + "</option>");
                      if (val.equalsIgnoreCase("Chemistry")) { selected = " selected=\"selected\""; } else { selected = ""; }
                      out.println("<option" + selected + " value=\"Chemistry\">" + cm.cms("chemistry") + "</option>");
                      if (val.equalsIgnoreCase("Climate")) { selected = " selected=\"selected\""; } else { selected = ""; }
                      out.println("<option" + selected + " value=\"Climate\">" + cm.cms("climate") + "</option>");
                      if (val.equalsIgnoreCase("Cover")) { selected = " selected=\"selected\""; } else { selected = ""; }
                      out.println("<option" + selected + " value=\"Cover\">" + cm.cms("cover") + "</option>");
                      if (val.equalsIgnoreCase("Depth")) { selected = " selected=\"selected\""; } else { selected = ""; }
                      out.println("<option" + selected + " value=\"Depth\">" + cm.cms("depth") + "</option>");
                      if (val.equalsIgnoreCase("Geomorph")) { selected = " selected=\"selected\""; } else { selected = ""; }
                      out.println("<option" + selected + " value=\"Geomorph\">" + cm.cms("geomorph") + "</option>");
                      if (val.equalsIgnoreCase("Humidity")) { selected = " selected=\"selected\""; } else { selected = ""; }
                      out.println("<option" + selected + " value=\"Humidity\">" + cm.cms("humidity") + "</option>");
                      if (val.equalsIgnoreCase("LifeForm")) { selected = " selected=\"selected\""; } else { selected = ""; }
                      out.println("<option" + selected + " value=\"LifeForm\">" + cm.cms("life_form") + "</option>");
                      if (val.equalsIgnoreCase("LightIntensity")) { selected = " selected=\"selected\""; } else { selected = ""; }
                      out.println("<option" + selected + " value=\"LightIntensity\">" + cm.cms("light_intensity") + "</option>");
                      if (val.equalsIgnoreCase("Salinity")) { selected = " selected=\"selected\""; } else { selected = ""; }
                      out.println("<option" + selected + " value=\"Salinity\">" + cm.cms("salinity") + "</option>");
                      if (val.equalsIgnoreCase("Spatial")) { selected = " selected=\"selected\""; } else { selected = ""; }
                      out.println("<option" + selected + " value=\"Spatial\">" + cm.cms("spatial") + "</option>");
                      if (val.equalsIgnoreCase("Substrate")) { selected = " selected=\"selected\""; } else { selected = ""; }
                      out.println("<option" + selected + " value=\"Substrate\">" + cm.cms("substrate") + "</option>");
                      if (val.equalsIgnoreCase("Temporal")) { selected = " selected=\"selected\""; } else { selected = ""; }
                      out.println("<option" + selected + " value=\"Temporal\">" + cm.cms("temporal") + "</option>");
                      if (val.equalsIgnoreCase("Water")) { selected = " selected=\"selected\""; } else { selected = ""; }
                      out.println("<option" + selected + " value=\"Water\">" + cm.cms("water") + "</option>");
                      if (val.equalsIgnoreCase("Usage")) { selected = " selected=\"selected\""; } else { selected = ""; }
                      out.println("<option" + selected + " value=\"Usage\">" + cm.cms("usage") + "</option>");
                      out.println("</select>");
                      %>
                      <%=cm.cmsInput("name")%>
                      <%=cm.cmsInput("code_eunis_annex")%>
                      <%=cm.cmsInput("legal_instruments")%>
                      <%=cm.cmsInput("source_database")%>
                      <%=cm.cmsInput("country")%>
                      <%=cm.cmsInput("biogeographic_region")%>
                      <%=cm.cmsInput("reference_author")%>
                      <%=cm.cmsInput("reference_title")%>
                      <%=cm.cmsInput("altitude")%>
                      <%=cm.cmsInput("chemistry")%>
                      <%=cm.cmsInput("climate")%>
                      <%=cm.cmsInput("cover")%>
                      <%=cm.cmsInput("depth")%>
                      <%=cm.cmsInput("geomorph")%>
                      <%=cm.cmsInput("humidity")%>
                      <%=cm.cmsInput("life_form")%>
                      <%=cm.cmsInput("light_intensity")%>
                      <%=cm.cmsInput("marine")%>
                      <%=cm.cmsInput("salinity")%>
                      <%=cm.cmsInput("spatial")%>
                      <%=cm.cmsInput("substrate")%>
                      <%=cm.cmsInput("temporal")%>
                      <%=cm.cmsInput("tidal")%>
                      <%=cm.cmsInput("water")%>
                      <%=cm.cmsInput("usage")%>
                      <%
                    } else if(NatureObject.equalsIgnoreCase("Species")) {
                      if(val.equalsIgnoreCase("ScientificName")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"ScientificName\">"+cm.cms("scientific_name")+"</option>");
                      if(val.equalsIgnoreCase("VernacularName")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"VernacularName\">"+cm.cms("vernacular_name")+"</option>");
                      if(val.equalsIgnoreCase("Group")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"Group\">"+cm.cms("group")+"</option>");
                      if(val.equalsIgnoreCase("ThreatStatus")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"ThreatStatus\">"+cm.cms("threat_status")+"</option>");
                      if(val.equalsIgnoreCase("InternationalThreatStatus")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"InternationalThreatStatus\">"+cm.cms("international_threat_status")+"</option>");
                      if(val.equalsIgnoreCase("Country")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"Country\">"+cm.cms("country")+"</option>");
                      if(val.equalsIgnoreCase("Biogeoregion")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"Biogeoregion\">"+cm.cms("biogeoregion")+"</option>");
                      if(val.equalsIgnoreCase("Author")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"Author\">"+cm.cms("reference_author")+"</option>");
                      if(val.equalsIgnoreCase("Title")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"Title\">"+cm.cms("reference_title")+"</option>");
                      if(val.equalsIgnoreCase("LegalInstrument")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"LegalInstrument\">"+cm.cms("species_advanced_19")+"</option>");
                      if(val.equalsIgnoreCase("Taxonomy")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"Taxonomy\">"+cm.cms("taxonomy")+"</option>");
                      if(val.equalsIgnoreCase("Abundance")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"Abundance\">"+cm.cms("abundance")+"</option>");
                      if(val.equalsIgnoreCase("Trend")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"Trend\">"+cm.cms("trend")+"</option>");
                      if(val.equalsIgnoreCase("DistributionStatus")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"DistributionStatus\">"+cm.cms("distribution_status")+"</option>");
                      out.println("</select>");
                      %>
                      <%=cm.cmsInput("scientific_name")%>
                      <%=cm.cmsInput("vernacular_name")%>
                      <%=cm.cmsInput("group")%>
                      <%=cm.cmsInput("threat_status")%>
                      <%=cm.cmsInput("international_threat_status")%>
                      <%=cm.cmsInput("country")%>
                      <%=cm.cmsInput("biogeoregion")%>
                      <%=cm.cmsInput("reference_author")%>
                      <%=cm.cmsInput("reference_title")%>
                      <%=cm.cmsInput("species_advanced_19")%>
                      <%=cm.cmsInput("taxonomy")%>
                      <%=cm.cmsInput("abundance")%>
                      <%=cm.cmsInput("trend")%>
                      <%=cm.cmsInput("distribution_status")%>
                      <%
                    } else if(NatureObject.equalsIgnoreCase("Sites")) {
                      if(val.equalsIgnoreCase("Name")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"Name\">"+cm.cms("name")+"</option>");
                      if(val.equalsIgnoreCase("Code")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"Code\">"+cm.cms("code_column")+"</option>");
                      if(val.equalsIgnoreCase("DesignationYear")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"DesignationYear\">"+cm.cms("designation_year")+"</option>");
                      if(val.equalsIgnoreCase("Country")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"Country\">"+cm.cms("country")+"</option>");
                      if(val.equalsIgnoreCase("Size")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"Size\">"+cm.cms("size")+"</option>");
                      if(val.equalsIgnoreCase("Longitude")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"Longitude\">"+cm.cms("longitude")+"</option>");
                      if(val.equalsIgnoreCase("Latitude")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"Latitude\">"+cm.cms("latitude")+"</option>");
                      if(val.equalsIgnoreCase("MinimumAltitude")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"MinimumAltitude\">"+cm.cms("min_altitude")+"</option>");
                      if(val.equalsIgnoreCase("MaximumAltitude")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"MaximumAltitude\">"+cm.cms("max_altitude")+"</option>");
                      if(val.equalsIgnoreCase("MeanAltitude")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"MeanAltitude\">"+cm.cms("mean_altitude")+"</option>");
                      if(val.equalsIgnoreCase("Designation")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"Designation\">"+cm.cms("designation_type")+"</option>");
                      if(val.equalsIgnoreCase("HumanActivity")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"HumanActivity\">"+cm.cms("human_activity")+"</option>");
                      if(val.equalsIgnoreCase("Motivation")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"Motivation\">"+cm.cms("motivation")+"</option>");
                      if(val.equalsIgnoreCase("RegionCode")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"RegionCode\">"+cm.cms("region")+"</option>");
                      out.println("</select>");
                      %>
                      <%=cm.cmsInput("name")%>
                      <%=cm.cmsInput("code_column")%>
                      <%=cm.cmsInput("designation_year")%>
                      <%=cm.cmsInput("country")%>
                      <%=cm.cmsInput("size")%>
                      <%=cm.cmsInput("longitude")%>
                      <%=cm.cmsInput("latitude")%>
                      <%=cm.cmsInput("min_altitude")%>
                      <%=cm.cmsInput("max_altitude")%>
                      <%=cm.cmsInput("mean_altitude")%>
                      <%=cm.cmsInput("designation_type")%>
                      <%=cm.cmsInput("human_activity")%>
                      <%=cm.cmsInput("motivation")%>
                      <%
                    }

                    out.println("&nbsp;");

                    val=rs.getString("OPERATOR");
                    currentOperator = val;
                    out.println("<label for=\"Operator" + IdNode + "\" class=\"noshow\">"+cmsOperator+"</label>");
                    out.println("<select name=\"Operator" + IdNode + "\" onchange=\"submitOperatorForm(this,'" + IdNode + "','" + IdSession + "','" + NatureObject + "')\" title=\""+cmsOperator+"\" id=\"Operator" + IdNode + "\">");

                    if(val.equalsIgnoreCase("Equal")) { selected=" selected=\"selected\""; } else { selected=""; }
                    out.println("<option"+selected+" value=\"Equal\">"+cm.cms("equal")+"</option>");
                    if(val.equalsIgnoreCase("Contains")) { selected=" selected=\"selected\""; } else { selected=""; }
                    out.println("<option"+selected+" value=\"Contains\">"+cm.cms("contains")+"</option>");
                    if(val.equalsIgnoreCase("Between")) { selected=" selected=\"selected\""; } else { selected=""; }
                    out.println("<option"+selected+" value=\"Between\">"+cm.cms("between")+"</option>");
                    if(val.equalsIgnoreCase("Regex")) { selected=" selected=\"selected\""; } else { selected=""; }
                    out.println("<option"+selected+" value=\"Regex\">Regex</option>");
                    out.println("</select>");
                    %>
                    <%=cm.cmsInput("equal")%>
                    <%=cm.cmsInput("contains")%>
                    <%=cm.cmsInput("between")%>
                    <%
                    out.println("&nbsp;");

                    val = rs.getString("FIRST_VALUE");
                    currentValue = val;
                %>
                    <label for="First_Value<%=IdNode%>" class="noshow"><%=cm.cms("list_of_values")%></label>
                    <input type="text" title="<%=cm.cms("list_of_values")%>" id="First_Value<%=IdNode%>"
                           name="First_Value<%=IdNode%>" size="25" value="<%=val%>"
                           onblur="submitFirstValueForm(this,'<%=IdNode%>','<%=IdSession%>','<%=NatureObject%>');" onfocus="saveFirstValue(this)" onkeyup="textChanged(event)" />
                    <%=cm.cmsTitle("list_of_values")%>
                    <a title="<%=cm.cms("list_of_values")%>" href="javascript:choice('First_Value<%=IdNode%>','<%=currentAttribute%>','<%=NatureObject%>','<%=currentOperator%>')" name="first_binocular" onmouseover="setCurrentSelected(this.name)" onmouseout="setCurrentSelected('')"><img border="0" src="images/helper/helper.gif" width="11" height="18" alt="<%=cm.cms("list_of_values")%>" /></a>
                <%
                    if (rs.getString("OPERATOR").equalsIgnoreCase("Between")) {
                      out.println(cm.cmsText("and"));
                      val = rs.getString("LAST_VALUE");
                      currentValue = val;
                %>
                    <label for="Last_Value<%=IdNode%>" class="noshow"><%=cm.cms("list_of_values")%></label>
                    <input type="text" title="<%=cm.cms("list_of_values")%>" id="Last_Value<%=IdNode%>"
                           name="Last_Value<%=IdNode%>" size="25" value="<%=val%>"
                           onblur="submitLastValueForm(this,'<%=IdNode%>','<%=IdSession%>','<%=NatureObject%>')" onfocus="saveLastValue(this)" onkeyup="textChanged(event)" />
                    <%=cm.cmsTitle("list_of_values")%>
                    <a title="<%=cm.cms("list_of_values")%>" href="javascript:choice('Last_Value<%=IdNode%>','<%=currentAttribute%>','<%=NatureObject%>','<%=currentOperator%>')" name="last_binocular" onmouseover="setCurrentSelected(this.name)" onmouseout="setCurrentSelected('')"><img border="0" src="images/helper/helper.gif" width="11" height="18" alt="<%=cm.cms("list_of_values")%>" /></a>
                <%
                    }
                %>
                  <br />
                <%
                    }
                  }
                %>
                <% if(NatureObject.equalsIgnoreCase("Sites")) { %>
                <br />
                <jsp:include page="sites-databases.jsp" />
                <br />
                <% } %>
                <br />
                  <input type="button" class="standardButton" onclick="disableSaveButton()" disabled="disabled" value="Save" id="Save" name="Save" title="<%=cm.cms("save")%>" />
                  <%=cm.cmsTitle("save")%>
                  &nbsp;&nbsp;&nbsp;
                  <input type="submit" class="searchButton" value="Search" id="Search" name="Search" title="<%=cm.cms("search")%>" />
                  <%=cm.cmsTitle("search")%>
                  &nbsp;&nbsp;&nbsp;
                  <input type="button" class="standardButton" onclick="submitButtonForm('reset','0')" value="Reset" id="Reset" name="Reset" title="<%=cm.cms("reset")%>" />
                  <%=cm.cmsTitle("reset")%>
                <%
                } else {
                %>
                  <a title="<%=cm.cms("add_root")%>" href="javascript:submitButtonForm('addroot','0');"><img border="0" src="images/mini/add.gif" width="13" height="13" title="<%=cm.cms("add_root")%>" alt="<%=cm.cms("add_root")%>" /></a>&nbsp;<%=cm.cmsText("add_root")%>
                <%
                }
                  rs.close();
                %>
                </form>
                <br />
                <strong>
                  <%=cm.cmsText("combined_search_might_take_long_time")%>
                </strong>
                <br />
                <%
                  String criteria = tas.createCriteria(IdSession, NatureObject);
                  out.println(cm.cmsText("calculated_criteria"));
                  combinedexplainedcriteria2 = criteria.replace('#', ' ').replace('[', '(').replace(']', ')').replaceAll("AND", "<strong>AND</strong>").replaceAll("OR", "<strong>OR</strong>");
                  out.println(combinedexplainedcriteria2);

                  out.println("<br />");
                  out.println("<br />");
                  out.flush();

                  if(request.getParameter("Search") != null) {
                    String finalwhere = "";
                    String node = "";
                    int pos_start = -1;
                    int pos_end = -1;
                    String interpretedcriteria = "";
                    String intermediatefilter = "";

                    if(NatureObject.equalsIgnoreCase("Species")) {
                      combinednatureobject2 = "Species";
                      ro.finsiel.eunis.search.CombinedSearch tsas;
                      tsas = new ro.finsiel.eunis.search.CombinedSearch();
                      tsas.SetSQLLimit(SQL_LIMIT);
                      tsas.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);
                      pos_start = criteria.indexOf('#');
                      pos_end = criteria.indexOf('#', pos_start + 1);
                      while(pos_start != -1 && pos_end != -1) {
                        node = criteria.substring(pos_start + 1, pos_end);
                        interpretedcriteria = tsas.InterpretCriteria(node, IdSession, NatureObject);
                        combinedlistcriteria2 += node + ": " + interpretedcriteria + "<br />";
                        out.println(cm.cmsText("searching_for") + " " + interpretedcriteria + "...");
                        out.flush();
                        intermediatefilter = tsas.BuildFilter(node, IdSession, NatureObject);
                        out.println(cm.cmsText("advanced_found") + " <strong>" + tsas.getResultCount() + "</strong>");
                        if(tsas.getResultCount() >= SQL_LIMIT) {
                          String str = cm.cmsText("generic_combined-search-step2_13");
                          if(str != null) {
                            str = str.replaceAll("SQL_LIMIT", "" + SQL_LIMIT);
                            out.println(str);
                          }
                        }
                        out.println("<br />");
                        out.flush();

                        finalwhere = "";
                        finalwhere += criteria.substring(0, pos_start);
                        finalwhere += "ID_NATURE_OBJECT IN (" + intermediatefilter + ")";
                        finalwhere += criteria.substring(pos_end + 1);
                        criteria = finalwhere;

                        pos_start = criteria.indexOf('#', pos_end + 1);
                        if(pos_start != -1) {
                          pos_end = criteria.indexOf('#', pos_start + 1);
                        } else {
                        }
                      }
                    }

                    if(NatureObject.equalsIgnoreCase("Habitat")) {
                      combinednatureobject2 = "Habitats";
                      ro.finsiel.eunis.search.CombinedSearch tsas;
                      tsas = new ro.finsiel.eunis.search.CombinedSearch();
                      tsas.SetSQLLimit(SQL_LIMIT);
                      tsas.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);
                      pos_start = criteria.indexOf('#');
                      pos_end = criteria.indexOf('#', pos_start + 1);
                      while(pos_start != -1 && pos_end != -1) {
                        node = criteria.substring(pos_start + 1, pos_end);
                        interpretedcriteria = tsas.InterpretCriteria(node, IdSession, NatureObject);
                        combinedlistcriteria2 += node + ": " + interpretedcriteria + "<br />";
                        out.println(cm.cmsText("searching_for") + " " + interpretedcriteria + "...");
                        out.flush();
                        intermediatefilter = tsas.BuildFilter(node, IdSession, NatureObject);
                        out.println(cm.cmsText("advanced_found") + " <strong>" + tsas.getResultCount() + "</strong>");
                        if(tsas.getResultCount() >= SQL_LIMIT) {
                          String str = cm.cmsText("generic_combined-search-step2_13");
                          if(str != null) {
                            str = str.replaceAll("SQL_LIMIT", "" + SQL_LIMIT);
                            out.println(str);
                          }
                        }
                        out.println("<br />");
                        out.flush();

                        finalwhere = "";
                        finalwhere += criteria.substring(0, pos_start);
                        finalwhere += "ID_NATURE_OBJECT IN (" + intermediatefilter + ")";
                        finalwhere += criteria.substring(pos_end + 1);
                        criteria = finalwhere;

                        pos_start = criteria.indexOf('#', pos_end + 1);
                        if(pos_start != -1) {
                          pos_end = criteria.indexOf('#', pos_start + 1);
                        } else {
                        }
                      }
                    }

                    if(NatureObject.equalsIgnoreCase("Sites")) {
                      combinednatureobject2 = "Sites";
                      ro.finsiel.eunis.search.CombinedSearch tsas;
                      tsas = new ro.finsiel.eunis.search.CombinedSearch();
                      tsas.SetSourceDB(SourceDB);
                      tsas.SetSQLLimit(SQL_LIMIT);
                      tsas.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);
                      pos_start = criteria.indexOf('#');
                      pos_end = criteria.indexOf('#', pos_start + 1);
                      while(pos_start != -1 && pos_end != -1) {
                        node = criteria.substring(pos_start + 1, pos_end);
                        interpretedcriteria = tsas.InterpretCriteria(node, IdSession, NatureObject);
                        combinedlistcriteria2 += node + ": " + interpretedcriteria + "<br />";
                        out.println(cm.cmsText("searching_for") + " " + interpretedcriteria + "...");
                        out.flush();
                        intermediatefilter = tsas.BuildFilter(node, IdSession, NatureObject);
                        out.println(cm.cmsText("advanced_found") + " <strong>" + tsas.getResultCount() + "</strong>");
                        if(tsas.getResultCount() >= SQL_LIMIT) {
                          String str = cm.cmsText("generic_combined-search-step2_13");
                          if(str != null) {
                            str = str.replaceAll("SQL_LIMIT", "" + SQL_LIMIT);
                            out.println(str);
                          }
                        }
                        out.println("<br />");
                        out.flush();

                        finalwhere = "";
                        finalwhere += criteria.substring(0, pos_start);
                        finalwhere += "ID_NATURE_OBJECT IN (" + intermediatefilter + ")";
                        finalwhere += criteria.substring(pos_end + 1);
                        criteria = finalwhere;

                        pos_start = criteria.indexOf('#', pos_end + 1);
                        if(pos_start != -1) {
                          pos_end = criteria.indexOf('#', pos_start + 1);
                        } else {
                        }
                      }
                    }

                    ro.finsiel.eunis.search.CombinedSearch tsas;
                    tsas = new ro.finsiel.eunis.search.CombinedSearch();
                    tsas.SetSourceDB(SourceDB);
                    tsas.SetSQLLimit(SQL_LIMIT);
                    tsas.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);
                    String str = tsas.calculateCriteria(IdSession, NatureObject);

                    tsas.DeleteResults(IdSession, NatureObject);

                    if(NatureObject.equalsIgnoreCase("Species")) {
                      str = "SELECT ID_NATURE_OBJECT FROM CHM62EDT_SPECIES WHERE (" + str + ")";
                    }
                    if(NatureObject.equalsIgnoreCase("Habitat")) {

                      String isGoodHabitat = " IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',RIGHT(CHM62EDT_HABITAT.CODE_2000,2),1) <> IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '','00',2) AND IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',LENGTH(CHM62EDT_HABITAT.CODE_2000),1) = IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',4,1) ";
                      str = "SELECT ID_NATURE_OBJECT FROM CHM62EDT_HABITAT WHERE   " + isGoodHabitat + " AND (" + str + ")";
                    }
                    if(NatureObject.equalsIgnoreCase("Sites")) {
                      str = "SELECT ID_NATURE_OBJECT FROM CHM62EDT_SITES WHERE (" + str + ")";
                    }
                    String query = tsas.ExecuteFilterSQL(str, "");
                    out.println("<br /><strong>" + cm.cmsText("combined_total_matches") + "&nbsp;" + tsas.getResultCount() + "</strong><br /><br />");
                    out.flush();

                    if(tsas.getResultCount() > 0) {
                      tsas.AddResult(IdSession, NatureObject, query);
                    }

                    if(tsas.getResultCount() > 0) {%>
                <br />
                <form name="search" action="combined-search-3.jsp" method="post">
                  <input type="hidden" name="combinedexplainedcriteria2" value="<%=combinedexplainedcriteria2%>" />
                  <input type="hidden" name="combinedlistcriteria2" value="<%=combinedlistcriteria2%>" />
                  <input type="hidden" name="combinednatureobject2" value="<%=combinednatureobject2%>" />
                  <%
                    if(NatureObject.equalsIgnoreCase("Species")) {
                  %>
                  <input type="submit" name="Proceed to next page" title="<%=cm.cms("combined_proceed_to_next_page")%>"
                         id="NextPageSpecies" value="<%=cm.cms("combined_proceed_to_next_page")%>" class="searchButton" />
                  <%=cm.cmsInput("combined_proceed_to_next_page")%>
                  <%
                    }
                  %>
                  <%
                    if(NatureObject.equalsIgnoreCase("Habitat")) {
                  %>
                  <input type="submit" title="<%=cm.cms("combined_proceed_to_next_page")%>" name="Proceed to next page"
                         id="NextPageHabitat" value="<%=cm.cms("combined_proceed_to_next_page")%>" class="searchButton" />
                  <%=cm.cmsInput("combined_proceed_to_next_page")%>
                  <%
                    }
                  %>
                  <%
                    if(NatureObject.equalsIgnoreCase("Sites")) {
                  %>
                  <input type="submit" title="<%=cm.cms("combined_proceed_to_next_page")%>" name="Proceed to next page"
                         id="NextPageSites" value="<%=cm.cms("combined_proceed_to_next_page")%>" class="searchButton" />
                  <%=cm.cmsInput("combined_proceed_to_next_page")%>
                  <input type="hidden" name="sourcedbcriteria" value="<%=sourcedbcriteria.replaceAll("'","")%>" />
                  <%
                    }
                  %>
                  <input type="hidden" name="idsession" value="<%=IdSession%>" />
                  <input type="hidden" name="secondnatureobject" value="<%=NatureObject%>" />
                  <%
                    if(NatureObject.equalsIgnoreCase("Species")) {
                  %>
                  <input type="hidden" name="firstnatureobject" value="Sites" />
                  <input type="hidden" name="natureobject" value="Habitat" />
                  <%
                    }
                  %>
                  <%
                    if(NatureObject.equalsIgnoreCase("Habitat")) {
                  %>
                  <input type="hidden" name="firstnatureobject" value="Species" />
                  <input type="hidden" name="natureobject" value="Sites" />
                  <%
                    }
                  %>
                  <%
                    if(NatureObject.equalsIgnoreCase("Sites")) {
                  %>
                  <input type="hidden" name="firstnatureobject" value="Habitat" />
                  <input type="hidden" name="natureobject" value="Species" />
                  <%
                    }
                  %>
                </form>
                <br />
                <form name="search_skip" action="combined-search-3.jsp" method="post">
                  <input type="hidden" name="combinedexplainedcriteria2" value="<%=combinedexplainedcriteria2%>" />
                  <input type="hidden" name="combinedlistcriteria2" value="<%=combinedlistcriteria2%>" />
                  <input type="hidden" name="combinednatureobject2" value="<%=combinednatureobject2%>" />
                  <%
                    if(NatureObject.equalsIgnoreCase("Species")) {
                  %>
                  <input type="submit" name="Proceed to next page" title="<%=cm.cms("combined_proceed_to_next_page_sites")%>"
                         id="NextPageSpecies2" value="<%=cm.cms("combined_proceed_to_next_page_sites")%>" class="searchButton" />
                  <%=cm.cmsInput("combined_proceed_to_next_page_sites")%>
                  <%
                    }
                  %>
                  <%
                    if(NatureObject.equalsIgnoreCase("Habitat")) {
                  %>
                  <input type="submit" name="Proceed to next page" title="<%=cm.cms("combined_proceed_to_next_page_species")%>"
                         id="NextPageHabitat2" value="<%=cm.cms("combined_proceed_to_next_page_species")%>" class="searchButton" />
                  <%=cm.cmsInput("combined_proceed_to_next_page_species")%>
                  <%
                    }
                  %>
                  <%
                    if(NatureObject.equalsIgnoreCase("Sites")) {
                  %>
                  <input type="submit" name="Proceed to next page" title="<%=cm.cms("combined_proceed_to_next_page_habitats")%>"
                         id="NextPageSites2" value="<%=cm.cms("combined_proceed_to_next_page_habitats")%>" class="searchButton" />
                  <%=cm.cmsInput("combined_proceed_to_next_page_habitats")%>
                  <input type="hidden" name="sourcedbcriteria" value="<%=sourcedbcriteria.replaceAll("'","")%>" />
                  <%
                    }
                  %>
                  <input type="hidden" name="idsession" value="<%=IdSession%>" />
                  <input type="hidden" name="idsession" value="<%=IdSession%>" />
                  <input type="hidden" name="secondnatureobject" value="<%=NatureObject%>" />
                  <%
                    if(NatureObject.equalsIgnoreCase("Species")) {
                  %>
                  <input type="hidden" name="firstnatureobject" value="Sites" />
                  <input type="hidden" name="natureobject" value="Habitat" />
                  <input type="hidden" name="skip" value="Habitat" />
                  <%
                    }
                  %>
                  <%
                    if(NatureObject.equalsIgnoreCase("Habitat")) {
                  %>
                  <input type="hidden" name="firstnatureobject" value="Species" />
                  <input type="hidden" name="natureobject" value="Sites" />
                  <input type="hidden" name="skip" value="Sites" />
                  <%
                    }
                  %>
                  <%
                    if(NatureObject.equalsIgnoreCase("Sites")) {
                  %>
                  <input type="hidden" name="firstnatureobject" value="Habitat" />
                  <input type="hidden" name="natureobject" value="Species" />
                  <input type="hidden" name="skip" value="Species" />
                  <%
                    }
                  %>
                </form>
                <%--    end modify--%>
                <%} else { %>
                <br />
                <%=cm.cmsText("no_results")%>
                <br />
                <% }
                }
                  con.close();
                %>
                <%=cm.br()%>
                <%=cm.cmsMsg("combined_search")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("press_save_to_save_criteria")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("criteria_saved")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("any")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("all")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("error_deleting_root")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("error_adding_branch")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("error_deleting_branch")%>
                <%=cm.br()%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="combined-search-2.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <!-- start of right (by default at least) column -->
        <div id="portal-column-two">
          <div class="visualPadding">
            <jsp:include page="inc_column_right.jsp" />
          </div>
        </div>
        <!-- end of the right (by default at least) column -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_FOOTER" ) )%>
    </div>
  </body>
</html>
