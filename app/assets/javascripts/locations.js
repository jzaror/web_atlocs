//# Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/

function validateLocationForm() {
	alert("HI");
	return false;
}
$(document).ready(function() {

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

	$('#fileupload').fileupload({
        dataType: 'json',
        progressall: function (e, data) {
	        var progress = parseInt(data.loaded / data.total * 100, 10);
	        console.log(e)
	        console.log(data)
	        $("#progress-bar").css("width",progress+"%")

	    },
        done: function (e, data) {
            console.log(data.result)
            appendfile(data.result.files)
        	$("#file-progress").addClass("invisible")
        },
        start: function(e) {
        	console.log(e)
        	$("#file-progress").removeClass("invisible")
        }
    });

});

function appendfile(file) {
	$("#file-list").append("<tr id='file"+file.deleteUrl+"' class='file'><td><img src='"+file.url+"' style='width:80px;height:auto'><td><a href='"+file.url+"'>"+file.name+"</a></td><td class='text-right'><a href='javascript:deletefile(\""+file.deleteUrl+"\")' id='delete-file-button-"+file.deleteUrl+"' class='btn btn-danger btn-sm'><i class='mdi mdi-close'></i> eliminar</a></td></tr>")
};
function deletefile(id) {
	$("#delete-file-button-"+id).attr("disabled","disabled");
	$.ajax({
		url: '/attachments/'+id+'/destroy',
		type: 'GET'
	})
	.done(function() {
		$("#file"+id).remove();
	})
	.fail(function() {
		console.log("error");
				$("#file"+id).remove();

	})
	.always(function() {
		console.log("complete");
	});
};
