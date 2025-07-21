package com.infinite.jsf.recipient.daoImpl;

import java.sql.SQLException;
import java.util.Calendar;
import java.util.Date;
import java.util.Random;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.infinite.jsf.recipient.dao.LoginDao;
import com.infinite.jsf.recipient.model.OtpStatus;
import com.infinite.jsf.recipient.model.Purpose;
import com.infinite.jsf.recipient.model.Recipient;
import com.infinite.jsf.recipient.model.RecipientOtp;
import com.infinite.jsf.recipient.model.RecipientStatus;
import com.infinite.jsf.util.RecipientIdGenerator;
import com.infinite.jsf.util.SessionHelper;
import com.infinite.jsf.util.SignUpMailSend;

public class LoginDaoImpl implements LoginDao {
	Session session;

	// session means connection between java application and database

	// Creates a ransom 5 digit otp between 10000 to 29999
	public int generateOtp() {
		Random r = new Random(System.currentTimeMillis()); // Random number generated with time
		return ((1 + r.nextInt(2)) * 10000 + r.nextInt(10000));// Random number between 10000 to 29999
	}

	// add member and send otp
	@Override
	public String addRecipient(Recipient recipient) throws ClassNotFoundException, SQLException {
		// TODO Auto-generated method stub

		session = SessionHelper.getSessionFactory().openSession(); // open Hibernate session (connection)

		// Transient State: recipient is not yet saved or associated with session
		String hId = RecipientIdGenerator.getNextRecipientId(session);
		recipient.sethId(hId);
		recipient.setCreatedAt(new java.util.Date(System.currentTimeMillis()));

		// Begin transaction and persist recipient
		Transaction trans = session.beginTransaction(); // transaction- when one or two operations is done in one single
														// unit of work on database
		// starts a transaction with begin transaction
		recipient.setStatus(RecipientStatus.ACTIVE);
		session.save(recipient); // save reciptent object // Persistent State: recipient is now associated with
									// session
		trans.commit(); // Commit to db //// Changes are flushed to DB; recipient is now stored

		RecipientOtp otp = new RecipientOtp(); // generate otp object
		int code = generateOtp(); // generate OTp
		otp.setOtpCode(code);
		otp.setStatus(OtpStatus.PENDING);
		otp.setPurpose(Purpose.REGISTER); // Ensure DB column is VARCHAR with enough length (e.g., VARCHAR(20))
		otp.setUserName(recipient.getUserName()); // Set Otp username link to reciptent
		otp.setEmail(recipient.getEmail());// set Otp email link to recipient

		// Set expiresAt to 10 minutes from now
		java.util.Calendar calendar = java.util.Calendar.getInstance();
		calendar.add(java.util.Calendar.MINUTE, 10); // 10-minute expiration
		otp.setCreatedAt(new java.util.Date(System.currentTimeMillis()));
		otp.setExpiresAt(calendar.getTime());

		trans = session.beginTransaction(); // another transaction begin
		session.save(otp);
		trans.commit();

		String subject = "Hii " + recipient.getUserName()
				+ ", Congratulations!! you are now the member of our Hospital Mangement System";
		String body = "Your Otp code is " + code + ". Please Use it for password Generation";
		SignUpMailSend.sendInfo(recipient.getEmail(), subject, body); // Send Otp email

		return "Recipient Record added and Send Otp by email";
	}

	// to generate aplhanumeric
	public String getAlphaNumericString() {
		String AlphaNumericString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" + "0123456789" + "abcdefghijklmnopqrstuvwxyz";

		// Create a String Builder with a capacity of 10 characters
		StringBuilder sb = new StringBuilder(10);

		// loop 10 times to create a random password
		for (int i = 0; i < 10; i++) {
			// Generate a random index and append it to StringBuilder
			int index = (int) (AlphaNumericString.length() * Math.random());
			// get the character at the random index and append it to StringBuilder
			sb.append(AlphaNumericString.charAt(index));
		}
		// convert the StringBuilder to String and print the Final Result
		return sb.toString();
	}

	@Override
	public RecipientOtp generatePassword(String email, int otpCode) throws ClassNotFoundException, SQLException {
		Session session = null;
		Transaction tx = null;
		RecipientOtp otp = null;

		try {
			session = SessionHelper.getSessionFactory().openSession();
			tx = session.beginTransaction();

			Query query = session.createQuery("FROM RecipientOtp WHERE email = :email AND otpCode = :otpCode");
			query.setParameter("email", email);
			query.setParameter("otpCode", otpCode);

			otp = (RecipientOtp) query.uniqueResult();

			if (otp == null) {
				return null; // OTP not found
			}

			if (otp.getExpiresAt().before(new java.util.Date())) {
				otp.setStatus(OtpStatus.EXPIRED);
				session.update(otp);
				tx.commit();
				return otp; // still return object with EXPIRED status
			}

			if (otp.getStatus() == OtpStatus.PENDING) {
				otp.setStatus(OtpStatus.VERIFIED); // mark verified
				session.update(otp);
			}

			tx.commit();
		} catch (Exception e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			if (session != null)
				session.close();
		}

		return otp;
	}

	@Override
	public String createPassword(String userName, String newPassword) throws ClassNotFoundException, SQLException {
		// TODO Auto-generated method stub

		Session session = SessionHelper.getSessionFactory().openSession();
		Transaction tx = session.beginTransaction();

		int updated = session.createQuery("UPDATE Recipient SET password = :password WHERE userName = :userName")
				.setParameter("password", newPassword).setParameter("userName", userName).executeUpdate();

		tx.commit();

		if (updated == 0) {
			return "Recipient with this username not found";
		}

		return "Recipient Updated Successfully";
	}

	@Override
	public boolean login(String userName, String password) throws ClassNotFoundException, SQLException {
		// TODO Auto-generated method stub

		session = SessionHelper.getSessionFactory().openSession();

		Query query = session
				.createQuery("FROM Recipient WHERE userName = :userName AND password = :password AND status = :status");
		query.setParameter("userName", userName);
		query.setParameter("password", password);
		query.setParameter("status", RecipientStatus.ACTIVE);

		Recipient recipient = (Recipient) query.uniqueResult();

		return recipient != null;
	}

	@Override
	public boolean existsbyUserName(String username) {
		// TODO Auto-generated method stub

		session = SessionHelper.getSessionFactory().openSession();
		Query query = session.createQuery("SELECT COUNT(*) FROM Recipient WHERE userName=:userName");
		query.setParameter("userName", username);
		Long count = (Long) query.uniqueResult();
		session.close();
		return count != null && count > 0;
	}

	@Override
	public boolean existsByEmail(String email) {
		// TODO Auto-generated method stub

		session = SessionHelper.getSessionFactory().openSession();
		Query query = session.createQuery("SELECT COUNT(*) FROM Recipient WHERE email=:email");
		query.setParameter("email", email);
		Long count = (Long) query.uniqueResult();
		session.close();

		return count != null && count > 0;
	}

	@Override
	public boolean existsByMobile(String mobile) {
		// TODO Auto-generated method stub

		session = SessionHelper.getSessionFactory().openSession();
		Query query = session.createQuery("SELECT COUNT(*) FROM Recipient WHERE mobile=:mobile");
		query.setParameter("mobile", mobile);
		Long count = (Long) query.uniqueResult();
		session.close();

		return count != null && count > 0;

	}

	@Override
	public String resendOtp(String email) throws ClassNotFoundException, SQLException {
		Session session = null;
		Transaction tx = null;

		try {
			session = SessionHelper.getSessionFactory().openSession();

			// Step 1: Check if recipient exists
			Query userQuery = session.createQuery("FROM Recipient WHERE email = :email");
			userQuery.setParameter("email", email);
			Recipient recipient = (Recipient) userQuery.uniqueResult();

			if (recipient == null) {
				return "Email not found.";
			}

			tx = session.beginTransaction();

			// Step 2: Expire all previous PENDING OTPs
			Query expireQuery = session.createQuery(
					"UPDATE RecipientOtp SET status = :expired WHERE email = :email AND status = :pending");
			expireQuery.setParameter("expired", OtpStatus.EXPIRED);
			expireQuery.setParameter("email", email);
			expireQuery.setParameter("pending", OtpStatus.PENDING);
			expireQuery.executeUpdate();

			// Step 3: Generate new OTP
			int newOtp = generateOtp(); // Generates a 5-digit OTP

			// Step 4: Create new OTP object
			RecipientOtp otp = new RecipientOtp();
			otp.setUserName(recipient.getUserName());
			otp.setEmail(email);
			otp.setOtpCode(newOtp);
			otp.setStatus(OtpStatus.PENDING);
			otp.setPurpose(Purpose.REGISTER);
			otp.setCreatedAt(new Date());

			// Set expiry time to 10 minutes
			Calendar calendar = Calendar.getInstance();
			calendar.add(Calendar.MINUTE, 10);
			otp.setExpiresAt(calendar.getTime());

			session.save(otp);
			tx.commit();

			// Step 5: Send email
			String subject = "OTP for Password Reset";
			String body = "Dear " + recipient.getFirstName() + ",\n\n" + "Your new OTP is: " + newOtp + "\n"
					+ "It is valid for 10 minutes.\n\n" + "Thanks,\nHealthSure Team";

			SignUpMailSend.sendInfo(email, subject, body);

			return "OTP resent successfully to your registered email.";

		} catch (Exception e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
			return "Failed to resend OTP.";
		} finally {
			if (session != null)
				session.close();
		}
	}
	
	
	@Override
	public Recipient getRecipientByUserName(String userName) {
	    Session session = SessionHelper.getSessionFactory().openSession();
	    try {
	        return (Recipient) session.createQuery("FROM Recipient WHERE userName = :userName")
	                                  .setParameter("userName", userName)
	                                  .uniqueResult();
	    } finally {
	        session.close();
	    }
	}

	public void updateEmailByUserName(String userName, String newEmail) {
		
	    session = SessionHelper.getSessionFactory().openSession();
	    Transaction tx = session.beginTransaction();

	        Query query = session.createQuery("UPDATE Recipient SET email = :email WHERE userName = :userName");
	        query.setParameter("email", newEmail);
	        query.setParameter("userName", userName);
	        int result = query.executeUpdate();

	        tx.commit();

	        System.out.println("Email updated for user: " + userName + ", rows affected: " + result);
	    } 


}