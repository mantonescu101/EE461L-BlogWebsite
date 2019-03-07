package guestbook;

import java.io.IOException;
import java.io.UnsupportedEncodingException;

import javax.servlet.http.*;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
// File Name SendEmail.java

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
	
	
	
	
		Properties props = new Properties();
		Session session = Session.getDefaultInstance(props, null);

		try {
		  Message msg = new MimeMessage(session);
		  msg.setFrom(new InternetAddress("jasonstephen15@gmail.com", "Example.com Admin"));
		  msg.addRecipient(Message.RecipientType.TO,
		                   new InternetAddress("jasonstephen15@gmail.com", "Mr. User"));
		  msg.setSubject("Your Example.com account has been activated");
		  msg.setText("This is a test");
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
