package com.infinite.jsf.recipient.dao;

import java.util.List;

import com.infinite.jsf.recipient.model.PatientInsuranceDetails;

public interface InsuranceDao {
    
    //  Return all insurances for a recipient
    public List<PatientInsuranceDetails> showInsuranceOfRecipient(String recipientId);
    
    boolean isRecipientExist(String hId);


}