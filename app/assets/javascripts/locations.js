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

	// $('#pictureInput').on('change', function(event) {
	//     var files = event.target.files;
	//     var image = files[0]
	//     var reader = new FileReader();
	//     reader.onload = function(file) {
	//       var img = new Image();
	//       console.log(file);
	//       img.src = file.target.result;
	//       $('#file-list').append(
	//       	"<tr>\
	//       	<td>\
	//       	<img src='"+img.src+"' style='width:80px;height:auto'>\
	//       	</td>\
	//       	</tr>"
 //      		);
	//     }
	//     reader.readAsDataURL(image);
	//     console.log(files);
	//   });

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
            appendfile(data.result)
        	$("#file-progress").addClass("invisible")
        },
        start: function(e) {
        	console.log(e)
        	$("#file-progress").removeClass("invisible")
        }
    });

});

function appendfile(file) {
	if ( file.is_main == "true" ){
		$("#file-list").append(
			"<tr id='file"+file.deleteUrl+"' class='file'>\
				<td>\
					<img src='"+file.url+"' style='width:80px;height:auto'>\
					<td>\
					<a href='"+file.url+"'>"+file.name+"</a>\
				 	</td>\
					<td class='text-right'>\
						<span class='badge badge-primary'> Imagen Destacada </span>\
					</td>\
					<td class='text-right'>\
					<a href='javascript:deletefile(\""+file.deleteUrl+"\")' id='delete-file-button-"+file.deleteUrl+"' class='btn btn-danger btn-sm'>\
					<i class='mdi mdi-close'></i>Eliminar</a>\
				</td>\
			</tr>")
	}else
	{
		$("#file-list").append(
			"<tr id='file"+file.deleteUrl+"' class='file'>\
				<td><img src='"+file.url+"' style='width:80px;height:auto'>\
				<td>\
					<a href='"+file.url+"'>"+file.name+"</a>\
				</td>\
				<td class='text-right'>\
					<a href='javascript:featureImage(\""+file.id+"\",\""+file.location_id+"\")' class='btn btn-sm btn-secondary'> Destacar </a>\
				</td>\
				<td class='text-right'>\
					<a href='javascript:deletefile(\""+file.deleteUrl+"\")' id='delete-file-button-"+file.deleteUrl+"' class='btn btn-danger btn-sm'>\
					<i class='mdi mdi-close'></i> Eliminar</a>\
				</td>\
			</tr>")
	}
};

function featureImage(attachment_id,location_id){
	$.ajax({
		url: '/locations/'+location_id+'/feature_image',
		type: 'put',
		dataType: 'JSON',
		data:
			{attachment_id: attachment_id}
	})
	.done(function(){
		window.location.reload();
	})
	.fail(function() {
		console.log("error");
	})
}

function deletefile(id) {
	$("#delete-file-button-"+id).attr("disabled","disabled");
	$.ajax({
		url: '/uploads/'+id+'/destroy',
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
