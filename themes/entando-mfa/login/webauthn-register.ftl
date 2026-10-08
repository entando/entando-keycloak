<#import "mfa-template.ftl" as layout>
<@layout.registrationLayout icon="key"; section>
  <#if section = "header">
    ${kcSanitize(msg("webauthn-registration-title"))?no_esc}
  <#elseif section = "form">
    <p class="MfaPage__text">${msg("mfaWebauthnRegisterDescription")}</p>

    <form id="register" class="MfaForm" action="${url.loginAction}" method="post">
      <input type="hidden" id="clientDataJSON" name="clientDataJSON" />
      <input type="hidden" id="attestationObject" name="attestationObject" />
      <input type="hidden" id="publicKeyCredentialId" name="publicKeyCredentialId" />
      <input type="hidden" id="transports" name="transports" />
      <input type="hidden" id="error" name="error" />

      <div class="MfaField">
        <label for="authenticatorLabel" class="LoginPage__label">${msg("mfaWebauthnLabel")}</label>
        <input type="text" id="authenticatorLabel" name="authenticatorLabel" class="LoginPage__input" autocomplete="off"
          value="${msg("mfaWebauthnLabelDefault")}" />
        <span class="MfaField__hint">${msg("mfaWebauthnLabelHint")}</span>
      </div>

      <@layout.logoutOtherSessions />
    </form>

    <div id="mfa-webauthn-config" hidden
      data-challenge="${challenge}"
      data-user-id="${userid}"
      data-username="${username}"
      data-signature-algorithms="<#list signatureAlgorithms as sigAlg>${sigAlg?c}<#sep>,</#list>"
      data-rp-entity-name="${rpEntityName}"
      data-rp-id="${rpId}"
      data-attestation-conveyance-preference="${attestationConveyancePreference}"
      data-authenticator-attachment="${authenticatorAttachment}"
      data-require-resident-key="${requireResidentKey}"
      data-user-verification-requirement="${userVerificationRequirement}"
      data-create-timeout="${createTimeout?c}"
      data-exclude-credential-ids="${excludeCredentialIds}"
      data-unsupported-text="${msg("webauthn-unsupported-browser-text")}"></div>

    <div class="MfaActions">
      <button type="button" class="LoginPage__button" id="registerWebAuthn" data-webauthn-action="register">${msg("doRegisterSecurityKey")}</button>
      <#if !isSetRetry?has_content && isAppInitiatedAction?has_content>
        <form action="${url.loginAction}" id="kc-webauthn-settings-form" method="post" class="MfaActions__secondary">
          <button type="submit" class="LoginPage__button MfaButton--secondary" id="cancelWebAuthnAIA" name="cancel-aia" value="true">${msg("doCancel")}</button>
        </form>
      </#if>
    </div>

    <script src="${url.resourcesPath}/js/base64url.js"></script>
    <script src="${url.resourcesPath}/js/webauthn.js" defer></script>
  </#if>
</@layout.registrationLayout>
