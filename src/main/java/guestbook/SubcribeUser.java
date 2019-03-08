package guestbook;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class SubcribeUser extends HttpServlet {

	public static List<String> emails = new ArrayList<>();
	public static String email = "";

	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException{
		
		String sub = req.getParameter("sub");
		
        if(sub.equals("true")) {
        	email = req.getParameter("emailBox");
        	addUser(email);	
        } else {
    		email = req.getParameter("emailBoxUnsub");
        	deleteUser(email);
        }
        
        String guestbookName = req.getParameter("guestbookName");
        
        resp.sendRedirect("/guestbook.jsp");

	}
	
	public void addUser(String email) {
		if(!emails.contains(email)) {
		emails.add(email);
		System.out.println(email + " Success");
	}
	}
	
	public void deleteUser(String email) {
		if(emails.contains(email)) {
			emails.remove(email);
			System.out.println(email + " Successfully removed");
		}
	}
	
	
	

}
