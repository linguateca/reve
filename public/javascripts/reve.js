

function obtain_user_name () {
	var username = null;
	while (!username) {
		username = prompt("Introduza nome do utilizador.");
	}
	$("#username").html(username);
}