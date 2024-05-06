<?php

// Retrieve domain parameter
$domain = isset($argv[1]) ? $argv[1] : null;

if (!$domain) {
    die("Domain parameter not provided.\n");
}

// Retrieve database credentials from environment variable
$databaseUrl = getenv('DATABASE_URL');

if (!$databaseUrl) {
    die("DATABASE_URL environmental variable not set.\n");
}

// Parse database URL
$dbParams = parse_url($databaseUrl);

// Extract database credentials
$dbHost = $dbParams['host'];
$dbPort = $dbParams['port'];
$dbName = ltrim($dbParams['path'], '/');
$dbUser = $dbParams['user'];
$dbPass = $dbParams['pass'];

// Connect to the database
$pdo = new PDO("mysql:host=$dbHost;port=$dbPort;dbname=$dbName", $dbUser, $dbPass);

// Prepare SQL statement for updating HTTP URLs
$stmtHttp = $pdo->prepare("UPDATE sales_channel_domain SET url = :newHttpDomain WHERE url LIKE 'http://%' AND url IS NOT NULL;");
$stmtHttp->bindParam(':newHttpDomain', $newHttpDomain, PDO::PARAM_STR);

// Prepare SQL statement for updating HTTPS URLs
$stmtHttps = $pdo->prepare("UPDATE sales_channel_domain SET url = :newHttpsDomain WHERE url LIKE 'https://%' AND url IS NOT NULL;");
$stmtHttps->bindParam(':newHttpsDomain', $newHttpsDomain, PDO::PARAM_STR);

// Execute SQL statement for HTTP URLs
$newHttpDomain = "http://$domain";
$stmtHttp->execute();

// Get the affected rows for HTTP URLs
$affectedHttpCount = $stmtHttp->rowCount();

// Execute SQL statement for HTTPS URLs
$newHttpsDomain = "https://$domain";
$stmtHttps->execute();

// Get the affected rows for HTTPS URLs
$affectedHttpsCount = $stmtHttps->rowCount();

// Print changes
echo "Changes:\n";

// Fetch and print changes for HTTP URLs
$stmtHttpSelect = $pdo->query("SELECT sales_channel_id, url FROM sales_channel_domain WHERE url LIKE 'http://%' AND url IS NOT NULL;");
while ($row = $stmtHttpSelect->fetch(PDO::FETCH_ASSOC)) {
    echo "Changing sales channel domain from " . $row['url'] . " to $newHttpDomain\n";
}

// Fetch and print changes for HTTPS URLs
$stmtHttpsSelect = $pdo->query("SELECT sales_channel_id, url FROM sales_channel_domain WHERE url LIKE 'https://%' AND url IS NOT NULL;");
while ($row = $stmtHttpsSelect->fetch(PDO::FETCH_ASSOC)) {
    echo "Changing sales channel domain from " . $row['url'] . " to $newHttpsDomain\n";
}