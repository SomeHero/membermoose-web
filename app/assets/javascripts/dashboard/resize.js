// Note: You will also need to change this variable in the "variable.less" file.
$.navbar_height = 51;
/*
 * APP DOM REFERENCES
 * Description: Obj DOM reference, please try to avoid changing these
 */
$.root_ = $('body');
$.left_panel = $('#left-panel');
$.main_panel = $('#content-wrapper');
$.footer = $('#footer');
$.content_panel = $('#main')
$.shortcut_dropdown = $('#shortcut');

/*
 * DOCUMENT LOADED EVENT
 * Description: Fire when DOM is ready
 */

$(document).ready(function() {
  /*
   * Fire tooltips
   */
  if ($("[rel=tooltip]").length) {
    $("[rel=tooltip]").tooltip();
  }

  //TODO: was moved from window.load due to IE not firing consist
  nav_page_height()

  // INITIALIZE LEFT NAV
  // if (!null) {
  //   $('nav ul').jarvismenu({
  //     accordion : true,
  //     speed : $.menu_speed,
  //     closedSign : '<em class="fa fa-expand-o"></em>',
  //     openedSign : '<em class="fa fa-collapse-o"></em>'
  //   });
  // } else {
  //   alert("Error - menu anchor does not exist");
  // }

  // COLLAPSE LEFT NAV
  $('.minifyme').click(function(e) {
    $('body').toggleClass("minified");
    $(this).effect("highlight", {}, 500);
    e.preventDefault();
  });

  // HIDE MENU
  $('#hide-menu >:first-child > a').click(function(e) {
    $('body').toggleClass("hidden-menu");
    e.preventDefault();
  });

  $('#show-shortcut').click(function(e) {
    if ($.shortcut_dropdown.is(":visible")) {
      shortcut_buttons_hide();
    } else {
      shortcut_buttons_show();
    }
    e.preventDefault();
  });

  // SHOW & HIDE MOBILE SEARCH FIELD
  $('#search-mobile').click(function() {
    $.root_.addClass('search-mobile');
  });

  $('#cancel-search-js').click(function() {
    $.root_.removeClass('search-mobile');
  });

  // ACTIVITY
  // ajax drop
  $('#activity').click(function(e) {
    $this = $(this);

    if ($this.find('.badge').hasClass('bg-color-red')) {
      $this.find('.badge').removeClassPrefix('bg-color-');
      $this.find('.badge').text("0");
      // console.log("Ajax call for activity")
    }

    if (!$this.next('.ajax-dropdown').is(':visible')) {
      $this.next('.ajax-dropdown').fadeIn(150);
      $this.addClass('active');
    } else {
      $this.next('.ajax-dropdown').fadeOut(150);
      $this.removeClass('active')
    }

    var mytest = $this.next('.ajax-dropdown').find('.btn-group > .active > input').attr('id');
    //console.log(mytest)

    e.preventDefault();
  });

  $('input[name="activity"]').change(function() {
    //alert($(this).val())
    $this = $(this);

    url = $this.attr('id');
    container = $('.ajax-notifications');

    loadURL(url, container);

  });

  $(document).mouseup(function(e) {
    if (!$('.ajax-dropdown').is(e.target)// if the target of the click isn't the container...
      && $('.ajax-dropdown').has(e.target).length === 0) {
      $('.ajax-dropdown').fadeOut(150);
      $('.ajax-dropdown').prev().removeClass("active")
    }
  });

  $('button[data-loading-text]').on('click', function() {
    var btn = $(this)
    btn.button('loading')
    setTimeout(function() {
      btn.button('reset')
    }, 3000)
  });

  // NOTIFICATION IS PRESENT

  function notification_check() {
    $this = $('#activity > .badge');

    if (parseInt($this.text()) > 0) {
      $this.addClass("bg-color-red bounceIn animated")
    }
  }

  notification_check();
});
/*
 * RESIZER WITH THROTTLE
 * Source: http://benalman.com/code/projects/jquery-resize/examples/resize/
 */

(function($, window, undefined) {

  var elems = $([]), jq_resize = $.resize = $.extend($.resize, {}), timeout_id, str_setTimeout = 'setTimeout', str_resize = 'resize', str_data = str_resize + '-special-event', str_delay = 'delay', str_throttle = 'throttleWindow';

  jq_resize[str_delay] = $.throttle_delay;

  jq_resize[str_throttle] = true;

  $.event.special[str_resize] = {

    setup : function() {
      if (!jq_resize[str_throttle] && this[str_setTimeout]) {
        return false;
      }

      var elem = $(this);
      elems = elems.add(elem);
      $.data(this, str_data, {
        w : elem.width(),
        h : elem.height()
      });
      if (elems.length === 1) {
        loopy();
      }
    },
    teardown : function() {
      if (!jq_resize[str_throttle] && this[str_setTimeout]) {
        return false;
      }

      var elem = $(this);
      elems = elems.not(elem);
      elem.removeData(str_data);
      if (!elems.length) {
        clearTimeout(timeout_id);
      }
    },

    add : function(handleObj) {
      if (!jq_resize[str_throttle] && this[str_setTimeout]) {
        return false;
      }
      var old_handler;

      function new_handler(e, w, h) {
        var elem = $(this), data = $.data(this, str_data);
        data.w = w !== undefined ? w : elem.width();
        data.h = h !== undefined ? h : elem.height();

        old_handler.apply(this, arguments);
      };
      if ($.isFunction(handleObj)) {
        old_handler = handleObj;
        return new_handler;
      } else {
        old_handler = handleObj.handler;
        handleObj.handler = new_handler;
      }
    }
  };

  function loopy() {
    timeout_id = window[str_setTimeout](function() {
      elems.each(function() {
        var elem = $(this), width = elem.width(), height = elem.height(), data = $.data(this, str_data);
        if (width !== data.w || height !== data.h) {
          elem.trigger(str_resize, [data.w = width, data.h = height]);
        }

      });
      loopy();

    }, jq_resize[str_delay]);

  };

})(jQuery, this);

/*
 * NAV OR #LEFT-BAR RESIZE DETECT
 * Description: changes the page min-width of #CONTENT and NAV when navigation is resized.
 * This is to counter bugs for min page width on many desktop and mobile devices.
 * Note: This script uses JSthrottle technique so don't worry about memory/CPU usage
 */

// Fix page and nav height
function nav_page_height() {
  setHeight = $('#main').height();
  menuHeight = $.left_panel.height();
  windowHeight = $(window).height() - $.navbar_height;
  //set height

  if (setHeight > windowHeight) {// if content height exceedes actual window height and menuHeight
    $.left_panel.css('min-height', setHeight + 'px');
    $('#content-wrapper').css('min-height', setHeight + 'px');
    $('#main').css('min-height', setHeight + 'px');
    $.root_.css('min-height', setHeight + $.navbar_height + 'px');
  } else {
    $.left_panel.css('min-height', windowHeight + 'px');
    $('#content-wrapper').css('min-height', windowHeight + 'px');
    $('#main').css('min-height', windowHeight + 'px');
    $.root_.css('min-height', windowHeight + 'px');
  }
  $.footer.css('visibility', 'visible');
}

$('#content-wrapper').resize(function() {
  nav_page_height();
  check_if_mobile_width();
})

$('nav').resize(function() {
  nav_page_height();
})

function check_if_mobile_width() {
  if ($(window).width() < 979) {
    $.root_.addClass('mobile-view-activated')
  } else if ($.root_.hasClass('mobile-view-activated')) {
    $.root_.removeClass('mobile-view-activated');
  }
}
