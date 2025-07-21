<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsf/core" %>
<%@ taglib prefix="h" uri="http://java.sun.com/jsf/html" %>

<f:view>
<html lang="en">
<head>
    <title>InsuranceCorp | Executive Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        :root {
            --primary: #002b5c;
            --accent: #005a9e;
            --bg: #f4f6f9;
            --card-bg: #ffffff;
            --shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: var(--bg);
            color: #333;
        }

        header {
            background: var(--primary);
            color: white;
            padding: 20px 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        header h1 {
            font-size: 24px;
            margin: 0;
            letter-spacing: 0.5px;
        }

        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .card {
            background: var(--card-bg);
            border-radius: 12px;
            padding: 30px;
            text-align: center;
            box-shadow: var(--shadow);
            transition: transform 0.2s ease-in-out;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .card h2 {
            font-size: 2.6rem;
            margin: 0;
            color: var(--primary);
        }

        .card p {
            margin-top: 10px;
            color: #555;
            font-size: 1rem;
        }

        .carousel {
            position: relative;
            background: linear-gradient(135deg, #e9f1fb, #cfdff2);
            padding: 40px 20px;
            border-radius: 10px;
            box-shadow: var(--shadow);
            text-align: center;
            font-size: 1.4em;
            font-weight: 500;
            color: var(--primary);
            min-height: 100px;
        }

        .nav-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 20px;
            margin-top: 40px;
        }

        .nav-tile {
            background: white;
            border-left: 5px solid var(--accent);
            padding: 20px;
            border-radius: 10px;
            box-shadow: var(--shadow);
            text-align: left;
            font-weight: bold;
            color: #444;
            transition: all 0.2s ease-in-out;
        }

        .nav-tile:hover {
            background: #f0f8ff;
            transform: scale(1.02);
        }

        @media (max-width: 600px) {
            header {
                flex-direction: column;
                align-items: flex-start;
            }

            .carousel {
                font-size: 1.1em;
                padding: 30px 10px;
            }
        }
    </style>
</head>
<body>
<header>
    <h1>InsuranceCorp Executive Dashboard</h1>
    <h:outputText value="Welcome, Admin" />
</header>

<div class="container">
    <!-- Stat Cards -->
    <div class="cards">
        <div class="card">
            <h2>1,280</h2>
            <p>Total Policies</p>
        </div>
        <div class="card">
            <h2>312</h2>
            <p>Active Claims</p>
        </div>
        <div class="card">
            <h2>948</h2>
            <p>Customers</p>
        </div>
    </div>

    <!-- Text Carousel -->
    <div class="carousel" id="carouselMessage">
        Discover smarter coverage options with our 2025 insurance roadmap.
    </div>

    <!-- Quick Navigation Tiles -->
    <div class="nav-grid">
        <div class="nav-tile">🏥 Health Plans</div>
        <div class="nav-tile">📄 Claims Center</div>
        <div class="nav-tile">👤 Customers</div>
        <div class="nav-tile">🧑‍💼 Agents</div>
        <div class="nav-tile">📊 Analytics</div>
        <div class="nav-tile">⚙️ Admin Panel</div>
    </div>
</div>

<script>
    const messages = [
        "Discover smarter coverage options with our 2025 insurance roadmap.",
        "We’ve achieved 98.3% claim settlement ratio in 2024.",
        "Now covering senior citizens up to 85 years of age.",
        "Faster onboarding – get insured in under 5 minutes!",
        "Introducing Family+ Plans with global hospitalization cover."
    ];

    let index = 0;
    const carousel = document.getElementById("carouselMessage");

    setInterval(() => {
        index = (index + 1) % messages.length;
        carousel.innerText = messages[index];
    }, 4000);
</script>
</body>
</html>
</f:view>
