<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsf/core" prefix="f" %>
<%@ taglib uri="http://java.sun.com/jsf/html" prefix="h" %>

<f:view>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
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

        .success-message {
            color: green;
            font-size: 16px;
            font-weight: bold;
            text-align: center;
            margin-bottom: 20px;
        }
    </style>

    <script>
        function checkStrength(password) {
            let strengthText = "";
            let color = "";

            const strongRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$/;
            const mediumRegex = /^(?=.*[a-zA-Z])(?=.*\d).{6,}$/;

            if (strongRegex.test(password)) {
                strengthText = "Strong password";
                color = "green";
            } else if (mediumRegex.test(password)) {
                strengthText = "Medium strength password";
                color = "orange";
            } else {
                strengthText = "Weak password";
                color = "red";
            }

            const div = document.getElementById("passwordStrength");
            div.textContent = strengthText;
            div.style.color = color;
        }
    </script>
</head>

<body>
    <h:form id="form">
        <div class="form-container">
            <h2>Create Password</h2>
            
           <h:messages globalOnly="true" styleClass="success-message" />
            
            <!-- Success message and redirection button -->
            <h:panelGroup rendered="#{loginController.passwordCreated}">
                <div class="success-message">
                
                
                     Your password has been created successfully!
                </div>
                <h:commandButton value="Click Me to Login" action="Login.jsp?faces-redirect=true" styleClass="btn" />
            </h:panelGroup>

            <!-- Form shown only if password not created -->
            <h:panelGroup rendered="#{!loginController.passwordCreated}">
                <div class="form-group">
                    <h:outputLabel for="userName" value="UserName:" styleClass="form-label" />
                    <h:inputText id="userName" value="#{loginController.userName}" readonly="true" disabled="true" styleClass="form-input" />
                </div>

                <div class="form-group">
                    <h:outputLabel for="newPassword" value="New Password:" styleClass="form-label" />
                    <h:inputSecret id="newPassword" value="#{loginController.password}" styleClass="form-input" onkeyup="checkStrength(this.value)" />
                    <div id="passwordStrength" class="error-message"></div>
                    <h:message for="newPassword" styleClass="error-message" />
                </div>

                <div class="form-group">
                    <h:outputLabel for="confirmPassword" value="Confirm Password:" styleClass="form-label" />
                    <h:inputSecret id="confirmPassword" value="#{loginController.confirmPassword}" styleClass="form-input" />
                    <h:message for="confirmPassword" styleClass="error-message" />
                </div>

                <h:commandButton value="Create Password" action="#{loginController.createPassword}" styleClass="btn" />

            </h:panelGroup>
        </div>
    </h:form>

    <!-- Footer Include -->
    <jsp:include page="/footer/Footer.jsp" />
</body>
</html>
</f:view>