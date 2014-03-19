<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2006 EEA - European Environment Agency.
  - Description : EUNIS habitat types tree
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
  request.setCharacterEncoding( "UTF-8");  
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<%@ page import="ro.finsiel.eunis.search.Utilities"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="ro.finsiel.eunis.utilities.SQLUtilities"%>
<%@ page import="eionet.eunis.util.JstlFunctions" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,habitat_types#habitats.jsp,eunis_habitat_type_hierarchical_view";
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cms("eunis_habitat_type_hierarchical_view") %>'></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">
        <link rel="StyleSheet" href="css/eunistree.css" type="text/css" />
    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <a name="documentContent"></a>
          <h1>
            <%=cm.cmsPhrase("EUNIS habitat type hierarchical view")%>
          </h1>
<!-- MAIN CONTENT -->
                  <br/>
            <%
              String expand = Utilities.formatString( request.getParameter( "expand" ), "" );

              String SQL_DRV = application.getInitParameter("JDBC_DRV");
              String SQL_URL = application.getInitParameter("JDBC_URL");
              String SQL_USR = application.getInitParameter("JDBC_USR");
              String SQL_PWD = application.getInitParameter("JDBC_PWD");

              SQLUtilities sqlc = new SQLUtilities();
              sqlc.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);

              String strSQL = "";

              Connection con = null;
              PreparedStatement ps = null;
              ResultSet rs = null;
              PreparedStatement ps2 = null;
              ResultSet rs2 = null;
              PreparedStatement ps4 = null;
              ResultSet rs4 = null;
              PreparedStatement ps5 = null;
              ResultSet rs5 = null;
              PreparedStatement ps6 = null;
              ResultSet rs6 = null;
              PreparedStatement ps7 = null;
              ResultSet rs7 = null;
              PreparedStatement ps8 = null;
              ResultSet rs8 = null;

              try
              {
                Class.forName( SQL_DRV );
                con = DriverManager.getConnection( SQL_URL, SQL_USR, SQL_PWD );
                
                //we display root nodes
                strSQL = "SELECT ID_HABITAT, SCIENTIFIC_NAME, EUNIS_HABITAT_CODE";
                strSQL = strSQL + " FROM CHM62EDT_HABITAT";
                strSQL = strSQL + " WHERE LENGTH(EUNIS_HABITAT_CODE) = 1";
                strSQL = strSQL + " AND EUNIS_HABITAT_CODE<>'-'";
                strSQL = strSQL + " ORDER BY EUNIS_HABITAT_CODE ASC";

                ps = con.prepareStatement( strSQL );
                rs = ps.executeQuery();
                String hide = cm.cmsPhrase("Hide sublevel habitat types");
                String show = cm.cmsPhrase("Show sublevel habitat types");
            %>
                <ul class="eunistree">
            <%
                while(rs.next())
                {
            %>
                  <li>
                  	<% if(Utilities.expandContains(expand,rs.getString("EUNIS_HABITAT_CODE"))){ %>
                      <a title="<%=hide%>" id="level_<%=rs.getString("EUNIS_HABITAT_CODE")%>" href="habitats-code-browser.jsp?expand=<%=Utilities.removeFromExpanded(expand,rs.getString("EUNIS_HABITAT_CODE"))%>#level_<%=rs.getString("EUNIS_HABITAT_CODE")%>"><img src="images/img_minus.gif" alt="<%=hide%>"/></a>
                    <% } else { %>
                      <a title="<%=show%>" id="level_<%=rs.getString("EUNIS_HABITAT_CODE")%>" href="habitats-code-browser.jsp?expand=<%=Utilities.addToExpanded(expand,rs.getString("EUNIS_HABITAT_CODE"))%>#level_<%=rs.getString("EUNIS_HABITAT_CODE")%>"><img src="images/img_plus.gif" alt="<%=show%>"/></a>
                    <% } %>
                    <a title="<%=rs.getString("SCIENTIFIC_NAME")%>" href="habitats/<%=rs.getString("ID_HABITAT")%>"><%=rs.getString("EUNIS_HABITAT_CODE")%> : <%=JstlFunctions.bracketsToItalics(rs.getString("SCIENTIFIC_NAME"))%></a><br/>
                    <%
                    	if(expand.length()>0 && Utilities.expandContains(expand,rs.getString("EUNIS_HABITAT_CODE"))) {
		                  strSQL = "SELECT ID_HABITAT, SCIENTIFIC_NAME, EUNIS_HABITAT_CODE";
		                  strSQL = strSQL + " FROM CHM62EDT_HABITAT";
		                  strSQL = strSQL + " WHERE EUNIS_HABITAT_CODE LIKE '"+rs.getString("EUNIS_HABITAT_CODE").substring(0,1)+"%'";
		                  strSQL = strSQL + " AND LEVEL=2";
		                  strSQL = strSQL + " ORDER BY EUNIS_HABITAT_CODE ASC";
		
		                  ps2 = con.prepareStatement( strSQL );
		                  rs2 = ps2.executeQuery();

		            %>
		                  <ul class="eunistree">
		            <%
		            	  boolean hasLevel2 = false;
		                  while(rs2.next())
		                  {
		                	hasLevel2 = true;
		                    if(sqlc.EunisHabitatHasChilds(rs2.getString("EUNIS_HABITAT_CODE"))) {
		            %>
		                    <li>
		                    <% if(Utilities.expandContains(expand,rs2.getString("EUNIS_HABITAT_CODE"))){ %>
		                      <a title="<%=hide%>" id="level_<%=rs2.getString("EUNIS_HABITAT_CODE")%>" href="habitats-code-browser.jsp?expand=<%=Utilities.removeFromExpanded(expand,rs2.getString("EUNIS_HABITAT_CODE"))%>#level_<%=rs2.getString("EUNIS_HABITAT_CODE")%>"><img src="images/img_minus.gif" alt="<%=hide%>"/></a>
		                    <% } else { %>
		                      <a title="<%=show%>" id="level_<%=rs2.getString("EUNIS_HABITAT_CODE")%>" href="habitats-code-browser.jsp?expand=<%=Utilities.addToExpanded(expand,rs2.getString("EUNIS_HABITAT_CODE"))%>#level_<%=rs2.getString("EUNIS_HABITAT_CODE")%>"><img src="images/img_plus.gif" alt="<%=show%>"/></a>
		                    <% } %>
		                      <a title="<%=rs2.getString("SCIENTIFIC_NAME")%>" href="habitats/<%=rs2.getString("ID_HABITAT")%>"><%=rs2.getString("EUNIS_HABITAT_CODE")%> : <%=JstlFunctions.bracketsToItalics(rs2.getString("SCIENTIFIC_NAME"))%></a><br/>
		                    
		            <%
		                    } else {
		            %>
		                    <li>
		                      <img src="images/img_bullet.gif" alt="<%=rs2.getString("SCIENTIFIC_NAME")%>"/>&nbsp;<a title="<%=rs2.getString("SCIENTIFIC_NAME")%>" href="habitats/<%=rs2.getString("ID_HABITAT")%>"><%=rs2.getString("EUNIS_HABITAT_CODE")%> : <%=JstlFunctions.bracketsToItalics(rs2.getString("SCIENTIFIC_NAME"))%></a><br/>
		                    
		            <%
		                    }
		
		                     if(expand.length()>0 && Utilities.expandContains(expand,rs2.getString("EUNIS_HABITAT_CODE"))) {
		                       strSQL = "SELECT ID_HABITAT, SCIENTIFIC_NAME, EUNIS_HABITAT_CODE";
		                       strSQL = strSQL + " FROM CHM62EDT_HABITAT";
		                       strSQL = strSQL + " WHERE EUNIS_HABITAT_CODE LIKE '"+rs2.getString("EUNIS_HABITAT_CODE").substring(0,2)+"%'";
		                       strSQL = strSQL + " AND LEVEL=3";
		                       strSQL = strSQL + " ORDER BY EUNIS_HABITAT_CODE ASC";
		
		                       ps4 = con.prepareStatement( strSQL );
		                       rs4 = ps4.executeQuery();
		
		            %>
		                       <ul class="eunistree">
		            <%
		                       while(rs4.next())
		                       {
		                         if(sqlc.EunisHabitatHasChilds(rs4.getString("EUNIS_HABITAT_CODE"))) {
		            %>
		                         <li>
		                         	<% if(Utilities.expandContains(expand,rs4.getString("EUNIS_HABITAT_CODE"))){ %>
				                      <a title="<%=hide%>" id="level_<%=rs4.getString("EUNIS_HABITAT_CODE")%>" href="habitats-code-browser.jsp?expand=<%=Utilities.removeFromExpanded(expand,rs4.getString("EUNIS_HABITAT_CODE"))%>#level_<%=rs4.getString("EUNIS_HABITAT_CODE")%>"><img src="images/img_minus.gif" alt="<%=hide%>"/></a>
				                    <% } else { %>
				                      <a title="<%=show%>" id="level_<%=rs4.getString("EUNIS_HABITAT_CODE")%>" href="habitats-code-browser.jsp?expand=<%=Utilities.addToExpanded(expand,rs4.getString("EUNIS_HABITAT_CODE"))%>#level_<%=rs4.getString("EUNIS_HABITAT_CODE")%>"><img src="images/img_plus.gif" alt="<%=show%>"/></a>
				                    <% } %>
		                            <a title="<%=rs4.getString("SCIENTIFIC_NAME")%>" href="habitats/<%=rs4.getString("ID_HABITAT")%>"><%=rs4.getString("EUNIS_HABITAT_CODE")%> : <%=JstlFunctions.bracketsToItalics(rs4.getString("SCIENTIFIC_NAME"))%></a>
		                         
		            <%
		                         } else {
		            %>
		                         <li>
		                           <img src="images/img_bullet.gif" alt="<%=rs4.getString("SCIENTIFIC_NAME")%>"/>&nbsp;<a title="<%=rs4.getString("SCIENTIFIC_NAME")%>" href="habitats/<%=rs4.getString("ID_HABITAT")%>"><%=rs4.getString("EUNIS_HABITAT_CODE")%> : <%=JstlFunctions.bracketsToItalics(rs4.getString("SCIENTIFIC_NAME"))%></a>
		                         
		            <%
		                         }
		
		                         if(expand.length()>0 && Utilities.expandContains(expand,rs4.getString("EUNIS_HABITAT_CODE"))) {
		                           strSQL = "SELECT ID_HABITAT, SCIENTIFIC_NAME, EUNIS_HABITAT_CODE";
		                           strSQL = strSQL + " FROM CHM62EDT_HABITAT";
		                           strSQL = strSQL + " WHERE EUNIS_HABITAT_CODE LIKE '"+rs4.getString("EUNIS_HABITAT_CODE").substring(0,4)+"%'";
		                           strSQL = strSQL + " AND LEVEL=4";
		                           strSQL = strSQL + " ORDER BY EUNIS_HABITAT_CODE ASC";
		
		                           ps5 = con.prepareStatement( strSQL );
		                           rs5 = ps5.executeQuery();
		
		            %>
		                           <ul class="eunistree">
		            <%
		                           while(rs5.next())
		                           {
		                             if(sqlc.EunisHabitatHasChilds(rs5.getString("EUNIS_HABITAT_CODE"))) {
		            %>				
		                            <li>
		                            	<% if(Utilities.expandContains(expand,rs5.getString("EUNIS_HABITAT_CODE"))){ %>
					                      <a title="<%=hide%>" id="level_<%=rs5.getString("EUNIS_HABITAT_CODE")%>" href="habitats-code-browser.jsp?expand=<%=Utilities.removeFromExpanded(expand,rs5.getString("EUNIS_HABITAT_CODE"))%>#level_<%=rs5.getString("EUNIS_HABITAT_CODE")%>"><img src="images/img_minus.gif" alt="<%=hide%>"/></a>
					                    <% } else { %>
					                      <a title="<%=show%>" id="level_<%=rs5.getString("EUNIS_HABITAT_CODE")%>" href="habitats-code-browser.jsp?expand=<%=Utilities.addToExpanded(expand,rs5.getString("EUNIS_HABITAT_CODE"))%>#level_<%=rs5.getString("EUNIS_HABITAT_CODE")%>"><img src="images/img_plus.gif" alt="<%=show%>"/></a>
					                    <% } %>
		                              	<a title="<%=rs5.getString("SCIENTIFIC_NAME")%>" href="habitats/<%=rs5.getString("ID_HABITAT")%>"><%=rs5.getString("EUNIS_HABITAT_CODE")%> : <%=JstlFunctions.bracketsToItalics(rs5.getString("SCIENTIFIC_NAME"))%></a>
		                            
		            <%
		                             } else {
		            %>
		                            <li>
		                              <img src="images/img_bullet.gif" alt="<%=rs5.getString("SCIENTIFIC_NAME")%>"/>&nbsp;<a title="<%=rs5.getString("SCIENTIFIC_NAME")%>" href="habitats/<%=rs5.getString("ID_HABITAT")%>"><%=rs5.getString("EUNIS_HABITAT_CODE")%> : <%=JstlFunctions.bracketsToItalics(rs5.getString("SCIENTIFIC_NAME"))%></a>
		                            
		            <%
		                             }
		                             if(expand.length()>0 && Utilities.expandContains(expand,rs5.getString("EUNIS_HABITAT_CODE"))) {
		                               strSQL = "SELECT ID_HABITAT, SCIENTIFIC_NAME, EUNIS_HABITAT_CODE";
		                               strSQL = strSQL + " FROM CHM62EDT_HABITAT";
		                               strSQL = strSQL + " WHERE EUNIS_HABITAT_CODE LIKE '"+rs5.getString("EUNIS_HABITAT_CODE").substring(0,5)+"%'";
		                               strSQL = strSQL + " AND LEVEL=5";
		                               strSQL = strSQL + " ORDER BY EUNIS_HABITAT_CODE ASC";
		
		                               ps6 = con.prepareStatement( strSQL );
		                               rs6 = ps6.executeQuery();
		
		            %>
		                               <ul class="eunistree">
		            <%
		                               while(rs6.next())
		                               {
		                                 if(sqlc.EunisHabitatHasChilds(rs6.getString("EUNIS_HABITAT_CODE"))) {
		            %>
		                                 <li>
		                                 	<% if(Utilities.expandContains(expand,rs6.getString("EUNIS_HABITAT_CODE"))){ %>
						                      <a title="<%=hide%>" id="level_<%=rs6.getString("EUNIS_HABITAT_CODE")%>" href="habitats-code-browser.jsp?expand=<%=Utilities.removeFromExpanded(expand,rs6.getString("EUNIS_HABITAT_CODE"))%>#level_<%=rs6.getString("EUNIS_HABITAT_CODE")%>"><img src="images/img_minus.gif" alt="<%=hide%>"/></a>
						                    <% } else { %>
						                      <a title="<%=show%>" id="level_<%=rs6.getString("EUNIS_HABITAT_CODE")%>" href="habitats-code-browser.jsp?expand=<%=Utilities.addToExpanded(expand,rs6.getString("EUNIS_HABITAT_CODE"))%>#level_<%=rs6.getString("EUNIS_HABITAT_CODE")%>"><img src="images/img_plus.gif" alt="<%=show%>"/></a>
						                    <% } %>
											<a title="<%=rs6.getString("SCIENTIFIC_NAME")%>" href="habitats/<%=rs6.getString("ID_HABITAT")%>"><%=rs6.getString("EUNIS_HABITAT_CODE")%> : <%=JstlFunctions.bracketsToItalics(rs6.getString("SCIENTIFIC_NAME"))%></a>
		                                 
		            <%
		                                 } else {
		            %>
		                                 <li>
		                                   <img src="images/img_bullet.gif" alt="<%=rs6.getString("SCIENTIFIC_NAME")%>"/>&nbsp;<a title="<%=rs6.getString("SCIENTIFIC_NAME")%>" href="habitats/<%=rs6.getString("ID_HABITAT")%>"><%=rs6.getString("EUNIS_HABITAT_CODE")%> : <%=JstlFunctions.bracketsToItalics(rs6.getString("SCIENTIFIC_NAME"))%></a>
		                                 
		            <%
		                                 }
		                                 if(expand.length()>0 && Utilities.expandContains(expand,rs6.getString("EUNIS_HABITAT_CODE"))) {
		                                   strSQL = "SELECT ID_HABITAT, SCIENTIFIC_NAME, EUNIS_HABITAT_CODE";
		                                   strSQL = strSQL + " FROM CHM62EDT_HABITAT";
		                                   strSQL = strSQL + " WHERE EUNIS_HABITAT_CODE LIKE '"+rs6.getString("EUNIS_HABITAT_CODE").substring(0,6)+"%'";
		                                   strSQL = strSQL + " AND LEVEL=6";
		                                   strSQL = strSQL + " ORDER BY EUNIS_HABITAT_CODE ASC";
		
		                                   ps7 = con.prepareStatement( strSQL );
		                                   rs7 = ps7.executeQuery();
		
		            %>
		                                   <ul class="eunistree">
		            <%
		                                   while(rs7.next())
		                                   {
		            %>
		                                     <li>
		                                       <img src="images/img_bullet.gif" alt="<%=rs7.getString("SCIENTIFIC_NAME")%>"/>&nbsp;<a title="<%=rs7.getString("SCIENTIFIC_NAME")%>" href="habitats/<%=rs7.getString("ID_HABITAT")%>"><%=rs7.getString("EUNIS_HABITAT_CODE")%> : <%=JstlFunctions.bracketsToItalics(rs7.getString("SCIENTIFIC_NAME"))%></a><br/>
		                                     </li>
		            <%
		                                   }
		
		            %>
		                                   </ul>
		            <%
		                                   rs7.close();
		                                   ps7.close();
		                                 }
		                                 %>
		                                  </li> 
		                                 <%
		
		                               }
		            %>
		                               </ul>
		            <%
		
		                               rs6.close();
		                               ps6.close();
		                             }
		                             %>
		                               </li> 
		                             <%
		                           }
		
		            %>
		                           </ul>
		            <%
		                           rs5.close();
		                           ps5.close();
		                         }
								%>
		                          </li> 
		                        <%
		                       }
		
		            %>
		                       </ul>
		            <%
		                       rs4.close();
		                       ps4.close();
		                     }
		                     %>
		                       </li> 
		                     <%
		                  }
		                  rs2.close();
		                  ps2.close();
		
		            %>
		                  </ul>
		            <%
		                }
                    %>
                  </li>
            <%
                }
            %>
                </ul>
                <%=cm.cmsTitle("Show sublevel habitat types")%>
                <%=cm.br()%>
                <%=cm.cmsTitle("Hide sublevel habitat types")%>
            <%

                rs.close();
                ps.close();

                out.println("<br/><br/>");

                //we begin to display the tree

                con.close();
              }
              catch ( Exception e )
              {
                e.printStackTrace();
                return;
              }

            %>
                  <br/>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>