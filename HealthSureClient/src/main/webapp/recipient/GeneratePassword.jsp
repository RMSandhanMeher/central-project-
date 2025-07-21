<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="f" uri="http://java.sun.com/jsf/core" %>
<%@ taglib prefix="h" uri="http://java.sun.com/jsf/html" %>
<!DOCTYPE html>
<f:view>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Generate Password</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #e6f2f1;
            margin: 0;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
        }

        .container {
            width: 100%;
            max-width: 420px;
            background-color: #ffffff;
            padding: 35px 30px;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 128, 128, 0.2);
        }

        h2 {
            text-align: center;
            color: #006d6a;
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
            color: #444;
        }

        input[type="text"] {
            width: 100%;
            padding: 10px 12px;
            margin-bottom: 18px;
            border: 1px solid #b0c4c4;
            border-radius: 6px;
            font-size: 14px;
            background-color: #f9fdfd;
        }

        input[readonly] {
            background-color: #f0f0f0;
            color: #666;
            cursor: not-allowed;
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
            margin-top: 10px;
        }

        .btn:hover {
            background-color: #006666;
        }

        .error-message {
            color: #d9534f;
            font-size: 13px;
            margin-top: -10px;
            margin-bottom: 10px;
            display: block;
        }

        .link {
            margin-top: 12px;
            text-align: center;
        }

        .link a {
            color: #008080;
            text-decoration: underline;
            font-weight: 600;
        }

        #timer {
            font-size: 13px;
            color: #666;
            margin-top: 6px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Generate New Password</h2>
        <h:form id="form">
            <h:panelGrid columns="1" cellpadding="0" style="width:100%;">

                <label for="email">Email</label>
                <h:inputText id="email" value="#{loginController.email}" readonly="true" />
                <h:message for="email" styleClass="error-message" />

                <label for="otp">Enter OTP</label>
                <h:inputText id="otp" value="#{loginController.otpCode}" maxlength="5"
                             onkeypress="return event.charCode >= 48 && event.charCode <= 57" />
                <h:message for="otp" styleClass="error-message" />

                <h:commandButton value="Submit" action="#{loginController.generatePassword}" styleClass="btn" />

                <div class="link">
                    <h:commandLink id="resendOtpLink" value="Resend OTP" action="#{loginController.resendOtp}" />
                    <div id="timer"></div>
                </div>
                

                 <h:commandButton value="Back" action="#{loginController.backToSignup}" />
                

                <h:messages globalOnly="true" layout="table" style="color:red;" />

            </h:panelGrid>
        </h:form>
    </div>

  <script type="text/javascript">
    let seconds = 30;
    let interval;

    function startTimer() {
        const resendBtn = document.getElementById("form:resendOtpLink");
        const timerLabel = document.getElementById("timer");

        if (!resendBtn || !timerLabel) return;

        // Disable the resend button
        resendBtn.style.pointerEvents = 'none';
        resendBtn.style.color = 'gray';

        // Start countdown
        interval = setInterval(function () {
            if (seconds === 0) {
                clearInterval(interval);
                resendBtn.style.pointerEvents = 'auto';
                resendBtn.style.color = '#008080';
                timerLabel.innerText = "You can now resend OTP.";
            } else {
                timerLabel.innerText = seconds + " sec";
                seconds--;
            }
        }, 1000);
    }

    window.onload = startTimer;
</script>

</body>
</html>
</f:view>
          