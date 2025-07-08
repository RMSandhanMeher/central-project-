package com.infinite.jsf.pharmacy.model;

import java.util.Date;

import com.infinite.jsf.provider.model.Doctors;
import com.infinite.jsf.provider.model.Prescription;
import com.infinite.jsf.recipient.model.Recipient;

public class DispensedMedicine {
    private String dispenseId;
    private Medicine medicine;
    private Integer quantityDispensed;
    private Date dispenseDate;
    private Prescription prescription;
    private Doctors doctor;
    private Recipient recipient;
    private Pharmacist pharmacist;
    private Pharmacy pharmacy;
	public String getDispenseId() {
		return dispenseId;
	}
	public void setDispenseId(String dispenseId) {
		this.dispenseId = dispenseId;
	}
	public Medicine getMedicine() {
		return medicine;
	}
	public void setMedicine(Medicine medicine) {
		this.medicine = medicine;
	}
	public Integer getQuantityDispensed() {
		return quantityDispensed;
	}
	public void setQuantityDispensed(Integer quantityDispensed) {
		this.quantityDispensed = quantityDispensed;
	}
	public Date getDispenseDate() {
		return dispenseDate;
	}
	public void setDispenseDate(Date dispenseDate) {
		this.dispenseDate = dispenseDate;
	}
	public Prescription getPrescription() {
		return prescription;
	}
	public void setPrescription(Prescription prescription) {
		this.prescription = prescription;
	}
	public Doctors getDoctor() {
		return doctor;
	}
	public void setDoctor(Doctors doctor) {
		this.doctor = doctor;
	}
	public Recipient getRecipient() {
		return recipient;
	}
	public void setRecipient(Recipient recipient) {
		this.recipient = recipient;
	}
	public Pharmacist getPharmacist() {
		return pharmacist;
	}
	public void setPharmacist(Pharmacist pharmacist) {
		this.pharmacist = pharmacist;
	}
	public Pharmacy getPharmacy() {
		return pharmacy;
	}
	public void setPharmacy(Pharmacy pharmacy) {
		this.pharmacy = pharmacy;
	}
	public DispensedMedicine() {
		super();
		// TODO Auto-generated constructor stub
	}
    
    // Constructors, getters and setters
}
