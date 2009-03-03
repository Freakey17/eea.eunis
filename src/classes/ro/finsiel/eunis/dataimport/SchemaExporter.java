package ro.finsiel.eunis.dataimport;

import java.io.IOException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import ro.finsiel.eunis.session.SessionManager;
import ro.finsiel.eunis.utilities.SQLUtilities;

public class SchemaExporter extends HttpServlet {
	
	private static List<String> errors = null;
	
	/**	
	* Overrides public method doPost of javax.servlet.http.HttpServlet.
	* @param request Request object
	* @param response Response object.
	*/
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		HttpSession session = request.getSession(false);
		SessionManager sessionManager = (SessionManager) session.getAttribute("SessionManager");
		if (sessionManager.isAuthenticated() && sessionManager.isImportExportData_RIGHT()) {
			errors = new ArrayList<String>();
		
			String SQL_DRV = request.getSession().getServletContext().getInitParameter("JDBC_DRV");
			String SQL_URL = request.getSession().getServletContext().getInitParameter("JDBC_URL");
	        String SQL_USR = request.getSession().getServletContext().getInitParameter("JDBC_USR");
	        String SQL_PWD = request.getSession().getServletContext().getInitParameter("JDBC_PWD");
	        
			String table = request.getParameter("table");
			String nl = "\n";
			
			try {
		    
				SQLUtilities sql = new SQLUtilities();
				sql.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);
				List<ColumnDTO> columns = sql.getTableInfoList(table);
				
				StringBuilder s = new StringBuilder();
				s.append("<xsd:schema xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">").append(nl);
				s.append("<xsd:element name=\"ROWSET\">").append(nl);
				s.append("<xsd:complexType>").append(nl);
				s.append("<xsd:sequence>").append(nl);
				s.append("<xsd:element ref=\"ROW\" minOccurs=\"0\" maxOccurs=\"unbounded\"/>").append(nl);
				s.append("</xsd:sequence>").append(nl);
				s.append("</xsd:complexType>").append(nl);
				s.append("</xsd:element>").append(nl).append(nl);
				
				s.append("<xsd:element name=\"ROW\">").append(nl);
				s.append("<xsd:complexType>").append(nl);
				s.append("<xsd:sequence>").append(nl);
				
				for(Iterator<ColumnDTO> it = columns.iterator(); it.hasNext();){
					ColumnDTO column = it.next();
					String name = column.getColumnName();
					int type = column.getColumnType();
					int size = column.getColumnSize();

					if(type == Types.VARCHAR || type == Types.CHAR || type == Types.LONGVARCHAR){
						s.append("<xsd:element name=\"").append(name).append("\" minOccurs=\"0\" maxOccurs=\"1\">").append(nl);
						s.append("<xsd:simpleType>").append(nl);
						s.append("<xsd:restriction base=\"xsd:string\">").append(nl);
						s.append("<xsd:maxLength value=\"").append(size).append("\"/>").append(nl);
						s.append("</xsd:restriction>").append(nl);
						s.append("</xsd:simpleType>").append(nl);
						s.append("</xsd:element>").append(nl);
					} else {
						String xsdType = "";
						if(type == Types.INTEGER || type == Types.BIGINT || type == Types.NUMERIC)
							xsdType = "xsd:int";
						else if(type == Types.FLOAT || type == Types.FLOAT || type == Types.REAL || type == Types.DECIMAL)
							xsdType = "xsd:double";
						else if(type == Types.TINYINT || type == Types.SMALLINT)
							xsdType = "xsd:short";
						else if(type == Types.BOOLEAN)
							xsdType = "xsd:boolean";
						else if(type == Types.DATE)
							xsdType = "xsd:date";
						else
							xsdType = "xsd:string";
						
						s.append("<xsd:element name=\"").append(name).append("\" minOccurs=\"0\" maxOccurs=\"1\" type=\"").append(xsdType).append("\"/>").append(nl);
					}
				}
				
				s.append("</xsd:sequence>").append(nl);
				s.append("</xsd:complexType>").append(nl);
				s.append("</xsd:element>").append(nl);
				s.append("</xsd:schema>").append(nl);
				
				response.setContentType("application/xml;charset=UTF-8"); 
				response.setHeader("Content-Disposition", "attachment; filename="+table+".xsd");
			    response.getWriter().write(s.toString());
				
			} catch(Exception e){
				e.printStackTrace();
				errors.add(e.getMessage());
			}
		} else {
			response.sendRedirect("dataimport/schema-exporter.jsp");
		}
	}
	
}
