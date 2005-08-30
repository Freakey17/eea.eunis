package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;

/**
 * JRF table for CHM62EDT_NATURE_OBJECT_PICTURE.
 * @author finsiel
 **/
public class Chm62edtNatureObjectPictureDomain extends AbstractDomain {

  /**
   * Implements newPersistentObject from AbstractDomain.
   * @return New persistent object (table row).
   */
  public PersistentObject newPersistentObject() {
    return new Chm62edtNatureObjectPicturePersist();
  }

  /**
   * Implements setup from AbstractDomain.
   */
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());
    this.setTableName("CHM62EDT_NATURE_OBJECT_PICTURE");
    this.addColumnSpec(
            new CompoundPrimaryKeyColumnSpec(
                    new StringColumnSpec("ID_OBJECT", "getIdObject", "setIdObject", DEFAULT_TO_NULL),
                    new StringColumnSpec("NATURE_OBJECT_TYPE", "getNatureObjectType", "setNatureObjectType", DEFAULT_TO_NULL, REQUIRED),
                    new StringColumnSpec("NAME", "getName", "setName", DEFAULT_TO_NULL, REQUIRED),
                    new StringColumnSpec("FILE_NAME", "getFileName", "setFileName", DEFAULT_TO_NULL, REQUIRED)
            )
    );
    this.addColumnSpec(new StringColumnSpec("DESCRIPTION", "getDescription", "setDescription", DEFAULT_TO_EMPTY_STRING));
  }
}