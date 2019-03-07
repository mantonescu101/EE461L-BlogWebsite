<!-- %@ page contentType="text/html;charset=UTF-8" language="java" %> -->

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

 <body>
<div class="header">
  <h2>All Posts!</h2>
  <%-- <h5 style="color:#069"> By: Jason and Mircea</h5> --%>
</div>

<div class="row">
  <%-- <div class="leftcolumn">
    <div class="card">
      <h2>TITLE HEADING</h2>
      <h5>Title description, Dec 7, 2017</h5>
      <div class="fakeimg" style="height:200px;">Image</div>
      <p>Some text..</p>
      <p>Sunt in culpa qui officia deserunt mollit anim id est laborum consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco.</p>
    </div>
    <div class="card">
      <h2>TITLE HEADING</h2>
      <h5>Title description, Sep 2, 2017</h5>
      <div class="fakeimg" style="height:200px;">Image</div>
      <p>Some text..</p>
      <p>Sunt in culpa qui officia deserunt mollit anim id est laborum consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco.</p>
    </div>
  </div> --%>
  <%-- <div class="rightcolumn">
    <div class="card">
      <h2>About Me</h2>
      <div class="fakeimg" style="height:100px;">Image</div>
      <p>Some text about me in culpa qui officia deserunt mollit anim..</p>
    </div>
   <div class="card">
      <h2>Login</h2>

      <p>Put Login Link here</p>
    </div>
    <div class="card">
      <h3>Subscription</h3>
          <input type="text"><br>
          <button class="button">Subscribe</button>
          <button class="button">Unsubscribe</button>
    </div>
  </div> --%>
</div>





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
<%-- 
<p>Hello, ${fn:escapeXml(user.nickname)}! (You can

<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p> --%>

<%

   // } else {

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

        <p>Blog '${fn:escapeXml(guestbookName)}' has no Posts.</p>

        <%

    } else {

        %>

        <%-- <p>Messages in Guestbook '${fn:escapeXml(guestbookName)}'.</p> --%>

        <%

        



                for (Entity greeting : greetings) {

            pageContext.setAttribute("greeting_content", greeting.getProperty("content")); //content

            pageContext.setAttribute("greeting_titleBox", greeting.getProperty("titleBox")); //content

            pageContext.setAttribute("greeting_date", greeting.getProperty("date"));

            if (greeting.getProperty("user") != null) {


                pageContext.setAttribute("greeting_user",

                                         greeting.getProperty("user"));

                %>

    			 <!--  <div class="leftcolumn"> -->

    			<div class="card">
    			<h2>${fn:escapeXml(greeting_titleBox)}</h2>
    			<h5>By: ${fn:escapeXml(greeting_user.nickname)}</h5> <h5 style="color:#D3D3D3">${fn:escapeXml(greeting_date)}</h5>
    			<hr>


                <p>${fn:escapeXml(greeting_content)}</p>
    			</div>
    			<!-- </div> -->
                <%

            }

        }

    }

%>


<div class="footer">
    <h2>
  <a href="guestbook.jsp">Back To Main Page</a>
  </h2>
</div>




<%-- 
    <form action="/sign" method="post">

      <div><textarea name="content" rows="3" cols="60"></textarea></div>

      <div><input type="submit" value="Post Greeting" /></div>

      <input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>

    </form> --%>



  </body>

</html>
