<#import "mfa-template.ftl" as layout>
<@layout.registrationLayout icon="shield" displayMessage=!messagesPerField.existsError('totp','userLabel'); section>
  <#if section = "header">
    ${msg("loginTotpTitle")}
  <#elseif section = "form">
    <p class="MfaPage__text">${msg("mfaTotpIntro")}</p>

    <ol class="MfaSteps" id="kc-totp-settings">
      <li class="MfaStep">
        <span class="MfaStep__number">1</span>
        <div>
          <h2 class="MfaStep__title">${msg("mfaTotpStep1Title")}</h2>
          <p class="MfaStep__text">${msg("loginTotpStep1")}</p>
          <ul class="MfaChips" id="kc-totp-supported-apps">
            <#list totp.supportedApplications as app>
              <li class="MfaChip">${msg(app)}</li>
            </#list>
          </ul>
        </div>
      </li>

      <#if mode?? && mode = "manual">
        <li class="MfaStep">
          <span class="MfaStep__number">2</span>
          <div>
            <h2 class="MfaStep__title">${msg("mfaTotpStep2ManualTitle")}</h2>
            <p class="MfaStep__text">${msg("loginTotpManualStep2")}</p>
            <div class="MfaSecret">
              <span class="MfaSecret__value" id="kc-totp-secret-key">${totp.totpSecretEncoded}</span>
              <button type="button" class="MfaLink" data-mfa-copy="#kc-totp-secret-key" data-mfa-copy-compact
                data-mfa-copied="${msg("mfaCopied")}"><@layout.svg name="copy" /><span>${msg("mfaCopy")}</span></button>
            </div>
            <p class="MfaStep__text">${msg("loginTotpManualStep3")}</p>
            <dl class="MfaDl">
              <dt>${msg("loginTotpType")}</dt><dd id="kc-totp-type">${msg("loginTotp." + totp.policy.type)}</dd>
              <dt>${msg("loginTotpAlgorithm")}</dt><dd id="kc-totp-algorithm">${totp.policy.getAlgorithmKey()}</dd>
              <dt>${msg("loginTotpDigits")}</dt><dd id="kc-totp-digits">${totp.policy.digits}</dd>
              <#if totp.policy.type = "totp">
                <dt>${msg("loginTotpInterval")}</dt><dd id="kc-totp-period">${totp.policy.period}</dd>
              <#elseif totp.policy.type = "hotp">
                <dt>${msg("loginTotpCounter")}</dt><dd id="kc-totp-counter">${totp.policy.initialCounter}</dd>
              </#if>
            </dl>
            <p class="MfaStep__text"><a href="${totp.qrUrl}" id="mode-barcode" class="MfaLink">${msg("loginTotpScanBarcode")}</a></p>
          </div>
        </li>
      <#else>
        <li class="MfaStep">
          <span class="MfaStep__number">2</span>
          <div>
            <h2 class="MfaStep__title">${msg("mfaTotpStep2Title")}</h2>
            <p class="MfaStep__text">${msg("loginTotpStep2")}</p>
            <div class="MfaQr">
              <img id="kc-totp-secret-qr-code" class="MfaQr__image" src="data:image/png;base64, ${totp.totpSecretQrCode}" alt="${msg("mfaTotpQrAlt")}">
              <a href="${totp.manualUrl}" id="mode-manual" class="MfaLink">${msg("loginTotpUnableToScan")}</a>
            </div>
          </div>
        </li>
      </#if>

      <li class="MfaStep">
        <span class="MfaStep__number">3</span>
        <div>
          <h2 class="MfaStep__title">${msg("mfaTotpStep3Title")}</h2>
          <p class="MfaStep__text">${msg("loginTotpStep3")}</p>
        </div>
      </li>
    </ol>

    <form action="${url.loginAction}" class="MfaForm" id="kc-totp-settings-form" method="post">
      <div class="MfaField">
        <label for="totp" class="LoginPage__label">${msg("authenticatorCode")} <span class="MfaRequired">*</span></label>
        <input type="text" id="totp" name="totp" class="LoginPage__input MfaCodeInput" data-mfa-code
          inputmode="numeric" autocomplete="one-time-code" maxlength="8" placeholder="${msg("mfaOtpCodePlaceholder")}"
          aria-invalid="<#if messagesPerField.existsError('totp')>true</#if>" aria-describedby="input-error-otp-code" />
        <@layout.fieldError field="totp" id="input-error-otp-code" />
        <input type="hidden" id="totpSecret" name="totpSecret" value="${totp.totpSecret}" />
        <#if mode??><input type="hidden" id="mode" name="mode" value="${mode}" /></#if>
      </div>

      <div class="MfaField">
        <label for="userLabel" class="LoginPage__label">
          ${msg("loginTotpDeviceName")}
          <#if totp.otpCredentials?size gte 1><span class="MfaRequired">*</span><#else><span class="MfaOptional">${msg("mfaOptional")}</span></#if>
        </label>
        <input type="text" id="userLabel" name="userLabel" class="LoginPage__input" autocomplete="off"
          placeholder="${msg("mfaTotpDeviceNamePlaceholder")}"
          aria-invalid="<#if messagesPerField.existsError('userLabel')>true</#if>" aria-describedby="input-error-otp-label" />
        <span class="MfaField__hint">${msg("loginTotpStep3DeviceName")}</span>
        <@layout.fieldError field="userLabel" id="input-error-otp-label" />
      </div>

      <@layout.logoutOtherSessions />

      <#-- The primary button comes first in the DOM so that pressing Enter submits instead of cancelling -->
      <div class="MfaActions">
        <button type="submit" class="LoginPage__button" id="saveTOTPBtn">${msg("doSubmit")}</button>
        <#if isAppInitiatedAction??>
          <button type="submit" class="LoginPage__button MfaButton--secondary" id="cancelTOTPBtn" name="cancel-aia" value="true">${msg("doCancel")}</button>
        </#if>
      </div>
    </form>
  </#if>
</@layout.registrationLayout>
