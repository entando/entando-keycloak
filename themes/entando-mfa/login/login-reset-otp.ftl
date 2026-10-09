<#import "mfa-template.ftl" as layout>
<@layout.registrationLayout icon="trash" displayMessage=!messagesPerField.existsError('totp'); section>
  <#if section = "header">
    ${msg("mfaResetOtpTitle")}
  <#elseif section = "form">
    <p class="MfaPage__text" id="kc-otp-reset-form-description">${msg("otp-reset-description")}</p>

    <form id="kc-otp-reset-form" class="MfaForm" action="${url.loginAction}" method="post">
      <div class="MfaChoice">
        <#list configuredOtpCredentials.userOtpCredentials as otpCredential>
          <input id="kc-otp-credential-${otpCredential?index}" class="MfaChoice__radio" type="radio" name="selectedCredentialId"
            value="${otpCredential.id}" <#if otpCredential.id == configuredOtpCredentials.selectedCredentialId>checked="checked"</#if>>
          <label for="kc-otp-credential-${otpCredential?index}" class="MfaChoice__item">
            <span class="MfaChoice__icon"><@layout.svg name="phone" /></span>
            <span class="MfaChoice__body">
              <span class="MfaChoice__heading">${otpCredential.userLabel!msg("mfaOtpDefaultDeviceName")}</span>
            </span>
            <span class="MfaChoice__check" aria-hidden="true"></span>
          </label>
        </#list>
      </div>

      <div class="MfaActions">
        <button id="kc-otp-reset-form-submit" class="LoginPage__button" type="submit">${msg("doSubmit")}</button>
      </div>
    </form>
  </#if>
</@layout.registrationLayout>
