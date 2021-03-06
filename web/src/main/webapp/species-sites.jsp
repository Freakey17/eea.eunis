<%--
<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick sites, show species' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 java.util.Vector,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.species.sites.SitesSearchCriteria"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
    WebContentManagement cm = SessionManager.getWebContent();
    String eeaHome = application.getInitParameter( "EEA_HOME" );
    String btrail = "eea#" + eeaHome + ",home#index.jsp,sites#sites.jsp,pick_sites_show_species_location";
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cms("pick_sites_show_species") %>'></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${title}" btrail="<%= btrail%>">
<stripes:layout-component name="head">
    <link rel="stylesheet" type="text/css" href="/css/eea_search.css">
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript">
      //<![CDATA[

      var errInvalidRegion = '<%=cm.cms("biogeographic_region_is_not_valid")%>';
        // Change the operator list according to criteria selected element from criteria type list
        function changeCriteria() {
          var criteriaType = document.getElementById("searchAttribute").options[document.getElementById("searchAttribute").selectedIndex].value;
          var operList = document.getElementById("relationOp");
          changeOperatorList(criteriaType, operList);
        }

        // Reconstruct the list items depending on the selected item
        function changeOperatorList(criteriaType, operList) {
          removeElementsFromList(operList);
          var optIS = document.createElement("OPTION");
          optIS.text = "<%=cm.cmsPhrase("is")%>";
          optIS.value = "<%=Utilities.OPERATOR_IS%>";
          var optSTART = document.createElement("OPTION");
          optSTART.text = "<%=cm.cms("starts")%>";
          optSTART.value = "<%=Utilities.OPERATOR_STARTS%>";
          var optCONTAIN = document.createElement("OPTION");
          optCONTAIN.text = "<%=cm.cmsPhrase("contains")%>";
          optCONTAIN.value = "<%=Utilities.OPERATOR_CONTAINS%>";
          var optGREAT = document.createElement("OPTION");
          optGREAT.text = "<%=cm.cms("greater")%>";
          optGREAT.value = "<%=Utilities.OPERATOR_GREATER_OR_EQUAL%>";
          var optSMALL = document.createElement("OPTION");
          optSMALL.text = "<%=cm.cms("smaller")%>";
          optSMALL.value = "<%=Utilities.OPERATOR_SMALLER_OR_EQUAL%>";
          // Site name
          if (criteriaType == <%=SitesSearchCriteria.SEARCH_NAME%>)
          {
            operList.add(optCONTAIN, 2);
            operList.add(optIS, 0);
            operList.add(optSTART, 1);
          }
          // Site size
          if (criteriaType == <%=SitesSearchCriteria.SEARCH_SIZE%>)
          {
            operList.add(optIS, 0);
            operList.add(optGREAT, 1);
            operList.add(optSMALL, 2);
          }
          // Site length
          if (criteriaType == <%=SitesSearchCriteria.SEARCH_LENGTH%>)
          {
            operList.add(optIS, 0);
            operList.add(optGREAT, 1);
            operList.add(optSMALL, 2);
          }
          // Country
          if (criteriaType == <%=SitesSearchCriteria.SEARCH_COUNTRY%>)
          {
            operList.add(optCONTAIN, 1);
            operList.add(optIS, 0);
          }
          // Region
          if (criteriaType == <%=SitesSearchCriteria.SEARCH_REGION%>)
          {
            operList.add(optCONTAIN, 1);
            operList.add(optIS, 0);
          }
        }

        // This function removes all the elements of a list
        function removeElementsFromList(operList)
        {
          for (i = operList.length - 1; i >= 0; i--)
          {
            operList.remove(i);
          }
        }

        function validateForm()
        {
          document.criteria.scientificName.value = trim(document.criteria.scientificName.value);

          var errMessageName = "<%=cm.cms("please_type_letters_from_site_name")%>";
          var errMessageSize = "<%=cm.cms("enter_size_as_number")%>";

          // Validate it's selected SIZE?LENGTH
          var criteriaType = document.getElementById("searchAttribute").options[document.getElementById("searchAttribute").selectedIndex].value;
          var searchString = document.criteria.scientificName.value;
          var fSearchString = parseFloat(searchString);

          if ((criteriaType == <%=SitesSearchCriteria.SEARCH_SIZE%> ||
              criteriaType == <%=SitesSearchCriteria.SEARCH_LENGTH%>) && isNaN(fSearchString))
          {
              alert(errMessageSize);
              return false;
          }

          if(criteriaType == <%=SitesSearchCriteria.SEARCH_COUNTRY%>)
          {
            // Check if country is a valid country
           if (!validateCountry('<%=Utilities.getCountryListString()%>',searchString))
           {
             alert(errInvalidCountry);
             return false;
           }
         }

          if(criteriaType == <%=SitesSearchCriteria.SEARCH_REGION%>)
          {
            // Check if region is a valid region
           if (!validateRegion('<%=Utilities.getRegionListString()%>',searchString))
           {
             alert(errInvalidRegion);
             return false;
           }
         }

          // Validate the input field
          var siteName;
          siteName = document.criteria.scientificName.value;
          if (siteName == "")
          {
            alert(errMessageName);
            return false;
          }
          // Validate selection of databases
          return checkValidSelection();// From sites-databases.jsp.
        }

        function openHelper(URL)
        {
          document.criteria.scientificName.value = trim(document.criteria.scientificName.value);
          var scientificName = document.criteria.scientificName.value;
          var relationOp = document.criteria.relationOp.value;
          var searchAttribute = document.criteria.searchAttribute.value;
          // If selects attribute scientific name, validate the form for input.
          if (searchAttribute == <%=SitesSearchCriteria.SEARCH_NAME%> && !validateForm())
          {
            // Return, form validation failed.
            return;
          }
          if (searchAttribute == <%=SitesSearchCriteria.SEARCH_SIZE%> || searchAttribute == <%=SitesSearchCriteria.SEARCH_LENGTH%>)
          {
            // Return, no popup for size or length
            alert("<%=cm.cms("species_sites_22")%>");
            return;
          }
          if (!checkValidSelection())
          {
            // Return, no database selected
            return;
          }
          URL2 = URL;
          URL2 += '?searchAttribute=' + searchAttribute;
          URL2 += '&scientificName=' + scientificName;
          URL2 += '&relationOp=' + relationOp;
          URL2 += Db2Url();
          eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0,resizable=no,location=0,width=450,height=500,left=500,top=0');");
        }
      //]]>
    </script>
    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <a name="documentContent"></a>
        <h1>
           <%=cm.cmsPhrase("Pick sites, show species")%>
        </h1>
<!-- MAIN CONTENT -->
                <p>
                        <%=cm.cmsPhrase("Please type a few letters from site name.")%>
                </p>
                <form name="criteria" method="get" onsubmit="javascript: return validateForm();" action="species-sites-result.jsp">
                  <fieldset class="large">
                  <legend><%=cm.cmsPhrase("Search in")%></legend>
                       <jsp:include page="sites-databases.jsp" />
                  </fieldset>

                  <fieldset class="large">
                  <legend><%=cm.cmsPhrase("Search what")%></legend>

                        <img width="11" height="12" style="vertical-align:middle" alt="<%=cm.cmsPhrase("This field is mandatory")%>" title="<%=cm.cmsPhrase("This field is mandatory")%>" src="images/mini/field_mandatory.gif" />&nbsp;
                        <label for="searchAttribute" class="noshow"><%=cm.cms("search_attribute")%></label>
                        <select id="searchAttribute" title="<%=cm.cms("search_attribute")%>" name="searchAttribute" onchange="changeCriteria()">
                          <option value="<%=SitesSearchCriteria.SEARCH_NAME%>" selected="selected"><%=cm.cms("site_name")%></option>
                          <option value="<%=SitesSearchCriteria.SEARCH_SIZE%>"><%=cm.cms("site_size")%></option>
                          <option value="<%=SitesSearchCriteria.SEARCH_LENGTH%>"><%=cm.cms("species_sites_10")%></option>
                          <option value="<%=SitesSearchCriteria.SEARCH_COUNTRY%>"><%=cm.cms("country_name")%></option>
                          <option value="<%=SitesSearchCriteria.SEARCH_REGION%>"><%=cm.cms("biogeographic_region_name")%></option>
                        </select>
                        <%=cm.cmsLabel("search_attribute")%>
                        <%=cm.cmsTitle("search_attribute")%>
                          &nbsp;
                        <select id="select2" title="<%=cm.cmsPhrase("Operator")%>" name="relationOp">
                          <option value="<%=Utilities.OPERATOR_IS%>"><%=cm.cmsPhrase("is")%></option>
                          <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cmsPhrase("contains")%></option>
                          <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=cm.cmsPhrase("starts with")%></option>
                        </select>

                        <label for="scientificName" class="noshow"><%=cm.cmsPhrase("Filter value")%></label>
                        <input title="<%=cm.cmsPhrase("Filter value")%>" size="32" id="scientificName" name="scientificName" value="" />
                        <a title="<%=cm.cms("list_values_link")%>" href="javascript:openHelper('species-sites-choice.jsp')"><img alt="<%=cm.cms("list_values_link")%>" height="18" src="images/helper/helper.gif" width="11" border="0" title="<%=cm.cms("list_values_link")%>" /></a>
                        <%=cm.cmsTitle("list_values_link")%>
                  </fieldset>

                  <fieldset class="large">
                    <legend><%=cm.cmsPhrase("Output fields")%></legend>
                    <strong>
                      <%=cm.cmsPhrase("Search will provide the following information (checked fields will be displayed), as provided in the original database:")%>
                    </strong>
                    <br/>
                              <input title="<%=cm.cmsPhrase("Group")%>" id="checkbox1" type="checkbox" name="showGroup" value="true" checked="checked" />
                              <label for="checkbox1"><%=cm.cmsPhrase("Group")%></label>

                              <input title="<%=cm.cms("order_column")%>" id="checkbox2" type="checkbox" name="showOrder" value="true" checked="checked" />
                              <label for="checkbox2"><%=cm.cmsPhrase("Order")%></label>
                               <%=cm.cmsTitle("order_column")%>

                              <input title="<%=cm.cms("family")%>" id="checkbox3" type="checkbox" name="showFamily" value="true" checked="checked" />
                              <label for="checkbox3"><%=cm.cmsPhrase("Family")%></label>
                              <%=cm.cmsTitle("family")%>

                              <input title="<%=cm.cmsPhrase("Scientific name")%>" id="checkbox5" type="checkbox" name="showScientificName" value="true" disabled="disabled" checked="checked" />
                              <label for="checkbox5"><%=cm.cmsPhrase("Species scientific name")%></label>

                              <input title="<%=cm.cms("sites")%>" id="checkbox4" type="checkbox" name="showSites" value="true" checked="checked" />
                              <label for="checkbox4"><%=cm.cmsPhrase("Please enter size as a numerical value.")%></label>
                              <%=cm.cmsTitle("sites")%>
                      </fieldset>

                      <div class="submit_buttons">
                        <input id="Reset" type="reset" value="<%=cm.cmsPhrase("Reset")%>" name="Reset" class="standardButton" title="<%=cm.cmsPhrase("Reset")%>" />
                        <input id="Search" type="submit" value="<%=cm.cmsPhrase("Search")%>" name="submit2" class="submitSearchButton" title="<%=cm.cmsPhrase("Search")%>" />
                      </div>
                </form>

                      <%
                        // Save search criteria
                        if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
                        {
                      %>
                          <br />
                          <script type="text/javascript" language="JavaScript">
                          //<![CDATA[
                          // values of source and database constants from specific class Domain(only in habitat searches, so here are all '')
                          var source1='';
                          var source2='';
                          var database1='';
                          var database2='';
                          var database3='';
                         //]]>
                         </script>
                          <%=cm.cmsPhrase("Biogeographic regions is not valid, please use helper to find biogeographic regions")%>:
                          <a title="<%=cm.cms("save_open_link")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'species-sites.jsp','2','criteria',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img alt="<%=cm.cms("save_open_link")%>" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
                          <%=cm.cmsTitle("save_open_link")%>
                      <%
                          // Set Vector for URL string
                          Vector show = new Vector();
                          show.addElement("showGroup");
                          show.addElement("showOrder");
                          show.addElement("showScientificName");
                          show.addElement("showFamily");
                          show.addElement("showOtherInfo");

                          String pageName = "species-sites.jsp";
                          String pageNameResult = "species-sites-result.jsp?"+Utilities.writeURLCriteriaSave(show);
                          // Expand or not save criterias list
                          String expandSearchCriteria = (request.getParameter("expandSearchCriteria")==null?"no":request.getParameter("expandSearchCriteria"));
                      %>
                <jsp:include page="show-criteria-search.jsp">
                  <jsp:param name="pageName" value="<%=pageName%>" />
                  <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
                  <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
                </jsp:include>
                    <%
                        }
                    %>

            <%=cm.br()%>
            <%=cm.cmsMsg("biogeographic_region_is_not_valid")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("starts")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("greater")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("smaller")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("please_type_letters_from_site_name")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("enter_size_as_number")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("species_sites_22")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("pick_sites_show_species")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("site_name")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("site_size")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("species_sites_10")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("country_name")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("biogeographic_region_name")%>
            <%=cm.br()%>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>
