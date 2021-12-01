<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.* " %>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Processing</title>
</head>
<body>
	<p> Signin 2 </p>
	<%
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String role = "";
		
		boolean validUser = false; 
		
		try {
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			String getUser ="select * from userinfo where username='"+username+"'"
	                + "and password='" + password + "'";
			PreparedStatement ps = con.prepareStatement(getUser);
	        ResultSet rs = ps.executeQuery();
	        if (!rs.next()) {
	        	validUser = false;
	        } else {
	        	role = rs.getString("role").toLowerCase();
	        	validUser = true;
	        }
	        con.close();
		}
	    catch (Exception ex) {
	    		out.print(ex);
	    		out.print("select failed");
	    	}
		 if(validUser) 
			request.getRequestDispatcher((role+"View.jsp")).forward(request, response);
		else {
			request.setAttribute("msg", "Username or password is incorrect.");
			request.getRequestDispatcher("signinPage.jsp").forward(request, response);
		} 
	 
	%>
</body>
</html>