$(document).ready(function(){
  extraOrServiceChanged();
});

function formatNumber (num) {
    return num.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1.")
}

$(function(){

  // map
  var options = {
    map: ".map_canvas",
    location: [-33.4263374, -70.6170497],
    details: "form",
    detailsAttribute: "data-geo",
    mapOptions: {
      zoom: 17
    }
  };
  $("#location_address").geocomplete(options)
    .bind("geocode:result", function(event, result){
      //$.log("Result: " + result.formatted_address);
    })
    .bind("geocode:error", function(event, status){
      //$.log("ERROR: " + status);
    })
    .bind("geocode:multiple", function(event, results){
      //$.log("Multiple: " + results.length + " results found");
  });

  //calculate final price on load
  $("#result").html(formatNumber(Math.ceil($("#location_price").val() * 1.15)));

  $("#location_price").on('input', function(e) {
    var currentPrice = $(this).val();
    var totalPrice = Math.ceil(currentPrice * 1.15);
    var fee = (totalPrice - currentPrice);
    $("#result").html(formatNumber(fee));
    $("#location_fee").val(fee);
  });

});

function extraOrServiceChanged(){
  if ($("#location_services_otro").is(":checked")){
    $('.other-services-comment').show();
  } else {
    $('.other-services-comment').val('');
    $('.other-services-comment').hide();
  }
  if ($("#location_extras_otro").is(":checked")){
    $('.other-extras-comment').show();
  } else {
    $('.other-extras-comment').val('');
    $('.other-extras-comment').hide();    
  }
}
