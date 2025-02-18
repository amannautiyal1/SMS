<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <style>
        /* Reuse the styles from your register page */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Arial', sans-serif;
            background-color: #f7f7f7;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .login-container {
            background-color: #fff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
        }

        .login-container h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #333;
        }

        .login-container input,
        .login-container button {
            width: 100%;
            padding: 12px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 16px;
            outline: none;
        }

        .login-container input:focus,
        .login-container button:focus {
            border-color: #5b9bd5;
            box-shadow: 0 0 8px rgba(91, 155, 213, 0.5);
        }

        .login-container button {
            background-color: #5b9bd5;
            color: white;
            cursor: pointer;
            border: none;
            font-weight: bold;
        }

        .login-container button:hover {
            background-color: #4682b4;
        }

        /* Responsive Design */
        @media (max-width: 600px) {
            .login-container {
                padding: 20px;
            }
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

    <div class="login-container">
        <h2>Login</h2>
        <form id="loginForm">
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Login</button>
        </form>
    </div>

    <script>
        // Handle form submission with AJAX
        $('#loginForm').on('submit', function(event) {
            event.preventDefault();

            var formData = $(this).serialize();  // Serialize the form data

            $.ajax({
                url: '/login-user', // API endpoint for login
                type: 'POST',
                data: formData,
                success: function(response) {
                    console.log('response : ', response);
                    // Show success message
                    if (response.status === 'success') {
                        // Store the JWT token in localStorage or sessionStorage
                        // localStorage.setItem('authToken', response.token); // Store JWT token

                        // Redirect to the home screen
                        // window.location.href = '/home';  // Redirect to the home page after login
                    }
                },
                error: function(xhr, status, error) {
                    alert('Error: ' + xhr.responseJSON.message);  // Show error message
                }
            });
        });
    </script>

</body>
</html>
