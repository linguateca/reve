
function esconder_revisoes() {
	$(".revisoes").hide();
}

function toggle_revisoes(button) {
	$(".revisoes").toggle();
	if ($(".revisoes").is(":visible")) {
		button.html("Esconder Revisões");
	} else {
		button.html("Mostrar Revisões");
	}
}

function obtain_user_name () {
	var username = null;
	username = prompt("Introduza nome do utilizador.");

	if (!username) {
		window.location = $("#uri_base").val();
	}

	$("#username").val(username);
}