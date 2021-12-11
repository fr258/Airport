<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>processing cancellation</title>
</head>
<body>
	<%
		String qID = request.getParameter("id"); 
		String text = request.getParameter("text");
		String username = (String) session.getAttribute("username");
		ArrayList<String> msg = new ArrayList<>();
		try {
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			String getQuestion ="select * from questionasked where qID ="+qID;
			PreparedStatement ps = con.prepareStatement(getQuestion);
	        ResultSet rs = ps.executeQuery();
			if(!rs.next())  {
				msg.add("Question is not found.");
			}
			
			if (text.length() > 1000) 	{
				msg.add("Answer is too long. Please shorten to under 1000 symbols");
			}
			if(msg.isEmpty()) {
				String newAnswer = "insert into answerprovided(answID, text, username, qID) values(?, ?, ?, ?)";
				String num = "select count(*) num from answerprovided";
             	ps = con.prepareStatement(num);
             	ResultSet rs1 = ps.executeQuery();
             	rs1.next();
             	ps = con.prepareStatement(newAnswer);
             	ps.setInt(1, rs1.getInt("num") + 1);
             	ps.setString(2, text);
             	ps.setString(3, username);
             	ps.setInt(4, rs.getInt("qID"));
             	out.println(ps);
             	ps.executeUpdate();
				msg.add("Answer has been added!");
				request.setAttribute("msg", msg);
				request.getRequestDispatcher("question.jsp").forward(request, response);
			}
			else {
				request.setAttribute("msg", msg);
				request.getRequestDispatcher("question.jsp").forward(request, response);
			}
	        con.close();
		}
	    catch (Exception ex) {
	    	msg = new ArrayList<>();
	    	msg.add("Something went wrong. Please try again.");
	    	msg.add(ex.toString());
			request.setAttribute("msg", msg);
			request.getRequestDispatcher("question.jsp").forward(request, response);
	    }


			
	%>
	
	
	

</body>
</html>