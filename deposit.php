<?php

# version 1.0

error_reporting( E_ALL );
ini_set( 'display_errors', 1 );
ini_set( 'display_startup_errors', 1 );

function msg( $message, $exit = true ) {
	$text = sprintf( "%s: %s", date( '[d.m.Y H:i:s]' ), $message );
	echo $text . PHP_EOL;
	if ( $exit ) {
		exit;
	}
}

$lockFile = sys_get_temp_dir() . '/deposit.lock';
touch( $lockFile );
$file = fopen( $lockFile, "r+" );

if ( ! $file || ! flock( $file, LOCK_EX | LOCK_NB ) ) {
	msg( "Автодепозит уже запущен" );
}

$exec = exec( '/usr/bin/yarn --cwd ~/ironfish/ironfish-cli/ start accounts:balance', $output, $code );
if ( $code ) {
	msg( "Нет возможности запросить баланс, code $code" );
}

$pattern = '|Amount available to spend: \$IRON (\d+\.\d+)|';
if ( ! preg_match( $pattern, implode( '', $output ), $matches ) ) {
	msg( "Нет монет((" );
}

$balance = (float) $matches[1];

if ( $balance < 0.10000001 ) {
	msg( "Нет монет ((" );
}

msg( "Досьупно для отправки: $balance", false );

while ( true ) {
	$exec = exec( '/usr/bin/yarn --cwd ~/ironfish/ironfish-cli/ start deposit --confirm', $output, $code );

	if ( $code ) {
		msg( "Нет возможности сделать депозит, код: $code" );
	}

	msg( "=== DДепозит выполнен: ===" . PHP_EOL . implode( PHP_EOL, $output ), false );
}
