<#import "mfa-template.ftl" as layout>
<@layout.registrationLayout icon="alert" displayMessage=true; section>
  <#if section = "header">
    ${kcSanitize(msg("webauthn-error-title"))?no_esc}
  <#elseif section = "form">
    <form id="kc-error-credential-form" action="${url.loginAction}" method="post">
      <input type="hidden" id="executionValue" name="authenticationExecution" />
      <input type="hidden" id="isSetRetry" name="isSetRetry" />
    </form>

    <div id="mfa-webauthn-config" hidden data-execution="${execution}"></div>

    <div class="MfaActions">
      <button type="button" class="LoginPage__button" name="try-again" id="kc-try-again" data-webauthn-action="retry">
        ${kcSanitize(msg("doTryAgain"))?no_esc}
      </button>
      <#if isAppInitiatedAction??>
        <form action="${url.loginAction}" id="kc-webauthn-settings-form" method="post" class="MfaActions__secondary">
          <button type="submit" class="LoginPage__button MfaButton--secondary" id="cancelWebAuthnAIA" name="cancel-aia" value="true">${msg("doCancel")}</button>
        </form>
      </#if>
    </div>

    <script src="${url.resourcesPath}/js/webauthn.js" defer></script>
  </#if>
</@layout.registrationLayout>
