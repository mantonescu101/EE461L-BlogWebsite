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
		
		if (guestbookName == null) {

	        guestbookName = "default";

	    }
		
	    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

	    UserService userService = UserServiceFactory.getUserService();
	    User user = userService.getCurrentUser();
	    
	    System.out.println("guestbook" + guestbookName);
	    
	    Key guestbookKey = KeyFactory.createKey("Guestbook", guestbookName);
	    
		Query query = new Query("Greeting", guestbookKey).addSort("user", Query.SortDirection.DESCENDING).addSort("date", Query.SortDirection.DESCENDING);

	    List<Entity> greetings = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(10));
	    
	    
	    List<Entity> recentPosts = new ArrayList<>();
	    String message = "Here are today's posts:\n\n";

	    Entity today = new Entity("Greeting", guestbookKey);
    
	    for(Entity greeting : greetings) {
	    	
	    	
	    	Date date = (Date)greeting.getProperty("date");
	    	 
	    	Calendar cal = Calendar.getInstance();
	    	cal.setTime(date);
	    	if( Calendar.DATE == cal.DATE) {
	    		recentPosts.add(greeting);
	    	}
	    }
	    
	    if(recentPosts.isEmpty()) {
	    	message = "No new posts!";
	    }
	    for(Entity recent : recentPosts) {
	    	message += recent.getProperty("user") + "wrote:\n";
	    	message += recent.getProperty("titleBox") + ":\n";
	    	message += recent.getProperty("content") + "\n\n";
	    }
	    
	
		Properties props = new Properties();
		Session session = Session.getDefaultInstance(props, null);

		List<String> emails = SubcribeUser.emails;
		
		try {
		  Message msg = new MimeMessage(session);
		  msg.setFrom(new InternetAddress("jasonstephen15@gmail.com", "Admin"));
		for(String email: emails) {
		  msg.addRecipient(Message.RecipientType.TO,
		                   new InternetAddress(email, "Yosef"));//user.getEmail(),user.getNickname())
		}
		  msg.setSubject("League Blog Updates!");
		  msg.setText(message);

		  Transport.send(msg);
		} catch (AddressException e) {
		  // ...
		} catch (MessagingException e) {
		  // ...
		} catch (UnsupportedEncodingException e) {
		  // ...
		}
		resp.sendRedirect("/guestbook.jsp");
	}
	
	

	

	     
	   
	
}
