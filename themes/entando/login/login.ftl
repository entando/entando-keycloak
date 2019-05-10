<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=social.displayInfo; section>
  <#if section = "title">
    ${msg("loginTitle",(realm.displayName!''))}
  <#elseif section = "form">
    <form id="kc-form-login" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post">
      <#if message?has_content>
        <div class="alert alert-danger">
          <#if message.type = 'success'><span class="${properties.kcFeedbackSuccessIcon!}"></span></#if>
          <#if message.type = 'warning'><span class="${properties.kcFeedbackWarningIcon!}"></span></#if>
          <#if message.type = 'error'><span class="${properties.kcFeedbackErrorIcon!}"></span></#if>
          <#if message.type = 'info'><span class="${properties.kcFeedbackInfoIcon!}"></span></#if>
          <span class="message-text">${message.summary?no_esc}</span>
        </div>
      </#if>

      <div class="${properties.kcFormGroupClass!}">
        <label for="username" class="${properties.kcLabelClass!}">${msg("username")}</label>
        <div>
          <input type="text" name="username" value="" tabindex="1" id="username" class="${properties.kcInputClass!}" autofocus/>
        </div>
      </div>

      <#if realm.password>
        <div class="${properties.kcFormGroupClass!}">
          <label for="password"class="${properties.kcLabelClass!}">${msg("password")}</label>
          <div>
            <input type="password" name="password" tabindex="2" id="password" class="${properties.kcInputClass!}"/>
          </div>
        </div>
      </#if>
      
      <div class="${properties.kcFormGroupClass!}">
        <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
          <input class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonLargeClass!}" type="submit" value="${msg("doLogIn")}"/>
        </div>
      </div>
      <#if social.providers??>
        <p class="para">${msg("selectAlternative")}</p>
        <div id="social-providers">
          <div id="kc-social-providers">
            <ul class="list horizontal">
              <#list social.providers as p>
                <li><a href="${p.loginUrl}" id="zocial-${p.alias}" class="button zocial ${p.providerId}">${p.displayName}</a></li>
              </#list>
            </ul>
          </div>
        </div>
      </#if>
    </form>
  </#if>
</@layout.registrationLayout>