<#import "mfa-template.ftl" as layout>
<@layout.registrationLayout icon="phone" displayMessage=!messagesPerField.existsError('totp'); section>
  <#if section = "header">
    ${msg("mfaOtpTitle")}
  <#elseif section = "form">
    <p class="MfaPage__text">${msg("mfaOtpDescription")}</p>

    <form id="kc-otp-login-form" class="MfaForm" action="${url.loginAction}" method="post">
      <#if otpLogin.userOtpCredentials?size gt 1>
        <fieldset class="MfaField">
          <legend class="LoginPage__label">${msg("mfaOtpSelectDevice")}</legend>
          <div class="MfaChoice">
            <#list otpLogin.userOtpCredentials as otpCredential>
              <input id="kc-otp-credential-${otpCredential?index}" class="MfaChoice__radio" type="radio" name="selectedCredentialId"
                value="${otpCredential.id}" <#if otpCredential.id == otpLogin.selectedCredentialId>checked="checked"</#if>>
              <label for="kc-otp-credential-${otpCredential?index}" class="MfaChoice__item">
                <span class="MfaChoice__icon"><@layout.svg name="phone" /></span>
                <span class="MfaChoice__body">
                  <span class="MfaChoice__heading">${otpCredential.userLabel!msg("mfaOtpDefaultDeviceName")}</span>
                </span>
                <span class="MfaChoice__check" aria-hidden="true"></span>
              </label>
            </#list>
          </div>
        </fieldset>
      </#if>

      <div class="MfaField">
        <label for="otp" class="LoginPage__label">${msg("loginOtpOneTime")}</label>
        <input id="otp" name="otp" type="text" class="LoginPage__input MfaCodeInput" data-mfa-code
          inputmode="numeric" autocomplete="one-time-code" maxlength="8" placeholder="${msg("mfaOtpCodePlaceholder")}" autofocus
          aria-invalid="<#if messagesPerField.existsError('totp')>true</#if>" aria-describedby="input-error-otp-code" />
        <@layout.fieldError field="totp" id="input-error-otp-code" />
      </div>

      <div class="MfaActions">
        <button class="LoginPage__button" name="login" id="kc-login" type="submit">${msg("doLogIn")}</button>
      </div>
    </form>
  </#if>
</@layout.registrationLayout>
