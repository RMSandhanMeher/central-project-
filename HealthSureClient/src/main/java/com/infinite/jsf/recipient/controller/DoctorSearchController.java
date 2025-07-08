package com.infinite.jsf.recipient.controller;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.regex.Pattern;
import java.util.logging.Logger;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.faces.model.SelectItem; // Import SelectItem

import com.infinite.jsf.provider.model.Doctors;
import com.infinite.jsf.recipient.dao.SearchDoctorDao;
import com.infinite.jsf.recipient.daoImpl.SearchDoctorDaoImpl;

public class DoctorSearchController {

	private static final Logger LOGGER = Logger.getLogger(DoctorSearchController.class.getName());

	private String searchBy = "doctorName"; // Default search type (match value for dropdown)
	private String searchValue; // Used for Doctor Name and Address
	private String selectedSpecialization; // New: Used for Specialization search

	private List<SelectItem> searchOptions; // For "Search By" dropdown
	private List<SelectItem> specializationOptions; // For "Specialization" dropdown

	private List<Doctors> searchResults = new ArrayList<>();
	private int currentPage = 0;
	private int pageSize = 4;

	private String sortField = "doctorName"; // default sort field
	private boolean ascending = true;

	// Flag to indicate if a search has been performed
	private boolean searchPerformed = false; // New property

	private SearchDoctorDao doctorDAO = new SearchDoctorDaoImpl();

	public DoctorSearchController() {
		// Initialize search options
		searchOptions = new ArrayList<>();
		searchOptions.add(new SelectItem("doctorName", "Doctor Name"));
		searchOptions.add(new SelectItem("specialization", "Specialization"));
		searchOptions.add(new SelectItem("address", "Address"));

		// Initialize specialization options
		specializationOptions = new ArrayList<>();
		specializationOptions.add(new SelectItem("", "• Select Specialization •")); // Placeholder
		specializationOptions.add(new SelectItem("Gynecology", "Gynecology"));
		specializationOptions.add(new SelectItem("Orthopedics", "Orthopedics"));
		specializationOptions.add(new SelectItem("Pediatrics", "Pediatrics"));
		specializationOptions.add(new SelectItem("Cardiology", "Cardiology"));
		specializationOptions.add(new SelectItem("Neurology", "Neurology"));
		specializationOptions.add(new SelectItem("Psychiatry", "Psychiatry"));
		specializationOptions.add(new SelectItem("Oncology", "Oncology"));
		specializationOptions.add(new SelectItem("Dermatology", "Dermatology"));
		specializationOptions.add(new SelectItem("General Surgery", "General Surgery"));
		specializationOptions.add(new SelectItem("ENT", "ENT"));
		specializationOptions.add(new SelectItem("Urology", "Urology"));
	}

	// This method is no longer directly called by AJAX,
	// but the logic here conceptually applies to how the UI
	// will manage input visibility. We'll rely on client-side JS.
	public void searchByChanged() {
		LOGGER.info("searchBy changed to: " + this.searchBy + " (Client-side logic expected to handle UI).");
		// We'll trust the client-side JS to show/hide and clear relevant inputs.
		// For server-side, it's about which value to *use* in executeSearch.
		// This method becomes less critical for behavior, but useful for logging if
		// somehow called.
	}

	// Executes search and resets pagination
	public void executeSearch() {
		FacesContext context = FacesContext.getCurrentInstance();
		searchPerformed = true; // Set flag to true when a search is attempted

		String currentSearchValue = null;

		if ("specialization".equals(searchBy)) {
			currentSearchValue = selectedSpecialization;
		} else {
			currentSearchValue = searchValue;
		}

		LOGGER.info("Starting search for: " + searchBy + " = '" + currentSearchValue + "'");

		if (currentSearchValue == null || currentSearchValue.trim().isEmpty()) {
			LOGGER.warning("Search input invalid: missing field or value.");
			context.addMessage(null,
					new FacesMessage(FacesMessage.SEVERITY_ERROR, "Please provide search criteria.", null));
			searchResults = new ArrayList<>(); // Clear previous results
			return;
		}

		currentSearchValue = currentSearchValue.trim().replaceAll("\\s{2,}", " "); // normalize multiple spaces

		// Apply specific validation/normalization based on searchBy
		if ("doctorName".equals(searchBy)) {
			if (!Pattern.matches("^[a-zA-Z. ]+$", currentSearchValue)) {
				LOGGER.warning("Validation failed for doctor name: " + currentSearchValue);
				context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_ERROR,
						"Doctor Name can only contain letters, spaces, and '.' (dot).", null));
				searchResults = new ArrayList<>();
				return;
			}
		} else if ("specialization".equals(searchBy)) {
			// No specific regex needed if using selectOneMenu, but trim and normalize for
			// DAO
			currentSearchValue = currentSearchValue.trim();
			if ("-- Select Specialization --".equals(currentSearchValue) || "".equals(currentSearchValue)) { // Check for placeholder
																												
				LOGGER.warning("Validation failed for specialization: Placeholder selected.");
				context.addMessage(null,
						new FacesMessage(FacesMessage.SEVERITY_ERROR, "Please select a valid specialization.", null));
				searchResults = new ArrayList<>();
				return;
			}
		} else if ("address".equals(searchBy)) {
			currentSearchValue = currentSearchValue.trim().replaceAll("\\s{2,}", " ");
		}

		// Pass the correct search type and value to DAO
		searchResults = doctorDAO.searchDoctors(searchBy, currentSearchValue);
		LOGGER.info("Doctor search result size: " + (searchResults != null ? searchResults.size() : 0));

		if (searchResults == null || searchResults.isEmpty()) {
			LOGGER.warning("No doctors found for: " + searchBy + " = '" + currentSearchValue + "'");
			context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_WARN,
					"No doctors found for the given search criteria.", null));
			searchResults = new ArrayList<>(); // Ensure searchResults is empty if no doctors found
		}

		sortResults();
		currentPage = 0;
		LOGGER.info("Search complete and results sorted successfully.");
	}

	public List<Doctors> getPaginatedDoctors() {
		if (searchResults == null || searchResults.isEmpty()) {
			return new ArrayList<>(); // Return empty list if no results
		}
		int fromIndex = currentPage * pageSize;
		int toIndex = Math.min(fromIndex + pageSize, searchResults.size());

		if (fromIndex > toIndex) {
			currentPage = 0; // Reset currentPage if somehow out of bounds
			fromIndex = 0;
			toIndex = Math.min(pageSize, searchResults.size());
		}
		if (fromIndex >= searchResults.size()) { // Handle case where results might become empty after pagination
			return new ArrayList<>();
		}

		return searchResults.subList(fromIndex, toIndex);
	}

	public void nextPage() {
		if (searchResults != null && (currentPage + 1) * pageSize < searchResults.size()) {
			currentPage++;
			LOGGER.info("Navigated to next page: " + (currentPage + 1));
		}
	}

	public void prevPage() {
		if (currentPage > 0) {
			currentPage--;
			LOGGER.info("Navigated to previous page: " + (currentPage + 1));
		}
	}

//	public void sortBy(String field) {
//		if (sortField.equals(field)) {
//			ascending = !ascending;
//		} else {
//			sortField = field;
//			ascending = true;
//		}
//		sortResults();
//		currentPage = 0;
//		LOGGER.info("Sorted by field: " + field + ", ascending: " + ascending);
//	}

	// Arrow Up button
	public void sortByAsc(String field) {
		this.sortField = field;
		this.ascending = true;
		sortResults();
		currentPage = 0;
		LOGGER.info("Forced sort ascending by field: " + field);
	}

	// Arrow down button
	public void sortByDesc(String field) {
		this.sortField = field;
		this.ascending = false;
		sortResults();
		currentPage = 0;
		LOGGER.info("Forced sort descending by field: " + field);
	}

	private void sortResults() {
		if (searchResults == null || searchResults.isEmpty()) {
			return; // No need to sort if no results
		}
		
		//Case Sorting logic
		Comparator<Doctors> comparator;
		switch (sortField) {
		case "specialization":
			comparator = Comparator.comparing(Doctors::getSpecialization,
					Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER));
			break;
		case "address":
			comparator = Comparator.comparing(Doctors::getAddress, Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER));
			break;
		case "email":
			comparator = Comparator.comparing(Doctors::getEmail, Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER));
			break;
		case "status":
			comparator = Comparator.comparing(d -> d.getStatus() != null ? d.getStatus().toString() : "",
					String.CASE_INSENSITIVE_ORDER);
			break;
		case "type":
			comparator = Comparator.comparing(d -> d.getType() != null ? d.getType().toString() : "",
					String.CASE_INSENSITIVE_ORDER);
			break;
		case "doctorName":
		default:
			comparator = Comparator.comparing(Doctors::getDoctorName,
					Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER));
		}

		if (!ascending) {
			comparator = comparator.reversed();
		}

		searchResults.sort(comparator);
	}

	public String bookDummy() {
		LOGGER.info("Book Appointment clicked.");
		// This method might navigate to a booking page or open a dialog
		return null; // Stay on the same page for now will be implemented in future
	}

	public String resetSearch() {
	    this.searchBy = ""; 
	    this.searchValue = null; 
	    this.selectedSpecialization = ""; 
	    this.searchResults = new ArrayList<>(); 
	    this.currentPage = 0;
	    this.sortField = ""; 
	    this.ascending = true; 
	    FacesContext context = FacesContext.getCurrentInstance();
	    if (context.getMessages().hasNext()) { // Check if there are global messages
	        while (context.getMessages().hasNext()) {
	            context.getMessages().next(); // Just consume them, they will not be re-rendered
	        }
	    }

	    LOGGER.info("Search form reset.");
	    return null; // Stay on the same page. A redirect is another option for full state reset: "pretty:searchDoctors"
	}
	
	
	
	

	
	

	// === Getters & Setters ===
	public String getSearchBy() {
		return searchBy;
	}

	public void setSearchBy(String searchBy) {
		this.searchBy = searchBy;
	}

	public String getSearchValue() {
		return searchValue;
	}

	public void setSearchValue(String searchValue) {
		this.searchValue = searchValue;
	}

	// Getter/Setter for selectedSpecialization
	public String getSelectedSpecialization() {
		return selectedSpecialization;
	}

	public void setSelectedSpecialization(String selectedSpecialization) {
		this.selectedSpecialization = selectedSpecialization;
	}

	// Getters for SelectItem lists
	public List<SelectItem> getSearchOptions() {
		return searchOptions;
	}

	public List<SelectItem> getSpecializationOptions() {
		return specializationOptions;
	}

	public List<Doctors> getSearchResults() {
		return searchResults;
	}

	public void setSearchResults(List<Doctors> searchResults) {
		this.searchResults = searchResults;
	}

	public int getCurrentPage() {
		return currentPage + 1;
	}

	public boolean isHasNextPage() {
		return searchResults != null && (currentPage + 1) * pageSize < searchResults.size();
	}

	public boolean isHasPrevPage() {
		return currentPage > 0;
	}

	public int getTotalPages() {
		if (searchResults == null || searchResults.isEmpty()) {
			return 0;
		}
		return (searchResults.size() + pageSize - 1) / pageSize;
	}

	public String getSortField() {
		return sortField;
	}

	public boolean isAscending() {
		return ascending;
	}

	// New Getter for searchPerformed flag
	public boolean isSearchPerformed() {
		return searchPerformed;
	}
}