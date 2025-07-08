package com.infinite.jsf.pharmacy.model;

import java.util.Date;

import com.infinite.jsf.provider.model.Doctors;
import com.infinite.jsf.provider.model.Prescription;
import com.infinite.jsf.recipient.model.Recipient;

public class DispensedEquipment {
    private String dispensedEquipId;
    private Equipment equipment;
    private Integer quantityDispensed;
    private Date dispenseDate;
    private Prescription prescription;
    private Doctors doctor;
    private Recipient recipient;
    private Pharmacist pharmacist;
    private Pharmacy pharmacy;
	public String getDispensedEquipId() {
		return dispensedEquipId;
	}
	public void setDispensedEquipId(String dispensedEquipId) {
		this.dispensedEquipId = dispensedEquipId;
	}
	public Equipment getEquipment() {
		return equipment;
	}
	public void setEquipment(Equipment equipment) {
		this.equipment = equipment;
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
	public DispensedEquipment() {
		super();
		// TODO Auto-generated constructor stub
	}
    
    // Constructors, getters and setters
}
