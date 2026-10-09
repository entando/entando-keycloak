<#--
  Layout for the multi-factor authentication pages.
  It wraps the Entando "registrationLayout" (template.ftl of the parent theme) so that the
  look & feel of the login page is preserved, and adds the parts the Entando layout does not
  render: page header, attempted username, feedback messages, "try another way" and info.
-->
<#import "template.ftl" as entando>

<#macro registrationLayout icon="shield" displayInfo=false displayMessage=true showAnotherWayIfPresent=true>
  <@entando.registrationLayout; section>
    <#if section = "form">
      <link href="${url.resourcesPath}/css/mfa.css" rel="stylesheet" type="text/css">
      <div class="MfaPage">
        <div class="MfaPage__header">
          <span class="MfaBadge"><@svg name=icon /></span>
          <h1 class="MfaPage__title"><#nested "header"></h1>
        </div>

        <#if auth?has_content && auth.showUsername() && !auth.showResetCredentials()>
          <div class="MfaUser">
            <span class="MfaUser__name"><@svg name="user" />${auth.attemptedUsername}</span>
            <a class="MfaLink" id="reset-login" href="${url.loginRestartFlowUrl}">${msg("mfaNotYou")}</a>
          </div>
        </#if>

        <#-- App-initiated actions should not see warning messages about the need to complete the action during login -->
        <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
          <div class="MfaAlert MfaAlert--${message.type}" role="alert">
            ${kcSanitize(message.summary)?no_esc}
          </div>
        </#if>

        <#nested "form">

        <#if showAnotherWayIfPresent && auth?has_content && auth.showTryAnotherWayLink()>
          <form id="kc-select-try-another-way-form" class="MfaAnotherWay" action="${url.loginAction}" method="post">
            <input type="hidden" name="tryAnotherWay" value="on" />
            <button type="submit" id="try-another-way" class="MfaLink">${msg("doTryAnotherWay")}</button>
          </form>
        </#if>

        <#if displayInfo>
          <div id="kc-info" class="MfaPage__info">
            <#nested "info">
          </div>
        </#if>
      </div>
      <script src="${url.resourcesPath}/js/mfa.js" defer></script>
    </#if>
  </@entando.registrationLayout>
</#macro>

<#-- Inline icons (stroke based, they inherit the current text color) -->
<#macro svg name>
  <svg class="MfaIcon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
    <#switch name>
      <#case "phone">
        <rect x="6.5" y="2.5" width="11" height="19" rx="2" /><path d="M11 18h2" />
        <#break>
      <#case "key">
        <circle cx="8" cy="15" r="4.5" /><path d="M11.2 11.8 20 3" /><path d="m16.5 6.5 2.5 2.5" /><path d="m14 9 2 2" />
        <#break>
      <#case "lock">
        <rect x="4.5" y="10.5" width="15" height="10.5" rx="2" /><path d="M8 10.5V7a4 4 0 0 1 8 0v3.5" />
        <#break>
      <#case "lifebuoy">
        <circle cx="12" cy="12" r="9" /><circle cx="12" cy="12" r="4" /><path d="m5.6 5.6 3.6 3.6M14.8 14.8l3.6 3.6M18.4 5.6l-3.6 3.6M9.2 14.8l-3.6 3.6" />
        <#break>
      <#case "user">
        <circle cx="12" cy="8" r="4" /><path d="M4 21c0-4 3.6-6 8-6s8 2 8 6" />
        <#break>
      <#case "chevron">
        <path d="m9 6 6 6-6 6" />
        <#break>
      <#case "copy">
        <rect x="9" y="9" width="11" height="11" rx="2" /><path d="M5 15V6a2 2 0 0 1 2-2h9" />
        <#break>
      <#case "download">
        <path d="M12 3v12M7 10l5 5 5-5M5 21h14" />
        <#break>
      <#case "print">
        <path d="M7 9V3h10v6" /><rect x="3" y="9" width="18" height="8" rx="2" /><path d="M7 14h10v7H7z" />
        <#break>
      <#case "alert">
        <path d="M12 3 22 21H2L12 3z" /><path d="M12 10v5M12 18h.01" />
        <#break>
      <#case "trash">
        <path d="M4 7h16M10 11v6M14 11v6M6 7l1 13h10l1-13M9 7V4h6v3" />
        <#break>
      <#default>
        <path d="M12 3 19 6v5c0 4.5-3 8.4-7 10-4-1.6-7-5.5-7-10V6l7-3z" /><path d="m9 12 2 2 4-4" />
    </#switch>
  </svg>
</#macro>

<#-- Maps an authentication selection (icon class and display name key) to an icon name -->
<#function iconFor cssClass displayName="">
  <#if cssClass?contains("OTP")><#return "phone"></#if>
  <#if cssClass?contains("WebAuthn")><#return "key"></#if>
  <#if cssClass?contains("Recovery") || displayName?contains("recovery")><#return "lifebuoy"></#if>
  <#if cssClass?contains("Password")><#return "lock"></#if>
  <#if cssClass?contains("Username")><#return "user"></#if>
  <#return "shield">
</#function>

<#macro logoutOtherSessions>
  <label class="MfaCheckbox">
    <input type="checkbox" id="logout-sessions" name="logout-sessions" value="on" checked>
    <span>${msg("logoutOtherSessions")}</span>
  </label>
</#macro>

<#macro fieldError field id>
  <#if messagesPerField.existsError(field)>
    <span id="${id}" class="MfaField__error" aria-live="polite">
      ${kcSanitize(messagesPerField.get(field))?no_esc}
    </span>
  </#if>
</#macro>
