<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@ taglib prefix="h" uri="http://java.sun.com/jsf/html"%>

<f:view>
	<html>
<head>
<title>Search Doctors</title>
<style>
/* Your existing CSS (as provided in your last message) goes here */
/* I've added a few specific styles needed for this no-ajax approach */
body {
	font-family: 'Segoe UI', sans-serif;
	background-color: #f8fcff;
	margin: 0;
	padding: 0;
	display: flex;
	flex-direction: column;
	align-items: center;
	min-height: 100vh;
}

.navbar-placeholder { /* This might be redundant if NavRecipient.jsp has its own height */
	width: 100%;
}

h2 {
	text-align: center;
	color: #0077b6;
	margin-top: 95px; /* Adjust based on your NavRecipient.jsp height */
	margin-bottom: 8px;
	font-size: 28px;
	text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
	width: 100%;
}

.main-content-panel {
	width: 75%;
	max-width: 1200px;
	margin-bottom: 20px;
	background-color: #ffffff;
	border-radius: 12px;
	box-shadow: 0px 8px 24px rgba(0, 0, 0, 0.15);
	padding: 30px;
	box-sizing: border-box;
	display: flex;
	flex-direction: column;
	align-items: center;
}

/* --- NEW & IMPROVED BUTTON STYLES --- */
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

.btn-primary {
	background-color: #007bff;
	color: white;
	box-shadow: 0 4px 8px rgba(0, 123, 255, 0.25);
}

.btn-primary:hover {
	background-color: #0069d9;
	box-shadow: 0 6px 12px rgba(0, 123, 255, 0.35);
}

.btn-secondary {
	background-color: #6c757d;
	color: white;
	box-shadow: 0 4px 8px rgba(108, 117, 125, 0.25);
}

.btn-secondary:hover {
	background-color: #5a6268;
	box-shadow: 0 6px 12px rgba(108, 117, 125, 0.35);
}

.btn-success {
	background-color: #28a745;
	color: white;
	padding: 8px 16px;
	font-size: 14px;
	box-shadow: 0 4px 8px rgba(40, 167, 69, 0.25);
}

.btn-success:hover {
	background-color: #218838;
	box-shadow: 0 6px 12px rgba(40, 167, 69, 0.35);
}

.search-buttons {
	text-align: center;
	margin-top: 2px;
	margin-bottom: 30px;
	width: 100%;
	display: flex;
	justify-content: center;
	gap: 20px;
}

.pagination {
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 15px;
	margin: 30px 0 10px 0;
	width: 100%;
}

.pagination-info {
	font-weight: bold;
	color: #333;
	font-size: 16px;
}

.data-table {
	width: 100%;
	margin: 15px 0 0 0;
	margin-top: 0px;
	border-collapse: collapse;
	background-color: #ffffff;
	border-radius: 10px;
	overflow: hidden;
	box-shadow: 0px 4px 16px rgba(0, 0, 0, 0.08);
}

.data-table th, .data-table td {
	border: 1px solid #bcd9ea;
	padding: 10px;
	text-align: left;
	font-size: 14px;
}

.data-table th {
	background-color: #d0f0f3;
	text-align: center;
	font-weight: bold;
	font-size: 15px;
}

.data-table th .h-panelgroup {
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 5px;
}

.data-table tr:nth-child(even) {
	background-color: #f1faff;
}

.data-table tr:hover {
	background-color: #e0f7ff;
}

/* Messages style */
.global-messages {
    list-style: none; /* Remove bullet points */
    padding: 0;
    margin: 0 auto 20px auto; /* Center and provide bottom margin */
    width: 80%; /* Adjust width as needed */
    text-align: center;
}
.global-messages li {
    padding: 10px 15px;
    margin-bottom: 8px;
    border-radius: 5px;
    font-size: 14px;
    font-weight: bold;
    color: #333;
}
.global-messages .ui-messages-info {
    background-color: #d4edda;
    color: bluw;
    border: 1px solid #c3e6cb;
}
.global-messages .ui-messages-warn {
    background-color: #fff3cd;
    color: yellow;
    border: 1px solid #ffeeba;
}
.global-messages .ui-messages-error {
    background-color: #f8d7da;
    color: red;
    border: 1px solid #f5c6cb;
}
.global-messages .ui-messages-fatal {
    background-color: #f8d7da;
    color: red;
    border: 1px solid #f5c6cb;
}


.not-found {
	text-align: center;
	font-weight: bold;
	color: #0077b6;
	margin-top: 20px;
	font-size: 1.2em;
	width: 100%;
}

.sort-icons-container {
	display: flex;
	flex-direction: column;
}
.sort-icons {
	display: block;
	line-height: 2;
	height: 8px; /* Ensure consistent height for arrows */
}

.sort-icons + .sort-icons {
	margin-top: 2px; /* More space between up and down arrows */
}

h\:inputText, h\:selectOneMenu {
	width: 100%;
	padding: 10px 12px;
	font-size: 15px;
	border-radius: 6px;
	border: 1px solid #cce0eb;
	box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.06);
	transition: border-color 0.2s, box-shadow 0.2s;
	box-sizing: border-box;
	/* Custom arrow for selectOneMenu */
    -webkit-appearance: none;
    -moz-appearance: none;
    appearance: none;
    background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path fill="%23666" d="M7 10l5 5 5-5z"/></svg>');
    background-repeat: no-repeat;
    background-position: right 10px center;
    background-size: 18px;
}

h\:inputText:focus, h\:selectOneMenu:focus {
	border-color: #007bff;
	box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.06), 0 0 0 3px
		rgba(0, 123, 255, 0.25);
	outline: none;
}

h\:outputLabel {
	font-weight: bold;
	color: #333;
	text-align: right;
	white-space: nowrap;
}

.search-inputs-grid {
	width: 60%; /* Adjusted for better appearance */
	margin-top: 2px;
	margin-bottom: 8px;
	margin-right: 220px;
	border-collapse: collapse;
}

.search-inputs-grid tr td:first-child {
	width: 35%;
	padding-right: 10px;
	vertical-align: middle;
	text-align: right;
}

.search-inputs-grid tr td:last-child {
	width: 65%;
	vertical-align: middle;
	padding-right: 10px;
}

.search-inputs-grid td {
	padding-top: 6px;
	padding-bottom: 8px;
}

/* New CSS to hide elements */
.hidden {
    display: none;
}

</style>
<!--Toggle for turning on the Specialization DropDown -->
<script type="text/javascript">
    function toggleSearchInput() {
        let by = document.getElementById('searchForm:searchBy').value;
        document.getElementById('searchForm:searchValueInputDiv').classList.toggle('hidden', by === 'specialization');
        document.getElementById('searchForm:specializationDropdownDiv').classList.toggle('hidden', by !== 'specialization');
        let input = document.getElementById('searchForm:searchValueInput'), 
        spec = document.getElementById('searchForm:specializationDropdown');
        if (by === 'specialization' && input) input.value = '';
        if (by !== 'specialization' && spec) spec.value = '';
    }
    window.onload = toggleSearchInput;
</script>

</head>
<body>

	<jsp:include page="/navbar/NavRecipient.jsp" />

	<h2>Search Doctors</h2>

	<h:form id="searchForm" styleClass="main-content-panel">
		<%-- Global messages display --%>
		<h:messages globalOnly="true" styleClass="global-messages" />
		<%-- Message for specific input components --%>
		<h:messages id="searchFieldMessages" for="searchFieldContainer" styleClass="global-messages" />


		<h:panelGrid columns="2" styleClass="search-inputs-grid">
			<h:outputLabel for="searchBy" value="Search By:" />
			<h:selectOneMenu id="searchBy"
				value="#{doctorSearchController.searchBy}" onchange="toggleSearchInput()">
				<f:selectItems value="#{doctorSearchController.searchOptions}" />
			</h:selectOneMenu>

			<h:outputLabel value="Search Value:" for="searchValueInputDiv" />
			<h:panelGroup id="searchValueInputDiv" layout="block">
				<h:inputText id="searchValueInput" value="#{doctorSearchController.searchValue}" />					
			</h:panelGroup>

            <h:panelGroup id="specializationDropdownDiv" layout="block" styleClass="hidden">
                <h:selectOneMenu id="specializationDropdown"
                    value="#{doctorSearchController.selectedSpecialization}">
                    <f:selectItems value="#{doctorSearchController.specializationOptions}" />
                </h:selectOneMenu>
            </h:panelGroup>
		</h:panelGrid>

		<div class="search-buttons">
			<h:commandButton value="Search"
				action="#{doctorSearchController.executeSearch}"
				styleClass="btn btn-primary" />

			<h:commandButton value="Reset"
				action="#{doctorSearchController.resetSearch}"
				styleClass="btn btn-secondary" immediate="true" />
		</div>


		<h:panelGroup
			rendered="#{not empty doctorSearchController.paginatedDoctors}">
			<h:dataTable value="#{doctorSearchController.paginatedDoctors}"
				var="doc" styleClass="data-table">

				<h:column>
					<f:facet name="header">
						<h:panelGroup styleClass="h-panelgroup">
							<h:outputText value="Doctor Name" />
							<h:panelGroup layout="block" styleClass="sort-icons-container">
								<h:commandLink
									action="#{doctorSearchController.sortByAsc('doctorName')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/up-arrow.png"
										width="9" height="9" title="Sort-Ascending" />
								</h:commandLink>

								<h:commandLink
									action="#{doctorSearchController.sortByDesc('doctorName')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/down-arrow.png"
										width="10" height="10" title="Sort-Descending" />
								</h:commandLink>
							</h:panelGroup>
						</h:panelGroup>
					</f:facet>
					<h:outputText value="#{doc.doctorName}" />
				</h:column>


				<h:column>
					<f:facet name="header">
						<h:panelGroup styleClass="h-panelgroup">
							<h:outputText value="Specialization" />
							<h:panelGroup layout="block" styleClass="sort-icons-container">
								<h:commandLink
									action="#{doctorSearchController.sortByAsc('specialization')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/up-arrow.png"
										width="9" height="9" title="Sort-Ascending" />
								</h:commandLink>

								<h:commandLink
									action="#{doctorSearchController.sortByDesc('specialization')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/down-arrow.png"
										width="10" height="10" title="Sort-Descending" />
								</h:commandLink>
							</h:panelGroup>
						</h:panelGroup>
					</f:facet>
					<h:outputText value="#{doc.specialization}" />
				</h:column>


				<h:column>
					<f:facet name="header">
						<h:panelGroup styleClass="h-panelgroup">
							<h:outputText value="Status" />
							<h:panelGroup layout="block" styleClass="sort-icons-container">
								<h:commandLink
									action="#{doctorSearchController.sortByAsc('status')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/up-arrow.png"
										width="9" height="9" title="Sort-Ascending" />
								</h:commandLink>
								<h:commandLink
									action="#{doctorSearchController.sortByDesc('status')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/down-arrow.png"
										width="10" height="10" title="Sort-Descending" />
								</h:commandLink>
							</h:panelGroup>
						</h:panelGroup>
					</f:facet>
					<h:outputText value="#{doc.status}" />
				</h:column>

				<h:column>
					<f:facet name="header">
						<h:panelGroup styleClass="h-panelgroup">
							<h:outputText value="Address" />
							<h:panelGroup layout="block" styleClass="sort-icons-container">
								<h:commandLink
									action="#{doctorSearchController.sortByAsc('address')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/up-arrow.png"
										width="9" height="9" title="Sort-Ascending" />
								</h:commandLink>
								<h:commandLink
									action="#{doctorSearchController.sortByDesc('address')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/down-arrow.png"
										width="10" height="10" title="Sort-Descending" />
								</h:commandLink>
							</h:panelGroup>
						</h:panelGroup>
					</f:facet>
					<h:outputText value="#{doc.address}" />
				</h:column>

				<h:column>
					<f:facet name="header">
						<h:panelGroup styleClass="h-panelgroup">
							<h:outputText value="Type" />
							<h:panelGroup layout="block" styleClass="sort-icons-container">
								<h:commandLink
									action="#{doctorSearchController.sortByAsc('type')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/up-arrow.png"
										width="9" height="9" title="Sort-Ascending" />
								</h:commandLink>
								<h:commandLink
									action="#{doctorSearchController.sortByDesc('type')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/down-arrow.png"
										width="10" height="10" title="Sort-Descending" />
								</h:commandLink>
							</h:panelGroup>
						</h:panelGroup>
					</f:facet>
					<h:outputText value="#{doc.type}" />
				</h:column>

				<h:column>
					<f:facet name="header">
						<h:panelGroup styleClass="h-panelgroup">
							<h:outputText value="Email" />
							<h:panelGroup layout="block" styleClass="sort-icons-container">
								<h:commandLink
									action="#{doctorSearchController.sortByAsc('email')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/up-arrow.png"
										width="9" height="9" title="Sort-Ascending" />
								</h:commandLink>

								<h:commandLink
									action="#{doctorSearchController.sortByDesc('email')}"
									styleClass="sort-icons">
									<h:graphicImage value="/resources/media/images/down-arrow.png"
										width="10" height="10" title="Sort-Descending" />
								</h:commandLink>
							</h:panelGroup>

						</h:panelGroup>
					</f:facet>
					<h:outputText value="#{doc.email}" />
				</h:column>

				<h:column>
					<f:facet name="header">
						<h:outputText value="Book Appointment" />
					</f:facet>
					<h:panelGroup rendered="#{doc.status eq 'ACTIVE'}">
						<h:commandButton value="Book"
							action="#{doctorSearchController.bookDummy}"
							styleClass="btn btn-success" />
					</h:panelGroup>
					<h:outputText rendered="#{doc.status ne 'ACTIVE'}"
						value="Unavailable Now" />
				</h:column>

			</h:dataTable>

			<div class="pagination">
				<h:commandButton value="« Previous"
					action="#{doctorSearchController.prevPage}"
					rendered="#{doctorSearchController.hasPrevPage}"
					styleClass="btn btn-primary" />

				<h:outputText styleClass="pagination-info"
					value="Page #{doctorSearchController.currentPage} of #{doctorSearchController.totalPages}" />

				<h:commandButton value="Next »"
					action="#{doctorSearchController.nextPage}"
					rendered="#{doctorSearchController.hasNextPage}"
					styleClass="btn btn-primary" />
			</div>
		</h:panelGroup>

		<h:panelGroup
			rendered="#{empty doctorSearchController.paginatedDoctors and not doctorSearchController.searchPerformed}">
			<div class="not-found">Kindly Search to Book appointments</div>
		</h:panelGroup>
	</h:form>

</body>
	</html>
</f:view>