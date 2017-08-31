// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready(function() {
  
  // BOOTSTRAP SCROLLSPY & AFFIX SCROLL ANIMATION
  $(".scrollspy .nav li > a").on('click', function(e) {
    // prevent default anchor click behavior
    e.preventDefault();
    // store hash
    var hash = this.hash;
    // animate
    $('html, body').animate({
      scrollTop: $(hash).offset().top - 70
    }, 333, function(){
      // when done, add hash to url
      // (default click behaviour)
      window.location.hash = hash;
    });
  });
  
  // Window Scroll UI Interaction
  $(window).scroll(function() {

    // Fixed Nav & back Button
    function fixedNavScroll() {
      var scroll;
      var bodySpecial = $('body.special-layout');
      // var btnFixed = $('.btn-fixed');
      scroll = $(window).scrollTop();
      if ( scroll >= 350 ) {
        bodySpecial.addClass('force-fixed-header');
        // btnFixed.addClass('show');
      } else if ( scroll <= 150 ) {
        // btnFixed.removeClass('show');
      } else {
        bodySpecial.removeClass('force-fixed-header');
      }
    };
    fixedNavScroll();

    // ...

  });

  // Checkbox Legales y Privacidad
  var legalCheck = $('#legal-checkbox');
  function legalCheckHandler(){
    if($(this).is(":checked")) {
      $('#form-submit').removeAttr('disabled');
    } else {
      $('#form-submit').attr('disabled', '');
    }
  };

  if (QueryString.newlocation) {
    legalCheck.on("change", legalCheckHandler);
  }

  // Unslider
  $('.welcome-slider').unslider({
    autoplay: true,
    delay: 6500,
    arrows: false,
    // animation: "fade",
    speed: 500,
  });
});
