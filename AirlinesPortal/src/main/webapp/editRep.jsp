<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.* " %>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Edit User</title>
</head>
<body>
	<p> Edit User </p>
	<%
		try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			
			//Create a SQL statement
			Statement stmt = con.createStatement();
			
			//Get parameters from the HTML form at the adminView.jsp
			String username = request.getParameter("username");
			
			//check to see if username we search for exists
			String getUser ="select * from userinfo where username='"+username+"'";
			PreparedStatement ss = con.prepareStatement(getUser);
			boolean userAlreadyExists;
	        ResultSet rs = ss.executeQuery();
	        if (!rs.next()) {
				request.setAttribute("msg", "Cant find username");
				out.print("Cant find username");
				request.getRequestDispatcher("welcomePage.jsp").forward(request, response);
	        }
			
			//check to see if user wanted to change usernames. if not, set newUsername to username, else they want a new username so we set newusername to the input textfield
			String newUsername;
			if( request.getParameter("newUsername").equals("") || request.getParameter("newUsername") == null){
				newUsername = username;
			}
			else{
				newUsername = request.getParameter("newUsername");
			}
			
			//get all other parameters
			String firstName = request.getParameter("firstName");
			String lastName = request.getParameter("lastName");
			String password = request.getParameter("password");
			String role = request.getParameter("role");
			//check to see if the user typed Representative or Customer correct
			if(role.equals("Representative") == false && role.equals("Customer") == false){
				request.setAttribute("msg", "New role must be Representative or Customer");
				out.print("New role must be Representative or Customer");
				request.getRequestDispatcher("welcomePage.jsp").forward(request, response);
			}

			//sql query
			String edit = "UPDATE userInfo SET username = ?, password = ?, firstName = ?, lastName = ?, role = ? WHERE username = ?";
			//Create a Prepared SQL statement allowing you to introduce the parameters of the query
			PreparedStatement ps = con.prepareStatement(edit);
			ps.setString(1, newUsername);
			ps.setString(2, password);
			ps.setString(3, firstName);
			ps.setString(4, lastName);
			ps.setString(5, role);
			ps.setString(6, username);
	        ps.executeUpdate();
	        
			//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
			con.close();

			out.print("Edit succeeded!");
		}
	    catch (Exception ex) {
	    		out.print(ex);
	    		out.print("Edit failed");
	    }
	%>

</body>
</html>