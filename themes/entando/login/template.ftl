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
  <link href="${url.resourcesPath}/css/zocial.css" rel="stylesheet" type="text/css">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
</head>

<body>
  <div class="LoginPage">
    <div class="LoginPage__formWrapper">
      <div class="LoginPage__brand">
        <div class="LoginPage__logo"></div>
        <div class="LoginPage__description">${msg("entandoUxBrandDescription")}</div>
      </div>
      <#nested "form">
      <#assign aDateTime = .now>
      <#assign aDate = aDateTime?date>
      <div class="LoginPage__copyright">${msg("copyright")} ${aDate?string.yyyy} <a href="https://www.entando.com/" class="LoginPage__url">Entando</a></div>
    </div>
  </div>
</body>
</html>
</#macro>
