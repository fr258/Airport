<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.* " %>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Delete User</title>
</head>
<body>
	<p> Delete User </p>
	<%
		try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();

			//Create a SQL statement
			Statement stmt = con.createStatement();

			//Get parameters from the HTML form at the adminView.jsp
			String username = request.getParameter("username");
			
			//check to see if username is valid
			String getUser ="select * from userinfo where username='"+username+"'";
			PreparedStatement ss = con.prepareStatement(getUser);
			boolean userAlreadyExists;
	        ResultSet rs = ss.executeQuery();
	        if (!rs.next()) {
				request.setAttribute("msg", "Cant find username");
				out.print("Cant find username");
				request.getRequestDispatcher("adminView.jsp").forward(request, response);
	        }

			//Make an delete statement for the userinfo table:
			String del = "DELETE FROM userinfo WHERE username = '" + username + "'";
			//Create a Prepared SQL statement allowing you to introduce the parameters of the query
			PreparedStatement ps = con.prepareStatement(del);
	        ps.executeUpdate();

			//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
			con.close();

			out.print("Delete succeeded!");
		}
	    catch (Exception ex) {
	    		out.print(ex);
	    		out.print("Delete failed");
	    }
	 
	%>

</body>
</html>