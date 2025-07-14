<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsf/core" %>
<%@ taglib prefix="h" uri="http://java.sun.com/jsf/html" %>

<!DOCTYPE html>
<f:view>
<html>
<head>
    <title>Forgot Password - HealthSure</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f1f1f1;
            margin: 0;
            padding: 0;
        }

        .forgot-container {
            max-width: 450px;
            background-color: #fff;
            padding: 25px;
            margin: 50px auto;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            border-radius: 10px;
        }

        .forgot-container h2 {
            text-align: center;
            color: #0077cc;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            font-weight: bold;
        }

        .form-group input {
            width: 100%;
            padding: 10px;
            box-sizing: border-box;
        }

        .btn-submit {
            background-color: #0077cc;
            color: white;
            border: none;
            padding: 10px;
            width: 100%;
            cursor: pointer;
            font-size: 16px;
            margin-top: 10px;
            border-radius: 5px;
        }

        .btn-submit:hover {
            background-color: #005fa3;
        }

        .error {
            color: red;
            font-size: 13px;
        }

        h:messages {
            color: red;
        }
    </style>
</head>
<body>
    <div class="forgot-container">
        <h2>Forgot Password</h2>

        <h:form id="forgotForm">
            <h:messages globalOnly="true" layout="list" styleClass="error" />

            <div class="form-group">
                <h:outputLabel for="userName" value="Username:" />
                <h:inputText id="userName" value="#{recipient.userName}" required="true"
                             requiredMessage="Username is required" />
            </div>

            <div class="form-group">
                <h:outputLabel for="email" value="Email:" />
                <h:inputText id="email" value="#{recipient.email}" required="true"
                             requiredMessage="Email is required" />
            </div>

            <div class="form-group">
                <h:outputLabel for="otp" value="OTP:" />
                <h:inputText id="otp" value="#{Otp.otpCode}" required="true"
                             requiredMessage="OTP is required" />
            </div>

            <h:commandButton value="Verify & Generate Password" action="#{loginController.forgotPassword}"
                             styleClass="btn-submit" />

            <br/><br/>

            <h:commandButton value="Resend OTP" action="#{loginController.resendOtp}" styleClass="btn-submit" />
        </h:form>
    </div>
</body>
</html>
</f:view>
  