<#import "mfa-template.ftl" as layout>
<@layout.registrationLayout icon="lifebuoy" displayMessage=!messagesPerField.existsError('recoveryCodeInput'); section>
  <#if section = "header">
    ${msg("auth-recovery-code-header")}
  <#elseif section = "form">
    <p class="MfaPage__text">${msg("auth-recovery-code-info-message")}</p>

    <form id="kc-recovery-code-login-form" class="MfaForm" action="${url.loginAction}" method="post">
      <div class="MfaField">
        <label for="recoveryCodeInput" class="LoginPage__label">${msg("auth-recovery-code-prompt", recoveryAuthnCodesInputBean.codeNumber?c)}</label>
        <input id="recoveryCodeInput" name="recoveryCodeInput" type="text" class="LoginPage__input MfaCodeInput MfaCodeInput--recovery"
          autocomplete="off" placeholder="XXXX-XXXX-XXXX" autofocus
          aria-invalid="<#if messagesPerField.existsError('recoveryCodeInput')>true</#if>" aria-describedby="input-error" />
        <@layout.fieldError field="recoveryCodeInput" id="input-error" />
      </div>

      <div class="MfaActions">
        <button class="LoginPage__button" name="login" id="kc-login" type="submit">${msg("doLogIn")}</button>
      </div>
    </form>
  </#if>
</@layout.registrationLayout>
