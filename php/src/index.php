<?php
 echo "<p>Legacy user: {$_SERVER['PHP_AUTH_USER']}</p>";
 echo "<p>Bonjour, {$_SERVER['SSL_CLIENT_S_DN_G']} ({$_SERVER['SSL_CLIENT_SAN_OTHER_msUPN_0']}).</p>";

 echo "<pre>";
 print_r($_SERVER);
 echo "</pre>";
?>
