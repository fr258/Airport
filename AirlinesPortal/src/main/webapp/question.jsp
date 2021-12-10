<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Viewing Questions</title>
</head>
<body>
	<%
		String qID = request.getParameter("id");
		try {
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			String getQuestion ="select * from questionasked where qID='"+qID+"'";
			PreparedStatement ps = con.prepareStatement(getQuestion);
	        ResultSet rs = ps.executeQuery(); 
	        if (!rs.next()) {
	        	out.println("Something went wrong. Seems like question was deleted.");
	        } else {
	        	String title = rs.getString("title");
	        	String body = rs.getString("bodyText");
	        	String user = rs.getString("username");
	        	int qid = rs.getInt("qID");
	        %>
	        <p> Question: <%= title %></p>
	        <p> Asked by: <%= user %></p>
	        <hr style="width:10%;text-align:left;margin-left:0">
	        <p style="max-width:50%"> <%= body %></p>
	        <hr style="width:10%;text-align:left;margin-left:0">
	        <br>
	        <p> Answers</p>
	        <table>
            <%
            String getNumAnswers ="select count(*) num from answerprovided where qID='"+qID+"'";
            ps = con.prepareStatement(getNumAnswers);
            ResultSet rsNum = ps.executeQuery();
            rsNum.next();
            if (rsNum.getInt("num") == 0) { %>
            	<tr>
                	<td>No answers yet.</td>
            	</tr>
            	<%
            } else {
            String getAnswers ="select * from answerprovided where qID='"+qID+"'";
            ps = con.prepareStatement(getAnswers);
            ResultSet rsAns = ps.executeQuery(); 
            while(rsAns.next()){ 
            	String answer = rsAns.getString("text");
    			String user2 = rsAns.getString("username");
            %>
            <tr>
                <td>Answered by <%= user2%></td>
            </tr>
            <tr>
            	<td style="max-width:50%"><%= answer%></td>
            </tr>
            <tr>
            <td> <hr style="width:10%;text-align:left;margin-left:0"></td>
            </tr>
            <% }} %>
        	</table>
        	<% 
			String username = (String) session.getAttribute("username");
			String getUser ="select * from userinfo where username='"+username+"'";
			ps = con.prepareStatement(getUser);
    		rs = ps.executeQuery();
    		if (!rs.next()) {
    			out.println("User is not authorized.");
  			  } else {
   		 	String role = rs.getString("role");
    			if (role.equals("Representative")) {
    				session.setAttribute("qID", qID);
    				%>
    				<form method="post">
					<table>
						<tr>
							<td>Type your answer.</td>
						</tr>
						<tr>
						<td><textarea required name="text" rows="4" cols="50"></textarea></td>
						</tr>
					</table>
			<button type="submit">Does not work</button>
		</form>
			<%
   	 	}
   	 }
	        }
	        con.close();
		}
	    catch (Exception ex) {
			request.setAttribute("msg", "Something went wrong. Please try again.");
			request.getRequestDispatcher("viewQuestions.jsp").forward(request, response);
	    }


			
	%>
	
	
	

</body>
</html>