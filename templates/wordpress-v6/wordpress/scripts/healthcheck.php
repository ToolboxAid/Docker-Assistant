#!/opt/bitnami/php/bin/php

<?php

//#!/bin/php

$filename = '/opt/bitnami/wordpress/alive.php';
$copyname = '/bitnami/scripts/alive.php';

if (file_exists($filename)) {
    echo "The file $filename exists";
} else {
	echo "The file $filename does not exist";
    if (!copy($copyname, $filename)) {
        echo "\nfailed to copy $copyfile...\n";
    }
}

echo "\n";

$handle = curl_init();

$url = "http://127.0.0.1:8080/alive.php";

// Set the url
curl_setopt($handle, CURLOPT_URL, $url);

// Set the result  responseto be a string.
curl_setopt($handle, CURLOPT_RETURNTRANSFER, true);

$response= curl_exec($handle);

$httpCode = curl_getinfo($handle, CURLINFO_HTTP_CODE);

if ( $httpCode != 200 ){
	$exit_code = 1;
    echo "Return code is {$httpCode} \n";
//#        .curl_error($handle);
} else {
    $exit_code = 0;
    echo htmlspecialchars($response);
}

curl_close($handle);

echo $response;
print "\n";

echo "Http Code: $httpCode\n";
echo "Exit Code: $exit_code\n";

exit ($exit_code);

?>

