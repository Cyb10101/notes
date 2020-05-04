require ["fileinto"];

# rule:[Global: Move to Spam]
if anyof (
    header :contains "from" "@example.org",
    header :contains "from" "@example.com"
) {
    fileinto "Junk";
}

# rule:[Global: Delete Spam]
if anyof (
    header :contains "from" "@example.org",
    header :contains "from" "@example.com"
) {
    discard;
}
