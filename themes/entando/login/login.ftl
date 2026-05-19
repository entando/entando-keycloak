<#import "template.ftl" as layout>
  <@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password') displayInfo=social.displayInfo && realm.password && !registrationDisabled??; section>
    <#if section="title">
      ${msg("loginTitle",(realm.displayName!''))}
      <#elseif section="form">
        <form class="LoginPage__form" action="${url.loginAction}" method="post">
          <div class="LoginPage__formGroup">
            <#if !usernameHidden??>
              <div class="LoginPage__inputGroup extra-margin">
                <label class="LoginPage__label">
                  ${msg("username")}
                </label>
                <div class="${properties.kcInputGroup!}">
                  <input type="text" name="username" tabindex="1" class="LoginPage__input" id="username" placeholder="Username" />
                </div>
              </div>
            </#if>
            <div class="LoginPage__inputGroup extra-margin">
              <label class="LoginPage__label">
                ${msg("password")}
              </label>
              <div class="${properties.kcInputGroup!}">
                <input type="password" name="password" tabindex="2" class="LoginPage__input" id="password" autocomplete="password" placeholder="Password" />
                <button class="${properties.kcFormPasswordVisibilityButtonClass!}" type="button" aria-label="${msg('showPassword')}"
                  aria-controls="password" data-password-toggle
                  data-icon-show="${properties.kcFormPasswordVisibilityIconShow!}" data-icon-hide="${properties.kcFormPasswordVisibilityIconHide!}"
                  data-label-show="${msg('showPassword')}" data-label-hide="${msg('hidePassword')}">
                  <i class="${properties.kcFormPasswordVisibilityIconShow!}" aria-hidden="true"></i>
                </button>
              </div>
              <#if usernameHidden?? && messagesPerField.existsError('username','password')>
                <span id="input-error" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                  ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
                </span>
              </#if>
            </div>
            <#if message?has_content>
              <div class="LoginPage__error">
                ${message.summary?no_esc} 
              </div>
              <div class="LoginPage__actionGroup" style="margin-top: 0;">
                <div></div>
                <button class="LoginPage__button" type="submit">
                  ${msg("doLogIn")}
                </button>
                <div class="LoginPage__loading">
                  <div class="LoginPage__spinner" />
                </div>
              </div>
              <#else>
                <div class="LoginPage__actionGroup">
                  <div></div>
                  <button class="LoginPage__button" type="submit">
                    ${msg("doLogIn")}
                  </button>
                  <div class="LoginPage__loading">
                    <div class="LoginPage__spinner" />
                  </div>
                </div>
            </#if>
          </div>
          <#if social.providers??>
            <div class="LoginPage__social">
              ${msg("socialLogin")}
            </div>
          </#if>
          <div>
            <#if social.providers??>
              <div id="social-providers">
                <div id="kc-social-providers">
                  <ul class="list horizontal">
                    <#list social.providers as p>
                      <li><a href="${p.loginUrl}" id="zocial-${p.alias}" class="button zocial ${p.providerId}">
                          ${p.displayName}
                        </a></li>
                    </#list>
                  </ul>
                </div>
              </div>
            </#if>
          </div>
        </form>
        <script type="module" src="${url.resourcesPath}/js/passwordVisibility.js"></script>
    </#if>
  </@layout.registrationLayout>