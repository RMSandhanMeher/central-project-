package com.infinite.jsf.recipient.controller;

import java.lang.reflect.Field;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpSession;

import com.infinite.jsf.insurance.model.PlanType;
import com.infinite.jsf.insurance.model.SubscribedMember;
import com.infinite.jsf.provider.model.MedicalProcedure;
import com.infinite.jsf.recipient.dao.InsuranceDao;
import com.infinite.jsf.recipient.daoImpl.InsuranceDaoImpl;
import com.infinite.jsf.recipient.model.PatientInsuranceDetails;
import com.infinite.jsf.recipient.model.Recipient;

public class ShowInsuranceController { // No annotations here as per request

	private MedicalProcedure medicalProcedure;
	private InsuranceDaoImpl insuranceDaoImpl;
	private Recipient recipient = new Recipient();
	private PatientInsuranceDetails selectedItem;
	private String hId;
	private String userName;
	private String fullName;
	private String selectedStatus; // New: Holds selected ACTIVE or EXPIRED


	private InsuranceDao insuranceDao = new InsuranceDaoImpl();

	private List<PatientInsuranceDetails> patientInsuranceList;
	private List<PatientInsuranceDetails> originalInsuranceList; // Store original unfiltered list
	private List<SubscribedMember> subscribedMembers;

	// Sorting state for Patient Insurance Details table
	private String currentInsuranceSortColumn;
	private String currentInsuranceSortDirection; // "asc" or "desc"

	// Sorting state for Subscribed Members table
	private String currentMemberSortColumn;
	private String currentMemberSortDirection; // "asc" or "desc"

	// Separate pagination for insurance and members
	private int insurancePage = 0;
	private int memberPage = 0;
	private final int pageSize = 4;

	// Date filter fields
	private Date fromDate;
	private Date toDate;

	
	
	
	
	// Show Insurance logic
	public List<PatientInsuranceDetails> getInsuranceData() {
		FacesContext context = FacesContext.getCurrentInstance();

		// Lazy fetch if list is null
		if (patientInsuranceList == null) {

			hId = (String) context.getExternalContext().getSessionMap().get("loggedInRecipientId");
			fullName = (String) context.getExternalContext().getSessionMap().get("fullName");

			// Initialize original list
			originalInsuranceList = insuranceDao.showInsuranceOfRecipient(hId);
			patientInsuranceList = originalInsuranceList; // Start with the full list

			
			if (patientInsuranceList == null || patientInsuranceList.isEmpty()) {
				context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_WARN, "No Insurance Found",
						"Please subscribe to a plan."));
				return Collections.emptyList();
			}

			
			// Apply default sort if needed (e.g., if no sort was previously applied)
			if (currentInsuranceSortColumn == null || currentInsuranceSortColumn.isEmpty()) {
				currentInsuranceSortColumn = "coverageStart"; // Example default
				currentInsuranceSortDirection = "desc";
			}
//			sortPatientInsuranceList();
			applyDefaultInsuranceSort();
			resetInsurancePage();
		}

		// Always return paginated data
		int from = insurancePage * pageSize;
		int to = Math.min(from + pageSize, patientInsuranceList.size());
		return patientInsuranceList.subList(from, to);
	}

	
	
	
	
	// View Members Logic
	public String viewMembers(PatientInsuranceDetails insurance) {
		this.selectedItem = insurance;
		if (insurance != null && insurance.getCoverageType() == PlanType.FAMILY) {
			this.subscribedMembers = insurance.getSubscribedMembers();

			// Optional: set hId in session just in case
			FacesContext.getCurrentInstance().getExternalContext().getSessionMap().put("hId", insurance.gethId());

			// Reset member table's sort state when viewing new members
			this.currentMemberSortColumn = null; // Clear sort state for new list
			this.currentMemberSortDirection = null;

			resetMemberPage();

			// Apply default sort to members if needed
			if (subscribedMembers != null && !subscribedMembers.isEmpty()) {
				currentMemberSortColumn = "memberId"; // Example default for members
				currentMemberSortDirection = "asc";
				sortViewMemberList();
			}

			return "/recipient/ViewMemebers.jsp?faces-redirect=true";
		}
		return null;
	}
	
	
	
	
	
	
	
	

	                                                    //ACTIVE or EXPIRED FILTERS
	// Filter by ACTIVE or EXPIRED (merged)
	public void filterByCoverageStatus(String status) {
		if (originalInsuranceList == null || status == null) {
			this.patientInsuranceList = Collections.emptyList();
			return;
		}

		this.selectedStatus = status; //Store selected filter status

		// Reset date range to avoid conflicting filters
		this.fromDate = null;
		this.toDate = null;

		this.patientInsuranceList = originalInsuranceList.stream()
			.filter(p -> p.getCoverageStatus() != null &&
			             p.getCoverageStatus().name().equalsIgnoreCase(status))
			.collect(Collectors.toList());

//		this.currentInsuranceSortColumn = null;
//		this.currentInsuranceSortDirection = null;
		applyDefaultInsuranceSort(); //sort via Covarage Start date
		resetInsurancePage();
	}

	
	
	
	
	
	
	
	

	                                                    //Date filter Logic
    //Date Filter
		public void filterByDateRange() {
			FacesContext context = FacesContext.getCurrentInstance();

			if (fromDate == null || toDate == null) {
				context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_ERROR,
						"Both From and To dates are required.", null));
				return;
			}

			if (fromDate.after(toDate)) {
				context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_ERROR,
						"From Date cannot be after To Date.", null));
				return;
			}

			if (originalInsuranceList == null || originalInsuranceList.isEmpty()) {
				context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_WARN,
						"No insurance records available to filter.", null));
				
				return;
			}

			this.patientInsuranceList = originalInsuranceList.stream().filter(p -> {
				Date start = p.getCoverageStartDate();
				boolean isInRange = start != null &&
				                    !start.before(fromDate) &&
				                    !start.after(toDate);

				boolean matchesStatus = true; // Allow all if not set
				if (selectedStatus != null && !selectedStatus.isEmpty()) {
					matchesStatus = p.getCoverageStatus() != null &&
					                p.getCoverageStatus().name().equalsIgnoreCase(selectedStatus);
				}

				return isInRange && matchesStatus;
			}).collect(Collectors.toList());

			if (patientInsuranceList.isEmpty()) {
				context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO,
						"No insurance records fall within the selected date range.", null));
			}

//			this.currentInsuranceSortColumn = null;
//			this.currentInsuranceSortDirection = null;
			applyDefaultInsuranceSort(); //Ensure latest insurance appears first
			resetInsurancePage();
		}



	
	
	
	

	// Member Pagination
	public List<SubscribedMember> getPaginatedMemberList() {
		if (subscribedMembers == null || subscribedMembers.isEmpty())
			return Collections.emptyList();
		int from = memberPage * pageSize;
		int to = Math.min(from + pageSize, subscribedMembers.size());
		return subscribedMembers.subList(from, to);
	}

	// Pagination Summary like showing 6 of 10 data
	public String getPaginationIncSummary() {
		if (patientInsuranceList == null || patientInsuranceList.isEmpty()) {
			return "";
		}
		int from = Math.min((insurancePage + 1) * pageSize, patientInsuranceList.size());
		int total = patientInsuranceList.size();
		int page = insurancePage + 1;
		int totalPages = getTotalPages();

		return "Showing " + from + " of " + total + " " + "Results";
	}


	
	// Pagination Summary for Members
	public String getPaginationMemSummary() {
		if (subscribedMembers == null || subscribedMembers.isEmpty()) {
			return "";
		}
		int from = Math.min((memberPage + 1) * pageSize, subscribedMembers.size());
		int total = subscribedMembers.size();
		int page = memberPage + 1;
		int totalPages = getTotalPages();

		return "Showing " + from + " of " + total + " " + "Results";
	}

	
	
	
	
	
	
	
	                                             // Full Sorting Methods
	
	private void applyDefaultInsuranceSort() {
	    currentInsuranceSortColumn = "coverageStartDate";
	    currentInsuranceSortDirection = "desc";
	    sortPatientInsuranceList();
	}


	// Sorting Asc Insurance
	public String sortByAsc(String fieldName) {
		this.currentInsuranceSortColumn = fieldName;
		this.currentInsuranceSortDirection = "asc";
		sortPatientInsuranceList();
		resetInsurancePage(); // Reset page after sort
		return null;
	}

	// Sorting Desc Insurance
	public String sortByDesc(String fieldName) {
		this.currentInsuranceSortColumn = fieldName;
		this.currentInsuranceSortDirection = "desc";
		sortPatientInsuranceList();
		resetInsurancePage(); // Reset page after sort
		return null;
	}

	// Sorting Asc members
	public String sortByAscMem(String fieldName) {
		this.currentMemberSortColumn = fieldName;
		this.currentMemberSortDirection = "asc";
		sortViewMemberList();
		resetMemberPage(); // Reset page after sort
		return null;
	}

	// Sorting Desc members
	public String sortByDescMem(String fieldName) {
		this.currentMemberSortColumn = fieldName;
		this.currentMemberSortDirection = "desc";
		sortViewMemberList();
		resetMemberPage(); // Reset page after sort
		return null;
	}

	// Filter Reset Button
	public String resetFilter() {
		this.insurancePage = 0;
		this.fromDate = null;
		this.toDate = null;
		this.selectedStatus = null; // ✅ Reset selected status too
		this.patientInsuranceList = insuranceDao.showInsuranceOfRecipient(hId);
		this.currentInsuranceSortColumn = null;
		this.currentInsuranceSortDirection = null;
		applyDefaultInsuranceSort();
		return null;
	}


	
	
	
	
	
	
	                                        // Sorting for PatientInsurance page
	@SuppressWarnings("unchecked")
	private void sortPatientInsuranceList() {
		if (patientInsuranceList == null || currentInsuranceSortColumn == null) // Use currentInsuranceSortColumn
			return;

		Collections.sort(patientInsuranceList, (a, b) -> {
			try {
				Field fieldA = a.getClass().getDeclaredField(currentInsuranceSortColumn); // Use
																							// currentInsuranceSortColumn
				Field fieldB = b.getClass().getDeclaredField(currentInsuranceSortColumn); // Use
																							// currentInsuranceSortColumn
				fieldA.setAccessible(true);
				fieldB.setAccessible(true);
				Comparable<Object> valueA = (Comparable<Object>) fieldA.get(a);
				Comparable<Object> valueB = (Comparable<Object>) fieldB.get(b);

				if (valueA == null)
					return currentInsuranceSortDirection.equals("asc") ? -1 : 1; // Use currentInsuranceSortDirection
				if (valueB == null)
					return currentInsuranceSortDirection.equals("asc") ? 1 : -1; // Use currentInsuranceSortDirection

				return currentInsuranceSortDirection.equals("asc") ? valueA.compareTo(valueB)
						: valueB.compareTo(valueA); // Use currentInsuranceSortDirection
			} catch (Exception e) {
				return 0;
			}
		});
	}

	
	
	                                           // Sorting for ViewMembers Page
	@SuppressWarnings("unchecked")
	private void sortViewMemberList() {
		if (subscribedMembers == null || currentMemberSortColumn == null) // Use currentMemberSortColumn
			return;

		Collections.sort(subscribedMembers, (a, b) -> {
			try {
				Field fieldA = a.getClass().getDeclaredField(currentMemberSortColumn); // Use currentMemberSortColumn
				Field fieldB = b.getClass().getDeclaredField(currentMemberSortColumn); // Use currentMemberSortColumn
				fieldA.setAccessible(true);
				fieldB.setAccessible(true);
				Comparable<Object> valueA = (Comparable<Object>) fieldA.get(a);
				Comparable<Object> valueB = (Comparable<Object>) fieldB.get(b);

				if (valueA == null)
					return currentMemberSortDirection.equals("asc") ? -1 : 1; // Use currentMemberSortDirection
				if (valueB == null)
					return currentMemberSortDirection.equals("asc") ? 1 : -1; // Use currentMemberSortDirection

				return currentMemberSortDirection.equals("asc") ? valueA.compareTo(valueB) : valueB.compareTo(valueA); // Use
																														// currentMemberSortDirection
			} catch (Exception e) {
				return 0;
			}
		});
	}
	
	
	
	
	
	
	
	

	                                                 // Getters & Setters
	public String gethId() {
		return hId;
	}

	public void sethId(String hId) {
		this.hId = hId;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getFullName() {
		return fullName;
	}

	public void setFullName(String fullName) {
		this.fullName = fullName;
	}

	public MedicalProcedure getMedicalProcedure() {
		return medicalProcedure;
	}

	public void setMedicalProcedure(MedicalProcedure medicalProcedure) {
		this.medicalProcedure = medicalProcedure;
	}

	public InsuranceDaoImpl getInsuranceDaoImpl() {
		return insuranceDaoImpl;
	}

	public void setInsuranceDaoImpl(InsuranceDaoImpl insuranceDaoImpl) {
		this.insuranceDaoImpl = insuranceDaoImpl;
	}

	public Recipient getRecipient() {
		return recipient;
	}

	public void setRecipient(Recipient recipient) {
		this.recipient = recipient;
	}

	public PatientInsuranceDetails getSelectedItem() {
		return selectedItem;
	}

	public void setSelectedItem(PatientInsuranceDetails selectedItem) {
		this.selectedItem = selectedItem;
	}

	public InsuranceDao getInsuranceDao() {
		return insuranceDao;
	}

	public void setInsuranceDao(InsuranceDao insuranceDao) {
		this.insuranceDao = insuranceDao;
	}

	public List<PatientInsuranceDetails> getPatientInsuranceList() {
		return patientInsuranceList;
	}

	public void setPatientInsuranceList(List<PatientInsuranceDetails> patientInsuranceList) {
		this.patientInsuranceList = patientInsuranceList;
	}

	public List<SubscribedMember> getSubscribedMembers() {
		return subscribedMembers;
	}

	public void setSubscribedMembers(List<SubscribedMember> subscribedMembers) {
		this.subscribedMembers = subscribedMembers;
	}

	public int getInsurancePage() {
		return insurancePage;
	}

	public void setInsurancePage(int insurancePage) {
		this.insurancePage = insurancePage;
	}

	// These 'sortField' and 'ascending' are now effectively unused as we have
	// specific ones for each table.
	// You might consider removing them if they are truly not used elsewhere.
	public String getSortField() {
		return null; // Not directly used for table sorting state anymore
	}

	public void setSortField(String sortField) {
		// Not directly used for table sorting state anymore
	}

	public boolean isAscending() {
		return true; // Not directly used for table sorting state anymore
	}

	public void setAscending(boolean ascending) {
		// Not directly used for table sorting state anymore
	}

	public int getPageSize() {
		return pageSize;
	}

	// Getters and Setters for currentInsuranceSortColumn and
	// currentInsuranceSortDirection
	public String getCurrentInsuranceSortColumn() {
		return currentInsuranceSortColumn;
	}

	public void setCurrentInsuranceSortColumn(String currentInsuranceSortColumn) {
		this.currentInsuranceSortColumn = currentInsuranceSortColumn;
	}

	public String getCurrentInsuranceSortDirection() {
		return currentInsuranceSortDirection;
	}

	public void setCurrentInsuranceSortDirection(String currentInsuranceSortDirection) {
		this.currentInsuranceSortDirection = currentInsuranceSortDirection;
	}

	// Getters and Setters for currentMemberSortColumn and
	// currentMemberSortDirection
	public String getCurrentMemberSortColumn() {
		return currentMemberSortColumn;
	}

	public void setCurrentMemberSortColumn(String currentMemberSortColumn) {
		this.currentMemberSortColumn = currentMemberSortColumn;
	}

	public String getCurrentMemberSortDirection() {
		return currentMemberSortDirection;
	}

	public void setCurrentMemberSortDirection(String currentMemberSortDirection) {
		this.currentMemberSortDirection = currentMemberSortDirection;
	}

	/**
	 * Determines if a sort button (up or down arrow) should be rendered for the
	 * PatientInsuranceDetails table. The button should disappear if it represents
	 * the currently active sort.
	 *
	 * @param column    The name of the column (e.g., "policyNumber",
	 *                  "coverageStartDate").
	 * @param direction "asc" for ascending, "desc" for descending.
	 * @return true if the button should be rendered, false otherwise.
	 */
	public boolean shouldRenderSortButton(String column, String direction) {
		// If no sorting is active, or if this is a different column, render all buttons
		if (currentInsuranceSortColumn == null || !currentInsuranceSortColumn.equals(column)) {
			return true;
		}
		// If it's the same column, render only if its direction is different from the
		// current sort direction
		return !currentInsuranceSortDirection.equals(direction);
	}

	/**
	 * Determines if a sort button (up or down arrow) should be rendered for the
	 * SubscribedMembers table. The button should disappear if it represents the
	 * currently active sort.
	 *
	 * @param column    The name of the column (e.g., "memberId", "fullName").
	 * @param direction "asc" for ascending, "desc" for descending.
	 * @return true if the button should be rendered, false otherwise.
	 */
	public boolean shouldRenderSortButtonMem(String column, String direction) {
		// If no sorting is active, or if this is a different column, render all buttons
		if (currentMemberSortColumn == null || !currentMemberSortColumn.equals(column)) {
			return true;
		}
		// If it's the same column, render only if its direction is different from the
		// current sort direction
		return !currentMemberSortDirection.equals(direction);
	}

	// Pagination getters/setters for Insurance table
	public void nextPage() {
		if (getHasNextPage())
			insurancePage++;
	}

	public void previousPage() {
		if (getHasPreviousPage())
			insurancePage--;
	}

	public boolean getHasNextPage() {
		return (insurancePage + 1) * pageSize < (patientInsuranceList != null ? patientInsuranceList.size() : 0);
	}

	public boolean getHasPreviousPage() {
		return insurancePage > 0;
	}

	public int getCurrentPage() {
		return insurancePage + 1;
	}

	public int getTotalPages() {
		if (patientInsuranceList == null || patientInsuranceList.isEmpty())
			return 0;
		return (int) Math.ceil((double) patientInsuranceList.size() / pageSize);
	}

	public void resetInsurancePage() {
		this.insurancePage = 0;
	}

	// Pagination getters/setters for Members table
	public void nextMemberPage() {
		if (getHasNextMemberPage())
			memberPage++;
	}

	public void previousMemberPage() {
		if (getHasPreviousMemberPage())
			memberPage--;
	}

	public boolean getHasNextMemberPage() {
		return (memberPage + 1) * pageSize < (subscribedMembers != null ? subscribedMembers.size() : 0);
	}

	public boolean getHasPreviousMemberPage() {
		return memberPage > 0;
	}

	public int getMemberPage() { // This returns current page number (1-based)
		return memberPage + 1;
	}

	public int getTotalMemberPages() {
		if (subscribedMembers == null || subscribedMembers.isEmpty())
			return 0;
		return (int) Math.ceil((double) subscribedMembers.size() / pageSize);
	}

	public void resetMemberPage() {
		this.memberPage = 0;
	}

	public Date getFromDate() {
		return fromDate;
	}

	public void setFromDate(Date fromDate) {
		this.fromDate = fromDate;
	}

	public Date getToDate() {
		return toDate;
	}

	public void setToDate(Date toDate) {
		this.toDate = toDate;
	}
	
	

	public String getSelectedStatus() {
		return selectedStatus;
	}





	public void setSelectedStatus(String selectedStatus) {
		this.selectedStatus = selectedStatus;
	}





	// Logout method
	public String logout() {
		FacesContext facesContext = FacesContext.getCurrentInstance();
		HttpSession session = (HttpSession) facesContext.getExternalContext().getSession(false);
		if (session != null) {
			System.out.println(recipient.getFullName()+" "+"has logged-out....");
			session.invalidate();
		}
		return "/home/Home.jsp?faces-redirect=true";
	}
}