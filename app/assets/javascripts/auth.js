var current_user=null;

function loginWithEmailAndPassword() {
	email=$("#login-email-input").val();
	password=$("#login-password-input").val();
	$.ajax({
		url: '/login.json',
		type: 'POST',
		dataType: 'json',
		data: {email:email,password:password}
	})
	.done(function(msg) {
		console.log(msg);
		if(msg.success==true) {
			current_user=msg.current_user;
			window.location.reload();
			// $(".mdi-close").click();
			// $("#loginlink").html("<a href='/logout'>Salir</a>");
		} else {
			alert(msg.message)
		}
		
	})
	.fail(function() {
		console.log("error");
	})
	.always(function() {
		console.log("complete");
	});
}
function registerWithEmailAndPassword() {
	console.log("creating user...")
	email=$("#register-email-input").val();
	password=$("#register-password-input").val();
	firstname=$("#register-firstname-input").val();
	lastname=$("#register-lastname-input").val();
	phone=$("#register-phone-input").val();
	$.ajax({
		url: '/users',
		type: 'POST',
		dataType: 'json',
		data: {email:email,password:password,first_name:firstname,last_name:lastname,phone:phone},
	})
	.done(function(msg) {
		if(msg.success==true) {
			current_user=msg.current_user
			window.location.href="/"

		} else {
			alert(msg.message);
		}
	})
	.fail(function() {
		console.log("error");
	})
	.always(function() {
		console.log("complete");
	});
	
}