
public type EmailRequest record {|
    string toAddress;
    string subject;
    string body;
|};

public type EmailResponse record {|
    boolean success;
    string message;
|};