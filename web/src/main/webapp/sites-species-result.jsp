<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Pick species, show sites" function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.sites.species.SpeciesPaginator,
                 ro.finsiel.eunis.jrfTables.sites.species.SpeciesDomain,
                 ro.finsiel.eunis.jrfTables.sites.species.SpeciesPersist,
                 ro.finsiel.eunis.search.sites.SitesSearchUtility,
                 ro.finsiel.eunis.search.sites.species.SpeciesBean,
                 ro.finsiel.eunis.search.sites.species.SpeciesSearchCriteria,
                 ro.finsiel.eunis.search.sites.species.SpeciesSortCriteria,
                 ro.finsiel.eunis.search.*,
                 ro.finsiel.eunis.utilities.TableColumns"%>
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.sites.species.SpeciesBean" scope="page">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<%
  // Prepare the search in results (fix)
  if (null != formBean.getRemoveFilterIndex()) { formBean.prepareFilterCriterias(); }
   // Check columns to be displayed
  boolean showSourceDB = Utilities.checkedStringToBoolean(formBean.getShowSourceDB(), SpeciesBean.HIDE);
  boolean showName = Utilities.checkedStringToBoolean(formBean.getShowName(), true);
  boolean showDesignType = Utilities.checkedStringToBoolean(formBean.getShowDesignationTypes(), SpeciesBean.HIDE);
  boolean showCoord = Utilities.checkedStringToBoolean(formBean.getShowCoordinates(), SpeciesBean.HIDE);
  boolean showSpecies  = Utilities.checkedStringToBoolean(formBean.getShowSpecies(), true);

  SourceDb source = formBean.getSourceDb();

  // Initialization
  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
  Integer searchAttribute = Utilities.checkedStringToInt(formBean.getSearchAttribute(), SpeciesSearchCriteria.SEARCH_SCIENTIFIC_NAME);
  SpeciesPaginator paginator = new SpeciesPaginator(new SpeciesDomain(formBean.toSearchCriteria(),
                                                                      formBean.toSortCriteria(),
                                                                      SessionManager.getShowEUNISInvalidatedSpecies(),
                                                                      source, searchAttribute));

  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  final String pageName = "sites-species-result.jsp";
  int resultsCount = paginator.countResults();
  int pagesCount = paginator.countPages();// This is used in @page include...
  int guid = 0;// This is used in @page include...
  // Now extract the results for the current page.

  List results = paginator.getPage(currentPage);
  // Set number criteria for the search result
  int noCriteria = (null==formBean.getCriteriaSearch()?0:formBean.getCriteriaSearch().length);
  // Prepare parameters for tsv
  Vector reportFields = new Vector();
  reportFields.addElement("sort");
  reportFields.addElement("ascendency");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("oper");
  reportFields.addElement("criteriaType");

  WebContentManagement cm = SessionManager.getWebContent();
  String tsvLink = "javascript:openTSVDownload('reports/sites/tsv-sites-species.jsp?" + formBean.toURLParam(reportFields) + "')";
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String location = "eea#" + eeaHome + ",home#index.jsp,species#species.jsp,sites_species_location#sites-species.jsp,results";
  if (results.isEmpty())
  {
    boolean fromRefine = formBean.getCriteriaSearch() != null && formBean.getCriteriaSearch().length > 0;
%>
      <jsp:forward page="emptyresults.jsp">
        <jsp:param name="location" value="<%=location%>" />
        <jsp:param name="fromRefine" value="<%=fromRefine%>" />
      </jsp:forward>
<%
  }
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cms("sites_species-result_title") %>'></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${title}" downloadLink="<%= tsvLink%>" btrail="<%= location%>">
    <stripes:layout-component name="head">
        <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/eea_search.css">
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/sites-names.js"></script>
    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <a name="documentContent"></a>
        <h1>
          <%=cm.cmsPhrase("Pick species, show sites")%>
        </h1>
<!-- MAIN CONTENT -->

            <%=cm.cmsPhrase("You searched sites related to species with ")%> <strong><%=(formBean.getMainSearchCriteria()).toHumanString()%></strong>.
            <br />
            <%=cm.cmsPhrase("Results found")%>:
            <strong>
              <%=resultsCount%>
            </strong>
            <br />
          <%
            // Prepare parameters for pagesize.jsp
            Vector pageSizeFormFields = new Vector();       /*  These fields are used by pagesize.jsp, included below.    */
            pageSizeFormFields.addElement("sort");          /*  *NOTE* I didn't add currentPage & pageSize since pageSize */
            pageSizeFormFields.addElement("ascendency");    /*   is overriden & also pageSize is set to default           */
            pageSizeFormFields.addElement("criteriaSearch");/*   to page "0" aka first page. */
          %>
                <jsp:include page="pagesize.jsp">
                  <jsp:param name="guid" value="<%=guid%>"/>
                  <jsp:param name="pageName" value="<%=pageName%>"/>
                  <jsp:param name="pageSize" value="<%=formBean.getPageSize()%>"/>
                  <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(pageSizeFormFields)%>"/>
                </jsp:include>
          <%
            // Prepare the form parameters.
            Vector filterSearch = new Vector();
            filterSearch.addElement("sort");
            filterSearch.addElement("ascendency");
            filterSearch.addElement("criteriaSearch");
            filterSearch.addElement("pageSize");
          %>
                <br />
                <div class="grey_rectangle">
                  <strong>
                    <%=cm.cmsPhrase("Refine your search")%>
                  </strong>
                  <form title="refine search results" name="criteriaSearch" method="get" onsubmit="return(check(<%=noCriteria%>));" action="">
                    <%=formBean.toFORMParam(filterSearch)%>
                    <label for="criteriaType" class="noshow"><%=cm.cmsPhrase("Criteria")%></label>
                    <select id="criteriaType" name="criteriaType" title="<%=cm.cmsPhrase("Criteria")%>">
          <%
            if (showSourceDB)
            {
          %>
                      <option value="<%=SpeciesSearchCriteria.CRITERIA_SOURCE_DB%>">
                        <%=cm.cms("database_source")%>
                      </option>
          <%
             }
             if (showName)
             {
          %>
                      <option value="<%=SpeciesSearchCriteria.CRITERIA_ENGLISH_NAME%>">
                        <%=cm.cms("site_name")%>
                      </option>
          <%
              }
          %>
                    </select>
                    <%=cm.cmsInput("database_source")%>
                    <%=cm.cmsInput("site_name")%>

                    <select id="oper" name="oper" title="<%=cm.cmsPhrase("Operator")%>">
                      <option value="<%=Utilities.OPERATOR_IS%>" selected="selected"><%=cm.cmsPhrase("is")%></option>
                      <option value="<%=Utilities.OPERATOR_STARTS%>"><%=cm.cmsPhrase("starts with")%></option>
                      <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cmsPhrase("contains")%></option>
                    </select>

                    <label for="criteriaSearch" class="noshow"><%=cm.cmsPhrase("Filter value")%></label>
                    <input id="criteriaSearch" name="criteriaSearch" type="text" size="30" title="<%=cm.cmsPhrase("Filter value")%>" />

                    <input id="submit" name="Submit" type="submit" value="<%=cm.cmsPhrase("Search")%>" class="submitSearchButton" title="<%=cm.cmsPhrase("Search")%>" />
                  </form>
          <%
            ro.finsiel.eunis.search.AbstractSearchCriteria[] criterias = formBean.toSearchCriteria();
            if (criterias.length > 1)
            {
          %>
                  <%=cm.cmsPhrase("Applied filters to the results:")%>
                  <br />
          <%
            }
            for (int i = criterias.length - 1; i > 0; i--)
            {
              AbstractSearchCriteria criteria = criterias[i];
              if (null != criteria && null != formBean.getCriteriaSearch())
              {
          %>
                  <a title="<%=cm.cms("removefilter_title")%>" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>"><img src="images/mini/delete.jpg" alt="<%=cm.cms("delete")%>" border="0" style="vertical-align:middle" /></a>
                  <%=cm.cmsTitle("removefilter_title")%>
                  <%=cm.cmsAlt("delete")%>
                  <strong><%= i + ". " + criteria.toHumanString()%></strong>
                  <br />
          <%
              }
            }
          %>
                </div>
                <br />
          <%
            // Prepare parameters for navigator.jsp
            Vector navigatorFormFields = new Vector();  /*  The following fields are used by paginator.jsp, included below.      */
            navigatorFormFields.addElement("pageSize"); /* NOTE* that I didn't add here currentPage since it is overriden in the */
            navigatorFormFields.addElement("sort");     /* <form name="..."> in the navigator.jsp!                               */
            navigatorFormFields.addElement("ascendency");
            navigatorFormFields.addElement("criteriaSearch");
          %>
                <jsp:include page="navigator.jsp">
                  <jsp:param name="pagesCount" value="<%=pagesCount%>"/>
                  <jsp:param name="pageName" value="<%=pageName%>"/>
                  <jsp:param name="guid" value="<%=guid%>"/>
                  <jsp:param name="currentPage" value="<%=formBean.getCurrentPage()%>"/>
                  <jsp:param name="toURLParam" value="<%=formBean.toURLParam(navigatorFormFields)%>"/>
                  <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(navigatorFormFields)%>"/>
                </jsp:include>
          <%
            // Compute the sort criteria
            Vector sortURLFields = new Vector();      /* Used for sorting */
            sortURLFields.addElement("pageSize");
            sortURLFields.addElement("criteriaSearch");
            String urlSortString = formBean.toURLParam(sortURLFields);
            AbstractSortCriteria sortSourceDB = formBean.lookupSortCriteria(SpeciesSortCriteria.SORT_SOURCE_DB);
            AbstractSortCriteria sortName = formBean.lookupSortCriteria(SpeciesSortCriteria.SORT_NAME);
            //AbstractSortCriteria sortDesignType = formBean.lookupSortCriteria(SpeciesSortCriteria.SORT_DESIGNATION);
            //AbstractSortCriteria sortSpecies = formBean.lookupSortCriteria(SpeciesSortCriteria.SORT_SPECIES);
            AbstractSortCriteria sortLat = formBean.lookupSortCriteria(SpeciesSortCriteria.SORT_LAT);
            AbstractSortCriteria sortLong = formBean.lookupSortCriteria(SpeciesSortCriteria.SORT_LONG);
          %>
                <table class="sortable listing" width="100%" summary="<%=cm.cmsPhrase("Search results")%>">
                  <thead>
                    <tr>
          <%
            if (showSourceDB)
            {
          %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SpeciesSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, null == sortSourceDB)%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=cm.cmsPhrase("Source data set")%></a>
                      </th>
          <%
            }
            if (showDesignType)
            {
          %>
                      <th class="nosort" scope="col">
                        <%=cm.cmsPhrase("Designation type")%>
                      </th>
          <%
            }
            if (showName)
            {
          %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SpeciesSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortName, null == sortName)%>"><%=Utilities.getSortImageTag(sortName)%><%=cm.cmsPhrase("Site name")%></a>
                      </th>
          <%
            }
            if (showCoord)
            {
          %>
                      <th class="nosort" scope="col" style="text-align : center; white-space:nowrap;">
                        <%=cm.cmsPhrase("Longitude")%>
                      </th>
                      <th class="nosort" scope="col" style="text-align : center; white-space:nowrap;">
                        <%=cm.cmsPhrase("Latitude")%>
                      </th>
          <%
            }
            if (showSpecies)
            {
          %>
                      <th class="nosort" scope="col">
                        <%=cm.cmsPhrase("Species name")%>
                      </th>
          <%
            }
          %>
                    </tr>
                  </thead>
                  <tbody>
          <%
            Iterator it = results.iterator();
            int i = 0;
            while (it.hasNext())
            {
              SpeciesPersist site = (SpeciesPersist)it.next();
          %>
                  <tr>
          <%
            if (showSourceDB)
            {
          %>
                    <td>
                      <%=Utilities.formatString(SitesSearchUtility.translateSourceDB(site.getSourceDB()))%>
                    </td>
          <%
            }
            if (showDesignType)
            {
          %>
                    <td>
                      <jsp:include page="sites-designations-detail.jsp">
                        <jsp:param name="idDesignation" value="<%=site.getIdDesignation()%>"/>
                        <jsp:param name="idGeoscope" value="<%=site.getIdGeoscope()%>"/>
                        <jsp:param name="sourceDB" value="<%=site.getSourceDB()%>"/>
                        <jsp:param name="idSite" value="<%=site.getIdSite()%>"/>
                      </jsp:include>
                    </td>
          <%
            }
            if (showName)
            {
          %>
                    <td>
                      <a href="sites/<%=site.getIdSite()%>"><%=Utilities.formatString(site.getName())%></a>
                    </td>
          <%
            }
            if (showCoord)
            {
          %>
                    <td style="white-space : nowrap; text-align : center;">
                      <%=SitesSearchUtility.formatLongitude(site.getLongitude())%>&nbsp;
                    </td>
                    <td style="white-space : nowrap; text-align : center;">
                      <%=SitesSearchUtility.formatLatitude(site.getLatitude())%>&nbsp;
                    </td>
          <%
            }
            if (showSpecies)
            {
          %>
                    <td>
          <%
//  Vector speciesURLFields = new Vector();
//  speciesURLFields.addElement("criteriaSearch");
//  String searchURL = formBean.toURLParam(speciesURLFields) + "&idNatureObject=" + site.getIdNatureObject();
              Integer relationOp = Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS);
              Integer idNatureObject = site.getIdNatureObject();
              // List of species attributes.
              List resultsSpecies = new SpeciesDomain().findSpeciesFromSite(new SpeciesSearchCriteria(searchAttribute,
                                                                                          formBean.getSearchString(),
                                                                                          relationOp),
                                                                                   SessionManager.getShowEUNISInvalidatedSpecies(),
                                                                                   idNatureObject,
                                                                                   searchAttribute, source);
              if (resultsSpecies != null && resultsSpecies.size() > 0)
              {
          %>
                      <%--<ul>--%>
          <%
                for(int ii=0;ii<resultsSpecies.size();ii++)
                {
                  TableColumns tableColumns = (TableColumns) resultsSpecies.get(ii);
                  String scientificName = (String)tableColumns.getColumnsValues().get(0);
                  Integer idSpecies = (Integer)tableColumns.getColumnsValues().get(1);
          %>
                        <p>
                            <a href="species/<%=idSpecies%>"><%=scientificName%></a>
                          </p>
          <%
                }
          %>
                      <%--</ul>--%>
          <%
            }
          %>
                    </td>
          <%
            }
          %>
                  </tr>
          <%
            }
          %>
                </tbody>
                <thead>
                  <tr>
          <%
            if (showSourceDB)
            {
          %>
                    <th class="nosort" scope="col">
                      <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SpeciesSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, null == sortSourceDB)%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=cm.cmsPhrase("Source data set")%></a>
                    </th>
          <%
            }
            if (showDesignType)
            {
          %>
                    <th class="nosort" scope="col">
                      <%=cm.cmsPhrase("Designation type")%>
                    </th>
          <%
            }
            if (showName)
            {
          %>
                    <th class="nosort" scope="col">
                      <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SpeciesSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortName, null == sortName)%>"><%=Utilities.getSortImageTag(sortName)%><%=cm.cmsPhrase("Site name")%></a>
                    </th>
          <%
            }
            if (showCoord)
            {
          %>
                    <th class="nosort" scope="col" style="text-align : center; white-space:nowrap;">
                      <%=cm.cmsPhrase("Longitude")%>
                    </th>
                    <th class="nosort" scope="col" style="text-align : center; white-space:nowrap;">
                      <%=cm.cmsPhrase("Latitude")%>
                    </th>
          <%
            }
            if (showSpecies)
            {
          %>
                      <th class="nosort" scope="col">
                        <%=cm.cmsPhrase("Species name")%>
                      </th>
          <%
            }
          %>
                    </tr>
                  </thead>
                </table>
                <jsp:include page="navigator.jsp">
                  <jsp:param name="pagesCount" value="<%=pagesCount%>"/>
                  <jsp:param name="pageName" value="<%=pageName%>"/>
                  <jsp:param name="guid" value="<%=guid + 1%>"/>
                  <jsp:param name="currentPage" value="<%=formBean.getCurrentPage()%>"/>
                  <jsp:param name="toURLParam" value="<%=formBean.toURLParam(navigatorFormFields)%>"/>
                  <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(navigatorFormFields)%>"/>
                </jsp:include>

                <%=cm.cmsMsg("sites_species-result_title")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("species_from_site")%>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>