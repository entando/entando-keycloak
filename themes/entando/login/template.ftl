<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
  <meta charset="utf-8">
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <meta name="robots" content="noindex, nofollow">

  <title>${msg("loginTitle",(realm.displayName!''))}</title>
  <link href="${url.resourcesPath}/img/favicon-entando.png" rel="icon"/>
  <link href="${url.resourcesPath}/css/login.css" rel="stylesheet" type="text/css">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

  <script>
  function showPassword() {
    var x = document.getElementById("password-field");
    var y = document.getElementById("img-eye");
    if (x.type === "password") {
      x.type = "text";
      y.style.backgroundImage = "url('${url.resourcesPath}/img/eye-open.png')";
    } else {
      x.type = "password";
      y.style.backgroundImage = "url('${url.resourcesPath}/img/eye-blind.svg')";
    }
  }
  </script>


</head>

<body>
    <#assign aDateTime = .now>
    <#assign aDate = aDateTime?date>
     <div class="LoginPage__topBar">
             <div class="LoginPage__topBarIconLogout"></div>
             <div class="LoginPage__topBarLabelLogin">Login</div>
             <div class="LoginPage__topBarLogo"></div>
     </div>
    <div class="LoginPage">

      <form class="LoginPage__form" action="${url.loginAction}" method="post">

        <div class="LoginPage__brand">
          <div class="LoginPage__logo">Welcome to Octo SmartPath</div>
        </div>
        <div class="LoginPage__formGroup">
          <div class="LoginPage__inputGroup">
            <input type="text" name="username" tabindex="1" class="LoginPage__input" id="username" placeholder="E-mail o username" />
          </div>
          <div class="LoginPage__inputGroup extra-margin">
            <input type="password" id="password-field" name="password" tabindex="2" class="LoginPage__input" id="password" placeholder="Password" />
            <div class="LoginPage__inputGroupEye">
                <div id="img-eye" class="LoginPage__inputGroupEyeImage" onclick="showPassword();"> </div>
            </div>
            <div class="LoginPage__recoveryPassword">
                <#if realm.resetPasswordAllowed>
                    <span><a tabindex="5" href="${url.loginResetCredentialsUrl}">${msg("doForgotPassword")}</a></span>
                </#if>
            </div>

          <#if message?has_content>
            <div class="LoginPage__error">${message.summary?no_esc}</div>
            <div class="LoginPage__actionGroup" style="margin-top: 0;">
              <button class="LoginPage__button" type="submit">${msg("doLogIn")}</button>
              <div class="LoginPage__loading">
                <div class="LoginPage__spinner" />
              </div>
            </div>
          <#else>
            <div class="LoginPage__actionGroup">
              <button class="LoginPage__button" type="submit">${msg("doLogIn")}</button>
              <div class="LoginPage__loading">
                <div class="LoginPage__spinner" />
              </div>
            </div>
          </#if>
        </div>
        <div class="LoginPage__copyright">All rights reserved Octo Telematics &copy; 2020</div>
        <div class="LoginPage__copyrightEntando">Digital Experience powered by Entando</div>
      </form>
    </div>
</body>
</html>
</#macro>
