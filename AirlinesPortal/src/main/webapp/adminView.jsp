<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<%
		String username = request.getParameter("username");
		if(username == null)
			request.getRequestDispatcher(("welcomePage.jsp")).forward(request, response);
		session.setAttribute("username", username);
			
	%>
	
	
	<p> Admin View for <strong> <%= username %> </strong></p>
	
	<form method="post" action="welcomePage.jsp">
		<input type="submit" value="logout">
	</form>
</body>
</html>