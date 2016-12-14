
<form method="post" action="api.php/">
  <input name="token" value=
    <?php
      require 'auth.php';

      $auth = new PHP_API_AUTH(array(
        'secret'=>'1QAZ2WSX3EDC4RFV5TGB6YHN7UJM8IK9OL0P',
        'authenticator'=>function($user,$pass){ if ($user=='ordinem' && $pass=='password') $_SESSION['user']=$user; }
      ));
      $auth->executeCommand();
    ?>/>
  <input type="submit" value="ok">
</form>
