<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>New Question</title>
</head>
<body>
		<form method="post" action="processQuestion.jsp">
			<table>
				<tr>    
					<td>Title</td><td><input type="text" name="title"></td>
				<tr>
					<td>Question</td><td><textarea name="bodyText" rows="4" cols="50"></textarea></td>
			</table>
			<input type="submit" value="Ask!">
		</form>
			

</body>
<%
			ArrayList<String> errors = (ArrayList<String>) request.getAttribute("msg");
			if(errors != null) {
				for(String a: errors)
					out.println(a);
				request.setAttribute("msg", null);
			}
			%>
</html>