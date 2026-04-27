public type LoginRequest record {|
    string username;
    string password;
|};

public type User record {|
    int id;
    string username;
    string email?;
    string password;
|};

public type SignupRequest record {|
    string username;
    string email;
    string password;
|};