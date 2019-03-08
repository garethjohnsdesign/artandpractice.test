var $tabs = $('[role="tab"]');
var namespace = $('body').data('section');

$tabs.on('click', function(e) {
  localStorage.setItem(namespace + '-tab', e.target.getAttribute('href'))
})

var tabPreference = localStorage.getItem(namespace + '-tab');
if (tabPreference) {
  $tabs.filter('[href="' + tabPreference + '"]').trigger( "click" );
}