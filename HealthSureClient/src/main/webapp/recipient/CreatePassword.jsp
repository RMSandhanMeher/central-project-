<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsf/core" prefix="f" %>
<%@ taglib uri="http://java.sun.com/jsf/html" prefix="h" %>

<f:view>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Create Password</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #f0f4f8, #dfe9f3);
            margin: 0;
            padding: 0;
        }

        .form-container {
            max-width: 500px;
            margin: 100px auto;
            background: #ffffff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            border-top: 5px solid #3498db;
        }

        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            font-weight: 600;
            color: #2c3e50;
            display: block;
            margin-bottom: 6px;
        }

        .form-input {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ccd6dd;
            border-radius: 6px;
            font-size: 14px;
            background: #f9f9f9;
            box-sizing: border-box;
        }

        .btn {
            width: 100%;
            background-color: #3498db;
            color: white;
            border: none;
            padding: 14px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-top: 10px;
        }

        .btn:hover {
            background-color: #2d89c8;
        }

        .error-message {
            color: #e74c3c;
            font-size: 12px;
            margin-top: 4px;
        }
    </style>
</head>
<body>
    <h:form>
        <div class="form-container">
            <h2>Create Password</h2>

            <div class="form-group">
                <h:outputLabel for="userName" value="UserName:" styleClass="form-label" />
                <h:inputText id="userName" value="#{loginController.userName}" required="true" styleClass="form-input" />
            </div>

            <div class="form-group">
                <h:outputLabel for="newPassword" value="New Password:" styleClass="form-label" />
                <h:inputSecret id="newPassword" value="#{loginController.password}" required="true" styleClass="form-input" />
            </div>

            <div class="form-group">
                <h:outputLabel for="confirmPassword" value="Confirm Password:" styleClass="form-label" />
                <h:inputSecret id="confirmPassword" value="#{loginController.confirmPassword}" required="true" styleClass="form-input" />
            </div>

            <h:commandButton value="Create Password" action="#{loginController.createPassword}" styleClass="btn" />
            <h:messages globalOnly="true" styleClass="error-message" />
        </div>
    </h:form>
    
       <!-- INCLUDE FOOTER -->
    <jsp:include page="/footer/Footer.jsp" />
    
    
    
</body>
</html>
</f:view>
