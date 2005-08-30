package ro.finsiel.eunis.jrfTables.users;

import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;

/**
 * JRF table for EUNIS_USERS_ROLES inner join EUNIS_ROLES.
 * @author finsiel
 **/
public class UsersRolesDomain extends AbstractDomain {

  /**
   * Implements newPersistentObject from AbstractDomain.
   * @return New persistent object (table row).
   */
  public PersistentObject newPersistentObject() {
    return new UsersRolesPersist();
  }

  /**
   * Implements setup from AbstractDomain.
   */
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());
    this.setTableName("EUNIS_USERS_ROLES");
    this.setTableAlias("A");
    this.addColumnSpec(
            new CompoundPrimaryKeyColumnSpec(
                    new StringColumnSpec("USERNAME", "getUserName", "setUserName", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY),
                    new StringColumnSpec("ROLENAME", "getRoleName", "setRoleName", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY)
            )
    );

    JoinTable eunisRoles = new JoinTable("EUNIS_ROLES E", "ROLENAME", "ROLENAME");
    this.addJoinTable(eunisRoles);
  }
}