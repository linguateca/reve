
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
	while (!username) {
		username = prompt("Introduza nome do utilizador.");
	}
	$("#username").val(username);
}