<#import "mfa-template.ftl" as layout>
<@layout.registrationLayout icon="shield" showAnotherWayIfPresent=false; section>
  <#if section = "header">
    ${msg("loginChooseAuthenticator")}
  <#elseif section = "form">
    <p class="MfaPage__text">${msg("mfaChooseAuthenticatorDescription")}</p>

    <form id="kc-select-credential-form" class="MfaForm" action="${url.loginAction}" method="post">
      <div class="MfaChoice">
        <#list auth.authenticationSelections as authenticationSelection>
          <button class="MfaChoice__item" type="submit" name="authenticationExecution" value="${authenticationSelection.authExecId}">
            <span class="MfaChoice__icon"><@layout.svg name=layout.iconFor(authenticationSelection.iconCssClass, authenticationSelection.displayName) /></span>
            <span class="MfaChoice__body">
              <span class="MfaChoice__heading">${msg('${authenticationSelection.displayName}')}</span>
              <span class="MfaChoice__description">${msg('${authenticationSelection.helpText}')}</span>
            </span>
            <span class="MfaChoice__arrow"><@layout.svg name="chevron" /></span>
          </button>
        </#list>
      </div>
    </form>
  </#if>
</@layout.registrationLayout>
