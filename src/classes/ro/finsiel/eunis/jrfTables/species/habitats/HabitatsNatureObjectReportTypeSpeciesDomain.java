package ro.finsiel.eunis.jrfTables.species.habitats;

import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;
import net.sf.jrf.join.joincolumns.IntegerJoinColumn;

/**
 * Date: Sep 23, 2003
 * Time: 12:38:24 PM
 */
public class HabitatsNatureObjectReportTypeSpeciesDomain extends AbstractDomain {


  /**
   **/
  public PersistentObject newPersistentObject() {
    return new HabitatsNatureObjectReportTypeSpeciesPersist();
  }

  /**
   **/
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());

    this.setTableName("CHM62EDT_HABITAT");
    this.setReadOnly(true);
    this.setTableAlias("H");

    this.addColumnSpec(new StringColumnSpec("ID_HABITAT", "getIdHabitat", "setIdHabitat", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
    this.addColumnSpec(new IntegerColumnSpec("ID_NATURE_OBJECT", "getIdNatureObjectHabitat", "setIdNatureObjectHabitat", DEFAULT_TO_ZERO, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("EUNIS_HABITAT_CODE", "getEunisHabitatCode", "setEunisHabitatCode", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("CODE_2000", "getCode2000", "setCode2000", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("SCIENTIFIC_NAME", "getHabitatScientificName", "setHabitatScientificName", DEFAULT_TO_NULL));

    JoinTable natureObjectReportType = new JoinTable("CHM62EDT_NATURE_OBJECT_REPORT_TYPE A", "ID_NATURE_OBJECT", "ID_NATURE_OBJECT_LINK");
    natureObjectReportType.addJoinColumn(new IntegerJoinColumn("ID_GEOSCOPE", "setIdGeoscope"));
    natureObjectReportType.addJoinColumn(new IntegerJoinColumn("ID_REPORT_ATTRIBUTES", "setIdReportAttributes"));
    natureObjectReportType.addJoinColumn(new IntegerJoinColumn("ID_REPORT_TYPE", "setIdReportType"));
    this.addJoinTable(natureObjectReportType);

    JoinTable species = new JoinTable("CHM62EDT_SPECIES C", "ID_NATURE_OBJECT", "ID_NATURE_OBJECT");
    species.addJoinColumn(new IntegerJoinColumn("ID_SPECIES", "setIdSpecies"));
    species.addJoinColumn(new IntegerJoinColumn("ID_SPECIES_LINK", "setIdSpeciesLink"));
    species.addJoinColumn(new StringJoinColumn("SCIENTIFIC_NAME", "setSpeciesScientificName"));
    natureObjectReportType.addJoinTable(species);
  }
}
