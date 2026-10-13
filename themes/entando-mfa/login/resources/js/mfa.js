// Behaviour shared by the Entando MFA login pages (OTP input, copy buttons, recovery codes).
(function () {
  'use strict';

  // One-time code inputs accept digits only (pasted codes such as "123 456" are cleaned up too)
  document.querySelectorAll('[data-mfa-code]').forEach(function (input) {
    input.addEventListener('input', function () {
      var digits = input.value.replace(/\D/g, '');
      if (digits !== input.value) {
        input.value = digits;
      }
    });
  });

  // Checkboxes that enable a button when checked
  document.querySelectorAll('[data-mfa-enables]').forEach(function (checkbox) {
    var target = document.querySelector(checkbox.getAttribute('data-mfa-enables'));
    if (!target) return;
    var sync = function () { target.disabled = !checkbox.checked; };
    checkbox.addEventListener('change', sync);
    sync();
  });

  // Prevent double submissions (the timeout lets the clicked button value be submitted first)
  document.querySelectorAll('form').forEach(function (form) {
    form.addEventListener('submit', function () {
      setTimeout(function () {
        form.querySelectorAll('button[type="submit"]').forEach(function (btn) {
          if (!btn.disabled) {
            btn.disabled = true;
            btn.setAttribute('data-mfa-submitting', '');
          }
        });
      }, 0);
    });
  });

  // Pages restored from the back/forward cache must be usable again
  window.addEventListener('pageshow', function (event) {
    if (!event.persisted) return;
    document.querySelectorAll('[data-mfa-submitting]').forEach(function (btn) {
      btn.disabled = false;
      btn.removeAttribute('data-mfa-submitting');
    });
  });

  function copyText(text) {
    if (navigator.clipboard && window.isSecureContext) {
      return navigator.clipboard.writeText(text);
    }
    var textarea = document.createElement('textarea');
    textarea.value = text;
    textarea.setAttribute('readonly', '');
    textarea.style.position = 'fixed';
    textarea.style.opacity = '0';
    document.body.appendChild(textarea);
    textarea.select();
    document.execCommand('copy');
    document.body.removeChild(textarea);
    return Promise.resolve();
  }

  function textOf(element) {
    if (element.tagName === 'OL' || element.tagName === 'UL') {
      return Array.prototype.map.call(element.querySelectorAll('li'), function (li) {
        return li.textContent.replace(/\s+/g, ' ').trim();
      }).join('\n');
    }
    return element.textContent.trim();
  }

  // Copy buttons: data-mfa-copy="<selector>" [data-mfa-copy-compact] [data-mfa-copied="<feedback label>"]
  document.querySelectorAll('[data-mfa-copy]').forEach(function (button) {
    button.addEventListener('click', function () {
      var source = document.querySelector(button.getAttribute('data-mfa-copy'));
      if (!source) return;
      var text = textOf(source);
      if (button.hasAttribute('data-mfa-copy-compact')) {
        text = text.replace(/\s+/g, '');
      }
      copyText(text).then(function () {
        var label = button.querySelector('span');
        var copied = button.getAttribute('data-mfa-copied');
        if (!label || !copied) return;
        var original = label.textContent;
        label.textContent = copied;
        button.classList.add('is-copied');
        setTimeout(function () {
          label.textContent = original;
          button.classList.remove('is-copied');
        }, 2000);
      });
    });
  });

  // Recovery codes: download and print
  var codesList = document.getElementById('kc-recovery-codes-list');
  if (codesList) {
    var formatNow = function () {
      return new Date().toLocaleString(document.documentElement.lang || undefined, {
        year: 'numeric', month: 'long', day: 'numeric', hour: 'numeric', minute: 'numeric', timeZoneName: 'short'
      });
    };
    var header = codesList.getAttribute('data-file-header');
    var description = codesList.getAttribute('data-file-description');
    var dateLabel = codesList.getAttribute('data-file-date');

    var downloadButton = document.getElementById('downloadRecoveryCodes');
    downloadButton && downloadButton.addEventListener('click', function () {
      var content = header + '\n\n' + textOf(codesList) + '\n\n' + description + '\n\n' + dateLabel + ' ' + formatNow();
      var link = document.createElement('a');
      link.href = 'data:text/plain;charset=utf-8,' + encodeURIComponent(content);
      link.download = 'kc-download-recovery-codes.txt';
      link.style.display = 'none';
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    });

    var printButton = document.getElementById('printRecoveryCodes');
    printButton && printButton.addEventListener('click', function () {
      var win = window.open('', '_blank');
      if (!win) return;
      var doc = win.document;
      doc.title = 'kc-download-recovery-codes';
      var style = doc.createElement('style');
      style.textContent = '@page { size: auto; margin-top: 0; } body { width: 480px; font-family: sans-serif; }' +
        ' pre { font-family: monospace; font-size: 14px; } p:first-of-type { margin-top: 48px; }';
      doc.head.appendChild(style);
      [header, null, description, dateLabel + ' ' + formatNow()].forEach(function (text) {
        var node = doc.createElement(text === null ? 'pre' : 'p');
        node.textContent = text === null ? textOf(codesList) : text;
        doc.body.appendChild(node);
      });
      win.print();
      win.close();
    });
  }
})();
