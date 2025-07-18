package com.infinite.jsf.recipient.controller;

import java.io.Serializable; // Import Serializable
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



public class DoctorSearchController implements Serializable {

    private static final long serialVersionUID = 1L; // Recommended for Serializable
    private static final Logger LOGGER = Logger.getLogger(DoctorSearchController.class.getName());

    private String searchBy = "doctorName";
    private String searchValue;
    private String selectedSpecialization;

    private List<SelectItem> searchOptions;
    private List<SelectItem> specializationOptions;

    private List<Doctors> searchResults = new ArrayList<>();
    private int currentPage = 0;
    private int pageSize = 4;

    private String sortField = "doctorName"; // This holds the field currently being sorted
    private boolean ascending = true; // This holds the direction of the current sort

    private boolean searchPerformed = false;
    private boolean initialized = false;

    // These fields are crucial for controlling button visibility
    private String currentSortColumn = "doctorName"; // Name of the column currently sorted
    private String currentSortOrder = "asc"; // "asc" or "desc"

    private SearchDoctorDao doctorDAO = new SearchDoctorDaoImpl();

    // Load dropdown options lazily (auto-triggered when page loads)
    public List<SelectItem> getSearchOptions() {
        if (!initialized) {
            searchOptions = new ArrayList<>();
            searchOptions.add(new SelectItem("doctorName", "Doctor Name"));
            searchOptions.add(new SelectItem("specialization", "Specialization"));
            searchOptions.add(new SelectItem("address", "Address"));

            loadSpecializationOptions();
            initialized = true;
        }
        return searchOptions;
    }
    
    
    public void searchByChanged() {
        LOGGER.info("Search type changed to: " + this.searchBy);
    }
    
    
    
    							   //Core method for executing the search
    public void executeSearch() {
        FacesContext context = FacesContext.getCurrentInstance();
        searchPerformed = true;

        String currentSearchValue = "specialization".equals(searchBy) ? selectedSpecialization : searchValue;

        LOGGER.info("Searching: " + searchBy + " = " + currentSearchValue);

                                                   //Validation
        if (currentSearchValue == null || currentSearchValue.trim().isEmpty()) {
            context.addMessage("searchForm:searchValueInput", new FacesMessage(FacesMessage.SEVERITY_ERROR,
                    "Please provide search criteria.", null));
            searchResults = new ArrayList<>();
            return;
        }

        currentSearchValue = currentSearchValue.trim().replaceAll("\\s{2,}", " ");

        
                                                  // Validation
        if ("doctorName".equals(searchBy)) {
            if (!Pattern.matches("^[a-zA-Z. ]+$", currentSearchValue)) {
                context.addMessage("searchForm:searchValueInput", new FacesMessage(FacesMessage.SEVERITY_ERROR,
                        "Doctor Name can only contain letters, spaces, and dot eg. (Dr.)", null));
                searchResults = new ArrayList<>();
                return;
            }
        } else if ("specialization".equals(searchBy)) {
            if ("• Select Specialization •".equals(currentSearchValue) || "".equals(currentSearchValue)) {
                context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_ERROR,
                        "Please select a valid specialization.", null));
                searchResults = new ArrayList<>();
                return;
            }
        }

        
        
                                                  // DAO call
        searchResults = doctorDAO.searchDoctors(searchBy, currentSearchValue);
        LOGGER.info("Results found: " + (searchResults != null ? searchResults.size() : 0));

        if (searchResults == null || searchResults.isEmpty()) {
            context.addMessage("searchForm:searchValueInput", new FacesMessage(FacesMessage.SEVERITY_WARN,
                    "No doctors found matching your search.", null));
            searchResults = new ArrayList<>();
        }

        sortResults();
        currentPage = 0;
    }
    
    
    
    // Pagination Module
    public List<Doctors> getPaginatedDoctors() {
        if (searchResults == null || searchResults.isEmpty()) return new ArrayList<>();

        int fromIndex = currentPage * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, searchResults.size());

        if (fromIndex > toIndex || fromIndex >= searchResults.size()) {
            currentPage = 0;
            fromIndex = 0;
            toIndex = Math.min(pageSize, searchResults.size());
        }

        return searchResults.subList(fromIndex, toIndex);
    }

    public void nextPage() {
        if ((currentPage + 1) * pageSize < searchResults.size()) currentPage++;
    }

    public void prevPage() {
        if (currentPage > 0) currentPage--;
    }
    
    
    
    
                                                   // Sorting Module
    public void sortByAsc(String field) {
        this.sortField = field;
        this.ascending = true;

        this.currentSortColumn = field; // Set the currently sorted column
        this.currentSortOrder = "asc"; // Set the current sort order

        sortResults();
        currentPage = 0;
    }

    
    public void sortByDesc(String field) {
        this.sortField = field;
        this.ascending = false;

        this.currentSortColumn = field; // Set the currently sorted column
        this.currentSortOrder = "desc"; // Set the current sort order

        sortResults();
        currentPage = 0;
    }
    
    
    
    
    
    private void sortResults() {
        if (searchResults == null || searchResults.isEmpty()) return;

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
    }
    
    
    
    //Count of data in a page/total page Summary
    public String getPaginationDocSummary() {
        if (searchResults == null || searchResults.isEmpty()) {
            return "";
        }
        int from = Math.min((currentPage + 1) * pageSize, searchResults.size());
        int total = searchResults.size();
        int page = currentPage + 1;
        int totalPages = getTotalPages();

        return "Showing " + from + " of " + total +" "+"Results";
    }

    
    
    
      /* Determines if a sort button (up or down arrow) should be rendered.
       The button should disappear if it represents the currently active sort.
       column The name of the column (e.g., "doctorName", "specialization").
       order "asc" for ascending, "desc" for descending.
       true if the button should be rendered, false otherwise. */
    
    public boolean renderSortButton(String column, String order) {
        // If this column is NOT the currently sorted column, always render both buttons
        if (!this.currentSortColumn.equals(column)) {
            return true;
        }

        // If this column IS the currently sorted column:
        // Render the button only if its order is different from the current sort order
        return !this.currentSortOrder.equals(order);
    }
    
    
                                                     //Reset Button
    public String resetSearch() {
        this.searchBy = "doctorName";
        this.searchValue = null;
        this.selectedSpecialization = "";
        this.searchResults = new ArrayList<>();
        this.currentPage = 0;
        this.sortField = "doctorName";
        this.ascending = true;
        this.searchPerformed = false;
        
        // Reset sort indicators to default, e.g., show both "doctorName" arrows
        this.currentSortColumn = "doctorName";
        this.currentSortOrder = "asc"; // Or you can set it to a neutral value if you want both arrows to show

        LOGGER.info("Search reset.");
        return "findDoctor"; // or same page's navigation outcome
    }
    
    
    
    
    
                                            //Lazy Loaded the specializations
    public List<SelectItem> getSpecializationOptions() {
        if (specializationOptions == null || specializationOptions.isEmpty()) {
            loadSpecializationOptions();
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
    
    
    
    
    
    
                                            // Getters & Setters
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
    } // 1-based for display

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