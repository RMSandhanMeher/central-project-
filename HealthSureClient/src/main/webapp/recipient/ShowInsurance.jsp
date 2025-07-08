<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@ taglib prefix="h" uri="http://java.sun.com/jsf/html"%>

<f:view>
	<html>
<head>
<title>Insurance Details</title>
<style>
/* Reset some default margins for consistency */
html, body {
	margin: 0;
	padding: 0;
}

body {
	font-family: 'Segoe UI', sans-serif;
	background-color: #f8fcff;
	display: flex;
	flex-direction: column; /* Stack children vertically */
	align-items: center; /* Center children horizontally */
	min-height: 100vh; /* Ensure body takes full viewport height */
}

/* Header (H2) Styling */
h2 {
	color: #0077b6;
	text-align: center;
	margin-top: 100px; /* Space from top (and navbar) */
	margin-bottom: 20px;
	/* Space between heading and the main content box */
	font-size: 28px;
	text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
	width: 100%; /* Ensure heading takes full width for centering */
}

/* Main Content Panel - The Shadowed Box */
.main-content-panel {
	width: 90%; /* Adjusted width for more content on this page */
	max-width: 1200px; /* Add a max-width for very large screens */
	margin-top: 0; /* Managed by body flex and h2 margin */
	margin-bottom: 30px;
	background-color: #ffffff;
	border-radius: 12px;
	box-shadow: 0px 8px 24px rgba(0, 0, 0, 0.15); /* Stronger shadow */
	padding: 30px; /* Internal padding for content */
	box-sizing: border-box; /* Include padding in element's total width */
	display: flex; /* Flex container for internal elements */
	flex-direction: column; /* Stack internal elements vertically */
	align-items: center; /* Center internal elements horizontally */
}

/* --- Input Grid (h:panelGrid) Styling for Recipient ID --- */
.recipient-input-grid { /* Specific class for this page's grid */
	width: 70%;
	/* Control the width of the input section within the main panel */
	margin: 0 auto 25px auto; /* Center the grid, add bottom margin */
	border-collapse: collapse; /* Remove extra table spacing */
}

/* Styling for the cells (td) within the recipient-input-grid */
.recipient-input-grid tr td {
	padding: 8px 0;
	/* Vertical padding for rows, horizontal padding handled by specific cell rules */
	vertical-align: middle; /* Align content vertically in the middle */
}

.recipient-input-grid tr td:first-child {
	/* Label column "Enter Recipient ID:" */
	width: 40%; /* Allocate specific width for the label */
	text-align: right; /* Right align the label */
	padding-right: 15px; /* Space between label and input */
}

.recipient-input-grid tr td:nth-child(2) { /* Input field column */
	width: 30%; /* Allocate width for the input */
	padding-left: 0;
	padding-right: 15px; /* Space between input and its buttons */
}

.recipient-input-grid tr td:last-child {
	/* Buttons column ("Show", "Reset") */
	width: 30%; /* Allocate remaining width for buttons */
	text-align: left; /* Left align buttons in their cell */
	padding-left: 0;
}

/* Form fields aesthetics */
h\:inputText, h\:selectOneMenu {
	width: 100%; /* Fill the allocated cell width */
	padding: 10px 12px;
	font-size: 15px;
	border-radius: 6px;
	border: 1px solid #cce0eb;
	box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.06);
	transition: border-color 0.2s, box-shadow 0.2s;
	box-sizing: border-box; /* Include padding in width */
}

h\:inputText:focus, h\:selectOneMenu:focus {
	border-color: #007bff;
	box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.06), 0 0 0 3px
		rgba(0, 123, 255, 0.25);
	outline: none;
}

/* Labels */
h\:outputLabel {
	font-weight: bold;
	color: #333;
	white-space: nowrap; /* Prevent label from wrapping */
}

/* --- NEW & IMPROVED BUTTON STYLES --- */

/* Base Button Style */
.btn {
	padding: 8px 20px;
	border: none;
	border-radius: 12px;
	cursor: pointer;
	font-size: 15px;
	font-weight: 600;
	text-decoration: none;
	display: inline-block;
	transition: background-color 0.3s ease, transform 0.1s ease, box-shadow
		0.3s ease;
	letter-spacing: 0.5px;
}

.btn:hover {
	transform: translateY(-0.8px);
}

.btn:active {
	transform: translateY(0);
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

/* Primary Button (for Show, Filter, Next/Prev) */
.btn-primary {
	background-color: #007bff;
	color: white;
	box-shadow: 0 4px 8px rgba(0, 123, 255, 0.25);
}

.btn-primary:hover {
	background-color: #0069d9;
	box-shadow: 0 6px 12px rgba(0, 123, 255, 0.35);
}

/* Secondary Button (for Reset) */
.btn-secondary {
	background-color: #6c757d;
	color: white;
	box-shadow: 0 4px 8px rgba(108, 117, 125, 0.25);
}

.btn-secondary:hover {
	background-color: #5a6268;
	box-shadow: 0 6px 12px rgba(108, 117, 125, 0.35);
}

/* Success Button (for View Members) - smaller for tables */
.btn-success {
	background-color: #28a745;
	color: white;
	padding: 8px 16px; /* Smaller padding */
	font-size: 14px; /* Smaller font */
	box-shadow: 0 4px 8px rgba(40, 167, 69, 0.25);
}

.btn-success:hover {
	background-color: #218838;
	box-shadow: 0 6px 12px rgba(40, 167, 69, 0.35);
}

/* Container for Show/Reset buttons */
.action-buttons-container {
	/* New class to wrap "Show" and "Reset" buttons inside their TD */
	display: flex;
	gap: 10px; /* Space between Show and Reset buttons */
	justify-content: flex-start;
	/* Align to the left in their table cell */
	align-items: center;
}

.filter-buttons-bar {
	text-align: center; /* Center filter buttons */
	margin-top: 0px;
	/* Space from input grid is now from grid's margin-bottom */
	margin-bottom: 30px; /* Space below filter buttons before table */
	width: 100%; /* Ensure it spans full width to apply text-align */
	display: flex; /* Use flexbox for spacing */
	justify-content: center; /* Center the filter buttons */
	gap: 15px; /* Space between filter buttons */
}

/* Remove old h:commandButton general styling as .btn classes will take over */
h\:commandButton {
	/* These styles are now managed by .btn, .btn-primary, .btn-secondary */
	/* Removed: padding, background-color, color, border, border-radius, cursor, font-size, font-weight, letter-spacing, transition, box-shadow */
	
}

/* Remove specific overrides that are now covered by .btn classes */
h\:commandButton:hover {
	/* Removed: background-color, transform, box-shadow */
	
}

h\:commandButton:active {
	/* Removed: transform, box-shadow */
	
}

.filter-buttons-bar h\:commandButton:not(:first-child) {
	margin-left: 0; /* Reset this, gap handles spacing now */
}

/* --- Table Styling --- */
.data-table {
	width: 100%;
	/* Table fills the width of its parent (.main-content-panel) */
	margin-top: 6px;
	border-collapse: collapse;
	background-color: #ffffff;
	border-radius: 10px;
	overflow: hidden;
	box-shadow: 0px 4px 16px rgba(0, 0, 0, 0.08);
}

.data-table th, .data-table td {
	border: 1px solid #bcd9ea;
	padding: 10px;
	text-align: center; /* Keep center for table data */
	font-size: 14px;
}

.data-table th {
	background-color: #d0f0f3;
	text-align: center;
	font-weight: bold;
	font-size: 15px;
}

.data-table tr:nth-child(even) {
	background-color: #f1faff;
}

.data-table tr:hover {
	background-color: #e0f7ff;
}

/* Table Header Sort Icons */
.h-panelgroup {
	display: flex;
	align-items: center;
	/* Vertically aligns the text and the arrow container */
	justify-content: center; /* Horizontally centers the content */
	gap: 5px; /* Adds a small space between text and arrows */
}

.sort-icons-container {
	display: flex;
	flex-direction: column; /* Stack arrows vertically */
}

.sort-icons { /* Applies to commandLink around graphicImage */
	display: block; /* Make links block to stack arrows */
	line-height: 1; /* Remove extra line height for tight stacking */
}

.sort-icons+.sort-icons {
	margin-top: 2px; /* Small space between up and down arrows */
}

/* Pagination */
.pagination {
	display: flex; /* Use flexbox for pagination buttons */
	align-items: center;
	justify-content: center; /* Center the pagination block */
	gap: 15px; /* Space between buttons and text */
	margin: 30px 0 10px 0; /* Adjust margin */
	width: 100%;
}

.pagination .btn { /* Apply base button style to pagination buttons */
	padding: 8px 18px; /* Slightly smaller for pagination */
	font-size: 14px;
}

.pagination h\:commandButton+h\:commandButton {
	/* Remove this, gap handles spacing now */
	margin-left: 0;
}

.pagination h\:outputText { /* Spacing around page number text */
	margin: 0 0px; /* Adjust margin for flexbox */
	font-weight: bold;
	color: #333;
	font-size: 16px;
}

.pagination-label {
	/* Renamed from h:outputText to match the class in the provided pagination */
	font-weight: bold;
	color: #333;
	font-size: 16px;
}

/* No Results Message */
.not-found {
	text-align: center;
	font-weight: bold;
	color: #0077b6;
	margin-top: 60px; /* Ample space if table is not rendered */
	font-size: 1.2em;
	text-shadow: 0.5px 0.5px #ccc;
	width: 100%; /* Ensure it takes full width to center text */
}

input.date-input {
	width: 150px;
	padding: 8px;
	font-size: 14px;
}

input.date-input::-webkit-calendar-picker-indicator {
	display: block;
}
</style>
<!-- Trick: render type="date" via JavaScript -->
<script>
  window.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('input.date-input').forEach(input => {
      input.setAttribute('type', 'date');
    });
  });
</script>

</head>

<body>

	<jsp:include page="/navbar/NavRecipient.jsp" />

	<h2>Show Insurance Details</h2>

	<h:form styleClass="main-content-panel">

		<h:messages globalOnly="true" style="color:red; margin-bottom: 20px;" />

		<h:panelGrid columns="3" styleClass="recipient-input-grid">
			<h:outputLabel for="recipientId" value="Enter Recipient ID:" />
			<h:inputText id="recipientId" value="#{recipientController.hId}" />
			<h:panelGroup styleClass="action-buttons-container">
				<h:commandButton value="Show"
					action="#{recipientController.insuranceDetailscontroller}"
					styleClass="btn btn-primary" />
				<h:commandButton value="Reset"
					action="#{recipientController.resetShow}"
					styleClass="btn btn-secondary" />
			</h:panelGroup>
		</h:panelGrid>

		<div class="filter-buttons-bar">
			<h:commandButton value="Show Active Only"
				action="#{recipientController.filterByCoverageStatus('ACTIVE')}"
				styleClass="btn btn-primary" />
			<h:commandButton value="Show Expired Only"
				action="#{recipientController.filterByCoverageStatus('EXPIRED')}"
				styleClass="btn btn-primary" />
			<h:commandButton value="Reset Filter"
				action="#{recipientController.resetFilter}"
				styleClass="btn btn-secondary" />
		</div>


		<div class="filter-buttons-bar">
			<h:outputLabel for="fromDate" value="From:"
				style="font-weight: bold;" />
			<h:inputText id="fromDate" value="#{recipientController.fromDate}"
				styleClass="date-input">
				<f:convertDateTime pattern="yyyy-MM-dd" />
			</h:inputText>

			<h:outputLabel for="toDate" value="To:" style="font-weight: bold;" />
			<h:inputText id="toDate" value="#{recipientController.toDate}"
				styleClass="date-input">
				<f:convertDateTime pattern="yyyy-MM-dd" />
			</h:inputText>

			<h:commandButton value="Filter by Date Range"
				action="#{recipientController.filterByDateRange}"
				styleClass="btn btn-primary" />
		</div>



		<h:dataTable value="#{recipientController.paginatedInsuranceList}"
			var="insurance" styleClass="data-table"
			rendered="#{not empty recipientController.paginatedInsuranceList}">

			<h:column>
				<f:facet name="header">
					<h:panelGroup styleClass="h-panelgroup">
						<h:outputText value="Patient Name" />
						<h:panelGroup layout="block" styleClass="sort-icons-container">
							<h:commandLink
								action="#{recipientController.sortByAsc('patientName')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/up-arrow.png"
									width="10" height="10" title="Sort-Ascending" />
							</h:commandLink>
							<h:commandLink
								action="#{recipientController.sortByDesc('patientName')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/down-arrow.png"
									width="10" height="10" title="Sort-Descending" />
							</h:commandLink>
						</h:panelGroup>
					</h:panelGroup>
				</f:facet>
				<h:outputText value="#{insurance.patientName}" />
			</h:column>

			<h:column>
				<f:facet name="header">
					<h:panelGroup styleClass="h-panelgroup">
						<h:outputText value="Company" />
						<h:panelGroup layout="block" styleClass="sort-icons-container">
							<h:commandLink
								action="#{recipientController.sortByAsc('companyName')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/up-arrow.png"
									width="10" height="10" title="Sort-Ascending" />
							</h:commandLink>
							<h:commandLink
								action="#{recipientController.sortByDesc('companyName')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/down-arrow.png"
									width="10" height="10" title="Sort-Descending" />
							</h:commandLink>
						</h:panelGroup>
					</h:panelGroup>
				</f:facet>
				<h:outputText value="#{insurance.companyName}" />
			</h:column>

			<h:column>
				<f:facet name="header">
					<h:panelGroup styleClass="h-panelgroup">
						<h:outputText value="Plan" />
						<h:panelGroup layout="block" styleClass="sort-icons-container">
							<h:commandLink
								action="#{recipientController.sortByAsc('planName')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/up-arrow.png"
									width="10" height="10" title="Sort-Ascending" />
							</h:commandLink>
							<h:commandLink
								action="#{recipientController.sortByDesc('planName')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/down-arrow.png"
									width="10" height="10" title="Sort-Descending" />
							</h:commandLink>
						</h:panelGroup>
					</h:panelGroup>
				</f:facet>
				<h:outputText value="#{insurance.planName}" />
			</h:column>

			<h:column>
				<f:facet name="header">
					<h:panelGroup styleClass="h-panelgroup">
						<h:outputText value="Coverage Start" />
						<h:panelGroup layout="block" styleClass="sort-icons-container">
							<h:commandLink
								action="#{recipientController.sortByAsc('coverageStartDate')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/up-arrow.png"
									width="10" height="10" title="Sort-Ascending" />
							</h:commandLink>
							<h:commandLink
								action="#{recipientController.sortByDesc('coverageStartDate')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/down-arrow.png"
									width="10" height="10" title="Sort-Descending" />
							</h:commandLink>
						</h:panelGroup>
					</h:panelGroup>
				</f:facet>
				<h:outputText value="#{insurance.coverageStartDate}">
					<f:convertDateTime pattern="yyyy-MM-dd" />
				</h:outputText>
			</h:column>

			<h:column>
				<f:facet name="header">
					<h:panelGroup styleClass="h-panelgroup">
						<h:outputText value="Coverage End" />
						<h:panelGroup layout="block" styleClass="sort-icons-container">
							<h:commandLink
								action="#{recipientController.sortByAsc('coverageEndDate')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/up-arrow.png"
									width="10" height="10" title="Sort-Ascending" />
							</h:commandLink>
							<h:commandLink
								action="#{recipientController.sortByDesc('coverageEndDate')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/down-arrow.png"
									width="10" height="10" title="Sort-Descending" />
							</h:commandLink>
						</h:panelGroup>
					</h:panelGroup>
				</f:facet>
				<h:outputText value="#{insurance.coverageEndDate}">
					<f:convertDateTime pattern="yyyy-MM-dd" />
				</h:outputText>
			</h:column>

			<h:column>
				<f:facet name="header">
					<h:panelGroup styleClass="h-panelgroup">
						<h:outputText value="Type" />
						<h:panelGroup layout="block" styleClass="sort-icons-container">
							<h:commandLink
								action="#{recipientController.sortByAsc('coverageType')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/up-arrow.png"
									width="10" height="10" title="Sort-Ascending" />
							</h:commandLink>
							<h:commandLink
								action="#{recipientController.sortByDesc('coverageType')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/down-arrow.png"
									width="10" height="10" title="Sort-Descending" />
							</h:commandLink>
						</h:panelGroup>
					</h:panelGroup>
				</f:facet>
				<h:outputText value="#{insurance.coverageType}" />
			</h:column>

			<h:column>
				<f:facet name="header">
					<h:panelGroup styleClass="h-panelgroup">
						<h:outputText value="Status" />
						<h:panelGroup layout="block" styleClass="sort-icons-container">
							<h:commandLink
								action="#{recipientController.sortByAsc('coverageStatus')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/up-arrow.png"
									width="10" height="10" title="Sort-Ascending" />
							</h:commandLink>
							<h:commandLink
								action="#{recipientController.sortByDesc('coverageStatus')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/down-arrow.png"
									width="10" height="10" title="Sort-Descending" />
							</h:commandLink>
						</h:panelGroup>
					</h:panelGroup>
				</f:facet>
				<h:outputText value="#{insurance.coverageStatus}" />
			</h:column>

			<h:column>
				<f:facet name="header">
					<h:panelGroup styleClass="h-panelgroup">
						<h:outputText value="Limit" />
						<h:panelGroup layout="block" styleClass="sort-icons-container">
							<h:commandLink
								action="#{recipientController.sortByAsc('coverageLimit')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/up-arrow.png"
									width="10" height="10" title="Sort-Ascending" />
							</h:commandLink>
							<h:commandLink
								action="#{recipientController.sortByDesc('coverageLimit')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/down-arrow.png"
									width="10" height="10" title="Sort-Descending" />
							</h:commandLink>
						</h:panelGroup>
					</h:panelGroup>
				</f:facet>
				<h:outputText value="#{insurance.coverageLimit}" />
			</h:column>

			<h:column>
				<f:facet name="header">
					<h:panelGroup styleClass="h-panelgroup">
						<h:outputText value="Remaining" />
						<h:panelGroup layout="block" styleClass="sort-icons-container">
							<h:commandLink
								action="#{recipientController.sortByAsc('remaining')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/up-arrow.png"
									width="10" height="10" title="Sort-Ascending" />
							</h:commandLink>
							<h:commandLink
								action="#{recipientController.sortByDesc('remaining')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/down-arrow.png"
									width="10" height="10" title="Sort-Descending" />
							</h:commandLink>
						</h:panelGroup>
					</h:panelGroup>
				</f:facet>
				<h:outputText value="#{insurance.remaining}" />
			</h:column>

			<h:column>
				<f:facet name="header">
					<h:panelGroup styleClass="h-panelgroup">
						<h:outputText value="Claimed" />
						<h:panelGroup layout="block" styleClass="sort-icons-container">
							<h:commandLink
								action="#{recipientController.sortByAsc('claimed')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/up-arrow.png"
									width="10" height="10" title="Sort-Ascending" />
							</h:commandLink>
							<h:commandLink
								action="#{recipientController.sortByDesc('claimed')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/down-arrow.png"
									width="10" height="10" title="Sort-Descending" />
							</h:commandLink>
						</h:panelGroup>
					</h:panelGroup>
				</f:facet>
				<h:outputText value="#{insurance.claimed}" />
			</h:column>

			<h:column>
				<f:facet name="header">
					<h:panelGroup styleClass="h-panelgroup">
						<h:outputText value="Last Claim" />
						<h:panelGroup layout="block" styleClass="sort-icons-container">
							<h:commandLink
								action="#{recipientController.sortByAsc('lastClaimDate')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/up-arrow.png"
									width="10" height="10" title="Sort-Ascending" />
							</h:commandLink>
							<h:commandLink
								action="#{recipientController.sortByDesc('lastClaimDate')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/down-arrow.png"
									width="10" height="10" title="Sort-Descending" />
							</h:commandLink>
						</h:panelGroup>
					</h:panelGroup>
				</f:facet>
				<h:outputText value="#{insurance.lastClaimDate}">
					<f:convertDateTime pattern="yyyy-MM-dd" />
				</h:outputText>
			</h:column>

			<h:column>
				<f:facet name="header">
					<h:outputText value="Action" />
				</f:facet>
				<h:panelGroup rendered="#{insurance.coverageType eq 'FAMILY'}">
					<h:commandButton value="View Members"
						action="#{recipientController.viewMembers(insurance)}"
						styleClass="btn btn-success" />
				</h:panelGroup>
			</h:column>

		</h:dataTable>

		<h:panelGroup
			rendered="#{empty recipientController.paginatedInsuranceList}">
			<div class="not-found">Please enter a Recipient ID and click
				'Show'.</div>
		</h:panelGroup>

		<div class="pagination">
			<h:commandButton value="« Previous"
				action="#{recipientController.previousPage}"
				rendered="#{recipientController.hasPreviousPage}"
				styleClass="btn btn-primary" />
			<h:outputText styleClass="pagination-label"
				value="Page #{recipientController.currentPage} of #{recipientController.totalPages}" />
			<h:commandButton value="Next »"
				action="#{recipientController.nextPage}"
				rendered="#{recipientController.hasNextPage}"
				styleClass="btn btn-primary" />
		</div>
	</h:form>

</body>
	</html>
</f:view>