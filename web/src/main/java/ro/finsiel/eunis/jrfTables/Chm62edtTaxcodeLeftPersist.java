/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:52 $
 **/
public class Chm62edtTaxcodeLeftPersist extends PersistentObject {

    String parentLevelName = null;
    Integer classId = null;

    /**
     * This is a database field.
     **/
    private String i_idTaxcode = null;

    /**
     * This is a database field.
     **/
    private String i_taxonomicLevel = null;

    /**
     * This is a database field.
     **/
    private String i_taxonomicName = null;

    /**
     * This is a database field.
     **/
    private String i_taxonomicGroup = null;

    /**
     * This is a database field.
     **/
    private Integer i_idDc = null;

    /**
     * This is a database field.
     **/
    private String i_idTaxcodeLink = null;

    /**
     * This is a database field.
     **/
    private String i_notes = null;

    public Chm62edtTaxcodeLeftPersist() {
        super();
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdDc() {
        return i_idDc;
    }

    /**
     * Getter for a joined field.
     **/
    public String getParentLevelName() {
        return parentLevelName;
    }

    /**
     * Getter for a joined field.
     **/
    public Integer getClassID() {
        return classId;
    }

    /**
     * Getter for a database field.
     **/
    public String getIdTaxcode() {
        return i_idTaxcode;
    }

    /**
     * Getter for a database field.
     **/
    public String getIdTaxcodeLink() {
        return i_idTaxcodeLink;
    }

    /**
     * Getter for a database field.
     **/
    public String getNotes() {
        return i_notes;
    }

    /**
     * Getter for a database field.
     **/
    public String getTaxonomicGroup() {
        return i_taxonomicGroup;
    }

    /**
     * Getter for a database field.
     **/
    public String getTaxonomicLevel() {
        return i_taxonomicLevel;
    }

    /**
     * Getter for a database field.
     **/
    public String getTaxonomicName() {
        return i_taxonomicName;
    }

    /**
     * Setter for a database field.
     * @param idDc
     **/
    public void setIdDc(Integer idDc) {
        i_idDc = idDc;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idTaxcode
     **/
    public void setIdTaxcode(String idTaxcode) {
        i_idTaxcode = idTaxcode;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idTaxcodeLink
     **/
    public void setIdTaxcodeLink(String idTaxcodeLink) {
        i_idTaxcodeLink = idTaxcodeLink;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param notes
     **/
    public void setNotes(String notes) {
        i_notes = notes;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     **/
    public void setParentLevelName(String value) {
        parentLevelName = value;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     **/
    public void setClassID(Integer value) {
        classId = value;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param taxonomicGroup
     **/
    public void setTaxonomicGroup(String taxonomicGroup) {
        i_taxonomicGroup = taxonomicGroup;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param taxonomicLevel
     **/
    public void setTaxonomicLevel(String taxonomicLevel) {
        i_taxonomicLevel = taxonomicLevel;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param taxonomicName
     **/
    public void setTaxonomicName(String taxonomicName) {
        i_taxonomicName = taxonomicName;
        this.markModifiedPersistentState();
    }

}
