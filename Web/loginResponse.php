<html>
<head>
<link rel="stylesheet" type="text/css" href="css/styles.css">
<title>Ordinem</title>
<link rel="shortcut icon" type="image/png" href="images/favicon.png"/>
<script>
function _ajax_request(url, data, callback, method) {
    return jQuery.ajax({
        url: url,
        type: method,
        data: data,
        success: callback
    });
}
</script>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<script>
jQuery.extend({
    put: function(url, data, callback) {
        return _ajax_request(url, data, callback, 'PUT');
}});
</script>
</head>

<body>
<div align='center'>
<h1 id='header'></h1>
<h3 id='response'>One moment please...</h3>
</div>
<script>
$.put('http://ordinem.ddns.net/api.php/students/<?php echo $_POST["studentID"].trim(); ?>', { 'pointBalance': '20' }, function(result) {
    if (result == 0) {
        $.post('http://ordinem.ddns.net/api.php/students/', { 'studentID': '<?php echo $_POST["studentID"].trim(); ?>', 'email': '<?php echo $_POST["email"].trim(); ?>' }, function(result) {
	    if (result != parseInt(<?php echo $_POST["studentID"].trim(); ?>)) {
	        document.getElementById("header").innerHTML =  "Failure.";
		document.getElementById("response").innerHTML = "Uh oh! <?php echo $_POST["studentID"].trim(); ?>  Looks like we weren't able to add you to the database. Error code 100  <br> <a href='http://ordinem.ddns.net/login.html'>Back to Login</a>";
	    } else {
	        document.getElementById("header").innerHTML = "Success!";
	        document.getElementById("response").innerHTML = "You have checked in to this event, your account now has 20 points!<br> <a href='http://ordinem.ddns.net/login.html'>Back to Login</a>";
	    }
	});

    } else {
	$.post('http://ordinem.ddns.net/api.php/checkins/', { 'checkinID': '<?php echo $_POST["studentID"].trim(); ?>191', 'studentID': '<?php echo $_POST["studentID"].trim(); ?>', 'eventID': '191' }, function(result) {
            console.log(result);
	    if (result != 0) {
                document.getElementById("header").innerHTML =  "Failure.";
                document.getElementById("response").innerHTML = "Uh oh! <?php echo $_POST["studentID"].trim(); ?>  Looks like something went wrong. This could happen if you already ckecked in to this event.<br> <a href='http://ordinem.ddns.net/login.html'>Back to Login</a>";
            } else {
                document.getElementById("header").innerHTML = "Success!";
                document.getElementById("response").innerHTML = "You have checked in to this event, your account now has 20 points!<br> <a href='http://ordinem.ddns.net/login.html'>Back to Login</a>";
            }
        });
    }
});

</script>

</body>
</html>
