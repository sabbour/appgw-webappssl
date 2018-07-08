<?php header("Cache-Control: no-cache, must-revalidate"); ?>
<html>
	<head>
		<title>Azure Application Gateway + Multi-tenant Azure Web App test</title>
	</head>
	<body>
		<h2><?php echo date("Y-m-d h:i:sa"); ?></h2>
		<h3>Request details</h3>
		<ul>
			<li>HTTP_HOST: <?= getenv('HTTP_HOST'); ?></li>
			<li>HTTP_X_ORIGINAL_HOST: <?= getenv('HTTP_X_ORIGINAL_HOST'); ?></li>
			<li>HTTP_WAS_DEFAULT_HOSTNAME: <?= getenv('HTTP_WAS_DEFAULT_HOSTNAME'); ?></li>
			<li>HTTP_X_CLIENT_IP: <?= getenv('HTTP_X_CLIENT_IP'); ?></li>
			<li>HTTP_CLIENT_IP: <?= getenv('HTTP_CLIENT_IP'); ?></li>
			<li>REMOTE_ADDR: <?= getenv('REMOTE_ADDR'); ?></li>
			<li>HTTP_X_FORWARDED_FOR: <?= getenv('HTTP_X_FORWARDED_FOR'); ?></li>
			<li>HTTP_X_FORWARDED_PROTO: <?= getenv('HTTP_X_FORWARDED_PROTO'); ?></li>
			<li>HTTP_X_FORWARDED_PORT: <?= getenv('HTTP_X_FORWARDED_PORT'); ?></li>
		</ul>
	</body>
</html>