<?php

/*
 *  OVERVIEW
 *
 *  env.local.php exists due to dynamic platform.sh DB password generation. Since the SW prioritizes .env.local.php over
 *  plain .env file, we're using .env.local.php as proxy to .env file, with addition of appending the configuration
 *  with dynamically generated DATABASE_URL.
 * */

// Helper function to parse .env file and convert it into an associative array
function parseEnv($filePath) {
    $envArray = [];
    $lines = file($filePath, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    foreach ($lines as $line) {
        if (strpos(trim($line), '#') === 0) {
            continue; // Skip comments
        }
        list($key, $value) = explode('=', $line, 2);
        $envArray[$key] = $value;
    }
    return $envArray;
}

// Path to the .env file
$envFilePath = __DIR__ . '/.env';

// Retrieve the PLATFORM_RELATIONSHIPS environment variable
$encodedRelationships = getenv('PLATFORM_RELATIONSHIPS');

// Get all values from ./.env and prepare an array to be returned
$outputArr = parseEnv($envFilePath);

if ($encodedRelationships) {
    $jsonRelationships = base64_decode($encodedRelationships);
    $relationships = json_decode($jsonRelationships, true);

    // Determine the key name in PLATFORM_RELATIONSHIPS for database
    // by combining branch  name (main/stage) with "database" suffix to get relation name
    $databaseKey = getenv('PLATFORM_BRANCH') . 'database'; // Modify if needed
    if (isset($relationships[$databaseKey])) {
        $dbData = $relationships[$databaseKey][0];

        // Crafting the DATABASE_URL
        $outputArr['DATABASE_URL'] = sprintf(
            'mysql://%s:%s@%s:%d/%s',
            $dbData['username'],
            $dbData['password'],
            $dbData['host'],
            $dbData['port'],
            $dbData['path']
        );
    }
}

return $outputArr;
