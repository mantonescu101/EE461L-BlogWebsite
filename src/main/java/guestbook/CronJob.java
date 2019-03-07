package guestbook;

import java.io.IOException; 
import java.io.UnsupportedEncodingException;

import javax.servlet.http.*;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;
import javax.activation.*;


public class CronJob extends HttpServlet {

	
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException{
//		
//		UserService userService = UserServiceFactory.getUserService();
//		User user = userService.getCurrentUser();
//		
//		if(user!=null) {
//		
//		resp.setContentType("text/plain");
//		resp.getWriter().println("Hello" + user.getNickname());
//		}else {
//			resp.sendRedirect(userService.createLoginURL(req.getRequestURI()));
//		}
	
	
		String guestbookName = req.getParameter("guestbookName");
		
	    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

	    UserService userService = UserServiceFactory.getUserService();
	    User user = userService.getCurrentUser();

	    Key guestbookKey = KeyFactory.createKey("Guestbook", guestbookName);
	    
		Query query = new Query("Greeting", guestbookKey).addSort("user", Query.SortDirection.DESCENDING).addSort("date", Query.SortDirection.DESCENDING);

	    List<Entity> greetings = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(50));
	    
	    List<Entity> recentPosts = new ArrayList<>();

	    Entity today = new Entity("Greeting", guestbookKey);
	    
	    for(Entity post : greetings) {
	    	Date date = (Date)post.getProperty("date");
	    	 
	    	Calendar cal = Calendar.getInstance();
	    	cal.setTime(date);
	    	if( Calendar.DATE == cal.DATE) {
	    		recentPosts.add(post);
	    	}
	    }
	    
	
		Properties props = new Properties();
		Session session = Session.getDefaultInstance(props, null);

		try {
		  Message msg = new MimeMessage(session);
		  msg.setFrom(new InternetAddress("jasonstephen15@gmail.com", "Admin"));
		  msg.addRecipient(Message.RecipientType.TO,
		                   new InternetAddress(user.getEmail(),user.getNickname()));
		  msg.setSubject("League Blog Updates!");
		  msg.setText((String)recentPosts.get((0)).getProperty("Content"));
//		  msg.setContent("<div class=\"card\">\r\n" + 
//		  		"    			<h2>${fn:escapeXml(greeting_titleBox)}</h2>\r\n" + 
//		  		"    			<h5>By: ${fn:escapeXml(greeting_user.nickname)}</h5> <h5 style=\"color:#D3D3D3\">${fn:escapeXml(greeting_date)}</h5>\r\n" + 
//		  		"    			<hr>\r\n" + 
//		  		"\r\n" + 
//		  		"\r\n" + 
//		  		"                <p>${fn:escapeXml(greeting_content)}</p>\r\n" + 
//		  		"    			</div>", "text/html");
		  Transport.send(msg);
		} catch (AddressException e) {
		  // ...
		} catch (MessagingException e) {
		  // ...
		} catch (UnsupportedEncodingException e) {
		  // ...
		}
    
	}
	
	

	

	     
	   
	
}
