<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.* " %>
<%@ page import="javax.servlet.http.*,javax.servlet.*,java.text.SimpleDateFormat"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<p> here </p>
<%
	out.println("departDate: "+request.getParameter("departDate"));
	out.println("isFlexible: "+request.getParameter("isFlexible"));
	
	try {
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		Calendar c = Calendar.getInstance();
		c.setTime(new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("departDate"))); 
		int departDay = c.get(Calendar.DAY_OF_WEEK);
		
		String getFlights = "select * from flight";
		PreparedStatement ps = con.prepareStatement(getFlights);
        ResultSet rs = ps.executeQuery();
		
		
        con.close();
	}
    catch (Exception ex) {
    		out.print(ex);
    		out.print("select failed");
    }
%>
</body>
</html>