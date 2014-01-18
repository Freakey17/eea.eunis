package ro.finsiel.eunis.jrfTables.combined;

import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.join.OuterJoinTable;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;
import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.advanced.AdvancedSortCriteria;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.exceptions.CriteriaMissingException;

import java.util.List;

/**
 * Date: 10.07.2003
 * Time: 16:43:39
 */
public class SitesCombinedDomain extends AbstractDomain implements Paginable {

  /** Criterias applied for sorting */
  private AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0]; // 0 length means unsorted
  /** Cache the results of a count to avoid overhead queries for counting */
  private Long _resultCount = new Long(-1);

  private String sid = "";

  public SitesCombinedDomain(String sid) {
    this.sid = sid;
  }

  /****/
  public PersistentObject newPersistentObject() {
    return new SitesCombinedPersist();
  }

  /****/
  public void setup() {
    this.setTableName("CHM62EDT_SITES");
    this.setReadOnly(true);
    this.setTableAlias("A");

    this.addColumnSpec(new StringColumnSpec("ID_SITE", "getIdSite", "setIdSite", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY));
    this.addColumnSpec(new IntegerColumnSpec("ID_NATURE_OBJECT", "getIdNatureObject", "setIdNatureObject", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("RESPONDENT", "getRespondent", "setRespondent", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("NAME", "getName", "setName", DEFAULT_TO_EMPTY_STRING, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("MANAGER", "getManager", "setManager", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("COMPLEX_NAME", "getComplexName", "setComplexName", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("DISTRICT_NAME", "getDistrictName", "setDistrictName", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("OWNERSHIP", "getOwnership", "setOwnership", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("HISTORY", "getHistory", "setHistory", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("CHARACTER", "getCharacter", "setCharacter", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("DESCRIPTION", "getDescription", "setDescription", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("MANAGEMENT_PLAN", "getManagementPlan", "setManagementPlan", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("IUCNAT", "getIucnat", "setIucnat", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("DESIGNATION_DATE", "getDesignationDate", "setDesignationDate", null));
    this.addColumnSpec(new StringColumnSpec("COMPILATION_DATE", "getCompilationDate", "setCompilationDate", null));
    this.addColumnSpec(new StringColumnSpec("PROPOSED_DATE", "getProposedDate", "setProposedDate", null));
    this.addColumnSpec(new StringColumnSpec("CONFIRMED_DATE", "getConfirmedDate", "setConfirmedDate", null));
    this.addColumnSpec(new StringColumnSpec("UPDATE_DATE", "getUpdateDate", "setUpdateDate", null));
    this.addColumnSpec(new StringColumnSpec("SPA_DATE", "getSpaDate", "setSpaDate", null));
    this.addColumnSpec(new StringColumnSpec("SAC_DATE", "getSacDate", "setSacDate", null));
    this.addColumnSpec(new StringColumnSpec("NATIONAL_CODE", "getNationalCode", "setNationalCode", null));
    this.addColumnSpec(new StringColumnSpec("NATURA_2000", "getNatura2000", "setNatura2000", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("NUTS", "getNuts", "setNuts", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("AREA", "getArea", "setArea", null));
    this.addColumnSpec(new StringColumnSpec("LENGTH", "getLength", "setLength", DEFAULT_TO_NULL));

    this.addColumnSpec(new StringColumnSpec("ALT_MEAN", "getAltMean", "setAltMean", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("ALT_MAX", "getAltMax", "setAltMax", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("ALT_MIN", "getAltMin", "setAltMin", DEFAULT_TO_NULL));

    this.addColumnSpec(new StringColumnSpec("LONGITUDE", "getLongitude", "setLongitude", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("LATITUDE", "getLatitude", "setLatitude", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("SOURCE_DB", "getSourceDB", "setSourceDB", DEFAULT_TO_NULL));

    OuterJoinTable natureObjectGeoscope = new OuterJoinTable("CHM62EDT_NATURE_OBJECT_GEOSCOPE B ", "ID_NATURE_OBJECT", "ID_NATURE_OBJECT");
    this.addJoinTable(natureObjectGeoscope);

    OuterJoinTable country = new OuterJoinTable("CHM62EDT_COUNTRY C", "ID_GEOSCOPE", "ID_GEOSCOPE");
    country.addJoinColumn(new StringJoinColumn("AREA_NAME_EN", "setAreaNameEn"));
    natureObjectGeoscope.addJoinTable(country);

    OuterJoinTable designations = new OuterJoinTable("CHM62EDT_DESIGNATIONS E ", "ID_DESIGNATION", "ID_DESIGNATION");
    designations.addJoinColumn(new StringJoinColumn("DESCRIPTION", "setDesign"));
    this.addJoinTable(designations);

    JoinTable advSearchResults = new JoinTable("EUNIS_COMBINED_SEARCH_RESULTS F", "ID_NATURE_OBJECT", "ID_NATURE_OBJECT");
    this.addJoinTable(advSearchResults);
  }

  /** This method is used to retrieve a sub-set of the main results of a query given its start index offset and end
   * index offset.
   * @param offsetStart The start offset (i.e. 0). If offsetStart = offSetEnd then return the whole list
   * @param pageSize The end offset (i.e. 1). If offsetStart = offSetEnd then return the whole list
   * @param sortCriteria The criteria used for sorting
   * @return A list of objects which match query criteria
   */
  public List getResults(int offsetStart, int pageSize, AbstractSortCriteria[] sortCriteria) throws CriteriaMissingException {
    this.sortCriteria = sortCriteria;
    // Prepare the WHERE clause
    String filterSQL = " 1=1 ";
    filterSQL += " AND F.ID_SESSION='" + sid + "'";
    // Add GROUP BY clause for unique results
    // Add the LIMIT clause to return only the wanted results
    if (pageSize != 0) { // Doesn't make sense for pageSize = 0.
      filterSQL += "GROUP BY A.ID_SITE, IF(B.ID_GEOSCOPE IS NULL, '', B.ID_GEOSCOPE) ";
    }
    // Add the ORDER BY clause to do the sorting
    if (sortCriteria.length > 0) {
      filterSQL += _prepareWhereSort();
    }
    filterSQL += " LIMIT " + offsetStart + ", " + pageSize;
    List tempList = this.findWhere(filterSQL.toString());
    _resultCount = new Long(-1);// After each query, reset the _resultCount, so countResults do correct numbering.
    return tempList;
  }

  /** This method is used to count the total list of results from a query. It is used to find all for use in pagination.
   * Having the total number of results and the results displayed per page, the you could find the number of pages i.e.
   * @return The total number of results
   */
  public Long countResults() throws CriteriaMissingException {
    if (-1 == _resultCount.longValue()) {
      _resultCount = _rawCount();
    }
    return _resultCount;
  }

  /** This method does the raw counting (meaning that will do a DB query for retrieving results count). You should check
   * in your code that this method is called (in ideal way) only once and results are cached. This is what
   * countResults() method does in this class
   */
  private Long _rawCount() {
    StringBuffer sql = new StringBuffer();
    sql.append("SELECT COUNT(DISTINCT A.ID_SITE, IF(B.ID_GEOSCOPE IS NULL, '', B.ID_GEOSCOPE)) FROM CHM62EDT_SITES A " +
            " LEFT OUTER JOIN CHM62EDT_NATURE_OBJECT_GEOSCOPE B ON A.ID_NATURE_OBJECT=B.ID_NATURE_OBJECT " +
            " LEFT OUTER JOIN CHM62EDT_COUNTRY C ON B.ID_GEOSCOPE=C.ID_GEOSCOPE " +
            " LEFT OUTER JOIN CHM62EDT_DESIGNATIONS E ON (A.ID_DESIGNATION=E.ID_DESIGNATION AND A.ID_GEOSCOPE=E.ID_GEOSCOPE) " +
            " INNER JOIN EUNIS_COMBINED_SEARCH_RESULTS F ON A.ID_NATURE_OBJECT=F.ID_NATURE_OBJECT " +
            " WHERE 1=1 AND F.ID_SESSION='" + sid + "'");
    Long ret = findLong(sql.toString());
    if (null == ret) return new Long(0);
    return ret;
  }

  /** Prepare the ORDER BY clause used to do the sorting. Basically it adds the ORDER clause with the criterias set in
   * the sortCriteria[] array.
   * @return SQL representation of the sorting.
   */
  private StringBuffer _prepareWhereSort() {
    StringBuffer filterSQL = new StringBuffer();
    try {
      boolean useSort = false;
      if (sortCriteria.length > 0) {
        int i = 0;
        do {
          if (i > 0) filterSQL.append(", ");
          AdvancedSortCriteria criteria = (AdvancedSortCriteria) sortCriteria[i]; // Notice the upcast here
          if (!criteria.getCriteriaAsString().equals("none")) {// Do not add if criteria is sort to NOT SORT
            if (!criteria.getAscendencyAsString().equals("none")) { // Don't add if ascendency is set to none, nasty hacks
              filterSQL.append(criteria.toSQL());
              useSort = true;
            }
          }
          i++;
        } while (i < sortCriteria.length);
      }
      if (useSort) {// If a sort criteria was indeed used, then insert ORDER BY clause at the start of the string
        filterSQL.insert(0, " ORDER BY ");
      }
    } catch (InitializationException e) {
      e.printStackTrace();  //To change body of catch statement use Options | File Templates.
    } finally {
      return filterSQL;
    }
  }
}
