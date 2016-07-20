package ireveal.repository;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.mail.MailException;
import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;

 
public class MailMail
{
	private String site2smsuserid;
	private String site2smspswd;
	 public String getSite2smsuserid() {
		return site2smsuserid;
	}

	public void setSite2smsuserid(String site2smsuserid) {
		this.site2smsuserid = site2smsuserid;
	}

	public String getSite2smspswd() {
		return site2smspswd;
	}

	public void setSite2smspswd(String site2smspswd) {
		this.site2smspswd = site2smspswd;
	}


	protected final Log logger = LogFactory.getLog(getClass());
	 private MailSender mailSender;
	    private SimpleMailMessage templateMessage;

	    public void setMailSender(MailSender mailSender) {
	        this.mailSender = mailSender;
	    }

	    public void setTemplateMessage(SimpleMailMessage templateMessage) {
	        this.templateMessage = templateMessage;
	    }
	
 
	public void sendMail(String msender, String content) {
 
		SimpleMailMessage msg = new SimpleMailMessage(this.templateMessage);
		
		msg.setTo(msender);
        msg.setText(content);
        
        try{
            this.mailSender.send(msg);
        }
        catch (MailException ex) {
        	 logger.info("inside SendAlertMail Exception "+ex.getMessage()); 
        }
        
	  /* MimeMessage message = mailSender.createMimeMessage();
 
	   try{
		MimeMessageHelper helper = new MimeMessageHelper(message, true);
 
		helper.setFrom(simpleMailMessage.getFrom());
		helper.setTo(simpleMailMessage.getTo());
		helper.setSubject(simpleMailMessage.getSubject());
		helper.setText(String.format(
			simpleMailMessage.getText(), dear, content));
 
		//FileSystemResource file = new FileSystemResource("C:\\log.txt");
		//helper.addAttachment(file.getFilename(), file);
		
		
 
	     }catch (MessagingException e) {
		throw new MailParseException(e);
	     }
	     mailSender.send(message);*/
         }
}
