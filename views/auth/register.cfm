<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register</title>
    <style>
        /* Reset some default browser styles */
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

        .register-container {
            background-color: #fff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
        }

        .register-container h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #333;
        }

        .register-container input,
        .register-container select,
        .register-container button {
            width: 100%;
            padding: 12px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 16px;
            outline: none;
        }

        .register-container input:focus,
        .register-container select:focus,
        .register-container button:focus {
            border-color: #5b9bd5;
            box-shadow: 0 0 8px rgba(91, 155, 213, 0.5);
        }

        .register-container button {
            background-color: #5b9bd5;
            color: white;
            cursor: pointer;
            border: none;
            font-weight: bold;
        }

        .register-container button:hover {
            background-color: #4682b4;
        }

        /* Responsive Design */
        @media (max-width: 600px) {
            .register-container {
                padding: 20px;
            }
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

    <div class="register-container">
        <h2>Create Account</h2>
        <form id="registerForm">
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>
            <input type="email" name="email" placeholder="Email" required>
            <select name="role">
                <option value="admin">Admin</option>
                <option value="faculty">Faculty</option>
                <option value="staff">Staff</option>
                <option value="student">Student</option>
            </select>
            <button type="submit">Register</button>
        </form>
    </div>

    <script>
        // Handle form submission with AJAX
        $('#registerForm').on('submit', function(event) {
            event.preventDefault();

            var formData = $(this).serialize();  // Serialize the form data

            $.ajax({
                url: '/register-user',
                type: 'POST',
                data: formData,
                success: function(response) {
                    console.log('response : ',response);
                      // Show success message
                    if (response.status === 'success') {
                        // Store the JWT token in localStorage/sessionStorage
                        // localStorage.setItem('authToken', response.token);

                        // Redirect to the home screen
                        // window.location.href = '/home';  // Redirect to home page after registration
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