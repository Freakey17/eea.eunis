package ro.finsiel.eunis.admin;

import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import ro.finsiel.eunis.WebContentManagement;

public class UpdateTemplate extends HttpServlet {
	
	/*
     *  (non-Javadoc)
     * @see javax.servlet.http.HttpServlet#service(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    public void service(HttpServletRequest req, HttpServletResponse res)
                                            throws ServletException, IOException {
        
          
       	WebContentManagement wm = new WebContentManagement();
       	
       	String baseDir = getServletContext().getInitParameter("TOMCAT_HOME");
       	
       	String headerUrl = getServletContext().getInitParameter("TEMPLATES_HEADER");
       	String headerText = wm.readContentFromURL(headerUrl);
       	String headerFileName = baseDir + getServletContext().getInitParameter("TEMPLATE_HEADER_LOCATION");
       	
       	String footerUrl = getServletContext().getInitParameter("TEMPLATES_FOOTER");
       	String footerText = wm.readContentFromURL(footerUrl);
       	String footerFileName = baseDir + getServletContext().getInitParameter("TEMPLATE_FOOTER_LOCATION");
       	
       	writeFile(headerFileName, headerText);
       	writeFile(footerFileName, footerText);       	
        
        res.sendRedirect("templateUpdated.jsp");
        
    }
    
    private void writeFile(String fileName, String txt) throws ServletException, IOException {
		
    	
    	try{
    		FileOutputStream fos = new FileOutputStream(fileName);
    		fos.write(new String("<%@page contentType=\"text/html;charset=UTF-8\"%>\n").getBytes());
    		fos.write(txt.getBytes("UTF-8"));
			
			if (fos != null) {
				fos.flush();
				fos.close();
			}
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
	}
    
}
