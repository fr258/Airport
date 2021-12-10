<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.* " %>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Questions and Answers</title>
</head>
<body>

<%try {
	ApplicationDB dbl = new ApplicationDB();	
	Connection conl = dbl.getConnection();
	String username = (String) session.getAttribute("username");
	String getUser ="select * from userinfo where username='"+username+"'";
	PreparedStatement psl = conl.prepareStatement(getUser);
    ResultSet rsl = psl.executeQuery();
    if (!rsl.next()) {
    	out.println("User is not authorized.");
    } else {
    	String role = rsl.getString("role");
    	if (role.equals("Customer")) {
    		%>
    		<form method="get" action="newQuestion.jsp">
    			<button type="submit" >Ask a question</button>
			</form>
			<%
    	}
    }

}
 catch (Exception ex) {
		out.print(ex);
		out.print("select failed");
}
%>


<form method="get" action="searchQnA.jsp">
<p> Search questions and answers</p>
		<table>
			<tr>    
				<td><input type="text" required name="keyword"></td>
				<td><input type="submit" value="Search"></td>
			</tr>
		</table>
</form>

<%
	try {
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		String getQuestions = "select * from questionasked";
		PreparedStatement ps = con.prepareStatement(getQuestions);
        ResultSet rs = ps.executeQuery();
        boolean noQuestions = false;
        if (!rs.next()) {
	        	noQuestions = true;
	        } else {
%>		

		<form action="question.jsp" method="post">
		<table BORDER="1">
            <tr>
                <th>Questions</th>
				<th># of answers</th>
				<th>View details</th>
            </tr>
            <% rs = ps.executeQuery();
            while(rs.next()){ 
            	String title = rs.getString("title");
    			int qID = rs.getInt("qID");
    			String getAnswers ="select count(*) num from answerprovided where qID='"+qID+"'";
    			ps = con.prepareStatement(getAnswers);
    	        ResultSet rsAns = ps.executeQuery();
    	        rsAns.next();
    	        int num = rsAns.getInt("num");
            %>
            <tr>
                <td><%= title%></td>
				<td><%= num%></td>    
				<td><button type="submit" name="id" value=<%=qID %>>Go</button></td>
            </tr>
            <% } %>
        </table>
		</form>
		<table>
	<% }
        if (noQuestions) {
			%> 
			<tr>    
				<td>No questions yet. Ask one!</td>
			</tr>
			</table>
			<%
		}
		ArrayList<String> errors = (ArrayList<String>) request.getAttribute("msg");
		if(errors != null) {
			for(String a: errors)
				out.println(a);
			request.setAttribute("msg", null);
		}
			//close the connection.
			db.closeConnection(con);
			%>
			
		

		

		
	<%	
	}
     catch (Exception ex) {
    		out.print(ex);
    		out.print("select failed");
    }
%>

</body>
</html>
