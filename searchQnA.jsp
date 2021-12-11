<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Search results</title>
</head>
<body>
	<%
		String keyword = request.getParameter("keyword");
		try {
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			String getQuestions ="select * from questionasked where title like '%"+ keyword +
					"%' or bodyText like '%" + keyword +"%'";
			PreparedStatement ps = con.prepareStatement(getQuestions);
	        ResultSet rsQ = ps.executeQuery(); 
	        String getAnswers ="select * from answerprovided where text like '%"+ keyword +"%'";
			ps = con.prepareStatement(getQuestions);
	        ResultSet rsA = ps.executeQuery();
	        %>
	        <p> Questions:</p>
	        <hr style="width:10%;text-align:left;margin-left:0">
	        <% 
	        if (!rsQ.next()) {	        	
	        %>
	        <p> No such questions found. </p>
	        <%  } else { %>
	        <form action="question.jsp" method="post">
	        <table BORDER="1">
            <tr>
                <th>Questions</th>
				<th># of answers</th>
				<th>View details</th>
            </tr>
            <% 
            	ps = con.prepareStatement(getQuestions);
	        	rsQ = ps.executeQuery();
	        	while(rsQ.next()){ 
            	String title = rsQ.getString("title");
    			int qID = rsQ.getInt("qID");
    			String getAnswersNum ="select count(*) num from answerprovided where qID='"+qID+"'";
    			ps = con.prepareStatement(getAnswersNum);
    	        ResultSet rsNum = ps.executeQuery();
    	        rsNum.next();
    	        int num = rsNum.getInt("num");
            %>
            <tr>
                <td><%= title%></td>
				<td><%= num%></td>    
				<td><button type="submit" name="id" value=<%=qID %>>Go</button></td>
            </tr>
            <% }%> 
        </table>
         </form>
         <%} %>
        <br>    
        <p> Answers:</p>
	        <hr style="width:10%;text-align:left;margin-left:0">
	        <% 
	        if (!rsA.next()) {	        	
	        %>
	        <p> No such answers found. </p>
	        <%  } else { %>
	        <form action="question.jsp" method="post">
	        <table BORDER="1">
            <tr>
                <th>Answers</th>
				<th>View related question</th>
            </tr>
            <% 
            	ps = con.prepareStatement(getAnswers);
	        	rsA = ps.executeQuery();
	        	while(rsA.next()){ 
            	String text = rsA.getString("text");
    			int qID = rsA.getInt("qID");
            %>
            <tr>
                <td><%= text%></td>
				<td><button type="submit" name="id" value=<%=qID %>>Go</button></td>
            </tr>
             <% } %>
        </table>
       
        <br>                
        </form>
           
	        <%}
	        con.close();
		}
	    catch (Exception ex) {
			request.setAttribute("msg", "Something went wrong. Please try again.");
			request.getRequestDispatcher("viewQuestions.jsp").forward(request, response);
	    }


			
	%>
	
	
	

</body>
</html>