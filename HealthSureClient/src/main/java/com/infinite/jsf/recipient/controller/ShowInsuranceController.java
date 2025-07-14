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

public class ShowInsuranceController {

	private MedicalProcedure medicalProcedure;
	private InsuranceDaoImpl insuranceDaoImpl;
	private Recipient recipient = new Recipient(); // instantiate to avoid null
	private PatientInsuranceDetails selectedItem;
	private String hId;
	private String userName;
	private String fullName;

	private InsuranceDao insuranceDao = new InsuranceDaoImpl();

	private List<PatientInsuranceDetails> patientInsuranceList;
	private List<PatientInsuranceDetails> original;
	private List<SubscribedMember> subscribedMembers;

	// Shared sorting
	private String sortField;
	private boolean ascending = true;

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
			
			patientInsuranceList = insuranceDao.showInsuranceOfRecipient(hId);
			original = patientInsuranceList;

			if (patientInsuranceList == null || patientInsuranceList.isEmpty()) {
				context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_WARN, "No Insurance Found",
						"Please subscribe to a plan."));
				return Collections.emptyList();
			}

			// Apply default sort
			sortPatientInsuranceList();
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

			resetMemberPage();
			return "/recipient/ViewMemebers.jsp?faces-redirect=true";
		}
		return null;
	}

	// Filter by ACTIVE or EXPIRED (merged)
	public void filterByCoverageStatus(String status) {
		if (original == null || status == null) {
			this.patientInsuranceList = Collections.emptyList();
		} else {
			this.patientInsuranceList = original.stream()
					.filter(p -> p.getCoverageStatus() != null && p.getCoverageStatus().name().equalsIgnoreCase(status))
					.collect(Collectors.toList());
		}
		resetInsurancePage();
	}

	// Date filter Logic
	// Filter by Date Range
	public void filterByDateRange() {
		if (fromDate != null && toDate != null && !fromDate.after(toDate) && !toDate.before(fromDate)) {
			patientInsuranceList = filterByDateRangeHelper(fromDate, toDate);
			resetInsurancePage();
		} else {
			FacesContext.getCurrentInstance().addMessage(null,
					new FacesMessage(FacesMessage.SEVERITY_ERROR, "Invalid date range. Please select properly", null));
		}
	}

	// Actual Date Filter
	private List<PatientInsuranceDetails> filterByDateRangeHelper(Date from, Date to) {
		if (original == null)
			return Collections.emptyList();

		return original.stream().filter(p -> {
			Date coverageStart = p.getCoverageStartDate();
			return coverageStart != null && !coverageStart.before(from) && !coverageStart.after(to);
		}).collect(Collectors.toList());
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

		return "Showing " + from + " of " + total +" "+ "Results";
	}

	// ======Full Sorting icon Methods=====
	// Sorting Asc Insurance
	public String sortByAsc(String fieldName) {
		this.sortField = fieldName;
		this.ascending = true;
		sortPatientInsuranceList();
		resetInsurancePage();
		return null;
	}

	// Sorting Desc Insurance
	public String sortByDesc(String fieldName) {
		this.sortField = fieldName;
		this.ascending = false;
		sortPatientInsuranceList();
		resetInsurancePage();
		return null;
	}

	// Sorting Asc members
	public String sortByAscMem(String fieldName) {
		this.sortField = fieldName;
		this.ascending = true;
		sortViewMemberList();
		resetMemberPage();
		return null;
	}

	// Sorting Desc members
	public String sortByDescMem(String fieldName) {
		this.sortField = fieldName;
		this.ascending = false;
		sortViewMemberList();
		resetMemberPage();
		return null;
	}

	// Filter Reset Button
	public String resetFilter() {
		this.insurancePage = 0;
		this.fromDate = null;
		this.toDate = null;
		this.patientInsuranceList = insuranceDao.showInsuranceOfRecipient(hId);
		return null;
	}

	// Sorting for PatientInsurance page
	@SuppressWarnings("unchecked")
	private void sortPatientInsuranceList() {
		if (patientInsuranceList == null || sortField == null)
			return;

		Collections.sort(patientInsuranceList, (a, b) -> {
			try {
				Field fieldA = a.getClass().getDeclaredField(sortField);
				Field fieldB = b.getClass().getDeclaredField(sortField);
				fieldA.setAccessible(true);
				fieldB.setAccessible(true);
				Comparable<Object> valueA = (Comparable<Object>) fieldA.get(a);
				Comparable<Object> valueB = (Comparable<Object>) fieldB.get(b);

				if (valueA == null)
					return ascending ? -1 : 1;
				if (valueB == null)
					return ascending ? 1 : -1;

				return ascending ? valueA.compareTo(valueB) : valueB.compareTo(valueA);
			} catch (Exception e) {
				return 0;
			}
		});
	}

	// Sorting for ViewMembers Page
	@SuppressWarnings("unchecked")
	private void sortViewMemberList() {
		if (subscribedMembers == null || sortField == null)
			return;

		Collections.sort(subscribedMembers, (a, b) -> {
			try {
				Field fieldA = a.getClass().getDeclaredField(sortField);
				Field fieldB = b.getClass().getDeclaredField(sortField);
				fieldA.setAccessible(true);
				fieldB.setAccessible(true);
				Comparable<Object> valueA = (Comparable<Object>) fieldA.get(a);
				Comparable<Object> valueB = (Comparable<Object>) fieldB.get(b);

				if (valueA == null)
					return ascending ? -1 : 1;
				if (valueB == null)
					return ascending ? 1 : -1;

				return ascending ? valueA.compareTo(valueB) : valueB.compareTo(valueA);
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

	public String getSortField() {
		return sortField;
	}

	public void setSortField(String sortField) {
		this.sortField = sortField;
	}

	public boolean isAscending() {
		return ascending;
	}

	public void setAscending(boolean ascending) {
		this.ascending = ascending;
	}

	public int getPageSize() {
		return pageSize;
	}

	// Pagination getters/setters
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

	public int getMemberPage() {
		return memberPage + 1;
	}

	public int getTotalMemberPages() {
		if (subscribedMembers == null || subscribedMembers.isEmpty())
			return 0;
		return (int) Math.ceil((double) subscribedMembers.size() / pageSize);
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


	//Logout method	
	  public String logout() {
	        FacesContext facesContext = FacesContext.getCurrentInstance();
	        HttpSession session = (HttpSession) facesContext.getExternalContext().getSession(false);
	        if (session != null) {
	            session.invalidate();
	        }
	        return "/home/Home.jsp?faces-redirect=true";
	    }

	
}
