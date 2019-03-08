$(document).ready( function () {
    // I only have one form on the page but you can be more specific if need be.
    var $form = $('.subscribe-form');

    if ( $form.length > 0 ) {
        $form.find('input[type="submit"]').bind('click', function ( event ) {
            if ( event ) event.preventDefault();

            register($form);
        });
    }
});

function register($form) {
    function notify(type, message) {
      var $notification = $form.find('.subscribe-form__notification-' + type);
      $notification.find('.alert').html(message);
      $notification.fadeIn(500);
      setTimeout(function() {
        if (type === 'success') {
          $form[0].reset();
        }

        $notification.fadeOut(500);
      }, 8000);
    }

    $.ajax({
        type: $form.attr('method'),
        url: $form.attr('action'),
        data: $form.serialize(),
        cache       : false,
        dataType    : 'json',
        contentType: "application/json; charset=utf-8",
        error       : function(err) { alert("Could not connect to the registration server. Please try again later."); },
        success     : function(data) {
            if (data.result != "success") {
                notify('danger', data.msg);
            } else {
                notify('success', data.msg);
            }
        }
    });
}





function toggleElementVisibilityById(id) {
  $('#' + id).toggle();
}

$('.carousel').each(function() {
  var $this = $(this);

  var $pagerStatusCurrentIndex = $this.find('.carousel__pager-status .current-index');
  $this.on('slid.bs.carousel', function(e) {
    var newTargetIndex = $(e.relatedTarget).attr('data-index')
    $pagerStatusCurrentIndex.html(newTargetIndex);
  })

  var $prevButton = $this.find('.prev-button');
  $prevButton.on('click', function() {
    $this.carousel('prev');
  });

  var $nextButton = $this.find('.next-button');
  $nextButton.on('click', function() {
    $this.carousel('next');
  });
});

// to affix the left nav on scroll
var $subheaderDivider = $('.subheader .section-divider');
var $subNav = $('.content .sub-nav');
var $bottomSubNav = $('.bottom-nav .sub-nav');

window.setSideNavWaypoints = function() {
  Waypoint.destroyAll();

  new Waypoint({
    element: $subheaderDivider[0] || document.getElementsByTagName('body')[0],
    offset: '95px',
    handler: function(direction) {
      $subNav.toggleClass('fixed');
    }
  });

  var offset = $subNav.height() + 195;

  new Waypoint({
    element: $('.footer-container')[0],
    offset: offset + 'px',
    handler: function(direction) {
      $bottomSubNav.toggleClass('is-visible');
      $bottomSubNav.css('margin-top', -$subNav.height())

      $subNav.toggleClass('is-visible');
    }
  });
}

setSideNavWaypoints();

$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
  setSideNavWaypoints();
})

var $window = $(window);

$window.resize(function() {
  if ($window.width() <= 768) {
    Waypoint.disableAll();
  } else {
    Waypoint.enableAll();
  }
})

function highlightSubNavElement(href) {
  $subNav.find('.active').removeClass('active');
  $bottomSubNav.find('.active').removeClass('active');

  $subNav.find('[href="' + href + '"]').parent().addClass('active');
  $bottomSubNav.find('[href="' + href + '"]').parent().addClass('active');
}

$subNav.find('li.scroll').on('click', function(e) {
  e.preventDefault();

  var href = $(this).find('a').attr('href');
  highlightSubNavElement(href);
  disableAllSideNavWaypoints();

  $('html, body').animate({
    scrollTop: $(href).offset().top - 125
  }, 500, function() {
    enableAllSideNavWaypoints();
  });
});

var $navigationSections = $('.navigation-section');

/**
 * Waypoints for scrolling down and highlighting
 * current sections. We store these on an array 
 * so that we can disable and enable them as a group
 */
window.sideNavWaypoints = [];

$navigationSections.each(function() {
  var $el = $(this)

  window.sideNavWaypoints.push(new Waypoint({
    element: this,
    offset: $el.attr('data-waypoint-offset') || '50%',
    handler: function(direction) {
      highlightSubNavElement('#' + $el.attr('id'));
    }
  }));
});

function enableAllSideNavWaypoints() {
  window.sideNavWaypoints.forEach(function(waypoint) {
    waypoint.enable();
  });
}

function disableAllSideNavWaypoints() {
  window.sideNavWaypoints.forEach(function(waypoint) {
    waypoint.disable();
  });
}

function listenToRecording() {
  var $audioPlayerWidget = $('.audio-player-widget');
  var $audioPlayer = $audioPlayerWidget.find('#audio-player');
  var recording = $audioPlayer.find('audio')[0];

  if ($audioPlayer.hasClass('in')) {
    recording.pause();
  } else {
    recording.play();
  }

  $audioPlayerWidget.find('i').toggleClass('hidden');
}

$('.no-upcoming-public-programs a').on('click', function(e) {
  e.preventDefault();

  $('html, body').animate({
    scrollTop: $(document).height()
  }, 500)
})