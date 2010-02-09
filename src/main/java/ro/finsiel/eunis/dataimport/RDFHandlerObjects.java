package ro.finsiel.eunis.dataimport;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

import ro.finsiel.eunis.utilities.EunisUtil;

import com.hp.hpl.jena.rdf.arp.ALiteral;
import com.hp.hpl.jena.rdf.arp.AResource;
import com.hp.hpl.jena.rdf.arp.StatementHandler;
import com.hp.hpl.jena.vocabulary.RDF;

import eionet.eunis.dto.LinkInfoDTO;
import eionet.eunis.stripes.extensions.LoadException;


/**
 * 
 * @author Risto Alt, e-mail: <a href="mailto:risto.alt@tieto.com">risto.alt@tieto.com</a>
 *
 */
public class RDFHandlerObjects implements StatementHandler, ErrorHandler{
	
	/** */
	private boolean saxErrorSet = false;
	private boolean saxWarningSet = false;
	
	private Logger logger = Logger.getLogger(RDFHandlerObjects.class);
	
	private static final String geo_ns = "http://rdf.geospecies.org/ont/geospecies#";
	
	/** */
	private static final String EMPTY_STRING = "";
	
	private LinkInfoDTO dto = null;
	
	private Connection con = null;
	
	private List<String> errors = null;
			
	/**
	 * @throws SQLException 
	 * 
	 */
	public RDFHandlerObjects(Connection con) throws SQLException{
		this.con = con;
		errors = new ArrayList<String>();
			
	}
	
	/*
	 *  (non-Javadoc)
	 * @see com.hp.hpl.jena.rdf.arp.StatementHandler#statement(com.hp.hpl.jena.rdf.arp.AResource, com.hp.hpl.jena.rdf.arp.AResource, com.hp.hpl.jena.rdf.arp.AResource)
	 */
	public void statement(AResource subject, AResource predicate, AResource object){
		
		statement(subject, predicate, object.isAnonymous() ? object.getAnonymousID() : object.getURI(), EMPTY_STRING, false, object.isAnonymous());
	}

	/*
	 *  (non-Javadoc)
	 * @see com.hp.hpl.jena.rdf.arp.StatementHandler#statement(com.hp.hpl.jena.rdf.arp.AResource, com.hp.hpl.jena.rdf.arp.AResource, com.hp.hpl.jena.rdf.arp.ALiteral)
	 */
	public void statement(AResource subject, AResource predicate, ALiteral object){
		
		statement(subject, predicate, object.toString(), object.getLang(), true, false);
	}
	
	/**
	 * 
	 * @param subject
	 * @param predicate
	 * @param object
	 * @param objectLang
	 * @param litObject
	 * @param anonObject
	 */
	private void statement(AResource subject, AResource predicate,
							String object, String objectLang, boolean litObject, boolean anonObject){

		try{
			if(predicate.toString().equals(RDF.type.toString()) && object.equals("http://rdf.geospecies.org/ont/geospecies#SpeciesConcept")){
				if(dto != null){
					insert(dto);
				}
					
				dto = new LinkInfoDTO();
				dto.setIdentifier(subject.toString());
			}
			if(dto != null){
				if(predicate.toString().equals(geo_ns+"hasCanonicalName"))
					dto.setHasCanonicalName(object);
				if(predicate.toString().equals(geo_ns+"hasScientificNameAuthorship"))
					dto.setHasScientificNameAutorship(object);
			}
			
		}
		catch (Exception e){
			errors.add(e.getMessage());
			throw new LoadException(e.toString(), e);
		}
	}
	
	private void insert(LinkInfoDTO dto) throws SQLException {
		
		String identifier = dto.getIdentifier();
		String sciName = dto.getHasCanonicalName();
		if(sciName == null)
			sciName = "";
		String author = dto.getHasScientificNameAutorship();
		
		if(sciName != null && author != null){
			String query = "SELECT S1.ID_NATURE_OBJECT, S2.AUTHOR FROM chm62edt_species AS S1, chm62edt_species AS S2 WHERE S1.ID_SPECIES = S2.ID_SPECIES_LINK AND S2.SCIENTIFIC_NAME = '"+EunisUtil.replaceTagsImport(sciName)+"'";
			
			PreparedStatement ps = null;
		    ResultSet rs = null;

		    try {
		    	ps = con.prepareStatement(query);
		    	rs = ps.executeQuery();
		    	while(rs.next()){
		    		String natob_id = rs.getString("ID_NATURE_OBJECT");
		    		String sql_author = rs.getString("AUTHOR");
		    		if(author != null && sql_author != null && author.equals(sql_author)){
		    			insertExternalObject(natob_id, "issame", identifier, sciName+" "+author);
		    		} else {
		    			insertExternalObject(natob_id, "maybesame", identifier, sciName+" "+author);
		    		}
		    	}
		    } catch ( Exception e ) {
		    	e.printStackTrace();
		    	errors.add(e.getMessage());
		    } finally {
		    	if(ps != null)
		    		ps.close();
	    		if(rs != null)
	    			rs.close();
		    }
		}
	}
	
	
	private void insertExternalObject(String natob_id, String type, String identifier, String name) throws SQLException {
		if(!externalObjectExists(natob_id)){
			String query = "INSERT INTO externalobjects (ID_NATURE_OBJECT, RELATION, RESOURCE, NAME) VALUES (?,?,?,?)";
			
			PreparedStatement ps = null;
		    try {
		    	ps = con.prepareStatement(query);
		    	
		    	ps.setString(1, natob_id);
		    	ps.setString(2, type);
		    	ps.setString(3, identifier);
		    	ps.setString(4, EunisUtil.replaceTagsImport(name));
		    	ps.executeUpdate();
		    	
		    } catch ( Exception e ) {
		    	e.printStackTrace();
		    	errors.add(e.getMessage());
		    } finally {
		    	if(ps != null)
		    		ps.close();
		    }
		}
	}
	
	public boolean externalObjectExists(String natob_id) throws SQLException {
		
		boolean ret = false;
		
		String query = "SELECT RESOURCE FROM externalobjects WHERE ID_NATURE_OBJECT="+natob_id+" LIMIT 1";
		
		PreparedStatement ps = null;
	    ResultSet rs = null;

	    try {
	    	ps = con.prepareStatement(query);
	    	rs = ps.executeQuery();
	    	while(rs.next()){
	    		ret = true;
	    	}
	    } catch ( Exception e ) {
	    	e.printStackTrace();
	    	errors.add(e.getMessage());
	    } finally {
	    	if(ps != null)
	    		ps.close();
    		if(rs != null)
    			rs.close();
	    }
	    return ret;
	}
	
	/**
	 * 
	 * @throws SQLException
	 */
	public void endOfFile() throws SQLException{
		
		if(dto != null){
			insert(dto);
		}		
		
	}
	
	/*
     * (non-Javadoc)
     * @see org.xml.sax.ErrorHandler#error(org.xml.sax.SAXParseException)
     */
	public void error(SAXParseException e) throws SAXException {

		if (!saxErrorSet){
			errors.add(e.getMessage());
			logger.warn("SAX error encountered: " + e.toString(), e);			
			saxErrorSet = true;
		}
	}
	
	/*
	 * (non-Javadoc)
	 * @see org.xml.sax.ErrorHandler#warning(org.xml.sax.SAXParseException)
	 */
	public void warning(SAXParseException e) throws SAXException {
		
		if (!saxWarningSet){
			logger.warn("SAX warning encountered: " + e.toString(), e);
			errors.add(e.getMessage());
			saxWarningSet = true;
		}
	}

	/*
	 * (non-Javadoc)
	 * @see org.xml.sax.ErrorHandler#fatalError(org.xml.sax.SAXParseException)
	 */
	public void fatalError(SAXParseException e) throws SAXException {
		throw new LoadException(e.toString(), e);
	}
	
	/**
	 * @return the saxError
	 */
	public List<String> getErrors() {
		return errors;
	}
}
