$(document).on('ajax:complete', '#edit-link-form', function(event, data, status) {
  if(status === "success") {
    $('.save-success').removeClass('hidden');
    $('.save-failed').addClass('hidden');
  } else {
    $('.save-success').addClass('hidden');
    $('.save-failed').removeClass('hidden');
  }
});

function copyLink() {
  var copyText = document.getElementById("short-url");

  copyText.select();
  copyText.setSelectionRange(0, 99999);

  document.execCommand('copy');

  alert('Copied url: ' + copyText.value);
}
