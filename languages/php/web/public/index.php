<?php
/*
 * public/index.php - PHP web: the page that answers "Hello, World!".
 *
 * Run it with:  ./run.sh   then open http://localhost:8080/
 *
 * Unlike the Flask (Python), Express (Node.js), or Go versions, there is no
 * server code here: no route, no handler function, no listen() call. The
 * PHP built-in web server (started by "php -S" in run.sh) does that part.
 * When a browser asks for "/", the server finds index.php in the public/
 * folder, runs it, and sends whatever this file outputs as the response.
 *
 * That is PHP's original idea: a PHP file is an HTML page with small
 * pieces of code inside "<?php ... ?>" tags. Everything outside the tags is
 * sent to the browser unchanged.
 *
 * This block comment is the only PHP code before the HTML. The closing tag
 * on the next line switches back to plain HTML. PHP also drops the newline
 * right after a closing tag, so the page starts with "<p>".
 */
?>
<p><?php echo "Hello, World!"; ?></p>
