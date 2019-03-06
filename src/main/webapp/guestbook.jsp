<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>

<%@ page import="com.google.appengine.api.users.User" %>

<%@ page import="com.google.appengine.api.users.UserService" %>

<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>

<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>

<%@ page import="com.google.appengine.api.datastore.Query" %>

<%@ page import="com.google.appengine.api.datastore.Entity" %>

<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>

<%@ page import="com.google.appengine.api.datastore.Key" %>

<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>



<html>

 <head>
   <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
 </head>

 <body>
<div class="header">
  <h2>The Summoner's Rift</h2>
  <h5 style="color:#069"> By: Jason and Mircea</h5>
</div>
<div class="row">
  <div class="leftcolumn">
    <div class="card">
      <h2>About Our Blog</h2>
      <img src="league.jpg" alt="Italian Trulli">
      
      <h5>Your one-stop League of Legends blog</h5>
      
      <p>Speak to Mircea and Jason for development tips.</p>
      <p>This is our blog, we will talk about league of legends and other moba sports!</p>
    </div>

<br>






<%

    String guestbookName = request.getParameter("guestbookName");

    if (guestbookName == null) {

        guestbookName = "default";

    }

    pageContext.setAttribute("guestbookName", guestbookName);

    UserService userService = UserServiceFactory.getUserService();

    User user = userService.getCurrentUser();

    if (user != null) {

      pageContext.setAttribute("user", user);

%>

<%-- <p>Hello, ${fn:escapeXml(user.nickname)}! (You can

<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
 --%>
<%

    } else {

%>

<%-- <p>Hello!

<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>

to include your name with greetings you post.</p> --%>

<%

    }

%>



<%

    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

    Key guestbookKey = KeyFactory.createKey("Guestbook", guestbookName);

    // Run an ancestor query to ensure we see the most up-to-date

    // view of the Greetings belonging to the selected Guestbook.

	Query query = new Query("Greeting", guestbookKey).addSort("user", Query.SortDirection.DESCENDING).addSort("date", Query.SortDirection.DESCENDING);

    List<Entity> greetings = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));

    if (greetings.isEmpty()) {

        %>

<%--         <p>Guestbook '${fn:escapeXml(guestbookName)}' has no messages.</p>
 --%>
        <%

    } else {

        %>

        <%-- <p>Messages in Guestbook '${fn:escapeXml(guestbookName)}'.</p> --%>

        <%

        for (Entity greeting : greetings) {

            pageContext.setAttribute("greeting_content", greeting.getProperty("content")); //content

            pageContext.setAttribute("greeting_titleBox", greeting.getProperty("titleBox")); //content

            pageContext.setAttribute("greeting_date", greeting.getProperty("date"));

            if (greeting.getProperty("user") == null) {

                %>

					<div class="alert">
					  <span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span>
					  This is an alert box.
					</div>
                <%

            } else {

                pageContext.setAttribute("greeting_user",

                                         greeting.getProperty("user"));

                %>

    			  <div class="leftcolumn">

    			<div class="card">
    			<h2>${fn:escapeXml(greeting_titleBox)}</h2>
    			<h5>By: ${fn:escapeXml(greeting_user.nickname)}</h5> <h5 style="color:#D3D3D3">${fn:escapeXml(greeting_date)}</h5>
    			<hr>


                <p>${fn:escapeXml(greeting_content)}</p>
    			</div>
    			</div>
                <%

            }


        }

    }

%>




    <form action="/sign" method="post">

      <div><textarea name="titleBox" rows="1" cols="60">Title</textarea></div>

      <div><textarea name="content" rows="5" cols="60">Content</textarea></div>

      <div><input type="submit" value="Submit Blog Post" /></div>

      <input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>

    </form>






  </div>
  <div class="rightcolumn">
    <div class="card">
      <h2>About Me</h2>
      <div class="fakeimg" style="height:100px;">Image</div>
      <p>Some text about me in culpa qui officia deserunt mollit anim..</p>
    </div>
   <div class="card">
         <h2>Login:</h2>
         <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
         <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">Sign out</a>
    </div>
    <div class="card">
      <h3>Subscription</h3>
          <input type="text"><br>
          <button class="button">Subscribe</button>
          <button class="button">Unsubscribe</button>
    </div>
  </div>
</div>

<div class="footer">
  <h2>
  <a href="blogs.jsp">See More Blogs</a>
  </h2>
</div>



  </body>

</html>
