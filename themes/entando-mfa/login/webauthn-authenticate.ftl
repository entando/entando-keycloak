<#import "mfa-template.ftl" as layout>
<@layout.registrationLayout icon="key" displayMessage=!messagesPerField.existsError('username') displayInfo=(realm.password && realm.registrationAllowed && !registrationDisabled??); section>
  <#if section = "header">
    ${kcSanitize(msg("webauthn-login-title"))?no_esc}
  <#elseif section = "form">
    <p class="MfaPage__text">${msg("mfaWebauthnDescription")}</p>

    <form id="webauth" action="${url.loginAction}" method="post">
      <input type="hidden" id="clientDataJSON" name="clientDataJSON" />
      <input type="hidden" id="authenticatorData" name="authenticatorData" />
      <input type="hidden" id="signature" name="signature" />
      <input type="hidden" id="credentialId" name="credentialId" />
      <input type="hidden" id="userHandle" name="userHandle" />
      <input type="hidden" id="error" name="error" />
    </form>

    <#if authenticators??>
      <form id="authn_select">
        <#list authenticators.authenticators as authenticator>
          <input type="hidden" name="authn_use_chk" value="${authenticator.credentialId}" />
        </#list>
      </form>

      <#if shouldDisplayAuthenticators?? && shouldDisplayAuthenticators>
        <#if authenticators.authenticators?size gt 1>
          <p class="LoginPage__label">${kcSanitize(msg("webauthn-available-authenticators"))?no_esc}</p>
        </#if>
        <div class="MfaChoice">
          <#list authenticators.authenticators as authenticator>
            <div class="MfaChoice__item MfaChoice__item--static">
              <span class="MfaChoice__icon"><@layout.svg name="key" /></span>
              <span class="MfaChoice__body">
                <span class="MfaChoice__heading">${kcSanitize(msg('${authenticator.label}'))?no_esc}</span>
                <#if authenticator.transports?? && authenticator.transports.displayNameProperties?has_content>
                  <span class="MfaChoice__description">
                    <#list authenticator.transports.displayNameProperties as nameProperty>${kcSanitize(msg('${nameProperty!}'))?no_esc}<#sep>, </#list>
                  </span>
                </#if>
                <span class="MfaChoice__description">
                  ${kcSanitize(msg('webauthn-createdAt-label'))?no_esc} ${kcSanitize(authenticator.createdAt)?no_esc}
                </span>
              </span>
            </div>
          </#list>
        </div>
      </#if>
    </#if>

    <div id="mfa-webauthn-config" hidden
      data-challenge="${challenge}"
      data-rp-id="${rpId}"
      data-user-verification="${userVerification}"
      data-user-identified="${isUserIdentified}"
      data-create-timeout="${createTimeout?c}"
      data-unsupported-text="${msg("webauthn-unsupported-browser-text")}"></div>

    <div class="MfaActions">
      <button id="authenticateWebAuthnButton" type="button" class="LoginPage__button" data-webauthn-action="authenticate" autofocus>
        ${kcSanitize(msg("webauthn-doAuthenticate"))}
      </button>
    </div>

    <script src="${url.resourcesPath}/js/base64url.js"></script>
    <script src="${url.resourcesPath}/js/webauthn.js" defer></script>
  <#elseif section = "info">
    <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
      <div id="kc-registration">
        <span>${msg("noAccount")} <a class="MfaLink" href="${url.registrationUrl}">${msg("doRegister")}</a></span>
      </div>
    </#if>
  </#if>
</@layout.registrationLayout>
