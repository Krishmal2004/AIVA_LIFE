import ballerina/http;
import ballerina/email;
import backend.models;

public isolated service class EmailService {
    *http:Service;

    private final email:SmtpClient smtpClient;

    public isolated function init() returns error? {
        // Replace with your Gmail address and the 16-character App Password you generated
        string senderEmail = "your.email@gmail.com"; 
        string appPassword = "your_16_char_app_password_here"; 

        // Initialize the SMTP client using Gmail's SMTP server
        self.smtpClient = check new ("smtp.gmail.com", senderEmail, appPassword, port = 465);
    }

    resource function post send(@http:Payload models:EmailRequest req) returns http:Ok|http:InternalServerError {
        
        email:Message emailMessage = {
            to: [req.toAddress],
            subject: req.subject,
            body: req.body
        };

        // Send the email
        error? sendResult = self.smtpClient->sendMessage(emailMessage);

        if sendResult is error {
            models:EmailResponse errRes = { success: false, message: "Failed to send email: " + sendResult.message() };
            return <http:InternalServerError> { body: errRes };
        }

        models:EmailResponse successRes = { success: true, message: "Email sent successfully" };
        return <http:Ok> { body: successRes };
    }
}