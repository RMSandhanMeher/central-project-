package com.infinite.jsf.recipient.model;

import java.io.Serializable;
import java.util.Date;


public class RecipientOtp implements Serializable{
	    private int otpId;
	    private String userName;
	    private Integer otpCode;
	    private OtpStatus status;
	    private Date createdAt;
	    private Date expiresAt;
	    private String email;
	    private Purpose purpose;
		public int getOtpId() {
			return otpId;
		}
		public void setOtpId(int otpId) {
			this.otpId = otpId;
		}
		public String getUserName() {
			return userName;
		}
		public void setUserName(String userName) {
			this.userName = userName;
		}
		public Integer getOtpCode() {
			return otpCode;
		}
		public void setOtpCode(Integer otpCode) {
			this.otpCode = otpCode;
		}
		public OtpStatus getStatus() {
			return status;
		}
		public void setStatus(OtpStatus status) {
			this.status = status;
		}
		public Date getCreatedAt() {
			return createdAt;
		}
		public void setCreatedAt(Date createdAt) {
			this.createdAt = createdAt;
		}
		public Date getExpiresAt() {
			return expiresAt;
		}
		public void setExpiresAt(Date expiresAt) {
			this.expiresAt = expiresAt;
		}
		public String getEmail() {
			return email;
		}
		public void setEmail(String email) {
			this.email = email;
		}
		public Purpose getPurpose() {
			return purpose;
		}
		public void setPurpose(Purpose purpose) {
			this.purpose = purpose;
		}
		public RecipientOtp(int otpId, String userName, Integer otpCode, OtpStatus status, Date createdAt,
				Date expiresAt, String email, Purpose purpose) {
			super();
			this.otpId = otpId;
			this.userName = userName;
			this.otpCode = otpCode;
			this.status = status;
			this.createdAt = createdAt;
			this.expiresAt = expiresAt;
			this.email = email;
			this.purpose = purpose;
		}
		public RecipientOtp() {
			super();
		}
		@Override
		public String toString() {
			return "RecipientOtp [otpId=" + otpId + ", userName=" + userName + ", otpCode=" + otpCode + ", status="
					+ status + ", createdAt=" + createdAt + ", expiresAt=" + expiresAt + ", email=" + email
					+ ", purpose=" + purpose + ", getOtpId()=" + getOtpId() + ", getUserName()=" + getUserName()
					+ ", getOtpCode()=" + getOtpCode() + ", getStatus()=" + getStatus() + ", getCreatedAt()="
					+ getCreatedAt() + ", getExpiresAt()=" + getExpiresAt() + ", getEmail()=" + getEmail()
					+ ", getPurpose()=" + getPurpose() + ", getClass()=" + getClass() + ", hashCode()=" + hashCode()
					+ ", toString()=" + super.toString() + "]";
		}
	    
	    
	    
	

}