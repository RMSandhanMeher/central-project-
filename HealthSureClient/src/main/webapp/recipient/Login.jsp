<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsf/html" prefix="h" %>
<%@ taglib uri="http://java.sun.com/jsf/core" prefix="f" %>

<f:view>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - HealthSure</title>
    <link rel="stylesheet" type="text/css" href="css/login.css" />
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #0072ff, #00c6ff);
            margin: 0;
            padding: 0;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-form {
            background-color: #ffffff;
            padding: 40px 30px;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 128, 128, 0.2);
            width: 100%;
            max-width: 420px;
        }

        .form-container h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #006d6a;
        }

        .form-group {
            margin-bottom: 18px;
        }

        label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
            color: #444;
        }

        input[type="text"], input[type="password"], input[type="email"] {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
            background-color: #f9fdfd;
            box-sizing: border-box;
        }

        input:invalid {
            border-color: #d9534f;
        }

        .btn {
            width: 100%;
            padding: 12px;
            background-color: #008080;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }

        .btn:hover {
            background-color: #006666;
        }

        .forgot-link {
            margin-top: 10px;
            text-align: center;
            color: #008080;
        }

        .forgot-link a {
            text-decoration: none;
            color: #0072ff;
            font-size: 14px;
        }

        .forgot-link a:hover {
            text-decoration: underline;
        }

        .error-messages {
            color: #d9534f;
            margin-top: 5px;
            font-size: 13px;
        }
    </style>
</head>

<body>

	<jsp:include page="/navbar/Navbar.jsp"/>
    <h:form styleClass="login-form">
        <div class="form-container">
            <h2>Login to HealthSure</h2>

            <!-- Email -->
            <div class="form-group">
                <h:outputLabel for="email" value="Email:" />
                <h:inputText id="email" value="#{loginController.email}" required="true" requiredMessage="Email is required" />
            </div>

            <!-- Username -->
            <div class="form-group">
                <h:outputLabel for="userName" value="Username:" />
                <h:inputText id="userName" value="#{loginController.userName}" required="true" requiredMessage="Username is required" />
            </div>

            <!-- Password -->
            <div class="form-group">
                <h:outputLabel for="password" value="Password:" />
                <h:inputSecret id="password" value="#{loginController.password}" required="true" requiredMessage="Password is required" />
            </div>

            <!-- Login Button -->
            <div class="form-group button-row">
                <h:commandButton value="Login" action="#{loginController.login}" styleClass="btn" />
            </div>

            <!-- Forgot Password Link -->
            <div class="forgot-link">
                <h:outputLink value="ForgotPassword.jsf" styleClass="text-red-500 hover:underline font-semibold">
                    Forget Password
                </h:outputLink>
            </div>

            <!-- Error Messages -->
            <div class="error-messages">
                <h:messages globalOnly="true" layout="list" />
            </div>
        </div>
    </h:form>
</body>

</html>
</f:view>
