// # This is a manifest file that'll be compiled into application.js, which will include all the files
// # listed below.
// #
// # Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// # or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
// #
// # It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// # compiled file.
// #
// # Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// # about supported directives.
// #
//= require auth
//= require jquery
//= require tether
//= require jquery_ujs
//= require jquery.datatables
//= require jquery.ui.widget
//= require jquery-ui.min
//= require jquery.fileupload.js
//= require unslider/dist/js/unslider-min

//= require moment
//= require fullcalendar

//= require interactions
//= require locations
//= require bookings
//= require calendar
//= require jquery.blueimp-gallery
//= require bootstrap-image-gallery
//= require jquery.jcrop
//= require papercrop

// # BOOTSTRAP
//= require bootstrap-sprockets

// # ALL THE REST
// # require_tree .
//= require geocomplete
//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.es.js
//= require jquery-ui/autocomplete
//= require autocomplete-rails


var QueryString = function () {
  // This function is anonymous, is executed immediately and
  // the return value is assigned to QueryString!
  var query_string = {};
  var query = window.location.search.substring(1);
  var vars = query.split("&");
  for (var i=0;i<vars.length;i++) {
    var pair = vars[i].split("=");
        // If first entry with this name
    if (typeof query_string[pair[0]] === "undefined") {
      query_string[pair[0]] = decodeURIComponent(pair[1]);
        // If second entry with this name
    } else if (typeof query_string[pair[0]] === "string") {
      var arr = [ query_string[pair[0]],decodeURIComponent(pair[1]) ];
      query_string[pair[0]] = arr;
        // If third or later entry with this name
    } else {
      query_string[pair[0]].push(decodeURIComponent(pair[1]));
    }
  }
    return query_string;
}();

$('#calendar').fullCalendar({});

$(document).ready(function() {
  $(".alert-success" ).delay(3000).fadeOut(2000);
});

// //OPEN MODAL AFTER CREATING A LOCATION
// if (QueryString.open=="newuser") {
//   //open modal to register user
//   $(window).load(function(){
//     $("#loginModal").modal("show");
//   });
//   console.log("crear usuario");
// }else if (QueryString.open=="share"){
//   //open share modal
// }
