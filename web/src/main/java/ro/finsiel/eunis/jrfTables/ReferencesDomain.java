package ro.finsiel.eunis.jrfTables;


import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.sql.JRFResultSet;

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.ReferencesSearchCriteria;
import ro.finsiel.eunis.formBeans.ReferencesSortCriteria;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.ReferencesWrapper;
import eionet.eunis.dto.PairDTO;
import eionet.eunis.dto.ReferenceSpeciesDTO;
import eionet.eunis.dto.ReferenceSpeciesGroupDTO;


/**
 * @author finsiel
 **/
public class ReferencesDomain extends AbstractDomain implements Paginable {

    /** Criterias applied for searching */
    private AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0]; // 0 length means not criteria set

    /** Criterias applied for sorting */
    private AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0]; // 0 length means unsorted

    /** Cache the results of a count to avoid overhead queries for counting */
    private Long _resultCount = new Long(-1);

    Vector ListOfReferences = new Vector();

    public ReferencesDomain(AbstractSearchCriteria[] searchCriteria, AbstractSortCriteria[] sortCriteria) {
        this.searchCriteria = searchCriteria;
        this.sortCriteria = sortCriteria;
    }

    /** This method is used to retrieve a sub-set of the main results of a query given its start index offset and end
     * index offset.
     * @param offsetStart The start offset (i.e. 0). If offsetStart = offSetEnd then return the whole list
     * @param pageSize The end offset (i.e. 1). If offsetStart = offSetEnd then return the whole list
     * @param sortCriteria The criteria used for sorting
     * @return A list of objects which match query criteria
     */
    @Override
    public List getResults(int offsetStart, int pageSize, AbstractSortCriteria[] sortCriteria) throws CriteriaMissingException {

        this.sortCriteria = sortCriteria;
        if (searchCriteria.length < 1) {
            throw new CriteriaMissingException(
            "Unable to search because no search criteria was specified...");
        }

        // add filter from results page
        StringBuffer filterSQL = _prepareWhereSearch("ReferencesPart");
        // Add the ORDER BY clause to do the sorting
        StringBuffer sortOrderAndLimit = new StringBuffer();

        if (sortCriteria.length > 0) {
            sortOrderAndLimit.append(_prepareWhereSort());
        }
        // Add the LIMIT clause to return only the wanted results
        if (pageSize != 0) { // Doesn't make sense for pageSize = 0.
            sortOrderAndLimit.append(" LIMIT " + offsetStart + ", " + pageSize);
        }

        Vector results = new Vector();

        try {
            results = getReferencesList(filterSQL, sortOrderAndLimit.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }

        List tempList = results;

        _resultCount = new Long(-1); // After each query, reset the _resultCount, so countResults do correct numbering.
        return tempList;
    }

    private Vector getReferencesList(StringBuffer SQLfilter, String sortOrderAndLimit) {
        final Vector results = new Vector();

        String condition = (SQLfilter.length() > 0 ? " AND " + SQLfilter : "");

        String SQL = " SELECT DISTINCT `DC_INDEX`.`SOURCE`,";
        SQL += " `DC_INDEX`.`CREATED`,";
        SQL += " `DC_INDEX`.`TITLE`,";
        SQL += " `DC_INDEX`.`EDITOR`,";
        SQL += " `DC_INDEX`.`PUBLISHER`,";
        SQL += " `DC_INDEX`.`URL`, DC_INDEX.ID_DC ";
        SQL += "  FROM  `DC_INDEX`";
        // !!added to get only references with species and habitats
        SQL += " INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`DC_INDEX`.`ID_DC` = `CHM62EDT_NATURE_OBJECT`.`ID_DC`)";
        SQL += " WHERE `DC_INDEX`.`COMMENT` = 'REFERENCES'";
        SQL += condition;
        SQL += sortOrderAndLimit;

        this.executeSQLQuery(SQL, new RowHandler() {
            public void handleRow(JRFResultSet rs) throws Exception {
                ReferencesWrapper rw = new ReferencesWrapper(rs.getString(1),
                        rs.getString(2), rs.getString(3), rs.getString(4),
                        rs.getString(5), rs.getString(6), rs.getString(7));

                results.addElement(rw);
            }
        });
        return results;
    }

    public List<PairDTO> getHabitatsForAReferences(String idDc) {
        final List<PairDTO> results = new ArrayList<PairDTO>();
        String isGoodHabitat = " IF(TRIM(H.CODE_2000) <> '',RIGHT(H.CODE_2000,2),1) <> IF(TRIM(H.CODE_2000) <> '','00',2) AND IF(TRIM(H.CODE_2000) <> '',LENGTH(H.CODE_2000),1) = IF(TRIM(H.CODE_2000) <> '',4,1) ";

        String SQL = " SELECT DISTINCT H.ID_HABITAT,H.SCIENTIFIC_NAME  ";
        SQL += " FROM  DC_INDEX A ";
        SQL += " INNER JOIN CHM62EDT_HABITAT_REFERENCES B ON (A.ID_DC = B.ID_DC) ";
        SQL += " INNER JOIN CHM62EDT_HABITAT H ON (B.ID_HABITAT = H.ID_HABITAT) ";
        SQL += " WHERE " + isGoodHabitat + " AND A.ID_DC = " + idDc;

        this.executeSQLQuery(SQL, new RowHandler() {
            public void handleRow(JRFResultSet rs) throws Exception {
                PairDTO dto = new PairDTO();

                dto.setKey(rs.getString(1));
                dto.setValue(rs.getString(2));
                results.add(dto);
            }
        });
        return results;
    }
    
    public List<ReferenceSpeciesGroupDTO> getSpeciesForAReferenceByGroup(String idDc)
            throws CriteriaMissingException {
        
        List<ReferenceSpeciesGroupDTO> grouped = new ArrayList<ReferenceSpeciesGroupDTO>();
        List<ReferenceSpeciesDTO> ungrouped = getSpeciesForAReference(idDc);
        
        int currentGroupId = 0;
        // splitting ungrouped data into groups.
        ReferenceSpeciesGroupDTO activeGroup = null;
        
        for (ReferenceSpeciesDTO referenceSpeciesDTO : ungrouped){
            if (referenceSpeciesDTO.getGroupSpeciesId() != currentGroupId){
                currentGroupId = referenceSpeciesDTO.getGroupSpeciesId();
                activeGroup = new ReferenceSpeciesGroupDTO();
                activeGroup.setGroupSpeciesId(referenceSpeciesDTO.getGroupSpeciesId());
                activeGroup.setGroupCommonName(referenceSpeciesDTO.getGroupCommonName());
                activeGroup.setGroupScientificName(referenceSpeciesDTO.getGroupScientificName());
                activeGroup.setReferenceSpecies(new ArrayList<ReferenceSpeciesDTO>());
                grouped.add(activeGroup);
            }
            
            activeGroup.getReferenceSpecies().add(referenceSpeciesDTO);
        }
        
        return grouped;
        
    }

    public List<ReferenceSpeciesDTO> getSpeciesForAReference(String idDc)
                    throws CriteriaMissingException {
        final List<ReferenceSpeciesDTO> results = new ArrayList<ReferenceSpeciesDTO>();
        String SQL = "";
        String condition = " AND A.ID_DC = " + idDc;

        SQL = "SELECT DISTINCT H.ID_SPECIES,H.SCIENTIFIC_NAME,H.AUTHOR, H.ID_GROUP_SPECIES, CS.COMMON_NAME, CS.SCIENTIFIC_NAME   "
                        + "FROM CHM62EDT_SPECIES H "
                        + "INNER JOIN CHM62EDT_REPORTS B ON H.ID_NATURE_OBJECT=B.ID_NATURE_OBJECT "
                        + "INNER JOIN CHM62EDT_REPORT_TYPE K ON B.ID_REPORT_TYPE = K.ID_REPORT_TYPE "
                        + "INNER JOIN DC_INDEX A ON B.ID_DC = A.ID_DC "
                        + "INNER JOIN CHM62EDT_GROUP_SPECIES CS ON CS.ID_GROUP_SPECIES = H.ID_GROUP_SPECIES "
                        + "WHERE 1=1 "
                        + condition
                        + // Note: 'SPECIES_GEO' isn't used in chm62edt_report_type
                        " AND K.LOOKUP_TYPE IN ('DISTRIBUTION_STATUS','LANGUAGE','CONSERVATION_STATUS','SPECIES_GEO','LEGAL_STATUS','SPECIES_STATUS','POPULATION_UNIT','TREND') "
                        + " GROUP BY H.SCIENTIFIC_NAME " + " ORDER BY CS.ID_GROUP_SPECIES, H.SCIENTIFIC_NAME";

        this.executeSQLQuery(SQL, new RowHandler() {
            public void handleRow(JRFResultSet rs) throws Exception {
                String speciesId = rs.getString(1);
                String speciesName = rs.getString(2);
                String speciesAuthor = rs.getString(3);
                String groupId = rs.getString(4);
                String groupCommonName = rs.getString(5);
                String groupScientificName = rs.getString(6);

                ReferenceSpeciesDTO specie = new ReferenceSpeciesDTO();
                specie.setId(speciesId);
                specie.setName(speciesName);
                specie.setAuthor(speciesAuthor);
                specie.setGroupSpeciesId(Integer.parseInt(groupId));
                specie.setGroupCommonName(groupCommonName);
                specie.setGroupScientificName(groupScientificName);
                
                results.add(specie);
            }
        });
        return results;
    }

    /**
     * This method is used to count the total list of results from a query. It is used to find all for use in pagination.
     * Having the total number of results and the results displayed per page, the you could find the number of pages i.e.
     * @return Number of results found
     */
    @Override
    public Long countResults() throws CriteriaMissingException {
        if (-1 == _resultCount.longValue()) {
            _resultCount = _rawCount();
        }
        return _resultCount;
    }

    /** This method does the raw counting (meaning that will do a DB query for retrieving results count). You should check
     * in your code that this method is called (in ideal way) only once and results are cached. This is what
     * countResults() method does in this class
     * @return
     * @throws ro.finsiel.eunis.exceptions.CriteriaMissingException
     */
    private Long _rawCount() throws CriteriaMissingException {
        Long result = new Long(0);

        if (searchCriteria.length < 1) {
            throw new CriteriaMissingException(
            "Unable to search because no search criteria was specified...");
        }

        StringBuffer filterSQL = _prepareWhereSearch("ReferencesPart");

        try {
            ListOfReferences = getReferencesList(filterSQL, "");
            result = new Long(ListOfReferences.size());
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    /** This helper method is used to construct the string after WHERE...based on search criterias set. In another words
     * constructs .....WHERE...>>B.ID_GEOSCOPE_LINK=XXX OR B.ID_GEOSCOPE_LINK=YYY OR B.ID_GEOSCOPE_LINK=ZZZ .....
     * @return SQL string
     * @throws ro.finsiel.eunis.exceptions.CriteriaMissingException If no search criteria search or wrong criteria is set.
     */
    private StringBuffer _prepareWhereSearch(String whatPart) throws CriteriaMissingException {
        StringBuffer filterSQL = new StringBuffer();

        if (searchCriteria.length <= 0) {
            throw new CriteriaMissingException(
            "No criteria set for searching. Search interrupted.");
        }

        for (int i = 0; i < searchCriteria.length; i++) {
            ReferencesSearchCriteria aCriteria = (ReferencesSearchCriteria) searchCriteria[i]; // upcast

            if (aCriteria != null) {
                aCriteria.setPart(whatPart);
                if (aCriteria.toSQL().length() > 0 && filterSQL.length() > 0) {
                    filterSQL.append(" AND ");
                }
                filterSQL.append(aCriteria.toSQL());
            }
        }
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
                    ReferencesSortCriteria criteria = (ReferencesSortCriteria) sortCriteria[i]; // Notice the upcast here

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

    @Override
    protected void setup() {
        // This is just a silly implementation to make JRF happy, since the entire results are handled directly 
        this.setTableName("DC_INDEX");
        this.setReadOnly(true);
        this.addColumnSpec(new IntegerColumnSpec("ID", "getId", "setId", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
    }

    @Override
    public PersistentObject newPersistentObject() {
        // this is not actually used, see ReferencesWrapper instead 
        return null;
    }

}
