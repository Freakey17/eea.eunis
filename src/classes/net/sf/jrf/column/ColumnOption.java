/*
 *
 * The contents of this file are subject to the Mozilla Public License
 * Version 1.1 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 *
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations under
 * the License.
 *
 * The Original Code is jRelationalFramework.
 *
 * The Initial Developer of the Original Code is is.com.
 * Portions created by is.com are Copyright (C) 2000 is.com.
 * All Rights Reserved.
 *
 * Contributor: James Evans (jevans@vmguys.com)
 * Contributor: ____________________________________
 *
 * Alternatively, the contents of this file may be used under the terms of
 * the GNU General Public License (the "GPL") or the GNU Lesser General
 * Public license (the "LGPL"), in which case the provisions of the GPL or
 * LGPL are applicable instead of those above.  If you wish to allow use of
 * your version of this file only under the terms of either the GPL or LGPL
 * and not to allow others to use your version of this file under the MPL,
 * indicate your decision by deleting the provisions above and replace them
 * with the notice and other provisions required by either the GPL or LGPL
 * License.  If you do not delete the provisions above, a recipient may use
 * your version of this file under either the MPL or GPL or LGPL License.
 *
 */
package net.sf.jrf.column;

/**  represented by the domain subclass. */
public abstract class ColumnOption {

  protected boolean i_required = false;
  protected boolean i_primaryKey = false;
  protected boolean i_sequencedPrimaryKey = false;
  protected boolean i_naturalPrimaryKey = false;
  protected boolean i_unique = false;
  protected boolean i_subtypeIdentifier = false;
  protected boolean i_optimisticLock = false;

  /**
   * Returns <code>true</code> if the column value is
   * required (e.g. underlying table column definition is "NOT NULL").
   *
   * @return   <code>true</code> if column value is required.
   */
  public boolean isRequired() {
    return i_required;
  }


  /**
   * Returns <code>true</code> if the column value is
   * is a sequenced primary key, a feature supported by various
   * vendors.
   *
   * @return   <code>true</code> if column value is a sequenced primary key.
   */
  public boolean isSequencedPrimaryKey() {
    return i_sequencedPrimaryKey;
  }

  /**
   * Returns <code>true</code> if the column value is
   * is a natural primary key.
   *
   * @return   <code>true</code> if column value is a natural primary key.
   */
  public boolean isNaturalPrimaryKey() {
    return i_naturalPrimaryKey;
  }

  /**
   * Returns <code>true</code> if the column value is
   * is a primary key, natural or sequenced.
   *
   * @return   <code>true</code> if column value is a primary key.
   */
  public boolean isPrimaryKey() {
    return i_primaryKey;
  }

  /**
   * Returns <code>true</code> if the column value is
   * must be unique in the database.
   *
   * @return   <code>true</code> if column value must be unique.
   */
  public boolean isUnique() {
    return i_unique;
  }

  /**
   * Returns <code>true</code> if the column value is
   * is a subtype identifier.
   *
   * @return   <code>true</code> if column value is a subtype identifier
   */
  public boolean isSubtypeIdentifier() {
    return i_subtypeIdentifier;
  }


  /**
   * Returns <code>true</code> if the column value is
   * is an optimistic lock column value.
   *
   * @return   <code>true</code> if column value is an optimistic lock column value
   */
  public boolean isOptimisticLock() {
    return i_optimisticLock;
  }

}
