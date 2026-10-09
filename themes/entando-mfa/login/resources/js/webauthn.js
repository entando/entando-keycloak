// WebAuthn (passkey) ceremonies for the Entando MFA login pages.
// Server-side parameters are read from the data-* attributes of #mfa-webauthn-config;
// the base64url helper is provided by the Keycloak base theme (js/base64url.js).
(function () {
  'use strict';

  var config = document.getElementById('mfa-webauthn-config');
  if (!config) return;
  var cfg = config.dataset;
  var NOT_SPECIFIED = 'not specified';

  function setValue(id, value) {
    document.getElementById(id).value = value;
  }

  function encode(buffer) {
    return base64url.encode(new Uint8Array(buffer), { pad: false });
  }

  function decode(value) {
    return base64url.decode(value, { loose: true });
  }

  function timeoutOf(value) {
    var seconds = parseInt(value, 10) || 0;
    return seconds !== 0 ? seconds * 1000 : undefined;
  }

  function fail(formId, error) {
    setValue('error', String(error));
    document.getElementById(formId).submit();
  }

  function authenticate() {
    if (!window.PublicKeyCredential) {
      fail('webauth', cfg.unsupportedText);
      return;
    }

    var publicKey = {
      rpId: cfg.rpId,
      challenge: decode(cfg.challenge)
    };

    var timeout = timeoutOf(cfg.createTimeout);
    if (timeout) publicKey.timeout = timeout;

    if (cfg.userIdentified === 'true') {
      var allowCredentials = Array.prototype.map.call(
        document.querySelectorAll('#authn_select input[name="authn_use_chk"]'),
        function (input) { return { id: decode(input.value), type: 'public-key' }; }
      );
      if (allowCredentials.length) publicKey.allowCredentials = allowCredentials;
    }

    if (cfg.userVerification !== NOT_SPECIFIED) publicKey.userVerification = cfg.userVerification;

    navigator.credentials.get({ publicKey: publicKey })
      .then(function (result) {
        setValue('clientDataJSON', encode(result.response.clientDataJSON));
        setValue('authenticatorData', encode(result.response.authenticatorData));
        setValue('signature', encode(result.response.signature));
        setValue('credentialId', result.id);
        if (result.response.userHandle) {
          setValue('userHandle', encode(result.response.userHandle));
        }
        document.getElementById('webauth').submit();
      })
      .catch(function (err) {
        fail('webauth', err);
      });
  }

  function register() {
    if (!window.PublicKeyCredential) {
      fail('register', cfg.unsupportedText);
      return;
    }

    var algorithms = (cfg.signatureAlgorithms || '').split(',').filter(Boolean).map(Number);
    if (algorithms.length === 0) algorithms = [-7];

    var publicKey = {
      challenge: decode(cfg.challenge),
      rp: { id: cfg.rpId, name: cfg.rpEntityName },
      user: {
        id: decode(cfg.userId),
        name: cfg.username,
        displayName: cfg.username
      },
      pubKeyCredParams: algorithms.map(function (alg) { return { type: 'public-key', alg: alg }; })
    };

    if (cfg.attestationConveyancePreference !== NOT_SPECIFIED) {
      publicKey.attestation = cfg.attestationConveyancePreference;
    }

    var authenticatorSelection = {};
    if (cfg.authenticatorAttachment !== NOT_SPECIFIED) {
      authenticatorSelection.authenticatorAttachment = cfg.authenticatorAttachment;
    }
    if (cfg.requireResidentKey !== NOT_SPECIFIED) {
      authenticatorSelection.requireResidentKey = cfg.requireResidentKey === 'Yes';
    }
    if (cfg.userVerificationRequirement !== NOT_SPECIFIED) {
      authenticatorSelection.userVerification = cfg.userVerificationRequirement;
    }
    if (Object.keys(authenticatorSelection).length) publicKey.authenticatorSelection = authenticatorSelection;

    var timeout = timeoutOf(cfg.createTimeout);
    if (timeout) publicKey.timeout = timeout;

    var excludeCredentials = (cfg.excludeCredentialIds || '').split(',').filter(Boolean)
      .map(function (id) { return { type: 'public-key', id: decode(id) }; });
    if (excludeCredentials.length) publicKey.excludeCredentials = excludeCredentials;

    navigator.credentials.create({ publicKey: publicKey })
      .then(function (result) {
        setValue('clientDataJSON', encode(result.response.clientDataJSON));
        setValue('attestationObject', encode(result.response.attestationObject));
        setValue('publicKeyCredentialId', encode(result.rawId));

        if (typeof result.response.getTransports === 'function') {
          var transports = result.response.getTransports();
          if (Array.isArray(transports)) setValue('transports', transports.join(','));
        }

        var label = document.getElementById('authenticatorLabel');
        if (!label.value.trim()) label.value = label.defaultValue;

        document.getElementById('register').submit();
      })
      .catch(function (err) {
        fail('register', err);
      });
  }

  function retry() {
    setValue('isSetRetry', 'retry');
    setValue('executionValue', cfg.execution);
    document.getElementById('kc-error-credential-form').submit();
  }

  var actions = { authenticate: authenticate, register: register, retry: retry };

  document.querySelectorAll('[data-webauthn-action]').forEach(function (button) {
    var action = actions[button.getAttribute('data-webauthn-action')];
    if (action) button.addEventListener('click', action);
  });
})();
