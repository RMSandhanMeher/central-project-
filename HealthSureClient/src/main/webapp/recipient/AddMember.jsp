<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsf/core" %>
<%@ taglib prefix="h" uri="http://java.sun.com/jsf/html" %>

<!DOCTYPE html>
<f:view>
<html>
<head>
    <meta charset="UTF-8">
    <title>Patient Registration</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #e6f2f1;
            margin: 0;
            padding: 0;
        }

        .form-container {
            max-width: 700px;
            margin: 60px auto;
            background-color: #ffffff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 128, 128, 0.2);
            border-top: 5px solid #008080;
        }

        h2 {
            text-align: center;
            color: #006d6a;
            margin-bottom: 30px;
        }

        .form-row {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            flex: 1 1 48%;
            display: flex;
            flex-direction: column;
        }

        label {
            font-weight: 600;
            color: #444;
            margin-bottom: 6px;
        }

        input, textarea, select {
            padding: 10px 12px;
            font-size: 14px;
            border: 1px solid #b0c4c4;
            border-radius: 6px;
            background-color: #f9fdfd;
            box-sizing: border-box;
        }

        .date-input {
            padding: 10px 12px;
            font-size: 14px;
            border: 1px solid #b0c4c4;
            border-radius: 6px;
            background-color: #f9fdfd;
            box-sizing: border-box;
            font-family: inherit;
        }

        textarea {
            resize: vertical;
        }

        .form-button {
            width: 100%;
            background-color: #008080;
            color: white;
            border: none;
            padding: 14px;
            font-size: 16px;
            font-weight: bold;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-top: 20px;
        }

        .form-button:hover {
            background-color: #006666;
        }

        .error-message {
            color: #d9534f;
            font-size: 13px;
            margin-top: 4px;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Patient Sign Up</h2>
        <h:form id="form">

            <h:messages globalOnly="true" layout="list" styleClass="error-message" />

            <!-- First Name and Last Name -->
            <div class="form-row">
                <div class="form-group">
                    <label>First Name: <span style="color:red">*</span></label>
                    <h:inputText id="firstName" value="#{recipient.firstName}" />
                    <h:message for="firstName" styleClass="error-message" />
                </div>
                <div class="form-group">
                    <label>Last Name: <span style="color:red">*</span></label>
                    <h:inputText id="lastName" value="#{recipient.lastName}" />
                    <h:message for="lastName" styleClass="error-message" />
                </div>
            </div>

            <!-- Username and Email -->
            <div class="form-row">
                <div class="form-group">
                    <label>User Name: <span style="color:red">*</span></label>
                    <h:inputText id="userName" value="#{recipient.userName}" />
                    <h:message for="userName" styleClass="error-message" />
                </div>
                <div class="form-group">
                    <label>Email: <span style="color:red">*</span></label>
                    <h:inputText id="email" value="#{recipient.email}" />
                    <h:message for="email" styleClass="error-message" />
                </div>
            </div>

            <!-- Mobile and Gender -->
            <div class="form-row">
                <div class="form-group">
                    <label>Mobile: <span style="color:red">*</span></label>
                    <h:inputText id="mobile" value="#{recipient.mobile}" maxlength="10"
                        onkeypress="return event.charCode >= 48 && event.charCode <= 57" />
                    <h:message for="mobile" styleClass="error-message" />
                </div>
                <div class="form-group">
                    <label>Gender: <span style="color:red">*</span></label>
                    <h:selectOneMenu id="gender" value="#{recipient.gender}">
                        <f:selectItem itemLabel="--Select--" itemValue="" />
                        <f:selectItem itemLabel="Male" itemValue="MALE" />
                        <f:selectItem itemLabel="Female" itemValue="FEMALE" />
                        <f:attribute name="label" value="Gender" />
                    </h:selectOneMenu>
                    <h:message for="gender" styleClass="error-message" />
                </div>
            </div>

            <!-- DOB and Address -->
            <div class="form-row">
                <div class="form-group">
                    <label>Date of Birth: <span style="color:red">*</span></label>
                    <input type="date" id="dobHtml" name="dobHtml"
                        min="1950-01-01" max="2025-12-31"
                        onchange="document.getElementById('form:dob').value = this.value;"
                        class="date-input" />
                    <h:inputHidden id="dob" value="#{loginController.recipient.dob}">
                        <f:convertDateTime pattern="yyyy-MM-dd" />
                    </h:inputHidden>
                    <h:message for="dob" styleClass="error-message" />
                </div>
                <div class="form-group">
                    <label>Address:</label>
                    <h:inputTextarea id="address" value="#{loginController.recipient.address}" />
                    <h:message for="address" styleClass="error-message" />
                </div>
            </div>

            <!-- Submit Button -->
            <h:commandButton value="Register Patient" action="#{loginController.addRecipient}" styleClass="form-button" />

        </h:form>
    </div>
</body>
</html>
</f:view>
