package com.infinite.jsf.recipient.controller;

import java.io.Serializable;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.ZoneId;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;

import com.infinite.jsf.recipient.dao.LoginDao;
import com.infinite.jsf.recipient.daoImpl.LoginDaoImpl;
import com.infinite.jsf.recipient.model.OtpStatus;
import com.infinite.jsf.recipient.model.Recipient;
import com.infinite.jsf.recipient.model.RecipientOtp;

public class LoginController implements Serializable{

	private Recipient recipient;
	private String userName;
	private Integer otpCode;
	private String password;
	private String newPassword;
	private String reEnterPassword;
	private String confirmPassword;
	private LoginDao loginDao = new LoginDaoImpl();
	private String email;
	private RecipientOtp recipientotp;
	private OtpStatus otpstatus;
	private String fullName;

	public RecipientOtp getRecipientotp() {
		return recipientotp;
	}

	public void setRecipientotp(RecipientOtp recipientotp) {
		this.recipientotp = recipientotp;
	}

	public OtpStatus getOtpstatus() {
		return otpstatus;
	}

	public void setOtpstatus(OtpStatus otpstatus) {
		this.otpstatus = otpstatus;
	}

	public Recipient getRecipient() {
		 if (recipient == null) {
		        FacesContext context = FacesContext.getCurrentInstance();
		        recipient = (Recipient) context.getExternalContext().getSessionMap().get("recipient");

		        if (recipient == null) {
		            recipient = new Recipient(); // final fallback
		        }
		    }
		    return recipient;
	}

	public void setRecipient(Recipient recipient) {
		this.recipient = recipient;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}
	

	public String getFullName() {
		return fullName;
	}

	public void setFullName(String fullName) {
		this.fullName = fullName;
	}

	public Integer getOtpCode() {
		return otpCode;
	}

	public void setOtpCode(Integer otpCode) {
		this.otpCode = otpCode;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getNewPassword() {
		return newPassword;
	}

	public void setNewPassword(String newPassword) {
		this.newPassword = newPassword;
	}

	public String getReEnterPassword() {
		return reEnterPassword;
	}

	public void setReEnterPassword(String reEnterPassword) {
		this.reEnterPassword = reEnterPassword;
	}

	public String getConfirmPassword() {
		return confirmPassword;
	}

	public void setConfirmPassword(String confirmPassword) {
		this.confirmPassword = confirmPassword;
	}

	public LoginDao getLoginDao() {
		return loginDao;
	}

	public void setLoginDao(LoginDao loginDao) {
		this.loginDao = loginDao;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getEmail() {

		if ((email == null || email.trim().isEmpty()) && FacesContext.getCurrentInstance() != null) {
			Object sessionEmail = FacesContext.getCurrentInstance().getExternalContext().getSessionMap()
					.get("registeredEmail");
			if (sessionEmail != null) {
				email = sessionEmail.toString();

			}
		}
		return email; // here in email retrieve registered Email through sessionmap

	}

	public String addRecipient() throws ClassNotFoundException, SQLException {

		FacesContext context = FacesContext.getCurrentInstance();
		boolean hasError = false;

		// validation of first name

		// First Name
		if (recipient.getFirstName() == null || recipient.getFirstName().trim().isEmpty()) {
			context.addMessage("form:firstName",
					new FacesMessage(FacesMessage.SEVERITY_ERROR, "First name is required", null));
			hasError = true;
		} else if (!recipient.getFirstName().matches("^[A-Z][a-zA-Z]*$")) {
			context.addMessage("form:firstName", new FacesMessage(FacesMessage.SEVERITY_ERROR,
					"First name must start with a capital letter and contain only alphabets", null));
			hasError = true;
		}

		// Last Name
		if (recipient.getLastName() == null || recipient.getLastName().trim().isEmpty()) {
			context.addMessage("form:lastName",
					new FacesMessage(FacesMessage.SEVERITY_ERROR, "Last name is required", null));
			hasError = true;
		} else if (!recipient.getLastName().matches("^[A-Z][a-zA-Z]*$")) {
			context.addMessage("form:lastName", new FacesMessage(FacesMessage.SEVERITY_ERROR,
					"Last name must start with a capital letter and contain only alphabets", null));
			hasError = true;
		}

		// Username
		if (recipient.getUserName() == null || recipient.getUserName().trim().isEmpty()) {
			context.addMessage("form:userName",
					new FacesMessage(FacesMessage.SEVERITY_ERROR, "Username is required", null));
			hasError = true;
		} else if (!recipient.getUserName().matches("^[a-zA-Z0-9_]{5,20}$")) {
			context.addMessage("form:userName", new FacesMessage(FacesMessage.SEVERITY_ERROR,
					"Username must be 5–20 characters (letters, digits, underscores)", null));
			hasError = true;
		} else if (loginDao.existsbyUserName(recipient.getUserName())) {
			context.addMessage("form:userName",
					new FacesMessage(FacesMessage.SEVERITY_ERROR, "Username already exists", null));
			hasError = true;
		}

		// Email
		String email = recipient.getEmail();
		if (email == null || email.trim().isEmpty()) {
			context.addMessage("form:email", new FacesMessage(FacesMessage.SEVERITY_ERROR, "Email is required", null));
			hasError = true;
		} else if (!email.contains("@")) {
			context.addMessage("form:email",
					new FacesMessage(FacesMessage.SEVERITY_ERROR, "Email must contain '@' symbol", null));
			hasError = true;
		} else if (!email.matches("^[a-zA-Z0-9._%+-]+@(gmail)\\.com$")) {
			context.addMessage("form:email",
					new FacesMessage(FacesMessage.SEVERITY_ERROR, "Only Gmail emails allowed", null));
			hasError = true;
		} else if (loginDao.existsByEmail(email)) {
			context.addMessage("form:email",
					new FacesMessage(FacesMessage.SEVERITY_ERROR, "Email already registered", null));
			hasError = true;
		}

		// mobile

		if (recipient.getMobile() == null || recipient.getMobile().trim().isEmpty()) {
			context.addMessage("form:mobile",
					new FacesMessage(FacesMessage.SEVERITY_ERROR, "Mobile Number is required", null));
			hasError = true;
		} else {
			// 1. Must contain only digits
			if (!recipient.getMobile().trim().matches("^\\d+$")) {
				context.addMessage("form:mobile", new FacesMessage(FacesMessage.SEVERITY_ERROR,
						"Mobile number must contain only digits (no letters or symbols)", null));
				hasError = true;
			}

			// 2. Must be at least 10 digits
			else if (recipient.getMobile().trim().length() < 10) {
				context.addMessage("form:mobile", new FacesMessage(FacesMessage.SEVERITY_ERROR,
						"Mobile number must be at least 10 digits", null));
				hasError = true;
			}

			// 3. Must not exceed 10 digits
			else if (recipient.getMobile().trim().length() > 10) {
				context.addMessage("form:mobile",
						new FacesMessage(FacesMessage.SEVERITY_ERROR, "Mobile number must not exceed 10 digits", null));
				hasError = true;
			}

			// 4. Must not start with 0
			else if (recipient.getMobile().trim().startsWith("0")) {
				context.addMessage("form:mobile",
						new FacesMessage(FacesMessage.SEVERITY_ERROR, "Mobile number cannot start with 0", null));
				hasError = true;
			}

			// 5. Must be unique
			else if (loginDao.existsByMobile(recipient.getMobile().trim())) {
				context.addMessage("form:mobile",
						new FacesMessage(FacesMessage.SEVERITY_ERROR, "Mobile number already in use", null));
				hasError = true;
			}
		}

		// Gender
		if (recipient.getGender() == null) {
			context.addMessage("form:gender",
					new FacesMessage(FacesMessage.SEVERITY_ERROR, "Gender is required", null));
			hasError = true;
		}

		// DOB
		if (recipient.getDob() == null) {
			context.addMessage("form:dob",
					new FacesMessage(FacesMessage.SEVERITY_ERROR, "Date of birth is required", null));
			hasError = true;
		} else {
			LocalDate birthDate = recipient.getDob().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
			LocalDate today = LocalDate.now();

			if (birthDate.isAfter(today)) {
				context.addMessage("form:dob",
						new FacesMessage(FacesMessage.SEVERITY_ERROR, "Date of birth cannot be in the future", null));
				hasError = true;
			} else if (birthDate.isEqual(today)) {
				context.addMessage("form:dob",
						new FacesMessage(FacesMessage.SEVERITY_ERROR, "Date of birth cannot be today", null));
				hasError = true;
			} else if (birthDate.isBefore(LocalDate.of(1950, 1, 1))) {
				context.addMessage("form:dob",
						new FacesMessage(FacesMessage.SEVERITY_ERROR, "Date of birth must be after 1950", null));
				hasError = true;
			}
		}

		// Address
		if (recipient.getAddress() == null || recipient.getAddress().trim().isEmpty()) {
			context.addMessage("form:address",
					new FacesMessage(FacesMessage.SEVERITY_ERROR, "Address is required", null));
			hasError = true;
		} else if (recipient.getAddress().length() < 10) {
			context.addMessage("form:address",
					new FacesMessage(FacesMessage.SEVERITY_ERROR, "Address must be at least 10 characters", null));
			hasError = true;
		} else if (recipient.getAddress().matches("^[0-9]+$")) {
			context.addMessage("form:address",
					new FacesMessage(FacesMessage.SEVERITY_ERROR, "Address cannot be just numbers", null));
			hasError = true;
		}

		if (hasError) {
			return null; // Don't proceed, show all collected messages
		}

		// If all validations pass
		loginDao.addRecipient(recipient);

		context.getExternalContext().getSessionMap().put("registeredEmail", recipient.getEmail());

		// Success message
		context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO, "Registration successful!", null));

		return "GeneratePassword.jsp?faces-redirect=true";
	}

	public String generatePassword() throws ClassNotFoundException, SQLException {
		FacesContext context = FacesContext.getCurrentInstance();

		if (email == null || email.trim().isEmpty()) {
			context.addMessage("form:email", new FacesMessage(FacesMessage.SEVERITY_ERROR, "Email is required", null));
			return null;
		}

		if (!email.matches("^[a-zA-Z0-9._%+-]+@gmail\\.com$")) {
			context.addMessage("form:email",
					new FacesMessage(FacesMessage.SEVERITY_ERROR, "Only valid Gmail addresses are allowed", null));
			return null;
		}

		if (otpCode == null || !String.valueOf(otpCode).matches("^\\d{5}$")) {
			context.addMessage("form:otp",
					new FacesMessage(FacesMessage.SEVERITY_ERROR, "OTP must be a 5-digit number", null));
			return null;
		}

		// Fetch OTP and mark verified inside DAO
		recipientotp = loginDao.generatePassword(email, otpCode);

		if (recipientotp == null) {
			context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_ERROR, "Invalid Email or OTP", null));
			return null;
		}

		if (recipientotp.getStatus() == OtpStatus.EXPIRED) {
			context.addMessage(null,
					new FacesMessage(FacesMessage.SEVERITY_ERROR, "OTP has expired. Please request a new one.", null));
			return null;
		}

		if (recipientotp.getStatus() != OtpStatus.VERIFIED) {
			context.addMessage(null,
					new FacesMessage(FacesMessage.SEVERITY_ERROR, "OTP already used or invalid", null));
			return null;
		}

		context.addMessage(null,
				new FacesMessage(FacesMessage.SEVERITY_INFO, "OTP verified. Please create your password.", null));
		return "CreatePassword.jsp?faces-redirect=true";
	}

	public String createPassword() throws ClassNotFoundException, SQLException {
		if (!password.equals(confirmPassword)) {
			FacesContext.getCurrentInstance().addMessage(null,
					new FacesMessage(FacesMessage.SEVERITY_ERROR, "Passwords do not match", null));
			return null;
		}

		String result = loginDao.createPassword(userName, password);

		if ("Recipent Updated Successfully".equals(result)) {
			FacesContext.getCurrentInstance().getExternalContext().getFlash().put("message",
					"Password updated successfully.");
			return null;
		} else {
			FacesContext.getCurrentInstance().addMessage(null,
					new FacesMessage(FacesMessage.SEVERITY_ERROR, result, null));
			System.out.println("Redirecting to login...");
			return "Login.jsp?faces-redirect=true";
		}
	}

	public String login() throws ClassNotFoundException, SQLException {

		FacesContext context = FacesContext.getCurrentInstance();

		// Validate required fields
		if (userName == null || userName.trim().isEmpty()) {
			context.addMessage("userName", new FacesMessage(FacesMessage.SEVERITY_ERROR, "Username is required", null));
			return null;
		}

		if (password == null || password.trim().isEmpty()) {
			context.addMessage("password", new FacesMessage(FacesMessage.SEVERITY_ERROR, "Password is required", null));
			return null;
		}

		boolean valid = loginDao.login(userName, password);

		
		
		if (valid) {
			Recipient recipient = loginDao.getRecipientByUserName(userName);
			
			if (recipient != null) {
				recipient.setFullName(recipient.getFirstName(),recipient.getLastName());
				System.out.println(recipient.getFullName()+" "+"has logged-in....");
		        FacesContext.getCurrentInstance().getExternalContext().getSessionMap().put("loggedInRecipientId", recipient.gethId());
		        FacesContext.getCurrentInstance().getExternalContext().getSessionMap().put("fullName", recipient.getFullName());
		        FacesContext.getCurrentInstance().getExternalContext().getSessionMap().put("recipient", recipient); // optional
		    }
			return "RecipientDashBoard.jsp?faces-redirect=true";
		} else {
			context.addMessage(null,
					new FacesMessage(FacesMessage.SEVERITY_ERROR, "Invalid Username or Password", null));
			return null;
		}
	}

	public String resendOtp() throws ClassNotFoundException, SQLException {
		FacesContext context = FacesContext.getCurrentInstance();

		if (email == null || email.trim().isEmpty()) {
			context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_ERROR, "Email is required", null));
			return null;
		}

		String result = loginDao.resendOtp(email);

		if (result.toLowerCase().contains("sent")) {
			context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO, result, null));
		} else {
			context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_ERROR, result, null));
		}

		return null;
	}

}