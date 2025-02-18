<!-- /views/home/home.cfm -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home</title>
    // <link rel="stylesheet" href="/assets/css/style.css">
</head>
<body>

    <div class="home-container">
        <h2>Welcome to the Home Page</h2>
        <p>Congratulations! You have successfully registered. This is a dummy home page.</p>
        <button onclick="logout()">Logout</button>
    </div>

    <script>
        // Logout functionality
        function logout() {
            localStorage.removeItem('authToken'); // Remove the stored token
            window.location.href = '/auth/register';  // Redirect to register page
        }

        // Example of using the JWT token for an API call
        var token = localStorage.getItem('authToken');
        if (token) {
            // Use the token for further authenticated API requests
            console.log("Token is available:", token);
        }
    </script>

</body>
</html>
