package ro.finsiel.eunis.search.sites.statistics;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import java.util.Vector;

import ro.finsiel.eunis.jrfTables.Chm62edtDesignationsDomain;
import ro.finsiel.eunis.jrfTables.sites.statistics.StatisticsDomain;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.CountryUtil;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.SitesFormBean;
import ro.finsiel.eunis.utilities.SQLUtilities;

/**
 * Form bean used for sites->statistical data.
 *
 * @author finsiel
 */
public class StatisticsBean extends SitesFormBean {
    private String designation = null;
    private String designationCat = null;
    private Long sitesNumber = new Long(-1);
    private Long totalArea = new Long(-1);
    private Long totalLength = new Long(-1);
    private static String[] db = {"Natura2000", "Corine", "Diploma", "CDDA_National", "CDDA_International", "Biogenetic",
            "NatureNet", "Emerald"};

    /**
     * Compute number of sites for main search criteria.
     *
     * @return number of sites
     */
    public Long computeNumberOfSites() {
        String sqlWhere = prepareSQLForComputeNoSites();
        Long sitesNumber;
        String sql = "";

        try {
            sql =
                    " SELECT COUNT(DISTINCT A.ID_SITE) FROM CHM62EDT_COUNTRY AS C "
                            + " INNER JOIN CHM62EDT_NATURE_OBJECT_GEOSCOPE AS B ON C.ID_GEOSCOPE = B.ID_GEOSCOPE "
                            + " INNER JOIN CHM62EDT_SITES AS A ON B.ID_NATURE_OBJECT=A.ID_NATURE_OBJECT ";
            if ((null != designation && designation.trim().length() > 0 && !designation.trim().equalsIgnoreCase("null"))
                    || (null != designationCat && !designationCat.equalsIgnoreCase("any") && !designationCat.trim()
                            .equalsIgnoreCase("null")))
            {
                sql +=
                        " INNER JOIN CHM62EDT_DESIGNATIONS E ON (A.ID_DESIGNATION=E.ID_DESIGNATION AND A.ID_GEOSCOPE=E.ID_GEOSCOPE)";
            }
            sql += " WHERE " + sqlWhere;

            sitesNumber = new StatisticsDomain().findLong(sql);

        } catch (Exception e) {
            e.printStackTrace();
            sitesNumber = new Long(0);
        }
        this.sitesNumber = sitesNumber;
        return sitesNumber;
    }

    /**
     * Construct the where condition for computeNumberOfSites function.
     *
     * @return SQL.
     */
    public String prepareSQLForComputeNoSites() {
        String sql = "";

        if (null != country && country.trim().length() > 0 && !country.trim().equalsIgnoreCase("null")) {
            sql += " C.AREA_NAME_EN='" + country + "'";
        }

        if (null != designation && designation.trim().length() > 0 && !designation.trim().equalsIgnoreCase("null")) {
            if (sql.length() > 0) {
                sql += " AND ( ";
            } else {
                sql += " ( ";
            }
            sql += "E.DESCRIPTION LIKE '%" + designation.replaceAll("'", "''") + "%'";
            sql += " OR ";
            sql += "E.DESCRIPTION_EN LIKE '%" + designation.replaceAll("'", "''") + "%'";
            sql += " OR ";
            sql += "E.DESCRIPTION_FR LIKE '%" + designation.replaceAll("'", "''") + "%'";
            sql += " )";
        }

        if (null != designationCat && !designationCat.equalsIgnoreCase("any") && !designationCat.trim().equalsIgnoreCase("null")) {
            if (sql.length() > 0) {
                sql += " AND ";
            }
            sql += "E.NATIONAL_CATEGORY='" + designationCat + "'";
        }

        if (null != yearMin && yearMin.trim().length() > 0 && !yearMin.trim().equalsIgnoreCase("null")) {
            if (sql.length() > 0) {
                sql += " AND ";
            }
            sql += " A.DESIGNATION_DATE IS NOT NULL" + " AND A.DESIGNATION_DATE <> ''";
            sql +=
                    " AND CAST(CONCAT(IF(A.source_db='BIOGENETIC',left(A.designation_date,4),''), "
                            + "IF(A.source_db='CDDA_INTERNATIONAL',right(A.designation_date,4),''), "
                            + "IF(A.source_db='CDDA_NATIONAL',right(A.designation_date,4),''), "
                            + "IF(A.source_db='EMERALD',right(A.designation_date,4),''), "
                            + "IF(A.source_db='DIPLOMA',right(A.designation_date,4),''), "
                            + "IF(A.source_db='NATURA2000',right(A.designation_date,4),''), "
                            + "IF(A.source_db='CORINE',right(A.designation_date,4),''), "
                            + "IF(A.source_db='NATURENET',right(A.designation_date,4),'')) AS SIGNED)";

            sql += ">=" + yearMin + " ";
        }
        if (null != yearMax && yearMax.trim().length() > 0 && !yearMax.trim().equalsIgnoreCase("null")) {
            if (sql.length() > 0) {
                sql += " AND ";
            }
            sql += " A.DESIGNATION_DATE IS NOT NULL" + " AND A.DESIGNATION_DATE <> ''";
            sql +=
                    " AND CAST(CONCAT(IF(A.source_db='BIOGENETIC',left(A.designation_date,4),''), "
                            + "IF(A.source_db='CDDA_INTERNATIONAL',right(A.designation_date,4),''), "
                            + "IF(A.source_db='CDDA_NATIONAL',right(A.designation_date,4),''), "
                            + "IF(A.source_db='EMERALD',right(A.designation_date,4),''), "
                            + "IF(A.source_db='DIPLOMA',right(A.designation_date,4),''), "
                            + "IF(A.source_db='NATURA2000',right(A.designation_date,4),''), "
                            + "IF(A.source_db='CORINE',right(A.designation_date,4),''), "
                            + "IF(A.source_db='NATURENET',right(A.designation_date,4),'')) AS SIGNED)";

            sql += "<=" + yearMax + " ";
        }
        boolean[] source =
                {DB_NATURA2000 == null ? false : true, DB_CORINE == null ? false : true, DB_DIPLOMA == null ? false : true,
                        DB_CDDA_NATIONAL == null ? false : true, DB_CDDA_INTERNATIONAL == null ? false : true,
                        DB_BIOGENETIC == null ? false : true, false, DB_EMERALD == null ? false : true,};

        sql = Utilities.getConditionForSourceDB(new StringBuffer(sql), source, db, "A").toString();

        return sql;
    }

    /**
     * Construct the where condition for query which returns the list of sites that fulfil main search criteria.
     *
     * @return SQL.
     */

    public String prepareSQLForFindSites() {
        String sql = "";

        if (null != country && country.trim().length() > 0 && !country.trim().equalsIgnoreCase("null")) {
            sql += " C.AREA_NAME_EN='" + country + "'";
        }

        if (null != yearMin && yearMin.trim().length() > 0 && !yearMin.trim().equalsIgnoreCase("null")) {
            if (sql.length() > 0) {
                sql += " AND ";
            }
            sql += " A.DESIGNATION_DATE IS NOT NULL" + " AND A.DESIGNATION_DATE <> ''";
            sql +=
                    " AND CAST(CONCAT(IF(A.source_db='BIOGENETIC',left(A.designation_date,4),''), "
                            + "IF(A.source_db='CDDA_INTERNATIONAL',right(A.designation_date,4),''), "
                            + "IF(A.source_db='CDDA_NATIONAL',right(A.designation_date,4),''), "
                            + "IF(A.source_db='EMERALD',right(A.designation_date,4),''), "
                            + "IF(A.source_db='DIPLOMA',right(A.designation_date,4),''), "
                            + "IF(A.source_db='NATURA2000',right(A.designation_date,4),''), "
                            + "IF(A.source_db='CORINE',right(A.designation_date,4),''), "
                            + "IF(A.source_db='NATURENET',right(A.designation_date,4),'')) AS SIGNED)";

            sql += ">=" + yearMin + " ";
        }
        if (null != yearMax && yearMax.trim().length() > 0 && !yearMax.trim().equalsIgnoreCase("null")) {
            if (sql.length() > 0) {
                sql += " AND ";
            }
            sql += " A.DESIGNATION_DATE IS NOT NULL" + " AND A.DESIGNATION_DATE <> ''";
            sql +=
                    " AND CAST(CONCAT(IF(A.source_db='BIOGENETIC',left(A.designation_date,4),''), "
                            + "IF(A.source_db='CDDA_INTERNATIONAL',right(A.designation_date,4),''), "
                            + "IF(A.source_db='CDDA_NATIONAL',right(A.designation_date,4),''), "
                            + "IF(A.source_db='EMERALD',right(A.designation_date,4),''), "
                            + "IF(A.source_db='DIPLOMA',right(A.designation_date,4),''), "
                            + "IF(A.source_db='NATURA2000',right(A.designation_date,4),''), "
                            + "IF(A.source_db='CORINE',right(A.designation_date,4),''), "
                            + "IF(A.source_db='NATURENET',right(A.designation_date,4),'')) AS SIGNED)";

            sql += "<=" + yearMax + " ";
        }
        boolean[] source =
                {DB_NATURA2000 == null ? false : true, DB_CORINE == null ? false : true, DB_DIPLOMA == null ? false : true,
                        DB_CDDA_NATIONAL == null ? false : true, DB_CDDA_INTERNATIONAL == null ? false : true,
                        DB_BIOGENETIC == null ? false : true, false, DB_EMERALD == null ? false : true};

        sql = Utilities.getConditionForSourceDB(new StringBuffer(sql), source, db, "A").toString();

        return sql;
    }

    /**
     * Return where condition in the others cases.
     *
     * @param useIso3l
     *            - country is obtained by iso3l
     * @return string condition
     */
    public String prepareSQL(boolean useIso3l) {
        String sql = "";

        if (useIso3l) {
            sql += " E.ISO_3L='" + CountryUtil.getIso3LByCountryName(country) + "'";
        }

        // --
        if (null != designation && designation.trim().length() > 0 && !designation.trim().equalsIgnoreCase("null")) {
            if (sql.length() > 0) {
                sql += " AND ( ";
            } else {
                sql += " ( ";
            }
            sql += "E.DESCRIPTION LIKE '%" + designation.replaceAll("'", "''") + "%'";
            sql += " OR ";
            sql += "E.DESCRIPTION_EN LIKE '%" + designation.replaceAll("'", "''") + "%'";
            sql += " OR ";
            sql += "E.DESCRIPTION_FR LIKE '%" + designation.replaceAll("'", "''") + "%'";
            sql += " )";
        }

        // --
        if (null != designationCat && !designationCat.equalsIgnoreCase("any") && !designationCat.trim().equalsIgnoreCase("null")) {
            if (sql.length() > 0) {
                sql += " AND ";
            }
            sql += "E.NATIONAL_CATEGORY='" + designationCat + "'";
        }

        if (useIso3l && null != yearMin && yearMin.trim().length() > 0 && !yearMin.trim().equalsIgnoreCase("null")) {
            if (sql.length() > 0) {
                sql += " AND ";
            }
            sql += " A.DESIGNATION_DATE IS NOT NULL" + " AND A.DESIGNATION_DATE <> ''";
            sql +=
                    " AND CAST(CONCAT(IF(A.source_db='BIOGENETIC',left(A.designation_date,4),''), "
                            + "IF(A.source_db='CDDA_INTERNATIONAL',right(A.designation_date,4),''), "
                            + "IF(A.source_db='CDDA_NATIONAL',right(A.designation_date,4),''), "
                            + "IF(A.source_db='EMERALD',right(A.designation_date,4),''), "
                            + "IF(A.source_db='DIPLOMA',right(A.designation_date,4),''), "
                            + "IF(A.source_db='NATURA2000',right(A.designation_date,4),''), "
                            + "IF(A.source_db='CORINE',right(A.designation_date,4),''), "
                            + "IF(A.source_db='NATURENET',right(A.designation_date,4),'')) AS SIGNED)";

            sql += ">=" + yearMin + " ";
        }

        if (useIso3l && null != yearMax && yearMax.trim().length() > 0 && !yearMax.trim().equalsIgnoreCase("null")) {
            if (sql.length() > 0) {
                sql += " AND ";
            }
            sql += " A.DESIGNATION_DATE IS NOT NULL" + " AND A.DESIGNATION_DATE <> ''";
            sql +=
                    " AND CAST(CONCAT(IF(A.source_db='BIOGENETIC',left(A.designation_date,4),''), "
                            + "IF(A.source_db='CDDA_INTERNATIONAL',right(A.designation_date,4),''), "
                            + "IF(A.source_db='CDDA_NATIONAL',right(A.designation_date,4),''), "
                            + "IF(A.source_db='EMERALD',right(A.designation_date,4),''), "
                            + "IF(A.source_db='DIPLOMA',right(A.designation_date,4),''), "
                            + "IF(A.source_db='NATURA2000',right(A.designation_date,4),''), "
                            + "IF(A.source_db='CORINE',right(A.designation_date,4),''), "
                            + "IF(A.source_db='NATURENET',right(A.designation_date,4),'')) AS SIGNED)";

            sql += "<=" + yearMax + " ";
        }

        if (useIso3l) {
            boolean[] source =
                    {DB_NATURA2000 == null ? false : true, DB_CORINE == null ? false : true, DB_DIPLOMA == null ? false : true,
                            DB_CDDA_NATIONAL == null ? false : true, DB_CDDA_INTERNATIONAL == null ? false : true,
                            DB_BIOGENETIC == null ? false : true, false, DB_EMERALD == null ? false : true,};

            sql = Utilities.getConditionForSourceDB(new StringBuffer(sql), source, db, "E").toString();
        }

        return sql;
    }

    /**
     * Human representation of this object.
     *
     * @return String.
     */
    public String toHumanString() {
        String result = "";

        if (null != country && country.trim().length() > 0 && !country.trim().equalsIgnoreCase("null")) {
            result += country;
        }
        if (null != designation && designation.trim().length() > 0 && !designation.trim().equalsIgnoreCase("null")) {
            result += ", designation contains '" + designation + "'";
        }
        if (null != designationCat && !designationCat.equalsIgnoreCase("any") && !designationCat.trim().equalsIgnoreCase("null")) {
            result += ", designation category is '" + designationCat + "'";
        }
        if (null != yearMin && yearMin.trim().length() > 0 && !yearMin.trim().equalsIgnoreCase("null")) {
            if (null == yearMax || yearMax.trim().length() <= 0 || yearMax.trim().equalsIgnoreCase("null")) {
                result += " and year greater than " + yearMin;
            } else {
                result += " and year between: " + yearMin + " and " + yearMax;
            }
        }
        if (null != yearMax && yearMax.trim().length() > 0 && !yearMax.trim().equalsIgnoreCase("null")) {
            if (null == yearMin || yearMin.trim().length() <= 0 || yearMin.trim().equalsIgnoreCase("null")) {
                result += " and year smaller that " + yearMax;
            }
            // else result += ", and year between: " + yearMin + " and " + yearMax;
        }

        return result;
    }

    /**
     * Put list of sites in where condition format.
     *
     * @param idSitesList
     * @param alias
     * @return string condition
     */

    private String getSitesConditions(List idSitesList, String alias) {
        if (idSitesList == null || idSitesList.size() <= 0) {
            return "";
        }
        StringBuffer result = new StringBuffer();

        result.append(alias);
        result.append(".ID_SITE IN ( ");
        for (int i = 0; i < idSitesList.size(); i++) {
            result.append("'");
            result.append(idSitesList.get(i));
            result.append("'");
            if (i < idSitesList.size() - 1) {
                result.append(",");
            } else {
                result.append(" ) ");
            }
        }
        return result.toString();
    }

    /**
     * Return list of designations.
     *
     * @param idSitesList
     * @return list of designations
     */
    public List getDesignationsList(List idSitesList) {
        String sqlWhere = prepareSQL(false);
        // String sqlWhereSecondSelect = prepareSQL( true );
        List designations = new Vector();

        String sql = "";

        sql =
                " SELECT E.*  FROM CHM62EDT_DESIGNATIONS E "
                        + " INNER JOIN CHM62EDT_SITES A ON (E.ID_DESIGNATION=A.ID_DESIGNATION AND E.ID_GEOSCOPE=A.ID_GEOSCOPE)"
                        + " WHERE " + getSitesConditions(idSitesList, "A")
                        + (sqlWhere != null && sqlWhere.trim().length() > 0 ? " AND " + sqlWhere : "")
                        + " GROUP BY E.ID_DESIGNATION,E.ID_GEOSCOPE";
        // " UNION" +
        // " SELECT E.* " +
        // " FROM CHM62EDT_DESIGNATIONS AS E " +
        // " INNER JOIN CHM62EDT_SITES_DESIGNATIONS D ON (E.ID_DESIGNATION=D.ID_DESIGNATION AND E.ISO_3L=D.ISO_3L AND E.SOURCE_DB=D.SOURCE_DB)";

        // if((null != yearMin && yearMin.trim().length() > 0 && !yearMin.trim().equalsIgnoreCase( "null" )) ||
        // (null != yearMax && yearMax.trim().length() > 0 && !yearMax.trim().equalsIgnoreCase( "null" )))
        // {
        // sql += " INNER JOIN CHM62EDT_SITES AS A ON (A.ID_SITE=D.ID_SITE AND A.SOURCE_DB = D.SOURCE_DB) ";
        // }
        //
        // sql += " WHERE (1=1) AND " + sqlWhereSecondSelect + " GROUP BY E.ID_DESIGNATION,E.ISO_3L,E.DESCRIPTION,E.SOURCE_DB";

        try {
            designations = new Chm62edtDesignationsDomain().findCustom(sql);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return designations;
    }

    /**
     * Return no of sites and total area for a designation.
     *
     * @param idSitesList
     * @param id
     * @param idGeoscope
     * @param sqlUtilities
     * @return no of sites and total area for a designation
     */
    public Vector getValueForDesignations(List idSitesList, String id, String idGeoscope, SQLUtilities sqlUtilities) {

        Vector values = new Vector();

        String sqlWhere = prepareSQL(false);
        Long noSites = null;
        Long areaTotal = null;
        Long areaTotalOverlap = null;

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = sqlUtilities.getConnection();

            String sql =
                    "SELECT COUNT(DISTINCT AreaSite.ASite), sum(AreaSite.AArea) as GR FROM "
                            + " (SELECT  A.ID_SITE as ASite , A.AREA as AArea FROM CHM62EDT_DESIGNATIONS E "
                            + " INNER JOIN CHM62EDT_SITES A ON (E.ID_DESIGNATION=A.ID_DESIGNATION AND E.ID_GEOSCOPE=A.ID_GEOSCOPE)"
                            + " WHERE TRIM(E.ID_DESIGNATION)=TRIM('" + id + "') " + " AND  E.ID_GEOSCOPE = " + idGeoscope
                            + (sqlWhere != null && sqlWhere.trim().length() > 0 ? " AND " + sqlWhere : "") + " AND "
                            + getSitesConditions(idSitesList, "A") + ") as AreaSite";

            ps = con.prepareStatement(sql);

            rs = ps.executeQuery();
            if (rs != null && rs.next()) {
                noSites = rs.getLong(1);
                areaTotal = rs.getLong(2);
            }

            rs.close();
            rs = null;
            ps.close();
            ps = null;

            sql = "select OVERLAP from CHM62EDT_SITES_SITES WHERE OVERLAP > 0 LIMIT 1";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            boolean hasOverlaps = rs.next();

            rs.close();
            rs = null;
            ps.close();
            ps = null;
            
            if (hasOverlaps) {
                sql =
                        " select sum(gr.overlap) from (SELECT H.OVERLAP FROM CHM62EDT_DESIGNATIONS E "
                                + " INNER JOIN CHM62EDT_SITES AS A ON (A.ID_DESIGNATION=E.ID_DESIGNATION and A.ID_GEOSCOPE = E.ID_GEOSCOPE AND A.AREA>0) "
                                + " INNER JOIN CHM62EDT_SITES_SITES AS H ON (A.ID_SITE = H.ID_SITE AND H.OVERLAP>0) "
                                + " INNER JOIN CHM62EDT_SITES AS I ON (H.ID_SITE_LINK = I.ID_SITE AND I.AREA>0)"
                                + " WHERE TRIM(E.ID_DESIGNATION)=TRIM('" + id + "') " + " AND  E.ID_GEOSCOPE = " + idGeoscope
                                + (sqlWhere != null && sqlWhere.trim().length() > 0 ? " AND " + sqlWhere : "") + " AND "
                                + getSitesConditions(idSitesList, "A") + " group by A.ID_SITE,H.ID_SITE_LINK,H.OVERLAP) as gr";

                ps = con.prepareStatement(sql);

                rs = ps.executeQuery();

                if (rs != null && rs.next()) {
                    areaTotalOverlap = rs.getLong(1);

                }
            } else {
                areaTotalOverlap = (long) 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(con, ps, rs);

            if (noSites != null) {
                values.addElement(noSites);
            } else {
                values.addElement(new Long(0));
            }

            if (areaTotal != null) {
                if (areaTotalOverlap != null) {

                    values.addElement((areaTotal.longValue() - areaTotalOverlap.longValue() < 0 ? new Long(0) : new Long(areaTotal
                            .longValue() - areaTotalOverlap.longValue())));
                } else {
                    values.addElement(areaTotal);
                }
            } else {
                values.addElement(new Long(0));
            }

        }

        return values;
    }

    /**
     * Close all db elements.
     *
     * @param con
     *            connection
     * @param ps
     *            prepared sql statement
     * @param rs
     *            result set
     */
    private void closeAll(Connection con, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (con != null) {
                con.close();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    /**
     * Getter for sitesNumber property.
     *
     * @return sitesNumber.
     */
    public Long getSitesNumber() {
        return sitesNumber;
    }

    /**
     * Getter for totalArea property.
     *
     * @return totalArea.
     */
    public Long getTotalArea() {

        if (null == totalArea) {
            totalArea = new Long(0);
        }

        return totalArea;

    }

    /**
     * Getter for totalLength property.
     *
     * @return totalLength.
     */
    public Long getTotalLength() {

        if (null == totalLength) {
            totalLength = new Long(0);
        }

        return totalLength;

    }

    /**
     * Getter for designation property.
     *
     * @return designation.
     */
    public String getDesignation() {
        return designation;
    }

    /**
     * Setter for designation property.
     *
     * @param designation
     *            designation.
     */
    public void setDesignation(String designation) {
        this.designation = designation;
    }

    /**
     * Getter for designationCat property.
     *
     * @return designationCat.
     */
    public String getDesignationCat() {
        return designationCat;
    }

    /**
     * Setter for designationCat property.
     *
     * @param designationCat
     *            designationCat.
     */
    public void setDesignationCat(String designationCat) {
        this.designationCat = designationCat;
    }

    /**
     * This method is used to retrieve the basic criterias used to do the first search.
     *
     * @return First criterias used for search (when going from query page to result page).
     */
    @Override
    public AbstractSearchCriteria getMainSearchCriteria() {
        return null;
    }

    /**
     * This method will transform the request parameters used for search back in search objects (AbstractSearchCriteria) in order to
     * use them in searches...
     *
     * @return objects which are used for search / filter
     */
    @Override
    public AbstractSearchCriteria[] toSearchCriteria() {
        // This search doesn't use search refinement.
        return new AbstractSearchCriteria[0];
    }

    /**
     * This method will transform the request parameters used for sorting back in search objects (AbstractSortCriteria) in order to
     * use them in sorting, again...
     *
     * @return A list of AbstractSearchCriteria objects used to do the sorting.
     */
    @Override
    public AbstractSortCriteria[] toSortCriteria() {
        // This search doesn't need sorting.
        return new AbstractSortCriteria[0];
    }

    /**
     * This method will transform the request parameters, back to an URL compatible type of request so that one should not manually
     * write the URL.
     *
     * @param classFields
     *            Fields to be included in parameters.
     * @return An URL compatible type of representation(i.e.: >>param1=val1&param2=val2&param3=val3 etc.<<.
     */
    @Override
    public String toURLParam(Vector classFields) {
        // This search doesn't need pagination.
        return "";
    }

    /**
     * This method will transform the request parameters into a form compatible hidden input parameters, for example. &ltINPUT
     * type="hidden" name="paramName" value="paramValue"&gt.
     *
     * @param classFields
     *            Fields to be included in parameters.
     * @return An form compatible type of representation of request parameters.
     */
    @Override
    public String toFORMParam(Vector classFields) {
        // This search doesn't need pagination
        return "";
    }
}
