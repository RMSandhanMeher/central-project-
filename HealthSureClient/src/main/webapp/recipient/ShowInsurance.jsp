<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@ taglib prefix="h" uri="http://java.sun.com/jsf/html"%>

<f:view>
	<html>
<head>
<title>Show Insurance Details</title>
<link
	href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
	rel="stylesheet">
<style>
/* Basic Reset & Body Styling */
body {
	font-family: 'Poppins', sans-serif; /* Modern font */
	background-color: #eef2f7; /* Light, calming background */
	margin: 0;
	padding: 0;
	display: flex;
	flex-direction: column;
	align-items: center;
	min-height: 100vh;
	color: #333;
}

/* Page Title */
h2 {
	text-align: center;
	color: #0056b3; /* Deeper blue for headings */
	margin-top: 100px; /* Adjust for navbar */
	margin-bottom: 25px; /* More space below title */
	font-size: 32px; /* Larger title */
	font-weight: 600; /* Slightly bolder */
	letter-spacing: -0.5px;
}

/* Main Content Panel */
.main-content-panel {
	width: 90%; /* Cover more page width */
	max-width: 1800px; /* Increased max-width */
	margin-bottom: 30px;
	background-color: #ffffff;
	border-radius: 16px; /* More rounded corners */
	box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
	/* Softer, larger shadow */
	padding: 40px; /* Increased padding */
	box-sizing: border-box;
	display: flex;
	flex-direction: column;
	align-items: center;
}

/* Recipient ID Input Grid */
.recipient-input-grid {
	width: 70%;
	margin: 15px auto 25px auto;
	border-collapse: separate;
	border-spacing: 0 15px;
}

.recipient-input-grid tr td:first-child {
	width: 30%;
	padding-right: 20px;
	vertical-align: middle;
	text-align: right;
	font-weight: 500;
	color: #555;
	font-size: 15px;
}

.recipient-input-grid tr td:nth-child(2) {
	width: 35%; /* Adjust input width */
	vertical-align: middle;
}

.recipient-input-grid tr td:last-child {
	width: 35%; /* Adjust buttons width */
	vertical-align: middle;
}

/* Input & Select Common Styles */
.recipient-input-grid input[type="text"] {
	width: 100%;
	padding: 12px 18px;
	font-size: 16px;
	border: 1px solid #dcdfe6;
	border-radius: 8px;
	transition: border-color 0.3s ease, box-shadow 0.3s ease;
	outline: none;
	background-color: #f9fbff;
}

.recipient-input-grid input[type="text"]:focus {
	border-color: #4a90e2;
	box-shadow: 0 0 0 4px rgba(74, 144, 226, 0.2);
	background-color: #ffffff;
}

/* Button Styles - Adjusted for smaller size */
.btn {
	padding: 10px 20px; /* Slightly smaller buttons */
	border: none;
	border-radius: 8px;
	cursor: pointer;
	font-size: 15px; /* Slightly smaller font */
	font-weight: 500;
	text-decoration: none;
	display: inline-block;
	transition: background-color 0.3s ease, transform 0.2s ease;
	letter-spacing: 0.5px;
	outline: none;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.btn:hover {
	transform: translateY(-2px);
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
}

.btn:active {
	transform: translateY(0);
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.btn-primary {
	background-color: #007bff;
	color: white;
}

.btn-primary:hover {
	background-color: #0069d9;
}

.btn-secondary {
	background-color: #6c757d;
	color: white;
}

.btn-secondary:hover {
	background-color: #5a6268;
}

.btn-success {
	background-color: #28a745;
	color: white;
	padding: 8px 18px; /* Even smaller for table buttons */
	font-size: 13px;
}

.btn-success:hover {
	background-color: #218838;
}

.action-buttons-container {
	display: flex;
	gap: 15px; /* Space between Show and Reset buttons */
	justify-content: flex-start;
	align-items: center;
}

.filter-buttons-bar {
	width: 100%;
	display: flex;
	justify-content: center;
	gap: 15px; /* Reduced space between filter buttons */
	margin-top: 15px;
	margin-bottom: 25px; /* Space before table */
	flex-wrap: wrap; /* Allow wrapping on smaller screens */
	align-items: center;
}

.filter-buttons-bar .date-filter-group {
	display: flex;
	align-items: center;
	gap: 10px;
}

input.date-input {
	padding: 10px 15px;
	font-size: 15px;
	border: 1px solid #dcdfe6;
	border-radius: 8px;
	outline: none;
	transition: border-color 0.3s ease, box-shadow 0.3s ease;
	background-color: #f9fbff;
	-webkit-appearance: none;
	-moz-appearance: none;
	appearance: none;
}

input.date-input:focus {
	border-color: #4a90e2;
	box-shadow: 0 0 0 4px rgba(74, 144, 226, 0.2);
	background-color: #ffffff;
}

/* Data Table Styling */
.data-table {
	width: 100%;
	margin-top: 20px;
	border-collapse: collapse;
	background-color: #ffffff;
	border-radius: 12px;
	overflow: hidden;
	box-shadow: 0 6px 20px rgba(0, 0, 0, 0.07);
}

.data-table th, .data-table td {
	border: 1px solid #e9ecef;
	padding: 15px 10px; /* Reduced horizontal padding for more columns */
	text-align: center; /* Center align table data for consistency */
	font-size: 14px;
}

.data-table th {
	background-color: #f8f9fa;
	text-align: center;
	font-weight: 600;
	color: #495057;
	font-size: 15px;
	position: sticky;
	top: 0;
	z-index: 10;
}

.data-table th .h-panelgroup {
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 8px;
}

.data-table tr:nth-child(even) {
	background-color: #fcfdff;
}

.data-table tr:hover {
	background-color: #eef7ff;
}

/* Status Specific Styling - UPDATED TO MATCH UPPERCASE STATUS */
.status-ACTIVE { /* Specific class for active status */
	font-weight: 600;
	color: #28a745; /* Green for active */
}

.status-EXPIRED { /* Specific class for expired status */
	font-weight: 500;
	color: #dc3545; /* Red for expired */
}

/* Sort Icons */
.sort-icons-container {
	display: flex;
	flex-direction: column;
	margin-left: 5px;
}

.sort-icons {
	display: block;
	line-height: 1;
}

.sort-icons+.sort-icons {
	margin-top: 4px;
}

.sort-icons img {
	filter: invert(50%) sepia(0%) saturate(10%) hue-rotate(0deg)
		brightness(50%) contrast(100%);
	opacity: 0.7;
	transition: opacity 0.2s ease;
}

.sort-icons:hover img {
	opacity: 1;
	filter: invert(30%) sepia(0%) saturate(10%) hue-rotate(0deg)
		brightness(30%) contrast(100%);
}

/* Pagination Styles */
.pagination {
	display: flex;
	align-items: center;
	justify-content: flex-end; /* Align to the right */
	gap: 15px;
	margin: 25px 0 0 0;
	width: 100%;
}

.pagination .btn {
	padding: 8px 15px;
	font-size: 13px;
	border-radius: 6px;
	box-shadow: none;
	background-color: #f0f4f8;
	color: #4a90e2;
}

.pagination .btn:hover {
	background-color: #e0e7ed;
	transform: none;
	box-shadow: none;
}

.pagination .btn:active {
	background-color: #d0d6dd;
}

.pagination .btn:disabled {
	/* Use :disabled for JSF disabled attribute */
	opacity: 0.6;
	cursor: not-allowed;
	background-color: #f8f9fa;
	color: #99aab5;
}

.pagination-label {
	font-weight: 400;
	color: #777;
	font-size: 14px;
	margin: 0 10px;
}

/* Highlight effect and cursor pointer for clickable FAMILY rows */
.data-table tr.family-row:hover {
	cursor: pointer;
	background-color: #d6eaff;
}

/* Global Messages */
.global-messages {
	list-style: none;
	padding: 0;
	margin: 0 auto 30px auto;
	width: 90%;
	text-align: center;
}

.global-messages li {
	padding: 15px 20px;
	margin-bottom: 12px;
	border-radius: 10px;
	font-size: 15px;
	font-weight: 500;
	color: #333;
	border: 1px solid;
}

.global-messages .ui-messages-info {
	background-color: #d4edda;
	color: #155724;
	border-color: #c3e6cb;
}

.global-messages .ui-messages-warn {
	background-color: #fff3cd;
	color: #856404;
	border-color: #ffeeba;
}

.global-messages .ui-messages-error, .global-messages .ui-messages-fatal
	{
	background-color: #f8d7da;
	color: #721c24;
	border-color: #f5c6cb;
}

/* No results / Initial message */
.not-found {
	text-align: center;
	font-weight: 500;
	color: #555;
	margin-top: 30px;
	font-size: 1.1em;
	width: 100%;
	padding: 20px;
	background-color: #f0f4f8;
	border-radius: 10px;
	border: 1px solid #dcdfe6;
}
</style>

<script type="text/javascript">
    // Script to ensure type="date" for date inputs
    window.addEventListener('DOMContentLoaded', () => {
        document.querySelectorAll('input.date-input').forEach(input => {
            input.setAttribute('type', 'date');
        });
    });

    // Function to scroll to the table (will only apply after full page load if needed)
    function scrollToTable() {
        const table = document.querySelector('.data-table');
        if (table) {
            const offset = 80; // Adjust for navbar height
            const tablePosition = table.getBoundingClientRect().top + window.pageYOffset - offset;
            window.scrollTo({
                top: tablePosition,
                behavior: 'smooth'
            });
        }
    }

    // Call scroll to table on page load if the table is rendered
    window.onload = function() {
        const table = document.querySelector('.data-table');
        if (table) {
            scrollToTable();
        }
    };
</script>

</head>
<body>

	<jsp:include page="/navbar/NavRecipient.jsp" />

	<h2>Show Insurance Details</h2>

	<h:form id="insuranceForm" styleClass="main-content-panel">
		


		<%-- Filter Buttons (ALWAYS RENDERED NOW) --%>
		<h:panelGroup layout="block" styleClass="filter-buttons-bar">
			<h:commandButton value="Show Active Only"
				action="#{showincController.filterByCoverageStatus('ACTIVE')}"
				styleClass="btn btn-primary" />
			<h:commandButton value="Show Expired Only"
				action="#{showincController.filterByCoverageStatus('EXPIRED')}"
				styleClass="btn btn-primary" />

			<h:panelGroup layout="block" styleClass="date-filter-group">
				<h:outputLabel for="fromDate" value="From:" />
				<h:inputText id="fromDate" value="#{showincController.fromDate}"
					styleClass="date-input">
					<f:convertDateTime pattern="yyyy-MM-dd" />
				</h:inputText>

				<h:outputLabel for="toDate" value="To:" />
				<h:inputText id="toDate" value="#{showincController.toDate}"
					styleClass="date-input">
					<f:convertDateTime pattern="yyyy-MM-dd" />
				</h:inputText>

				<h:commandButton value="Filter by Date"
					action="#{showincController.filterByDateRange}"
					styleClass="btn btn-primary" />
			</h:panelGroup>

			<h:commandButton value="Reset Filters"
				action="#{showincController.resetFilter}"
				styleClass="btn btn-secondary" />
		</h:panelGroup>




        
		<h:panelGroup
			rendered="#{empty showincController.insuranceData}"
			style="margin-top: 15px; color: darkred; font-weight: bold;">
			<h:outputText
				value="No insurance records found. Please subscribe to a plan." />
		</h:panelGroup>




		<!-- Patient Name -->
			<h:dataTable id="insuranceTable"
				value="#{showincController.insuranceData}"
				var="insurance" styleClass="data-table"
				rendered="#{not empty showincController.insuranceData}">

				<!-- 1. Patient Name -->
				<h:column>
					<f:facet name="header">
						<h:panelGroup styleClass="h-panelgroup">
							<h:outputText value="Patient Name" />
							<h:panelGroup layout="block" styleClass="sort-icons-container">
								<h:commandLink
									action="#{showincController.sortByAsc('patientName')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/up-arrow.png"
										width="10" height="10" />
								</h:commandLink>
								<h:commandLink
									action="#{showincController.sortByDesc('patientName')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/down-arrow.png"
										width="10" height="10" />
								</h:commandLink>
							</h:panelGroup>
						</h:panelGroup>
					</f:facet>
					<h:panelGroup rendered="#{insurance.coverageType eq 'FAMILY'}">
						<h:commandLink
							action="#{showincController.viewMembers(insurance)}"
							style="display:block; text-decoration:none; color:inherit;">
							<h:outputText value="#{insurance.patientName}" />
						</h:commandLink>
					</h:panelGroup>
					<h:panelGroup rendered="#{insurance.coverageType ne 'FAMILY'}">
						<h:outputText value="#{insurance.patientName}" />
					</h:panelGroup>
				</h:column>

				<!-- 2. Company -->
				<h:column>
					<f:facet name="header">
						<h:panelGroup styleClass="h-panelgroup">
							<h:outputText value="Company" />
							<h:panelGroup layout="block" styleClass="sort-icons-container">
								<h:commandLink
									action="#{showincController.sortByAsc('companyName')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/up-arrow.png" 
										width="10" height="10" />
								</h:commandLink>
								<h:commandLink
									action="#{showincController.sortByDesc('companyName')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/down-arrow.png"
										width="10" height="10" />
								</h:commandLink>
							</h:panelGroup>
						</h:panelGroup>
					</f:facet>
					<h:panelGroup rendered="#{insurance.coverageType eq 'FAMILY'}">
						<h:commandLink
							action="#{showincController.viewMembers(insurance)}"
							style="display:block; text-decoration:none; color:inherit;">
							<h:outputText value="#{insurance.companyName}" />
						</h:commandLink>
					</h:panelGroup>
					<h:panelGroup rendered="#{insurance.coverageType ne 'FAMILY'}">
						<h:outputText value="#{insurance.companyName}" />
					</h:panelGroup>
				</h:column>

				<!-- 3. Plan -->
				<h:column>
					<f:facet name="header">
						<h:panelGroup styleClass="h-panelgroup">
							<h:outputText value="Plan" />
							<h:panelGroup layout="block" styleClass="sort-icons-container">
								<h:commandLink
									action="#{showincController.sortByAsc('planName')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/up-arrow.png"
										width="10" height="10" />
								</h:commandLink>
								<h:commandLink
									action="#{showincController.sortByDesc('planName')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/down-arrow.png"
										width="10" height="10" />
								</h:commandLink>
							</h:panelGroup>
						</h:panelGroup>
					</f:facet>
					<h:panelGroup rendered="#{insurance.coverageType eq 'FAMILY'}">
						<h:commandLink
							action="#{showincController.viewMembers(insurance)}"
							style="display:block; text-decoration:none; color:inherit;">
							<h:outputText value="#{insurance.planName}" />
						</h:commandLink>
					</h:panelGroup>
					<h:panelGroup rendered="#{insurance.coverageType ne 'FAMILY'}">
						<h:outputText value="#{insurance.planName}" />
					</h:panelGroup>
				</h:column>

				<!-- 4. Coverage Start -->
				<h:column>
					<f:facet name="header">
						<h:panelGroup styleClass="h-panelgroup">
							<h:outputText value="Coverage Start" />
							<h:panelGroup layout="block" styleClass="sort-icons-container">
								<h:commandLink
									action="#{showincController.sortByAsc('coverageStartDate')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/up-arrow.png"
										width="10" height="10" />
								</h:commandLink>
								<h:commandLink
									action="#{showincController.sortByDesc('coverageStartDate')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/down-arrow.png"
										width="10" height="10" />
								</h:commandLink>
							</h:panelGroup>
						</h:panelGroup>
					</f:facet>
					<h:panelGroup rendered="#{insurance.coverageType eq 'FAMILY'}">
						<h:commandLink
							action="#{showincController.viewMembers(insurance)}"
							style="display:block; text-decoration:none; color:inherit;">
							<h:outputText value="#{insurance.coverageStartDate}">
								<f:convertDateTime pattern="yyyy-MM-dd" />
							</h:outputText>
						</h:commandLink>
					</h:panelGroup>
					<h:panelGroup rendered="#{insurance.coverageType ne 'FAMILY'}">
						<h:outputText value="#{insurance.coverageStartDate}">
							<f:convertDateTime pattern="yyyy-MM-dd" />
						</h:outputText>
					</h:panelGroup>
				</h:column>

				<!-- 5. Coverage End -->
				<h:column>
					<f:facet name="header">
						<h:panelGroup styleClass="h-panelgroup">
							<h:outputText value="Coverage End" />
							<h:panelGroup layout="block" styleClass="sort-icons-container">
								<h:commandLink
									action="#{showincController.sortByAsc('coverageEndDate')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/up-arrow.png"
										width="10" height="10" />
								</h:commandLink>
								<h:commandLink
									action="#{showincController.sortByDesc('coverageEndDate')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/down-arrow.png"
										width="10" height="10" />
								</h:commandLink>
							</h:panelGroup>
						</h:panelGroup>
					</f:facet>
					<h:panelGroup rendered="#{insurance.coverageType eq 'FAMILY'}">
						<h:commandLink
							action="#{showincController.viewMembers(insurance)}"
							style="display:block; text-decoration:none; color:inherit;">
							<h:outputText value="#{insurance.coverageEndDate}">
								<f:convertDateTime pattern="yyyy-MM-dd" />
							</h:outputText>
						</h:commandLink>
					</h:panelGroup>
					<h:panelGroup rendered="#{insurance.coverageType ne 'FAMILY'}">
						<h:outputText value="#{insurance.coverageEndDate}">
							<f:convertDateTime pattern="yyyy-MM-dd" />
						</h:outputText>
					</h:panelGroup>
				</h:column>

				<!-- 6. Type -->
				<h:column>
					<f:facet name="header">
						<h:panelGroup styleClass="h-panelgroup">
							<h:outputText value="Type" />
							<h:panelGroup layout="block" styleClass="sort-icons-container">
								<h:commandLink
									action="#{showincController.sortByAsc('coverageType')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/up-arrow.png"
										width="10" height="10" />
								</h:commandLink>
								<h:commandLink
									action="#{showincController.sortByDesc('coverageType')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/down-arrow.png"
										width="10" height="10" />
								</h:commandLink>
							</h:panelGroup>
						</h:panelGroup>
					</f:facet>
					<h:panelGroup rendered="#{insurance.coverageType eq 'FAMILY'}">
						<h:commandLink
							action="#{showincController.viewMembers(insurance)}"
							style="display:block; text-decoration:none; color:inherit;">
							<h:outputText value="#{insurance.coverageType}" />
						</h:commandLink>
					</h:panelGroup>
					<h:panelGroup rendered="#{insurance.coverageType ne 'FAMILY'}">
						<h:outputText value="#{insurance.coverageType}" />
					</h:panelGroup>
				</h:column>

				<!-- 7. Status -->
				<h:column>
					<f:facet name="header">
						<h:panelGroup styleClass="h-panelgroup">
							<h:outputText value="Status" />
							<h:panelGroup layout="block" styleClass="sort-icons-container">
								<h:commandLink
									action="#{showincController.sortByAsc('coverageStatus')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/up-arrow.png"
										width="10" height="10" />
								</h:commandLink>
								<h:commandLink
									action="#{showincController.sortByDesc('coverageStatus')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/down-arrow.png"
										width="10" height="10" />
								</h:commandLink>
							</h:panelGroup>
						</h:panelGroup>
					</f:facet>
					<h:panelGroup rendered="#{insurance.coverageType eq 'FAMILY'}">
						<h:commandLink
							action="#{showincController.viewMembers(insurance)}"
							style="display:block; text-decoration:none; color:inherit;">
							<h:outputText value="#{insurance.coverageStatus}"
								styleClass="status-#{insurance.coverageStatus}" />
						</h:commandLink>
					</h:panelGroup>
					<h:panelGroup rendered="#{insurance.coverageType ne 'FAMILY'}">
						<h:outputText value="#{insurance.coverageStatus}"
							styleClass="status-#{insurance.coverageStatus}" />
					</h:panelGroup>
				</h:column>

				<!-- 8. Limit -->
				<h:column>
					<f:facet name="header">
						<h:panelGroup styleClass="h-panelgroup">
							<h:outputText value="Limit" />
							<h:panelGroup layout="block" styleClass="sort-icons-container">
								<h:commandLink
									action="#{showincController.sortByAsc('coverageLimit')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/up-arrow.png"
										width="10" height="10" />
								</h:commandLink>
								<h:commandLink
									action="#{showincController.sortByDesc('coverageLimit')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/down-arrow.png"
										width="10" height="10" />
								</h:commandLink>
							</h:panelGroup>
						</h:panelGroup>
					</f:facet>
					
					<h:panelGroup rendered="#{insurance.coverageType eq 'FAMILY'}">
						<h:commandLink
							action="#{showincController.viewMembers(insurance)}"
							style="display:block; text-decoration:none; color:inherit;">
							<h:outputText value="#{insurance.coverageLimit}" />
						</h:commandLink>
					</h:panelGroup>
					
					<h:panelGroup rendered="#{insurance.coverageType ne 'FAMILY'}">
						<h:outputText value="#{insurance.coverageLimit}" />
					</h:panelGroup>
				</h:column>

				<!-- 9. Remaining -->
				<h:column>
					<f:facet name="header">
						<h:panelGroup styleClass="h-panelgroup">
							<h:outputText value="Remaining" />
							<h:panelGroup layout="block" styleClass="sort-icons-container">
								<h:commandLink
									action="#{showincController.sortByAsc('remaining')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/up-arrow.png"
										width="10" height="10" />
								</h:commandLink>
								<h:commandLink
									action="#{showincController.sortByDesc('remaining')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/down-arrow.png"
										width="10" height="10" />
								</h:commandLink>
							</h:panelGroup>
						</h:panelGroup>
					</f:facet>
					<h:panelGroup rendered="#{insurance.coverageType eq 'FAMILY'}">
						<h:commandLink
							action="#{showincController.viewMembers(insurance)}"
							style="display:block; text-decoration:none; color:inherit;">
							<h:outputText value="#{insurance.remaining}" />
						</h:commandLink>
					</h:panelGroup>
					<h:panelGroup rendered="#{insurance.coverageType ne 'FAMILY'}">
						<h:outputText value="#{insurance.remaining}" />
					</h:panelGroup>
				</h:column>

				<!-- 10. Claimed -->
				<h:column>
					<f:facet name="header">
						<h:panelGroup styleClass="h-panelgroup">
							<h:outputText value="Claimed" />
							<h:panelGroup layout="block" styleClass="sort-icons-container">
								<h:commandLink
									action="#{showincController.sortByAsc('claimed')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/up-arrow.png"
										width="10" height="10" />
								</h:commandLink>
								<h:commandLink
									action="#{showincController.sortByDesc('claimed')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/down-arrow.png"
										width="10" height="10" />
								</h:commandLink>
							</h:panelGroup>
						</h:panelGroup>
					</f:facet>
					<h:panelGroup rendered="#{insurance.coverageType eq 'FAMILY'}">
						<h:commandLink
							action="#{showincController.viewMembers(insurance)}"
							style="display:block; text-decoration:none; color:inherit;">
							<h:outputText value="#{insurance.claimed}" />
						</h:commandLink>
					</h:panelGroup>
					<h:panelGroup rendered="#{insurance.coverageType ne 'FAMILY'}">
						<h:outputText value="#{insurance.claimed}" />
					</h:panelGroup>
				</h:column>

				<!-- 11. Last Claim -->
				<h:column>
					<f:facet name="header">
						<h:panelGroup styleClass="h-panelgroup">
							<h:outputText value="Last Claim" />
							<h:panelGroup layout="block" styleClass="sort-icons-container">
								<h:commandLink
									action="#{showincController.sortByAsc('lastClaimDate')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/up-arrow.png"
										width="10" height="10" />
								</h:commandLink>
								<h:commandLink
									action="#{showincController.sortByDesc('lastClaimDate')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/down-arrow.png"
										width="10" height="10" />
								</h:commandLink>
							</h:panelGroup>
						</h:panelGroup>
					</f:facet>
					
					<h:panelGroup rendered="#{insurance.coverageType eq 'FAMILY'}">
						<h:commandLink
							action="#{showincController.viewMembers(insurance)}"
							style="display:block; text-decoration:none; color:inherit;">
							<h:outputText value="#{insurance.lastClaimDate}">
								<f:convertDateTime pattern="yyyy-MM-dd" />
							</h:outputText>
						</h:commandLink>
					</h:panelGroup>
					
					<h:panelGroup rendered="#{insurance.coverageType ne 'FAMILY'}">
						<h:outputText value="#{insurance.lastClaimDate}">
							<f:convertDateTime pattern="yyyy-MM-dd" />
						</h:outputText>
					</h:panelGroup>
				</h:column>




			</h:dataTable>
			<!-- Close the dataTable properly -->

			<!-- Move pagination OUTSIDE the dataTable -->
		<h:panelGroup id="paginationPanel"
			rendered="#{not empty showincController.insuranceData}"
			layout="block" styleClass="pagination">
			<h:commandButton value="« Previous"
				action="#{showincController.previousPage}"
				disabled="#{not showincController.hasPreviousPage}"
				styleClass="btn btn-primary" />

			<h:outputText styleClass="pagination-label"
				value="Page #{showincController.currentPage} of #{showincController.totalPages}" />

			<h:commandButton value="Next »"
				action="#{showincController.nextPage}"
				disabled="#{not showincController.hasNextPage}"
				styleClass="btn btn-primary" />
		</h:panelGroup>
		
		<h:panelGroup
    rendered="#{not empty showincController.insuranceData}"
    layout="block"
    style="width: 100%; text-align: left; padding-bottom:2px; margin: 2px 0 0 0; font-size: 14px; color: #666; font-weight: 500;">
    <h:outputText value="#{showincController.paginationIncSummary}" />
</h:panelGroup>
		
	</h:form>
	<!-- ✅ Properly closing form -->

</body>
	</html>
</f:view>