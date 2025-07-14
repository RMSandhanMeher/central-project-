package com.infinite.jsf.recipient.dao;

import java.sql.SQLException;

import com.infinite.jsf.recipient.model.Recipient;
import com.infinite.jsf.recipient.model.RecipientOtp;

public interface LoginDao {
	
	public String addRecipient(Recipient recipient)throws ClassNotFoundException, SQLException;
	public RecipientOtp generatePassword(String email, int otpCode)throws ClassNotFoundException, SQLException;
	public String createPassword(String email, String pwd)throws ClassNotFoundException, SQLException;
	public boolean login(String userName, String password) throws ClassNotFoundException, SQLException;
	public boolean existsbyUserName(String username);
	public boolean existsByEmail(String email);
	public boolean existsByMobile(String mobile);
    public String resendOtp(String email) throws ClassNotFoundException, SQLException ;
	Recipient getRecipientByUserName(String userName);


}
