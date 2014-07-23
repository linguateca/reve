
function esconder_revisoes() {
	$(".revisoes").hide();
}

function toggle_revisoes(button) {
	$(".revisoes").toggle();
	if ($(".revisoes").hasClass("hide")) {
		button.html("Mostrar Revisões");
	} else {
		button.html("Esconder Revisões");
	}
}

function obtain_user_name () {
	var username = null;
	while (!username) {
		username = prompt("Introduza nome do utilizador.");
	}
	$("#username").html(username);
}