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
</head>

<body>
    <#assign aDateTime = .now>
    <#assign aDate = aDateTime?date>
    <div class="LoginPage">
      <form class="LoginPage__form" action="${url.loginAction}" method="post">
        <div class="LoginPage__brand">
          <div class="LoginPage__logo"></div>
          <div class="LoginPage__description">${msg("entandoUxBrandDescription")}</div>
        </div>
        <div class="LoginPage__formGroup">
          <div class="LoginPage__inputGroup">
            <label class="LoginPage__label">${msg("username")}</label>
            <input type="text" name="username" tabindex="1" class="LoginPage__input" id="username" placeholder="Username" />
          </div>
          <div class="LoginPage__inputGroup extra-margin">
            <label class="LoginPage__label">${msg("password")}</label>
            <input type="password" name="password" tabindex="2" class="LoginPage__input" id="password" placeholder="Password" />
          </div>
          <#if message?has_content>
            <div class="LoginPage__error">${message.summary?no_esc}</div>
            <div class="LoginPage__actionGroup" style="margin-top: 0;">
              <div></div>
              <button class="LoginPage__button" type="submit">${msg("doLogIn")}</button>
              <div class="LoginPage__loading">
                <div class="LoginPage__spinner" />
              </div>
            </div>
          <#else>
            <div class="LoginPage__actionGroup">
              <div></div>
              <button class="LoginPage__button" type="submit">${msg("doLogIn")}</button>
              <div class="LoginPage__loading">
                <div class="LoginPage__spinner" />
              </div>
            </div>
          </#if>
        </div>
        <div class="LoginPage__copyright">${msg("copyright")} ${aDate?string.yyyy} <a href="https://www.entando.com/" class="LoginPage__url">Entando</a></div>
      </form>
    </div>
</body>
</html>
</#macro>
