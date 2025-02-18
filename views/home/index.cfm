// views/home/index.cfm
<cfoutput>
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Home - Student Management System</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 20px;
                background-color: ##f5f5f5;
            }
            .dashboard {
                max-width: 1200px;
                margin: 0 auto;
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            .welcome-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }
            .logout-btn {
                background-color: ##dc3545;
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 4px;
                cursor: pointer;
            }
        </style>
    </head>
    <body>
        <div class="dashboard">
            <div class="welcome-header">
                <h1>Welcome, <span id="username"></span></h1>
                <button class="logout-btn" onclick="logout()">Logout</button>
            </div>
            <div class="content">
                <p>Role: <span id="userRole"></span></p>
                <p>You have successfully logged in to the Student Management System.</p>
            </div>
        </div>
    
        <script>
            // Check for authentication on page load
            document.addEventListener('DOMContentLoaded', function() {
                const token = localStorage.getItem('authToken');
                if (!token) {
                    window.location.href = '/login';
                    return;
                }
    
                // Decode JWT token (this is a simple decode, not validation)
                const payload = JSON.parse(atob(token.split('.')[1]));
                document.getElementById('username').textContent = payload.username;
                document.getElementById('userRole').textContent = payload.role;
            });
    
            function logout() {
                localStorage.removeItem('authToken');
                window.location.href = '/login';
            }
        </script>
    </body>
    </html>
    </cfoutput>