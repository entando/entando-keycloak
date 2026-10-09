<#import "mfa-template.ftl" as layout>
<@layout.registrationLayout icon="lifebuoy"; section>
  <#if section = "header">
    ${msg("recovery-code-config-header")}
  <#elseif section = "form">
    <div class="MfaAlert MfaAlert--warning" role="alert">
      <strong class="MfaAlert__title">${msg("recovery-code-config-warning-title")}</strong>
      ${msg("recovery-code-config-warning-message")}
    </div>

    <ol id="kc-recovery-codes-list" class="MfaCodes"
      data-file-header="${msg("recovery-codes-download-file-header")}"
      data-file-description="${msg("recovery-codes-download-file-description")}"
      data-file-date="${msg("recovery-codes-download-file-date")}">
      <#list recoveryAuthnCodesConfigBean.generatedRecoveryAuthnCodesList as code>
        <li><span class="MfaCodes__index">${code?counter}:</span> ${code[0..3]}-${code[4..7]}-${code[8..]}</li>
      </#list>
    </ol>

    <div class="MfaToolbar">
      <button id="printRecoveryCodes" class="MfaLink" type="button"><@layout.svg name="print" /><span>${msg("recovery-codes-print")}</span></button>
      <button id="downloadRecoveryCodes" class="MfaLink" type="button"><@layout.svg name="download" /><span>${msg("recovery-codes-download")}</span></button>
      <button id="copyRecoveryCodes" class="MfaLink" type="button" data-mfa-copy="#kc-recovery-codes-list"
        data-mfa-copied="${msg("recovery-codes-copied")}"><@layout.svg name="copy" /><span>${msg("recovery-codes-copy")}</span></button>
    </div>

    <form action="${url.loginAction}" class="MfaForm" id="kc-recovery-codes-settings-form" method="post">
      <input type="hidden" name="generatedRecoveryAuthnCodes" value="${recoveryAuthnCodesConfigBean.generatedRecoveryAuthnCodesAsString}" />
      <input type="hidden" name="generatedAt" value="${recoveryAuthnCodesConfigBean.generatedAt?c}" />
      <input type="hidden" id="userLabel" name="userLabel" value="${msg("recovery-codes-label-default")}" />

      <label class="MfaCheckbox">
        <input type="checkbox" id="kcRecoveryCodesConfirmationCheck" name="kcRecoveryCodesConfirmationCheck"
          data-mfa-enables="#saveRecoveryAuthnCodesBtn" />
        <span>${msg("recovery-codes-confirmation-message")}</span>
      </label>

      <@layout.logoutOtherSessions />

      <div class="MfaActions">
        <button type="submit" class="LoginPage__button" id="saveRecoveryAuthnCodesBtn" disabled>${msg("recovery-codes-action-complete")}</button>
        <#if isAppInitiatedAction??>
          <button type="submit" class="LoginPage__button MfaButton--secondary" id="cancelRecoveryAuthnCodesBtn" name="cancel-aia" value="true">${msg("recovery-codes-action-cancel")}</button>
        </#if>
      </div>
    </form>
  </#if>
</@layout.registrationLayout>
