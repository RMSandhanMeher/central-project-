package com.infinite.jsf.recipient.controller;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.logging.Logger;
import java.util.regex.Pattern;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.faces.model.SelectItem;

import com.infinite.jsf.provider.model.Doctors;
import com.infinite.jsf.recipient.dao.SearchDoctorDao;
import com.infinite.jsf.recipient.daoImpl.SearchDoctorDaoImpl;


public class DoctorSearchController implements Serializable{

    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(DoctorSearchController.class.getName());

    private String searchBy = "doctorName"; //Sets the default drop-down option to DocName
    private String searchValue; //Value entered by the user to be searched
    private String selectedSpecialization; // Used when searchBy = specialization
    private String searchMode = null; // Default to not selected ("start_with" or "contains")

    private List<SelectItem> searchOptions; //Drop-down for searchBy like Doctor name, Specialization & Address
    private List<SelectItem> specializationOptions; //Dynamically load all distinct specialization from DB

    private List<Doctors> searchResults = new ArrayList<>(); //Holds all fetched result
    
    private int currentPage = 0; //sample pagination first page
    private int pageSize = 4; //shows 4 data per pag`

    private String sortField = "doctorName";
    private boolean ascending = true;

    private boolean searchPerformed = false;
    private boolean initialized = false;

    private String currentSortColumn = "doctorName";
    private String currentSortOrder = "asc";

    private SearchDoctorDao doctorDAO = new SearchDoctorDaoImpl();

    
    
    
    
    // Constructor for initialization (alternative to @PostConstruct)
    public DoctorSearchController() {
        if (!initialized) {
            getSearchOptions(); // triggers drop-down + specialization loading
        }
    }

    
    
    
    
    //Lazy-loading to avoid DB hits on every request.
    public List<SelectItem> getSearchOptions() {
        
			try {
				if (searchOptions == null) {
					searchOptions = new ArrayList<>();
					searchOptions.add(new SelectItem("doctorName", "Doctor Name"));
					searchOptions.add(new SelectItem("specialization", "Specialization"));
					searchOptions.add(new SelectItem("address", "Address"));

					loadSpecializationOptions(); //load value from DB
					initialized = true;
				}
			} catch (Exception e) {
				LOGGER.info("An exception occured while getting search options");
			}
			return searchOptions;
    }

    
    
    
    
    public void searchByChanged() {
        try {
			LOGGER.info("Search type changed to: " + this.searchBy);
			if ("doctorName".equals(searchBy) || "address".equals(searchBy)) {
			    this.searchMode = null; // Setting desired default for these types
			}
			this.searchValue = null; // Clear searchValue when changing search type
			this.selectedSpecialization = ""; // Clear selected specialization
			this.searchResults = new ArrayList<>(); // Clear results
			this.searchPerformed = false; // Reset searchPerformed
			this.currentPage = 0; // Reset pagination
		} catch (Exception e) {
			LOGGER.info("An exception occured while changing Search");
			e.printStackTrace();
		}
    }

    
    
    
    
    
    // Core method for executing the search
    public void executeSearch() {
        try {
			FacesContext context = FacesContext.getCurrentInstance();
			
			searchPerformed = true;
			String currentSearchValue;
			
			if ("specialization".equals(searchBy)) {
			    currentSearchValue = selectedSpecialization;
			} else {
			    currentSearchValue = searchValue;
			}

			
			                                     //Validations
			LOGGER.info("Searching: " + searchBy + " = " + currentSearchValue + ", Mode: " + searchMode);

			if (currentSearchValue == null || currentSearchValue.trim().isEmpty()) {
			    if ("specialization".equals(searchBy)) {
			        context.addMessage("searchForm:specializationDropdown", new FacesMessage(FacesMessage.SEVERITY_ERROR,
			                "Please select a specialization from the dropdown.", null));
			    } else {
			        context.addMessage("searchForm:searchValueInput", new FacesMessage(FacesMessage.SEVERITY_ERROR,
			                "Please provide search criteria.", null));
			    }
			    searchResults = new ArrayList<>();
			    return;
			}
			
			
			
			//Remove leading and trailing spaces also replaces the multiple spaces with a single space     
			currentSearchValue = currentSearchValue.trim().replaceAll("\\s{2,}", " ");

			// Field-wise validation
			//Only allows letters, dots (for Dr.), and spaces.
			if ("doctorName".equals(searchBy)) {
			    if (!Pattern.matches("^[a-zA-Z. ]+$", currentSearchValue)) {
			        context.addMessage("searchForm:searchValueInput", new FacesMessage(FacesMessage.SEVERITY_ERROR,
			                "Doctor Name can only contain letters, spaces, and dot e.g. (Dr.)", null));
			        searchResults = new ArrayList<>(); //return empty list
			        return;
			    }
			    
			    
			} 
			     else if ("address".equals(searchBy)) {
			    // Updated regex to allow more common address characters: #, /, -
			    // If you still have issues, check your actual address data for other special characters
			    if (!Pattern.matches("^[a-zA-Z0-9.,\\s#/\\-]+$", currentSearchValue)) {
			        context.addMessage("searchForm:searchValueInput", new FacesMessage(FacesMessage.SEVERITY_ERROR,
			                "Address can only contain letters, numbers, commas (,), spaces.", null));
			        searchResults = new ArrayList<>();
			        return;
			    }
			}

			
			// Dao calls based on seachValue or searchMode
			if ("doctorName".equals(searchBy)) {
			    if ("startsWith".equals(searchMode)) {
			        searchResults = doctorDAO.findDoctorsByNameStartsWith(currentSearchValue);
			    }
			    else { // "contains" for doctorName
			        searchResults = doctorDAO.findDoctorsByNameContains(currentSearchValue);
			    }
			    
			} 
			else if ("address".equals(searchBy)) {
			    if ("startsWith".equals(searchMode)) {
			        searchResults = doctorDAO.findDoctorsByAddressStartsWith(currentSearchValue); // CORRECTED
			    }
			    else { // "contains" for address
			        searchResults = doctorDAO.findDoctorsByAddressContains(currentSearchValue);   // CORRECTED
			    }
			} 
			else { // Specialization - uses exact match ('eq' in DAO's searchDoctors method)
			    searchResults = doctorDAO.searchDoctors(searchBy, currentSearchValue);
			}

			LOGGER.info("Results found: " + (searchResults != null ? searchResults.size() : 0));

			if (searchResults == null || searchResults.isEmpty()) {
			    context.addMessage("searchForm:searchValueInput", new FacesMessage(FacesMessage.SEVERITY_WARN,
			            "No doctors found matching your search.", null));
			    searchResults = new ArrayList<>();
			}

			sortResults(); // Apply the current sortField (e.g. doctorName, specialization)
			currentPage = 0; //Reset to first page
		} catch (Exception e) {
			LOGGER.info("An error occured while executing search");
			e.printStackTrace();
		}
    }
    

    
    
    //Helps UI to toggle between input text and drop-down
    public boolean isShowSpecialization() {
        return "specialization".equals(searchBy);
    }


    
    
    
    // Pagination Block
    public List<Doctors> getPaginatedDoctors() {
        if (searchResults == null || searchResults.isEmpty())
            return new ArrayList<>();

        int fromIndex = currentPage * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, searchResults.size());

        try {
			if (fromIndex > toIndex || fromIndex >= searchResults.size()) {
			    currentPage = 0;
			    fromIndex = 0;
			    toIndex = Math.min(pageSize, searchResults.size());
			}
		} catch (Exception e) {
			LOGGER.info("An Exception occured while fetching paginated doctor list");
			e.printStackTrace();
		}
        //Return Paginated Results:
        return searchResults.subList(fromIndex, toIndex); 
    }

    
    
    public void nextPage() {
        try {
			if ((currentPage + 1) * pageSize < searchResults.size()) 
				currentPage++;
		} catch (Exception e) {
			LOGGER.info("An exception occured while fetching next page data");
		}
    }

    public void prevPage() {
        try {
			if (currentPage > 0) 
				currentPage--;
		} catch (Exception e) {
			LOGGER.info("An exception occured while fetching previous page data");
			e.printStackTrace();
		}
    }

    
    
    
    
    
    // Sorting Block
    //For ascending button
    public void sortByAsc(String field) {
        try {
			this.sortField = field;
			this.ascending = true;

			this.currentSortColumn = field;
			this.currentSortOrder = "asc";

			sortResults();
			currentPage = 0;
		} catch (Exception e) {
			LOGGER.info("An exception while sorting by Ascending");
			e.printStackTrace();
		}
    }

    //For descending button
    public void sortByDesc(String field) {
        try {
			this.sortField = field;
			this.ascending = false;

			this.currentSortColumn = field;
			this.currentSortOrder = "desc";

			sortResults();
			currentPage = 0;
		} catch (Exception e) {
			LOGGER.info("An exception while sorting by Descending");
			e.printStackTrace();
		}
    }

    //Actual Sorting method
    private void sortResults() {
        try {
			if (searchResults == null || searchResults.isEmpty()) 
				return;

			Comparator<Doctors> comparator;

			switch (sortField) {
			    case "specialization":
			        comparator = Comparator.comparing(Doctors::getSpecialization, Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER));
			        break;
			    case "address":
			        comparator = Comparator.comparing(Doctors::getAddress, Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER));
			        break;
			    case "email":
			        comparator = Comparator.comparing(Doctors::getEmail, Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER));
			        break;
			    case "status":
			        comparator = Comparator.comparing(d -> d.getStatus() != null ? d.getStatus().toString() : "", String.CASE_INSENSITIVE_ORDER);
			        break;
			    case "type":
			        comparator = Comparator.comparing(d -> d.getType() != null ? d.getType().toString() : "", String.CASE_INSENSITIVE_ORDER);
			        break;
			    case "doctorName":
			    default:
			        comparator = Comparator.comparing(Doctors::getDoctorName, Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER));
			}

			if (!ascending) {
			    comparator = comparator.reversed();
			}

			searchResults.sort(comparator);
		} catch (Exception e) {
			LOGGER.info("An exception occured while Sorting the fields");
			e.printStackTrace();
		}
    }

    
    
    
    
    
    //Builds a user-friendly string like:
    //e.g Showing 10 of 57 Results 
    public String getPaginationDocSummary() {
        try {
			if (searchResults == null || searchResults.isEmpty()) {
			    return "";
			}
		} catch (Exception e) {
			LOGGER.info("An exception occured while retriving pagination Summary");
			e.printStackTrace();
		}
        int from = Math.min((currentPage + 1) * pageSize, searchResults.size());
        int total = searchResults.size();
//        int page = currentPage + 1;
//        int totalPages = getTotalPages();

        return "Showing " + from + " of " + total +" "+"Results";
    }

    
    
    
    
    /* Determines if a sort button (up or down arrow) should be rendered.
       The button should disappear if it represents the currently active sort. */
    public boolean renderSortButton(String column, String order) {
    	//If not sorted column then show it
        try {
			if (!this.currentSortColumn.equals(column)) {
			    return true;
			}
		} catch (Exception e) {
			LOGGER.info("An Exception occured while rendering the Sorting buttons");
			e.printStackTrace();
		}
        
        //Only show the button if the sort order is different.
        return !this.currentSortOrder.equals(order);
    }

    
    
    //Reset Button
    //Resets everything to initial clean state
    public String resetSearch() {
        try {
			this.searchBy = "doctorName";
			this.searchValue = null;
			this.selectedSpecialization = "";
			this.searchResults = new ArrayList<>();
			this.currentPage = 0;
			this.sortField = "doctorName";
			this.ascending = true;
			this.searchPerformed = false;
			this.searchMode = null;
			
			// Reset sort indicators to default, e.g., show both "doctorName" arrows
			this.currentSortColumn = "doctorName";
			this.currentSortOrder = "asc"; // Or you can set it to a neutral value if you want both arrows to show

			LOGGER.info("Search reset.");
		} catch (Exception e) {
			LOGGER.info("An exception occured while performing the reset button");
			e.printStackTrace();
		}
        return "findDoctor"; // or same page's navigation outcome
    }

    
    
    
    
    //Lazy Loaded the specializations
    public List<SelectItem> getSpecializationOptions() {
        try {
			if (specializationOptions == null || specializationOptions.isEmpty()) {
			    loadSpecializationOptions();
			}
		} catch (Exception e) {
			LOGGER.info("An exception occured while retriving the Specialization from loadSpecializationOptions() ");
			e.printStackTrace();
		}
        return specializationOptions;
    }

    //Specialization fetching method
    private void loadSpecializationOptions() {
        specializationOptions = new ArrayList<>();
        specializationOptions.add(new SelectItem("", "• Select Specialization •"));

        try {
            List<String> specializations = doctorDAO.fetchAllSpecialization();
            if (specializations != null && !specializations.isEmpty()) {
                specializations.sort(String.CASE_INSENSITIVE_ORDER);
                for (String spec : specializations) {
                    if (spec != null && !spec.trim().isEmpty()) {
                    	//value, label
                        specializationOptions.add(new SelectItem(spec, spec));
                    }
                }
            }
        } catch (Exception e) {
            LOGGER.severe("Error fetching specializations: " + e.getMessage());
            FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(
                    FacesMessage.SEVERITY_ERROR, "Error loading specializations. Please try again.", null));
        }
    }

    // Dummy method for "Book Now"
    public String bookDummy() {
        FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO, "Booking functionality is not yet implemented.", null));
        return null; // Stay on the same page
    }

    // Getters & Setters for searchMode
    public String getSearchMode() {
        return searchMode;
    }

    public void setSearchMode(String searchMode) {
        this.searchMode = searchMode;
    }

    // Existing Getters & Setters
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

    public String getSelectedSpecialization() {
        return selectedSpecialization;
    }

    public void setSelectedSpecialization(String selectedSpecialization) {
        this.selectedSpecialization = selectedSpecialization;
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
        if (searchResults == null || searchResults.isEmpty())
            return 0;
        return (searchResults.size() + pageSize - 1) / pageSize;
    }

    public String getSortField() {
        return sortField;
    }

    public boolean isAscending() {
        return ascending;
    }

    public boolean isSearchPerformed() {
        return searchPerformed;
    }

    public String getCurrentSortColumn() {
        return currentSortColumn;
    }

    public String getCurrentSortOrder() {
        return currentSortOrder;
    }
    
    
}