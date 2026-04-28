public type GoogleLoginRequest record {|
    string idToken;
|};

public type GoogleUser record {|
    int id;
    string username;
    string email;
|};

public type GoogleAuthResponse record {|
    boolean success;
    string message;
    int|string userId?;
|};