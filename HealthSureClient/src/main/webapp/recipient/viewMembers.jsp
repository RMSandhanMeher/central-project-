<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsf/core" %>
<%@ taglib prefix="h" uri="http://java.sun.com/jsf/html" %>

<f:view>
<html>
<head>
    <title>Subscribed Family Members</title>
    <style>
        /* Universal Box-Sizing for consistent layout */
        html {
            box-sizing: border-box;
        }
        *, *:before, *:after {
            box-sizing: inherit;
        }

        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f8fcff; /* Light blue background */
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column; /* Stack navbar, heading, and main content vertically */
            align-items: center; /* Center content horizontally on the page */
            min-height: 100vh; /* Ensure body takes full viewport height */
            color: #333; /* Default text color */
        }

        /* Main Heading (H2) Styling */
        h2 {
            text-align: center;
            color: #0077b6; /* Professional blue */
            margin-top: 130px; /* Space from top (adjust if navbar pushes it down too much) */
            margin-bottom: 20px; /* Space between heading and the main content panel */
            font-size: 28px;
            font-weight: 600; /* Slightly bolder for headings */
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
            width: 100%; /* Ensure it spans full width for centering */
        }

        /* The Main Content Panel (the shadowed box for table and pagination) */
        .main-content-panel {
            width: 85%; /* Adjusted width for better aesthetics for table */
            max-width: 1100px; /* Maximum width for larger screens */
            margin-bottom: 40px; /* More space at the bottom */
            background-color: #ffffff; /* White background for the panel */
            border-radius: 12px; /* Rounded corners */
            box-shadow: 0px 8px 24px rgba(0, 0, 0, 0.15); /* Prominent shadow */
            padding: 35px 40px; /* Generous internal padding */
            display: flex;
            flex-direction: column; /* Stack table and pagination vertically */
            align-items: center; /* Center these items horizontally within the panel */
        }

        /* Data Table Styling */
        .data-table {
            width: 100%; /* Table fills the width of its parent (.main-content-panel) */
            margin-top: 0; /* No top margin here as it's within the main panel */
            border-collapse: collapse; /* Remove double borders */
            background-color: #ffffff;
            border-radius: 10px;
            overflow: hidden; /* Ensures rounded corners apply to content */
            box-shadow: 0px 4px 16px rgba(0, 0, 0, 0.08); /* Subtle shadow for the table */
        }

        .data-table th, .data-table td {
            border: 1px solid #cce0eb; /* Lighter border for cells */
            padding: 12px 10px; /* More vertical padding for cells */
            text-align: left; /* Keep text aligned left */
            font-size: 15px; /* Slightly larger font size for table content */
            color: #444; /* Darker text for readability */
        }

        .data-table th {
            background-color: #e0f7fa; /* Very light blue for headers */
            text-align: center; /* Center header text */
            font-weight: 700; /* Bold headers */
            font-size: 16px; /* Larger font for headers */
            color: #0077b6; /* Blue text for headers */
        }

        /* Striped rows */
        .data-table tr:nth-child(even) {
            background-color: #f5fafd; /* Very light blue for even rows */
        }

        /* Hover effect on rows */
        .data-table tr:hover {
            background-color: #e8f7fd; /* Lighter blue on row hover */
        }

        /* Table Header Sort Icons (h:panelGroup for Flexbox) */
        .data-table th .h-panelgroup { /* Target panelGroup inside table header */
            display: flex;
            align-items: center; /* Vertically aligns text and arrow container */
            justify-content: center; /* Horizontally centers content within the header cell */
            gap: 6px; /* Space between text and arrows */
            width: 100%; /* Ensure it takes full width of the th */
        }
        .sort-icons-container {
            display: flex;
            flex-direction: column; /* Stack arrows vertically */
        }
        .sort-icons { /* Applies to commandLink around graphicImage */
            display: block; /* Make links block to stack arrows */
            line-height: 1; /* Remove extra line height for tight stacking */
            padding: 2px 0; /* Small padding for click area */
        }
        .sort-icons img {
            vertical-align: middle; /* Align image nicely */
        }

        /* Pagination Styling */
        .pagination {
            text-align: center;
            margin-top: 30px; /* Space above pagination */
            margin-bottom: 0; /* No bottom margin, handled by main-content-panel */
            font-weight: 600; /* Bolder pagination text */
            color: #0077b6; /* Blue pagination text */
            font-size: 1.1em;
            width: 100%; /* Ensure it spans full width to center elements */
        }
        h\:commandButton {
            padding: 10px 25px; /* Adjust padding for pagination buttons */
            border: none;
            border-radius: 20px; /* Slightly less rounded than main action buttons */
            cursor: pointer;
            font-size: 16px; /* Slightly smaller font for pagination buttons */
            font-weight: 600;
            letter-spacing: 0.5px;
            color: white;
            transition: all 0.3s ease;

            /* Gradient for pagination buttons - using a different, perhaps slightly softer, blue-green */
            background: linear-gradient(to right, #4CAF50, #66BB6A); /* Example: Green gradient for pagination */
            box-shadow: 0 4px 12px rgba(76, 175, 80, 0.3); /* Softer shadow */
        }

        h\:commandButton:hover {
            background: linear-gradient(to right, #43A047, #5cb85c); /* Darker green on hover */
            transform: translateY(-2px); /* Lift effect */
            box-shadow: 0 6px 16px rgba(76, 175, 80, 0.4); /* Stronger shadow on hover */
        }

        h\:commandButton:active {
            transform: translateY(0);
            box-shadow: 0 2px 8px rgba(76, 175, 80, 0.2);
        }

        .pagination h\:commandButton + h\:commandButton { /* Space between pagination buttons */
            margin-left: 20px;
        }
        .pagination-label { /* Spacing around page number text */
            margin: 0 20px;
            color: #333; /* Darker color for page numbers */
        }

    </style>
</head>
<body>

<jsp:include page="/navbar/NavRecipient.jsp"/>


<h2>Subscribed Family Members</h2>

<h:form styleClass="main-content-panel">
    <h:dataTable value="#{recipientController.paginatedMemberList}" var="member"
                 styleClass="data-table" rendered="#{not empty recipientController.paginatedMemberList}">

			<h:column>
				<f:facet name="header">
					<h:panelGroup styleClass="h-panelgroup">
						<h:outputText value="Member Id" />
						<h:panelGroup layout="block" styleClass="sort-icons-container">
							<h:commandLink
								action="#{recipientController.sortByAscMem('memberId')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/up-arrow.png"
									width="10" height="10" />
							</h:commandLink>
							
							<h:commandLink
								action="#{recipientController.sortByDescMem('memberId')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/down-arrow.png"
									width="10" height="10" />
							</h:commandLink>
						</h:panelGroup>
					</h:panelGroup>
				</f:facet>
				<h:outputText value="#{member.memberId }" />
			</h:column>


			<h:column>
				<f:facet name="header">
					<h:panelGroup styleClass="h-panelgroup">
						<h:outputText value="Full Name" />
						<h:panelGroup layout="block" styleClass="sort-icons-container">
							<h:commandLink
								action="#{recipientController.sortByAscMem('fullName')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/up-arrow.png"
									width="10" height="10" />
							</h:commandLink>

							<h:commandLink
								action="#{recipientController.sortByDescMem('fullName')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/down-arrow.png"
									width="10" height="10" />
							</h:commandLink>
						</h:panelGroup>
					</h:panelGroup>
				</f:facet>
				<h:outputText value="#{member.fullName}" />
			</h:column>
			
			
			<h:column>
				<f:facet name="header">
					<h:panelGroup styleClass="h-panelgroup">
						<h:outputText value="Age" />
						<h:panelGroup layout="block" styleClass="sort-icons-container">
							<h:commandLink
								action="#{recipientController.sortByAscMem('age')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/up-arrow.png"
									width="10" height="10" />
							</h:commandLink>

							<h:commandLink
								action="#{recipientController.sortByDescMem('age')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/down-arrow.png"
									width="10" height="10" />
							</h:commandLink>
						</h:panelGroup>
					</h:panelGroup>
				</f:facet>
				<h:outputText value="#{member.age}" />
			</h:column>
			
			
			<h:column>
				<f:facet name="header">
					<h:panelGroup styleClass="h-panelgroup">
						<h:outputText value="Gender" />
						<h:panelGroup layout="block" styleClass="sort-icons-container">
							<h:commandLink
								action="#{recipientController.sortByAscMem('gender')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/up-arrow.png"
									width="10" height="10" />
							</h:commandLink>

							<h:commandLink
								action="#{recipientController.sortByDescMem('gender')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/down-arrow.png"
									width="10" height="10" />
							</h:commandLink>
						</h:panelGroup>
					</h:panelGroup>
				</f:facet>
				<h:outputText value="#{member.gender}" />
			</h:column>
			
			
			<h:column>
				<f:facet name="header">
					<h:panelGroup styleClass="h-panelgroup">
						<h:outputText value="Relation" />
						<h:panelGroup layout="block" styleClass="sort-icons-container">
							<h:commandLink
								action="#{recipientController.sortByAscMem('relationWithProposer')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/up-arrow.png"
									width="10" height="10" />
							</h:commandLink>

							<h:commandLink
								action="#{recipientController.sortByDescMem('relationWithProposer')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/down-arrow.png"
									width="10" height="10" />
							</h:commandLink>
						</h:panelGroup>
					</h:panelGroup>
				</f:facet>
				<h:outputText value="#{member.relationWithProposer}" />
			</h:column>


			<h:column>
				<f:facet name="header">
					<h:panelGroup styleClass="h-panelgroup">
						<h:outputText value="Aadhar No" />
						<h:panelGroup layout="block" styleClass="sort-icons-container">
							<h:commandLink
								action="#{recipeientController.sortByAscMem('aadharNo')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/up-arrow.png"
									width="10" height="10" />
							</h:commandLink>
							
							<h:commandLink
								action="#{recipeientController.sortByDescMem('aadharNo')}"
								styleClass="sort-icons">
								<h:graphicImage value="/resources/media/images/down-arrow.png"
									width="10" height="10" />
							</h:commandLink>
						</h:panelGroup>						
					</h:panelGroup>
				</f:facet>
				<h:outputText value="#{member.aadharNo}" />
			</h:column>

    </h:dataTable>

    <div class="pagination">
			<h:commandButton value="Previous"
				action="#{recipientController.previousMemberPage}"
				rendered="#{recipientController.hasPreviousMemberPage}" />
			<h:outputText styleClass="pagination-label"
				value="Page #{recipientController.memberPage} of #{recipientController.totalMemberPages}" />
			<h:commandButton value="Next"
				action="#{recipientController.nextMemberPage}"
				rendered="#{recipientController.hasNextMemberPage}" />
		</div>
	</h:form>

</body>
</html>
</f:view>