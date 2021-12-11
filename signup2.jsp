<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>processing signup</title>
</head>
<body>
	<%
		String firstName = request.getParameter("firstName"),
			   lastName = request.getParameter("lastName"),
			   username = request.getParameter("username"),
			   password = request.getParameter("password");
		boolean userAlreadyExists = false; 
		try {
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			String getUser ="select * from userinfo where username='"+username+"'";
			PreparedStatement ps = con.prepareStatement(getUser);
	        ResultSet rs = ps.executeQuery();
	        if (!rs.next()) {
	        	userAlreadyExists = false;
	        } else {
	        	userAlreadyExists = true;
	        }
			ArrayList<String> msg = new ArrayList<>();

			if(userAlreadyExists) 
				msg.add("Username already exists. Please choose again.");
					
			if(username != "")  {
				if(username.length() > 15)
					msg.add("Username is too long. Username must be less than 15 characters.");
			}
			else 
				msg.add("Username cannot be empty.");
			
			if(password != "") {
				if(password.length() > 35)
					msg.add("Password is too long. Password must be less than 35 characters.");
			}
			else 
				msg.add("Password cannot be empty.");
			
			if(firstName != "") {
				if(firstName.length() > 20)
					msg.add("First name is too long. First name must be less than 20 characters.");
			}
			else 
				msg.add("First name cannot be empty.");
			
			if(lastName != "") {
				if(lastName.length() > 20)
					msg.add("Last name is too long. Last name must be less than 20 characters.");	
			}
			else 
				msg.add("Last name cannot be empty.");
			
					
			if(msg.isEmpty()) {
				//Make an insert statement for the Sells table:
				String insert = "INSERT INTO userInfo(username, password, firstName, lastName, role)"
						+ "VALUES (?, ?, ?, ?, ?)";
				//Create a Prepared SQL statement allowing you to introduce the parameters of the query
				ps = con.prepareStatement(insert);

				//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
				ps.setString(1, username);
				ps.setString(2, password);
				ps.setString(3, firstName);
				ps.setString(4, lastName);
				ps.setString(5, "Customer");
				//Run the query against the DB
				ps.executeUpdate();

				request.getRequestDispatcher("customerView.jsp").forward(request, response);
			}
			else {
				request.setAttribute("msg", msg);
				request.getRequestDispatcher("signupPage.jsp").forward(request, response);
			}
	        con.close();
		}
	    catch (Exception ex) {
			request.setAttribute("msg", "Something went wrong. Please try again.");
			request.getRequestDispatcher("signupPage.jsp").forward(request, response);
	    }


			
	%>
	
	
	

</body>
</html>