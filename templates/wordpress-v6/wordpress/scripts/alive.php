<?php
/**
 * Check if basic WordPress structure is in place
 * This is to be used for load balancer health checks
 */

// Checks
define('WORDPRESS_CONFIG', __DIR__ . DIRECTORY_SEPARATOR . 'wp-config.php');
define('WORDPRESS_DIRECTORY', __DIR__ . DIRECTORY_SEPARATOR . 'wordpress');
define('WP_CONTENT_DIRECTORY', __DIR__ . DIRECTORY_SEPARATOR . 'wp-content');


// Health Check Flags
$_healthCheckStatus = true;
// Will stop the while loop
$_healthCheckCompleted = false;

// Just to be safe
try {
    // DoWhile loop here to simplify kicking out on a false $_healthCheckStatus
    do {
        // Check if wp-config exists
        if (!file_exists(WORDPRESS_CONFIG)) {
            $_healthCheckStatus = false;
        }

        // Make sure we have required directories
        $_healthCheckStatus = _dirIsValidAndNotEmpty(WORDPRESS_DIRECTORY);
        $_healthCheckStatus = _dirIsValidAndNotEmpty(WP_CONTENT_DIRECTORY);

        // Checks are complete, kick out the loop
        $_healthCheckCompleted = true; // Just say no to infinity and beyond
    } while (false === $_healthCheckCompleted && true === $_healthCheckStatus);
} catch (\Exception $e) {
    // Health check fails
    $_healthCheckStatus = false;
}

// If a bad healthcheck, return 404 to tell the load balancer we suck
if (false === $_healthCheckStatus) {
    header("HTTP/1.0 404 Not Found");
    ?>
	<html>
    <head>
      <title>the fan</title>
    </head>
    <body><h1>Shit is going to hit the fan</h1></body>
    </html>
    <?php
    die();
} else {
    ?>
	<html>
    <head>
      <title>I Look Good!!!</title>
    </head>
    <body><h1>I appear to be healthly</h1></body>
    </html>
    <?php
}

/**
 * Validates a directory and ensures it's not empty
 * @param string $dir
 * @return bool
 */
function _dirIsValidAndNotEmpty($dir) {
    // Make sure we have a directory
    if (is_dir($dir)) {
        // Make sure it's not empty
        $_dirIsNotEmpty = (new \FilesystemIterator($dir))->valid();
        if ($_dirIsNotEmpty) {
            return true;
        }
    }

    return false;
}
