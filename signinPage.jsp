<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.* " %>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Signin Page</title>
</head>
<body>
	<h4> Sign in </h4>
	<form method="post" action= "signinPage.jsp">
		<table>
			<tr>    
				<td>username</td><td><input type="text" name="username"></td>
			<tr>
				<td>password</td><td><input type="password" name="password"></td>
		</table>
		<input type="submit" value="submit">
	</form>
	
	<%
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		
		if(username != null || password != null) {		
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
				out.println("Username or password is incorrect.");
			} 
		}
	 %>


		

</body>
</html>