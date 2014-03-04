package eionet.eunis.stripes.actions.beans;

import ro.finsiel.eunis.search.species.SpeciesSearchUtility;
import ro.finsiel.eunis.search.species.VernacularNameWrapper;
import ro.finsiel.eunis.utilities.EmptyLastComparator;

import java.util.List;

/**
 * Unify the species for easy display
 */
public class SpeciesBean implements Comparable<SpeciesBean>{
    private String scientificName;
    private String commonName;
    private String group;
    private Object source;
    private String natura2000Code;
    private String url;
    private SpeciesType speciesType;

    public static enum SpeciesType {
        SITE (1),  // siteSpecies
        SITE_SPECIFIC (2), // siteSpecificSpecies
        EUNIS_LISTED (3),  // eunisSpeciesListedAnnexesDirectives
        EUNIS_OTHER_MENTIONED (4), // eunisSpeciesOtherMentioned
        NOT_EUNIS_LISTED (5), // notEunisSpeciesListedAnnexesDirectives
        NOT_EUNIS_OTHER (6);   // notEunisSpeciesOtherMentioned

        private final int id;
        SpeciesType(int id){
            this.id = id;
        }
    }


    public SpeciesBean(SpeciesType speciesType, String scientificName, String commonName, String group, Object source, String natura2000Code, String url, Integer idNatureObject) {
        this.speciesType = speciesType;
        this.scientificName = scientificName;
        this.commonName = commonName;
        this.group = group;
        this.source = source;
        this.natura2000Code = natura2000Code;
        this.url = url;

        if(this.commonName == null && idNatureObject != null){
            List<VernacularNameWrapper> vernNames = SpeciesSearchUtility.findVernacularNames(idNatureObject);
            for (VernacularNameWrapper vernName : vernNames){
                if (vernName.getLanguageCode().toLowerCase().equals("en")){
                    this.commonName = vernName.getName();
                    break;
                }
            }
        }

    }

    public String getScientificName() {
        return scientificName;
    }

    public String getGroup() {
        return group;
    }

    public Object getSource() {
        return source;
    }

    public String getCommonName() {
        return commonName;
    }

    public String getNatura2000Code() {
        return natura2000Code;
    }

    public String getUrl() {
        return url;
    }

    public int getSpeciesTypeId() {
        return speciesType.id;
    }

    public SpeciesType getSpeciesType() {
        return speciesType;
    }

    @Override
    public String toString() {
        return "SpeciesBean{" +
                "scientificName='" + scientificName + '\'' +
                ", commonName='" + commonName + '\'' +
                ", natura2000Code='" + natura2000Code + '\'' +
                ", group='" + group + '\'' +
                ", source=" + source +
                '}';
    }

    /**
     * Comparator to order by group and scientific name
     * @param o Object to compare
     * @return
     */
    @Override
    public int compareTo(SpeciesBean o) {
        String thisGroup = this.getGroup();
        String otherGroup = o.getGroup();
        String thisName = this.getScientificName();
        String otherName = o.getScientificName();

        if(otherGroup.equals(thisGroup)) {
            return EmptyLastComparator.getComparator().compare(thisName, otherName);
        } else {
            return EmptyLastComparator.getComparator().compare(thisGroup, otherGroup);
        }
    }
}
