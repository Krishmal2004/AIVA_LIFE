import ballerina/http;
import ballerina/sql;
import ballerinax/java.jdbc;
import backend.models;

public isolated service class SignupService {
    *http:Service;
    private final jdbc:Client dbClient;

    public isolated function init(jdbc:Client dbClient) {
        self.dbClient = dbClient;
    }

    resource function post signup(@http:Payload models:SignupRequest req) returns http:Created|http:BadRequest|http:InternalServerError {
        
        sql:ParameterizedQuery query = `INSERT INTO users (username, email, password) VALUES (${req.username}, ${req.email}, ${req.password})`;
        
        sql:ExecutionResult|sql:Error result = self.dbClient->execute(query);
        
        if result is sql:ExecutionResult {
            return <http:Created> {
                body: {
                    success: true,
                    message: "user account created successfully."
                }
            };
        } else {
            return <http:BadRequest> {
                body: {
                    success: false,
                    message: "username or email already exists."
                }
            };
        }
    }
}