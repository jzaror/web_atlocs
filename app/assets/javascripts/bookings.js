function createbooking() {
	locationid=$("#booking-location_id-input").val();
	start_date=$("#booking-start_date-input").val();
	end_date=$("#booking-end_date-input").val();
	comment=$("#booking-comment-input").val();
	data="location_id="+locationid+"&start_date="+start_date+"&end_date="+end_date+"&comment="+comment
	console.log(data)
	$.ajax({
		url: '/bookings',
		type: 'POST',
		dataType: 'json',
		data: data,
	})
	.done(function(msg) {
		// if(msg.message) {
		// 	alert(msg.message);
		// }
		if(msg.success) {
			console.log("success");
			$(".booking-request-form").hide();
			$(".alert").addClass("hide");
			$("#success-msg").removeClass("hide");
		} else {
			console.log("form validation error");
			$("#error-msg").removeClass("hide").html( msg.message );
		}
	})
	.fail(function() {
		alert("Ocurrió un error enviando tu solicitud. Por favor intenta mas tarde.")
		console.log("error");
	})
	.always(function(msg) {
		console.log("complete");
		console.log(msg)
	});
}

function submitcomment(booking) {
	$.ajax({
		url: '/bookings/'+booking+"/comment",
		type: 'POST',
		dataType: 'json',
		data: {body: $("#comment-body-input").val(),booking:booking},
	})
	.done(function(msg) {
		console.log(msg)
		$("#history").prepend('<div class="media"><div class="media-left"><div class="avatar-container"><div class="user-avatar inline"><i class="mdi mdi-account"></i></div></div></div><div class="media-body"><h4 class="media-heading">'+msg.comment.user.full_name+'</h4><p>'+msg.comment.text+'</p></div></div>');
		$("#comment-body-input").val('');
	})
	.fail(function() {
		alert("error enviando comentario. por favor intenta mas tarde")
		console.log("error");
	})
	.always(function() {
		console.log("complete");
	});

}


$(document).on("page:load", function() {

  function calendarFilter(){
    var current_date = $('#calendar').fullCalendar('getView');
    var start_date = current_date.start._d
    var end_date = current_date.end._d
    var new_data = {
      start: moment(start_date).format("YYYY-MM-DD"),
      end: moment(end_date).format("YYYY-MM-DD")
    }
    new_data['state'] = [];
    new_data['category'] = [];

    $('.category-btn').each(function(){
      if(!$(this).hasClass('active')){
        var paramValue = $(this).data('value');
        var paramName = $(this).data('param-name');
        new_data[paramName].push(paramValue);
      }
    });
    $('#calendar').fullCalendar('removeEventSources')
    $('#calendar').fullCalendar('refetchEvents')
    $('#calendar').fullCalendar('addEventSource', '/bookings.json?' + decodeURIComponent($.param(new_data)))
    $('#calendar').fullCalendar('refetchEvents');
  };

  $('.category-btn').on('click', function(){
    category = $(this).data('param-name');
    if ($(this).hasClass('active')){
      $(this).removeClass('active')
    }else{
      $(this).addClass('active')
    }
    calendarFilter();
  });

  $('.all-btn').on('click', function(){
    if ($(this).hasClass('active')){
      $('.category-btn').each(function(){
        $(this).addClass('active')
      })
    }else{
      $('.category-btn').each(function(){
        $(this).removeClass('active')
      })
    }
    calendarFilter();
  });

});
