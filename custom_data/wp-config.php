<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * This has been slightly modified (to read environment variables) for use in Docker.
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// IMPORTANT: this file needs to stay in-sync with https://github.com/WordPress/WordPress/blob/master/wp-config-sample.php
// (it gets parsed by the upstream wizard in https://github.com/WordPress/WordPress/blob/f27cb65e1ef25d11b535695a660e7282b98eb742/wp-admin/setup-config.php#L356-L392)

// a helper function to lookup "env_FILE", "env", then fallback
if (!function_exists('getenv_docker')) {
	// https://github.com/docker-library/wordpress/issues/588 (WP-CLI will load this file 2x)
	function getenv_docker($env, $default) {
		if ($fileEnv = getenv($env . '_FILE')) {
			return rtrim(file_get_contents($fileEnv), "\r\n");
		}
		else if (($val = getenv($env)) !== false) {
			return $val;
		}
		else {
			return $default;
		}
	}
}

#echo '---------------------------------------------';
#echo '<br>';
#echo getenv('WORDPRESS_DB_HOST');
#echo '<br>';
#echo getenv('WORDPRESS_DB_PORT_NUMBER');
#echo '<br>';
#echo getenv('WORDPRESS_DATABASE_NAME');
#echo '<br>';
#echo getenv('WORDPRESS_DB_NAME');
#echo '<br>';
#echo getenv('WORDPRESS_DATABASE_USER');
#echo '<br>';
#echo getenv('WORDPRESS_DATABASE_PASSWORD');
#echo '<br>';
#echo getenv('WORDPRESS_TABLE_PREFIX');
#echo '<br>';
#echo '---------------------------------------------';



# created by:setup_docker_wp_site.sh
# david quesenberry

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
//define( 'DB_NAME', getenv_docker('WORDPRESS_DB_NAME', 'wordpress') );
#define( 'DB_NAME', getenv_docker('DB_NAME','breamed$camisards'));
define( 'DB_NAME', getenv('WORDPRESS_DATABASE_NAME'));

/** Database username */
//define( 'DB_USER', getenv_docker('WORDPRESS_DB_USER', 'example username') );
define( 'DB_USER', getenv('WORDPRESS_DATABASE_USER'));


/** Database password */
#define( 'DB_PASSWORD', getenv_docker('WORDPRESS_DB_PASSWORD', 'example password') );
define( 'DB_PASSWORD', getenv('WORDPRESS_DATABASE_PASSWORD'));

/**
 * Docker image fallback values above are sourced from the official WordPress installation wizard:
 * https://github.com/WordPress/WordPress/blob/f9cc35ebad82753e9c86de322ea5c76a9001c7e2/wp-admin/setup-config.php#L216-L230
 * (However, using "example username" and "example password" in your database is strongly discouraged.  Please use strong, random credentials!)
 */

/** Database hostname */

#echo '---------------------------------------------';
#$hello_world = getenv('WORDPRESS_DB_HOST').':'.getenv('WORDPRESS_DB_PORT_NUMBER');
#echo $hello_world; // outputs "Hello World"
#define( 'DB_HOST', getenv_docker('WORDPRESS_DB_HOST', 'mysql') );
#define( 'DB_HOST', $hello_world);
#define( 'DB_HOST', getenv('WORDPRESS_DB_HOST'));
define( 'DB_HOST',  getenv('WORDPRESS_DB_HOST').':'.getenv('WORDPRESS_DB_PORT_NUMBER'));
#echo '---------------------------------------------';

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', getenv('WORDPRESS_DB_CHARSET', 'utf8'));

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', getenv('WORDPRESS_DB_COLLATE', ''));
/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
#define( 'AUTH_KEY',         getenv_docker('WORDPRESS_AUTH_KEY',         'put your unique phrase here') );
#define( 'SECURE_AUTH_KEY',  getenv_docker('WORDPRESS_SECURE_AUTH_KEY',  'put your unique phrase here') );
#define( 'LOGGED_IN_KEY',    getenv_docker('WORDPRESS_LOGGED_IN_KEY',    'put your unique phrase here') );
#define( 'NONCE_KEY',        getenv_docker('WORDPRESS_NONCE_KEY',        'put your unique phrase here') );
#define( 'AUTH_SALT',        getenv_docker('WORDPRESS_AUTH_SALT',        'put your unique phrase here') );
#define( 'SECURE_AUTH_SALT', getenv_docker('WORDPRESS_SECURE_AUTH_SALT', 'put your unique phrase here') );
#define( 'LOGGED_IN_SALT',   getenv_docker('WORDPRESS_LOGGED_IN_SALT',   'put your unique phrase here') );
#define( 'NONCE_SALT',       getenv_docker('WORDPRESS_NONCE_SALT',       'put your unique phrase here') );

// include('config.php');
// include('salt.php');

define('AUTH_KEY',         'v]buxq}CzT!a5JkV@w%STcD_TqF7h7O7cK((,q<jjI]c^p1L<hI#MiflH7(|m(er');
define('SECURE_AUTH_KEY',  'r(BeTZ)Eeu*[6{c7k<M8TFii)A_W*Mi_1gcW!D2#%Fylds:u`@N!u:M%#4V&QY!Q');
define('LOGGED_IN_KEY',    'i4gB[j+e:;Ut^&<En6,IS:|.%SjbO26$WcYew=r8ReU%U=+>Vv:~K)%1||x)K=Zt');
define('NONCE_KEY',        '9B+@ke~KM3FXKar`<k6dJs!H@]X-y+&])t4VDp]T}vIp9yF.%kR+(-}{|+O6/w2z');
define('AUTH_SALT',        '7K`nV[n`MZe@;s$T_`km3-6WK6xJClpCj1EO/VuGQ`&ct9E9~z:}pz-3Jna[-qj@');
define('SECURE_AUTH_SALT', 'E|O+|vZ3a1wO595~5||zmhQA3NQ|uo:HoP0aK4RbS%F=AHLHjrl-JW]qZFl>?/{c');
define('LOGGED_IN_SALT',   'tv-.)xGTVbg1r-|wHXksdSWG#uyEXtwL43#SzF1.9J[Jc),/5*+c5o]tf1+d6SW?');
define('NONCE_SALT',       'egl-`Z+Svstf}XLZ;gpl~GVS4Kn2GxaRaQqKJ^R<k(j=+V}~Mu=ZTt<5aKA5|uM=');

// (See also https://wordpress.stackexchange.com/a/152905/199287)

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
#      - WORDPRESS_TABLE_PREFIX=${TABLE_PREFIX}
#$table_prefix = getenv('TABLE_PREFIX');
#$table_prefix = getenv('WORDPRESS_TABLE_PREFIX');
#define('table_prefix',  getenv('TABLE_PREFIX'));
#define ('table_prefix','$TABLE_PREFIX');
#define ('table_prefix', 'ake_');

$table_prefix=getenv('WORDPRESS_TABLE_PREFIX');

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', !!getenv_docker('WORDPRESS_DEBUG', 'true') );

/* Add any custom values between this line and the "stop editing" line. */

// If we're behind a proxy server and using HTTPS, we need to alert WordPress of that fact
// see also https://wordpress.org/support/article/administration-over-ssl/#using-a-reverse-proxy
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && strpos($_SERVER['HTTP_X_FORWARDED_PROTO'], 'https') !== false) {
	$_SERVER['HTTPS'] = 'on';
}
// (we include this by default because reverse proxying is extremely common in container environments)

if ($configExtra = getenv_docker('WORDPRESS_CONFIG_EXTRA', '')) {
	eval($configExtra);
}

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
