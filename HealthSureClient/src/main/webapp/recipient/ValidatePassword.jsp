<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="f" uri="http://java.sun.com/jsf/core" %>
<%@ taglib prefix="h" uri="http://java.sun.com/jsf/html" %>

<!DOCTYPE html>
<f:view>
<html>
<head>
    <meta charset="UTF-8" />
    <title>HealthSure | Validate Temporary Password</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #e6f2f1;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 420px;
            margin: 100px auto;
            background-color: #ffffff;
            padding: 35px 30px;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 128, 128, 0.2);
            text-align: left;
        }

        h2 {
            text-align: center;
            color: #006d6a;
            margin-bottom: 25px;
        }

        .form-row {
            margin-bottom: 18px;
        }

        label {
            font-weight: 600;
            display: block;
            margin-bottom: 6px;
            color: #444;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #b0c4c4;
            border-radius: 6px;
            font-size: 14px;
            background-color: #f9fdfd;
        }

        .btn {
            background-color: #008080;
            color: white;
            padding: 12px;
            width: 100%;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }

        .btn:hover {
            background-color: #006666;
        }

        .error-message {
            color: #d9534f;
            font-size: 13px;
            margin-top: 5px;
        }

        h:messages {
            display: block;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h:form id="form">
            <h2>Validate Temporary Password</h2>

            <!-- Global messages -->
            <h:messages globalOnly="true" styleClass="error-message" />

            <!-- Username -->
            <div class="form-row">
                <h:outputLabel for="username" value="Username:" />
                <h:inputText id="username" value="#{loginController.userName}" />
                <h:message for="username" styleClass="error-message" />
            </div>

            <!-- Temporary Password -->
            <div class="form-row">
                <h:outputLabel for="newPassword" value="Temporary Password:" />
                <h:inputSecret id="newPassword" value="#{loginController.newPassword}" />
                <h:message for="newPassword" styleClass="error-message" />
            </div>

            <!-- Re-enter Temporary Password -->
            <div class="form-row">
                <h:outputLabel for="reEnterPassword" value="Re-enter Temporary Password:" />
                <h:inputSecret id="reEnterPassword" value="#{loginController.reEnterPassword}" />
                <h:message for="reEnterPassword" styleClass="error-message" />
            </div>

            <!-- Submit -->
            <div class="form-row">
                <h:commandButton value="Validate" action="#{loginController.validatePassword}" styleClass="btn" />
            </div>
        </h:form>
    </div>
</body>
</html>
</f:view>