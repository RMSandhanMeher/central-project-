package com.infinite.jsf.recipient.dao;

import java.util.List;
import com.infinite.jsf.provider.model.Doctors;

public interface SearchDoctorDao {

    // Search by a specific field (e.g., name, city, specialization)
    List<Doctors> searchDoctors(String searchBy, String value);

    // For 'Doctor Name starts with'
    List<Doctors> findDoctorsByNameStartsWith(String keyword);

    // For 'Doctor Name contains'
    List<Doctors> findDoctorsByNameContains(String keyword);

    // For 'Address starts with'
    List<Doctors> findDoctorsByAddressStartsWith(String keyword);

    // For 'Address contains'
    List<Doctors> findDoctorsByAddressContains(String keyword);

    // Fetch list of all unique specializations for dropdown
    List<String> fetchAllSpecialization();
}