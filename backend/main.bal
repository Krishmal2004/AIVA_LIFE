import ballerina/http;
import ballerinax/java.jdbc;
import backend.services.loginService;

final jdbc:Client dbClient = check new ("jdbc:sqlite:./aiva_life.db");

listener http:Listener listener = new (8080);

function init() returns error? {
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS users (
                                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                                    username TEXT UNIQUE,
                                    password TEXT
                                )`);
                                  
    _ = check dbClient->execute(`INSERT OR IGNORE INTO users (username, password) 
                                 VALUES ('testuser', 'password123')`);

    check ep.attach(new services:LoginService(dbClient), "/api");
}
