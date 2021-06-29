<?php
require_once __DIR__ . '/vendor/autoload.php';

use PHPJasper\PHPJasper;

$outputTemp = "temp/" . date('YmdHis') . "/";

$jasper = new PHPJasper;
$input = './jasper_test.jrxml';
$targetReportFile = './pdf';

$db_connection = [
    'driver' => 'mysql',
    'username' => "test",
    'password' => "123456789",
    'host' => "192.168.0.101",
    'database' => "test",
];

$options = [
    'format' => ['pdf'],
    'params' => [
        'p_value' => "test",
    ],
    'db_connection' => $db_connection,
];

// $debug = $jasper->process(
//     $input,
//     $targetReportFile,
//     $options
// )->output();

// print_r($debug);
// die();

$jasper->process(
    $input,
    $targetReportFile,
    $options
)->execute();

if (file_exists($targetReportFile . '.pdf')) {
    header("Content-Type: application/octet-stream");
    header('Content-Disposition: attachment; filename="downloaded.pdf"');
    header("Content-Length: " . filesize("download.pdf"));
    readfile($targetReportFile . '.pdf');
    die();
} else {
    die("Error: File not found.");
}
