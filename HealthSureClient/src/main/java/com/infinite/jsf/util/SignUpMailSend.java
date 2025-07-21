package com.infinite.jsf.util;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class SignUpMailSend {

    public static String sendInfo(String toEmail, String subject, String data) {

        final String fromEmail = "msulekha277@gmail.com";
        final String password = "exgv qnec wzfe gahj"; // REPLACE with 16-char App Password

        Properties properties = new Properties();
        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.port", "465");
        properties.put("mail.smtp.ssl.enable", "true");
        properties.put("mail.smtp.auth", "true");

        Session session = Session.getInstance(properties, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        session.setDebug(true); // log SMTP activity

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject(subject);
            message.setText(data);

            Transport.send(message);
            System.out.println("Mail sent successfully!");
            return "Mail Sent Successfully!";
        } catch (MessagingException e) {
            e.printStackTrace();
            return "Mail Sending Failed: " + e.getMessage();
        }
    }
}