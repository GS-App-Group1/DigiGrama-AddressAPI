isolated function validateNIC(string nic) returns error? {
    if (nic == "") {
        return error("NIC cannot be empty");
    }

    if (nic.length() < 10 || nic.length() > 12) {
        return error("Invalid NIC");
    }
}
