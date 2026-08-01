// Cookie-consent banner + Google Consent Mode.
// Analytics is denied by default (set in <head>) and only granted here
// after an explicit Accept. Choice persists in localStorage.
(function () {
  var KEY = 'cambridge-consent';
  var saved = null;
  try { saved = localStorage.getItem(KEY); } catch (e) {}

  function grant() {
    gtag('consent', 'update', { analytics_storage: 'granted' });
  }

  if (saved === 'granted') { grant(); return; }
  if (saved === 'denied') { return; }

  var bar = document.createElement('div');
  bar.className = 'consent-bar';
  bar.setAttribute('role', 'dialog');
  bar.setAttribute('aria-label', 'Cookie consent');
  bar.innerHTML =
    '<p class="consent-text">We use Google Analytics (anonymized) to see how many people visit. No ads, no personalization. <a href="privacy.html">Privacy</a></p>' +
    '<div class="consent-actions">' +
    '<button type="button" class="consent-btn consent-btn--accept">Accept</button>' +
    '<button type="button" class="consent-btn consent-btn--decline">Decline</button>' +
    '</div>';
  document.body.appendChild(bar);

  function close(choice) {
    try { localStorage.setItem(KEY, choice); } catch (e) {}
    bar.remove();
    if (choice === 'granted') grant();
  }
  bar.querySelector('.consent-btn--accept').addEventListener('click', function () { close('granted'); });
  bar.querySelector('.consent-btn--decline').addEventListener('click', function () { close('denied'); });
})();
