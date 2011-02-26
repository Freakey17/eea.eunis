package ro.finsiel.eunis.jrfTables.species.names;


import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.ShortColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.OuterJoinTable;
import net.sf.jrf.join.joincolumns.IntegerJoinColumn;
import net.sf.jrf.join.joincolumns.StringJoinColumn;
import net.sf.jrf.join.joincolumns.ShortJoinColumn;
import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.species.names.NameSearchCriteria;
import ro.finsiel.eunis.search.species.names.NameSortCriteria;

import java.util.List;


// SELECT *
// FROM CHM62EDT_REPORTS AS G
// INNER JOIN CHM62EDT_SPECIES AS A ON G.ID_NATURE_OBJECT = A.ID_NATURE_OBJECT
// INNER JOIN CHM62EDT_GROUP_SPECIES AS B ON A.ID_GROUP_SPECIES = B.ID_GROUP_SPECIES
// INNER JOIN CHM62EDT_TAXONOMY AS C ON A.ID_TAXONOMY = C.ID_TAXONOMY
// LEFT JOIN CHM62EDT_TAXONOMY AS D ON C.ID_TAXONOMY_LINK = D.ID_TAXONOMY
// WHERE G.VERNACULAR_NAME LIKE "AAA%" GROUP BY A.ID_NATURE_OBJECT

/**
 * @author finsiel
 * @version 1.0
 * @since 28.01.2003
 * Vernacular names in any language
 */
public class VernacularNameAnyDomain extends AbstractDomain implements Paginable {

    /** Criterias applied for searching */
    private AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0]; // 0 length means not criteria set

    /** Criterias applied for sorting */
    private AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0]; // 0 length means unsorted

    /** Cache the results of a count to avoid overhead queries for counting */
    private Long _resultCount = new Long(-1);

    private boolean showEUNISInvalidatedSpecies = false;

    /**
     * Normal constructor
     * @param searchCriteria Search criteria used to query the database
     * @param sortCriteria Sort criteria used to sort the results
     */
    public VernacularNameAnyDomain(AbstractSearchCriteria[] searchCriteria, AbstractSortCriteria[] sortCriteria, boolean showEUNISInvalidatedSpecies) {
        this.searchCriteria = searchCriteria;
        this.sortCriteria = sortCriteria;
        this.showEUNISInvalidatedSpecies = showEUNISInvalidatedSpecies;
    }

    /**
     * Used by JRF Framework
     * @return The PersistentObject representing a row from results
     */
    public PersistentObject newPersistentObject() {
        return new VernacularNameAnyPersist();
    }

    /**
     * Used by JRF Framework
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());

        this.setTableName("CHM62EDT_REPORTS");

        this.addColumnSpec(
                new CompoundPrimaryKeyColumnSpec(
                        new IntegerColumnSpec("ID_NATURE_OBJECT",
                        "getIdNatureObject", "setIdNatureObject",
                        DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                        new IntegerColumnSpec("ID_DC", "getIdDc", "setIdDc",
                        DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                        new IntegerColumnSpec("ID_GEOSCOPE", "getIdGeoscope",
                        "setIdGeoscope", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                        new IntegerColumnSpec("ID_GEOSCOPE_LINK",
                        "getIdGeoscopeLink", "setIdGeoscopeLink",
                        DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                        new IntegerColumnSpec("ID_REPORT_TYPE",
                        "getIdReportType", "setIdReportType", DEFAULT_TO_ZERO,
                        NATURAL_PRIMARY_KEY),
                        new IntegerColumnSpec("ID_REPORT_ATTRIBUTES",
                        "getIdReportAttributes", "setIdReportAttributes",
                        DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY)));
        this.setTableAlias("G");
        this.setReadOnly(true);

        JoinTable reportType = null;

        reportType = new JoinTable("CHM62EDT_REPORT_TYPE F", "ID_REPORT_TYPE",
                "ID_REPORT_TYPE");
        this.addJoinTable(reportType);

        JoinTable species = null;

        species = new JoinTable("CHM62EDT_SPECIES A", "ID_NATURE_OBJECT",
                "ID_NATURE_OBJECT");
        species.addJoinColumn(
                new StringJoinColumn("SCIENTIFIC_NAME", "scientificName",
                "setScientificName"));
        species.addJoinColumn(
                new ShortJoinColumn("VALID_NAME", "validName", "setValidName"));
        species.addJoinColumn(
                new IntegerJoinColumn("ID_SPECIES", "idSpecies", "setIdSpecies"));
        species.addJoinColumn(
                new IntegerJoinColumn("ID_SPECIES_LINK", "idSpeciesLink",
                "setIdSpeciesLink"));
        species.addJoinColumn(
                new IntegerJoinColumn("ID_SPECIES_LINK", "idSpeciesLink",
                "setIdSpeciesLink"));
        this.addJoinTable(species);

        OuterJoinTable groupSpecies = null;

        groupSpecies = new OuterJoinTable("CHM62EDT_GROUP_SPECIES B",
                "ID_GROUP_SPECIES", "ID_GROUP_SPECIES");
        groupSpecies.addJoinColumn(
                new StringJoinColumn("COMMON_NAME", "commonName",
                "setCommonName"));
        species.addJoinTable(groupSpecies);

        OuterJoinTable taxCodeFamily = null;

        taxCodeFamily = new OuterJoinTable("CHM62EDT_TAXONOMY C", "ID_TAXONOMY",
                "ID_TAXONOMY");
        taxCodeFamily.addJoinColumn(
                new StringJoinColumn("NAME", "taxonomyName", "setTaxonomyName"));
        taxCodeFamily.addJoinColumn(
                new StringJoinColumn("LEVEL", "taxonomyLevel",
                "setTaxonomyLevel"));
        taxCodeFamily.addJoinColumn(
                new StringJoinColumn("TAXONOMY_TREE", "taxonomyTree",
                "setTaxonomyTree"));
        taxCodeFamily.addJoinColumn(
                new StringJoinColumn("NAME", "taxonomicNameFamily",
                "setTaxonomicNameFamily"));
        taxCodeFamily.addJoinColumn(
                new StringJoinColumn("NAME", "taxonomicNameOrder",
                "setTaxonomicNameOrder"));
        species.addJoinTable(taxCodeFamily);

        // OuterJoinTable taxCodeOrder = null;
        // taxCodeOrder = new OuterJoinTable("CHM62EDT_TAXONOMY D", "ID_TAXONOMY_LINK", "ID_TAXONOMY");
        // taxCodeOrder.addJoinColumn(new StringJoinColumn("NAME", "taxonomicNameOrder", "setTaxonomicNameOrder"));
        // taxCodeFamily.addJoinTable(taxCodeOrder);

        // Joined tables
        JoinTable reportTypeAttributes = null;

        reportTypeAttributes = new JoinTable("CHM62EDT_REPORT_ATTRIBUTES I",
                "ID_REPORT_ATTRIBUTES", "ID_REPORT_ATTRIBUTES");
        reportTypeAttributes.addJoinColumn(
                new StringJoinColumn("VALUE", "setReportValue"));
        this.addJoinTable(reportTypeAttributes);

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
        if (searchCriteria.length < 1) {
            throw new CriteriaMissingException(
                    "Unable to search because no search criteria was specified...");
        }
        // Prepare the WHERE clause
        StringBuffer filterSQL = _prepareWhereSearch();

        // Add GROUP BY CLAUSE
        filterSQL.append(" GROUP BY A.ID_NATURE_OBJECT ");
        if (sortCriteria.length > 0) {
            filterSQL.append(_prepareWhereSort());
        }
        // Add the LIMIT clause to return only the wanted results
        if (pageSize != 0) { // Doesn't make sense for pageSize = 0.
            filterSQL.append(" LIMIT " + offsetStart + ", " + pageSize);
        }
        List tempList = this.findWhere(filterSQL.toString());

        _resultCount = new Long(-1); // After each query, reset the _resultCount, so countResults do correct numbering.
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
     * @see ro.finsiel.eunis.jrfTables.species.country.RegionDomain#countResults
     * @return
     * @throws ro.finsiel.eunis.exceptions.CriteriaMissingException
     */
    private Long _rawCount() throws CriteriaMissingException {
        StringBuffer sql = new StringBuffer();

        // Set the main QUERY
        sql.append(
                "SELECT COUNT(DISTINCT A.ID_NATURE_OBJECT) FROM CHM62EDT_REPORTS AS G "
                        + "INNER JOIN CHM62EDT_REPORT_TYPE AS F ON G.ID_REPORT_TYPE = F.ID_REPORT_TYPE "
                        + "INNER JOIN CHM62EDT_SPECIES AS A ON G.ID_NATURE_OBJECT = A.ID_NATURE_OBJECT "
                        + "LEFT JOIN CHM62EDT_GROUP_SPECIES AS B ON A.ID_GROUP_SPECIES = B.ID_GROUP_SPECIES "
                        + "LEFT JOIN CHM62EDT_TAXONOMY AS C ON A.ID_TAXONOMY = C.ID_TAXONOMY "
                        + "LEFT JOIN CHM62EDT_TAXONOMY AS D ON C.ID_TAXONOMY_LINK = D.ID_TAXONOMY "
                        + "INNER JOIN CHM62EDT_REPORT_ATTRIBUTES AS I ON G.ID_REPORT_ATTRIBUTES = I.ID_REPORT_ATTRIBUTES WHERE ");
        // Apply WHERE CLAUSE
        sql.append(_prepareWhereSearch().toString());
        // Apply SORT CLAUSE - DON'T NEED IT FOR COUNT...
        // Apply GROUP BY CLAUSE - DON'T NEED IT HERE
        Long ret = findLong(sql.toString());

        if (null == ret) {
            return new Long(0);
        }
        return ret;
    }

    /** This helper method is used to construct the string after WHERE...based on search criterias set. In another words
     * constructs .....WHERE...>>B.ID_GEOSCOPE_LINK=XXX OR B.ID_GEOSCOPE_LINK=YYY OR B.ID_GEOSCOPE_LINK=ZZZ .....
     * @return SQL string
     * @throws ro.finsiel.eunis.exceptions.CriteriaMissingException If no search criteria search or wrong criteria is set.
     */
    private StringBuffer _prepareWhereSearch() throws CriteriaMissingException {
        StringBuffer filterSQL = new StringBuffer();

        filterSQL.append(" F.LOOKUP_TYPE = 'LANGUAGE' ");
        if (searchCriteria.length <= 0) {
            throw new CriteriaMissingException(
                    "No criteria set for searching. Search interrupted.");
        }
        for (int i = 0; i < searchCriteria.length; i++) {
            if (i > 0) {
                filterSQL.append(" AND ");
            }
            NameSearchCriteria aCriteria = (NameSearchCriteria) searchCriteria[i]; // upcast

            filterSQL.append(
                    aCriteria.toSQL());
        }
        filterSQL.append(
                Utilities.showEUNISInvalidatedSpecies("AND A.VALID_NAME",
                showEUNISInvalidatedSpecies));
        // filterSQL.append(" AND C.LEVEL='FAMILY' AND D.LEVEL='ORDER' ");
        return filterSQL;
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
                    if (i > 0) {
                        filterSQL.append(", ");
                    }
                    NameSortCriteria criteria = (NameSortCriteria) sortCriteria[i]; // Notice the upcast here

                    if (!criteria.getCriteriaAsString().equals("none")) { // Do not add if criteria is sort to NOT SORT
                        if (!criteria.getAscendencyAsString().equals("none")) { // Don't add if ascendency is set to none, nasty hacks
                            filterSQL.append(
                                    criteria.toSQL());
                            useSort = true;
                        }
                    }
                    i++;
                } while (i < sortCriteria.length);
            }
            if (useSort) { // If a sort criteria was indeed used, then insert ORDER BY clause at the start of the string
                filterSQL.insert(0, " ORDER BY ");
            }
        } catch (InitializationException e) {
            e.printStackTrace(); // To change body of catch statement use Options | File Templates.
        } finally {
            return filterSQL;
        }
    }
}
