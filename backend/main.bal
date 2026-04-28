import ballerina/http;
import ballerinax/java.jdbc;
import backend.services; 

final jdbc:Client dbClient = check new ("jdbc:sqlite:./aiva_life.db");

// ep = end_point
listener http:Listener ep = new (8080);

function init() returns error? {
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS users (
                                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                                    username TEXT UNIQUE,
                                    email TEXT UNIQUE,
                                    password TEXT
                                )`);
                                  
    _ = check dbClient->execute(`INSERT OR IGNORE INTO users (username,email, password) 
                                 VALUES ('testuser', 'testuser@example.com', 'password123')`);


    //Login route 
    check ep.attach(new services:LoginService(dbClient), "/api");
    //Signup route
    check ep.attach(new services:SignupService(dbClient), "/api/signup");
    
    // google auth route - ADDED "check" before "new"
    check ep.attach(check new services:GoogleAuthService(dbClient), "/api/google-auth");
    
    // Email route - ADDED "check" before "new"
    check ep.attach(check new services:EmailService(), "/api/email");
}