<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
  <meta charset="utf-8">
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <meta name="robots" content="noindex, nofollow">

  <title><#nested "title"></title>
  <link href="${url.resourcesPath}/img/favicon-entando.png" rel="icon"/>
  <#if properties.styles?has_content>
    <#list properties.styles?split(' ') as style>
      <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
    </#list>
  </#if>
</head>

<body id="background-full" class="display-table">
  <#nested "header">
  <div class="display-cell ">
    <div class="col-md-6 v-align ">
      <div class="center1">
        <img class="logo-entando-login" src="${url.resourcesPath}/img/entando-logo.svg" />
        <p class="ux_brand"><strong>${msg("entandoUxBrand")}</strong></p>
        <p class="ux_brand_subtitle"> ${msg("entandoUxBrandSubtitle")}</p>
        <div class="spacer-login"></div>
        <div class="entando-intro">${msg("entandoIntro")}</div>
        <div class="copyright-entando">Copyright ${.now?string('yyyy')} <span class="entando-sm-write">Entando</span></div>
      </div>
    </div>
    <div class="col-md-6 v-align ">
      <div class="center2">
        <#nested "form">
      </div>
    </div>
  </div>
</body>
</html>
</#macro>