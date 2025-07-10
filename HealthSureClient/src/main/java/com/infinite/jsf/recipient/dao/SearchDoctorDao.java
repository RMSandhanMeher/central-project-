package com.infinite.jsf.recipient.dao;
import java.util.List;

import com.infinite.jsf.provider.model.Doctors;

public interface SearchDoctorDao {
	
	List<Doctors> searchDoctors(String searchBy, String value);
	
	List<String> fetchAllSpecialization();
	
}
