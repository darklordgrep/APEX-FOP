<%----------------------------------------------------------------------------
  -- Module   : apex_fop.jsp - APEX Print Server
  -- Date     : $Date: 2023-03-01 13:56:33 -0600 (Wed, 01 Mar 2023) $
  -- Location : $HeadURL: svn://gis.mvn.usace.army.mil/sandp/ApexFOP/trunk/apex_fop.jsp $
  -- Revision : $Revision: 17969 $
  -- Purpose  : apex_fop is an implementation of an Oracle Application Express
  --            print server, used to generate PDF reports. 
  -- Requires : Java Servlet Engine such as Tomcat. 
  --            Java JRE 1.6 or later
  ----------------------------------------------------------------------------
  --%>
<%@ page import='java.io.*'%>
<%@ page import='org.w3c.dom.Document'%>
<%@ page import='javax.xml.transform.TransformerFactory'%>
<%@ page import='javax.xml.transform.Transformer'%>
<%@ page import='javax.xml.transform.stream.StreamSource'%>
<%@ page import='javax.xml.transform.stream.StreamResult'%>
<%@ page import='javax.xml.transform.sax.SAXResult'%>
<%@ page import='javax.xml.transform.Result'%>
<%@ page import='org.xml.sax.InputSource'%>
<%@ page import='javax.xml.transform.Source'%>
<%@ page import='org.apache.fop.apps.*'%>

<%
if (request.getParameter("xml") == null) {
  response.setContentType("text/plain");
  PrintWriter outw = response.getWriter();
  outw.write("Parameter 'xml' is missing");
  return;
}
if (request.getParameter("template") == null) {
  response.setContentType("text/plain");
  PrintWriter outw = response.getWriter();
  outw.write("Parameter 'template' is missing");
  return;
}
ByteArrayOutputStream outBuffer = new ByteArrayOutputStream();

javax.xml.transform.TransformerFactory tFactory = javax.xml.transform.TransformerFactory.newInstance();

StreamSource ss = new StreamSource(new StringReader(request.getParameter("xml")));
StreamSource st = new StreamSource(new java.io.StringReader(request.getParameter("template")));

final FopFactory fopFactory = FopFactory.newInstance(new File(".").toURI());
Fop fop = fopFactory.newFop(MimeConstants.MIME_PDF, outBuffer);

//Setup Transformer
Transformer transformer = tFactory.newTransformer(st);

//Make sure the XSL transformation's result is piped through to FOP
Result res = new SAXResult(fop.getDefaultHandler());

//Start the transformation and rendering process
transformer.transform(ss, res);

//Prepare response
response.setContentType("application/pdf");
response.setHeader("Content-Disposition", "inline");
response.setContentLength(outBuffer.size());

//Send content to Browser
response.getOutputStream().write(outBuffer.toByteArray());
response.getOutputStream().flush();
%>

