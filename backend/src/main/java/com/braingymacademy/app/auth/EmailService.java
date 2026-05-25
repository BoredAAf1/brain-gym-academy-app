package com.braingymacademy.app.auth;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

@Service
public class EmailService {

    @Value("${BREVO_API_KEY:local_dummy_key}")
    private String brevoApiKey;

    public void sendPasswordResetEmail(String toEmail, String otp) {


        String htmlBody = "<p>Hello,</p>" +
                "<p>You have requested to reset your password for Brain Gym Academy.</p>" +
                "<p>Your reset code is: <strong>" + otp + "</strong></p>" +
                "<p>This code will expire in 1 hour.</p>" +
                "<p>If you did not request this password reset, please ignore this email.</p>" +
                "<p>Best regards,<br>Brain Gym Academy Team</p>";

        // The JSON payload required by Brevo's API
        String jsonPayload = """
                {
                    "sender": {"name": "Brain Gym Academy", "email": "mohnishpathak.2011@gmail.com"},
                    "to": [{"email": "%s"}],
                    "subject": "Password Reset Request - Brain Gym Academy",
                    "htmlContent": "%s"
                }
                """.formatted(toEmail, htmlBody);

        try {
            HttpClient client = HttpClient.newHttpClient();
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create("https://api.brevo.com/v3/smtp/email"))
                    .header("accept", "application/json")
                    .header("api-key", brevoApiKey)
                    .header("content-type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(jsonPayload))
                    .build();

            // Send the HTTP request to bypass the Render firewall
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            // Print the result to Render logs
            if (response.statusCode() >= 200 && response.statusCode() < 300) {
                System.out.println("OTP Email sent successfully to " + toEmail + " via Brevo API!");
            } else {
                System.err.println("Brevo API rejected the email. Status: " + response.statusCode() + " Body: " + response.body());
            }

        } catch (Exception e) {
            System.err.println("Critical error sending HTTP email: " + e.getMessage());
        }
    }
}
