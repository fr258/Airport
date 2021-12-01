<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Signup Page</title>
</head>
<body>
	<p>Signup Page</p>
			<form method="post" action="signup2.jsp">
				<table>
					<tr>    
						<td>username</td><td><input type="text" name="username"></td>
					<tr>
						<td>password</td><td><input type="password" name="password"></td>
					<tr>
						<td>first name</td><td><input type="text" name="firstName"></td>
					<tr>
						<td>last name</td><td><input type="text" name="lastName"></td>
					</tr>
				</table>
				<input type="submit" value="Sign up">
			</form>
			<%
				ArrayList<String> errors = (ArrayList<String>) request.getAttribute("msg");
				if(errors != null) {
					for(String a: errors)
						out.println(a);
					request.setAttribute("msg", null);
				}
			%>
</body>
</html>
