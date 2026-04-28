import ballerina/http;
import ballerina/sql;
import ballerinax/java.jdbc;
import backend.models;

public isolated service class GoogleAuthService {
    *http:Service;

    private final jdbc:Client dbClient;
    private final http:Client googleClient;

    public isolated function init(jdbc:Client dbClient) returns error? {
        self.dbClient = dbClient;
        self.googleClient = check new ("https://oauth2.googleapis.com");
    }

    resource function post login(@http:Payload models:GoogleLoginRequest req) returns http:Ok|http:Unauthorized|http:InternalServerError {
        
        http:Response|error googleRes = self.googleClient->get("/tokeninfo?id_token=" + req.idToken);

        if googleRes is http:Response && googleRes.statusCode == 200 {
            json|error payload = googleRes.getJsonPayload();
            
            if payload is map<json> {
                json emailJson = payload["email"];
                json nameJson = payload["name"];
                
                if emailJson is string && nameJson is string {
                    string email = emailJson;
                    string name = nameJson;
                    
                    sql:ParameterizedQuery checkUserQuery = `SELECT id, username, email FROM users WHERE email = ${email}`;
                    stream<models:GoogleUser, sql:Error?> resultStream = self.dbClient->query(checkUserQuery);
                    
                    var result = resultStream.next();

                    if result is record {|models:GoogleUser value;|} {

                        sql:Error? closeErr = resultStream.close();
                        
                        models:GoogleAuthResponse successRes = { success: true, message: "Google login successful", userId: result.value.id };
                        return <http:Ok> { body: successRes };
                        
                    } else {
                        sql:ParameterizedQuery insertQuery = `INSERT INTO users (username, email, password) VALUES (${name}, ${email}, 'GOOGLE_OAUTH_ACCOUNT')`;
                        sql:ExecutionResult|sql:Error insertRes = self.dbClient->execute(insertQuery);
                        
                        if insertRes is sql:ExecutionResult {
                            models:GoogleAuthResponse createdRes = { success: true, message: "Google account registered and logged in", userId: insertRes.lastInsertId };
                            return <http:Ok> { body: createdRes };
                        } else {
                            models:GoogleAuthResponse errRes = { success: false, message: "Database error while creating user" };
                            return <http:InternalServerError> { body: errRes };
                        }
                    }
                }
            }
        }
        
        models:GoogleAuthResponse unauthorizedRes = { success: false, message: "Invalid or expired Google Token" };
        return <http:Unauthorized> { body: unauthorizedRes };
    }
}