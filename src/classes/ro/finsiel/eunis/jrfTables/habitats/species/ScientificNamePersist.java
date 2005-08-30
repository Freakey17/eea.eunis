package ro.finsiel.eunis.jrfTables.habitats.species;

import net.sf.jrf.domain.PersistentObject;

public class ScientificNamePersist extends PersistentObject {
  /**
   * This is a database field.
   **/
  private Integer i_idNatureObject = null;

  /**
   * This is a database field.
   **/
  private String i_idHabitat = null;
  /**
   * This is a database field.
   **/
  private String i_scientificName = null;
  /**
   * This is a database field.
   **/
  private String i_description = null;
  /**
   * This is a database field.
   **/
  private String i_code2000 = null;
  /**
   * This is a database field.
   **/
  private String i_codeAnnex1 = null;
  /**
   * This is a database field.
   **/
  private String i_eunisHabitatCode = null;
  /**
   * This is a database field.
   **/
  private Integer i_habLevel = null;

  public ScientificNamePersist() {
    super();
  }

  /**
   * Getter for a database field.
   **/
  public String getCode2000() {
    return i_code2000;
  }

  /**
   * Getter for a database field.
   **/
  public String getCodeAnnex1() {
    return i_codeAnnex1;
  }

  /**
   * Getter for a database field.
   **/
  public String getDescription() {
    return i_description;
  }

  /**
   * Getter for a database field.
   **/
  public String getEunisHabitatCode() {
    return i_eunisHabitatCode;
  }

  /**
   * Getter for a database field.
   **/
  public Integer getHabLevel() {
    if (null == i_habLevel) return new Integer(0);
    return i_habLevel;
  }

  /**
   * Getter for a database field.
   **/
  public String getIdHabitat() {
    return i_idHabitat;
  }

  /**
   * Getter for a database field.
   **/
  public Integer getIdNatureObject() {
    return i_idNatureObject;
  }

  /**
   * Getter for a database field.
   **/
  public String getScientificName() {
    return i_scientificName;
  }

  /**
   * Setter for a database field.
   * @param code2000
   **/
  public void setCode2000(String code2000) {
    i_code2000 = code2000;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param codeAnnex1
   **/
  public void setCodeAnnex1(String codeAnnex1) {
    i_codeAnnex1 = codeAnnex1;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param description
   **/
  public void setDescription(String description) {
    i_description = description;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param eunisHabitatCode
   **/
  public void setEunisHabitatCode(String eunisHabitatCode) {
    i_eunisHabitatCode = eunisHabitatCode;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param habLevel
   **/
  public void setHabLevel(Integer habLevel) {
    i_habLevel = habLevel;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idHabitat
   **/
  public void setIdHabitat(String idHabitat) {
    i_idHabitat = idHabitat;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idNatureObject
   **/
  public void setIdNatureObject(Integer idNatureObject) {
    i_idNatureObject = idNatureObject;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param scientificName
   **/
  public void setScientificName(String scientificName) {
    i_scientificName = scientificName;
    this.markModifiedPersistentState();
  }
}