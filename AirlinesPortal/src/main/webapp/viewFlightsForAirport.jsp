<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
 
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();

		//Get parameters from the HTML form at the index.jsp
		String airport = request.getParameter("airport");		
		
		//Make an insert statement for the Sells table:
		String command = "SELECT * FROM flight WHERE arrivalApID = "+ airport + " union SELECT * FROM flight WHERE departApID = "+ airport;

		ResultSet result = stmt.executeQuery(command); %>
		
		<table>
		<tr>    
			<td>Flight ID#</td>
			</tr>
			<tr>
			<td><% if(result.next())
				{out.print(result.getString("fnum"));} %></td>
			</tr>
		</table>
			

		<%con.close();
		
		
	} catch (Exception ex) {
		out.print(ex);
		out.print("update failed");
	}
%>
</body>
</html>