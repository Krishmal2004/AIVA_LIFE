import ballerina/http;
import ballerina/sql;
import ballerinax/java.jdbc;
import backend.models; 

public isolated service class LoginService {
    *http:Service;

    private final jdbc:Client dbClient;

    public isolated function init(jdbc:Client dbClient) {
        self.dbClient = dbClient; 
    }

    resource function post login(@http:Payload models:LoginRequest req) returns http:Ok|http:Unauthorized|http:InternalServerError {
        sql:ParameterizedQuery query = `SELECT id, username, password FROM users WHERE username = ${req.username}`;
        
        stream<models:User, sql:Error?> resultStream = self.dbClient->query(query);

        record {|
            models:User value;
        |}|error? result = resultStream.next();

        if result is record {|models:User value;|} {
            models:User dbUser = result.value;
            error? closeErr = resultStream.close();
            
            if dbUser.password == req.password {
                return <http:Ok> { 
                    body: { success: true, message: "Login successful", userId: dbUser.id } 
                };
            } else {
                return <http:Unauthorized> { body: { success: false, message: "Invalid credentials" } };
            }
        } else if result is error {
            return <http:InternalServerError> { body: { success: false, message: "Database error" } };
        } else {
            return <http:Unauthorized> { body: { success: false, message: "User not found" } };
        }
    }
}