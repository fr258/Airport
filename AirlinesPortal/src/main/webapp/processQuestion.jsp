<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>processing question</title>
</head>
<body>
	<%
		String title = request.getParameter("title"),
			   bodyText = request.getParameter("bodyText"); 
	String username = (String) session.getAttribute("username");
	ArrayList<String> msg = new ArrayList<>();
		try {
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			String getUser ="select count(*) num from questionasked";
			PreparedStatement ps = con.prepareStatement(getUser);
	        ResultSet rs = ps.executeQuery();
	        rs.next();
	        int num = rs.getInt("num");
	        num++;
			
			if(title != "")  {
				if(title.length() > 200)
					msg.add("Title is too long. Title must be less than 200 characters.");
			}
			else 
				msg.add("Title cannot be empty.");
			
			if(bodyText != "") {
				if(bodyText.length() > 500)
					msg.add("Question body is too long. It must be less than 500 characters.");
			}
			else 
				msg.add("Question body cannot be empty.");
			
					
			if(msg.isEmpty()) {
				//Make an insert statement for the questions table:
				String insert = "INSERT INTO questionasked(qID, bodyText, title, username)"
						+ "VALUES (?, ?, ?, ?)";
				ps = con.prepareStatement(insert);
				ps.setInt(1, num);
				ps.setString(2, bodyText);
				ps.setString(3, title);
				ps.setString(4, username);
				//Run the query against the DB
				ps.executeUpdate();
				msg.add("Question has been asked! Await for response.");
				request.setAttribute("msg", msg);
				request.getRequestDispatcher("viewQuestions.jsp").forward(request, response);
			}
			else {
				request.setAttribute("msg", msg);
				request.getRequestDispatcher("newQuestion.jsp").forward(request, response);
			}
	        con.close();
		}
	    catch (Exception ex) {
	    	msg = new ArrayList<>();
	    	msg.add("Something went wrong. Please try again.");
	    	msg.add(ex.toString());
			request.setAttribute("msg", msg);
			request.getRequestDispatcher("newQuestion.jsp").forward(request, response);
	    }


			
	%>
	
	
	

</body>
</html>