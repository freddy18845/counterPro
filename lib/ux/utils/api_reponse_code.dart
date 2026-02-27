final List<Map<String, String>> responseCodes = [
  {"code": "00", "text": "Approved"},

  // General Declines
  {"code": "01", "text": "General Decline"},
  {"code": "02", "text": "Format Error"},
  {"code": "03", "text": "Duplicate Entry"},
  {"code": "04", "text": "Transaction Pending"},
  {"code": "05", "text": "Transaction Cancelled"},
  {"code": "06", "text": "Record Update Error/Failed"},

  // Security and Authentication Exceptions
  {"code": "10", "text": "Invalid Security Key"},
  {"code": "11", "text": "Invalid Security Token"},
  {"code": "12", "text": "Security Token Expired"},
  {"code": "13", "text": "Invalid User Credentials"},
  {"code": "14", "text": "Sign On Required"},
  {"code": "15", "text": "Security Violation"},
  {"code": "16", "text": "Invalid MAC"},
  {"code": "17", "text": "Cryptographic Error"},

  // Parametrization Declines
  {"code": "20", "text": "Invalid Or Unsupported Transaction Type"},
  {"code": "21", "text": "Invalid Amount Or Currency Format"},
  {"code": "22", "text": "Invalid Merchant"},
  {"code": "23", "text": "Invalid Terminal"},
  {"code": "24", "text": "Invalid Acquiring Network"},
  {"code": "25", "text": "Invalid Receiving Network"},
  {"code": "26", "text": "Invalid Currency"},
  {"code": "29", "text": "Suspected Fraud"},

  // Transactional Declines
  {"code": "30", "text": "PAN Invalid, Missing Or Blocked"},
  {"code": "31", "text": "PAN Blocked"},
  {"code": "32", "text": "Capture Card"},
  {"code": "33", "text": "PAN Expired"},
  {"code": "34", "text": "Incorrect PIN"},
  {"code": "35", "text": "PIN Tries Exceeded"},
  {"code": "36", "text": "Limit Exceeded"},
  {"code": "37", "text": "Account Invalid, Missing Or Blocked"},
  {"code": "38", "text": "Insufficient Funds"},
  {"code": "39", "text": "Insufficient Teller Balance"},
  {"code": "40", "text": "Invalid Cheque"},
  {"code": "41", "text": "Original Transaction Not Found"},
  {"code": "42", "text": "Original Transaction Not Processed Or Not Approved"},
  {"code": "43", "text": "Original Transaction Already Reversed"},
  {"code": "44", "text": "Invalid Or Unmatched Response Received"},

  // System Exceptions
  {"code": "50", "text": "Endpoint Unavailable"},
  {"code": "51", "text": "Function Blocked Or Not Permitted"},
  {"code": "52", "text": "Function Not Supported"},
  {"code": "53", "text": "Function Currently Not Available"},
  {"code": "54", "text": "Service Currently Not Available"},
  {"code": "55", "text": "Transaction Timeout"},
];
