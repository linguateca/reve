package ReVe;
use Dancer2;
use Dancer2::Plugin::Database;

our $VERSION = '0.1';

get '/review/*' => sub {
	my ($id) = splat;

	my $concs = _get_concs($id);
	my $lrevs = _get_latest_revision($id);
	for my $r (keys %$lrevs) {
		$concs->{$r}{class} = $lrevs->{$r};
	}
	my $revs = _get_all_revisions($id);
	for my $r (@$revs) {
		$r->{timestamp} = localtime $r->{timestamp};
		push @{$concs->{$r->{conc_id}}{revs}}, $r;
	}

	$concs = [
		map {$concs->{$_}} sort { $a <=> $b } keys %$concs
	];

	template 'project' => {
		project   => _get_project($id),
		concs     => $concs,
		classes   => _get_classes($id),
	}
};

get '/details/*/*' => sub {
	my ($id, $conc_id) = splat;

	my $classes;
	my $revisions = _get_revisions($conc_id);
	for (@{ _get_classes($id) }) {
		$classes->{$_->{id}} = $_;
	}
	$revisions = [ map {
		$_->{timestamp} = localtime($_->{timestamp});
		$_->{class}     = $classes->{$_->{class_id}};
		$_
	} @$revisions ];

	template 'detail' => {
		project   => _get_project($id),
		conc      => _get_conc($conc_id),
		revisions => $revisions,
	};
};

post '/save/*/*' => sub {
	my ($id, $conc_id) = splat;
	my $classe   = param "classe";
	my $obs      = param "obs";
	my $username = param "user";

	_save_revision($id, $conc_id, $classe, $obs, $username);

	content_type("json");
	to_json({status => 'ok'});
};

get '/' => sub {
    template 'index' => {
    	current => _get_projects()
    }
};



# CREATE TABLE "rev" ("id" INTEGER PRIMARY KEY IA,
#                     "titulo",
#                     "open" BOOL NOT NULL DEFAULT 1,
#                     "user" VARCHAR,
#                     "desc" VARCHAR)
sub _get_projects {
	[ database->quick_select('rev', {}) ]
}

sub _get_project {
	my $id = shift;
	my @x = database->quick_select('rev', { id => $id });
	return $x[0];
}

# CREATE TABLE "conc" ("id" INTEGER PRIMARY KEY AI NOT NULL,
#                      "rev_id" INTEGER NOT NULL ,
#                      "text" varchar);
sub _get_concs {
	my $id = shift;
	+{ map { ($_->{id} => $_)} (database->quick_select('conc', { rev_id => $id })) }
}

sub _get_conc {
	my $id = shift;
	my @x = database->quick_select('conc', { id => $id });
	return $x[0];
}

# CREATE TABLE "classes" ("id" INTEGER PRIMARY KEY AI,
#                         "rev_id" INTEGER NOT NULL,
#                         "order" INTEGER NOT NULL,
#                         "name" VARCHAR NOT NULL,
#                         "desc" VARCHAR)
sub _get_classes {
	my $id = shift;
	[ database->quick_select('classes', { rev_id => $id }, { order_by => 'order' })]
}

# CREATE TABLE "revision" ("conc_id" INTEGER NOT NULL,
#                          "class_id" INTEGER NOT NULL,
#                          "username" VARCHAR NOT NULL,
#                          "timestamp" DATETIME NOT NULL,
#                          "obs" VARCHAR,
#                          PRIMARY KEY ("conc_id", "class_id", "username"))

sub _get_all_revisions {
	my ($id) = @_;
	# classes.name, classes.desc, revision.conc_id, revision.class_id, revision.username, revision.obs, revision.timestamp
	my $sth = database->prepare("SELECT * FROM (conc INNER JOIN revision ON conc.id = revision.conc_id) as X INNER JOIN classes ON X.class_id = classes.id WHERE X.rev_id = ?;");
	$sth->execute($id);
	$sth->fetchall_arrayref({});
}

sub _get_latest_revision {
	my ($id) = @_;
	my $dbh = database->prepare("SELECT conc.id, revision.class_id, MAX(timestamp) FROM conc INNER JOIN revision ON conc.id = revision.conc_id WHERE conc.rev_id = ? GROUP BY conc_id;");
	$dbh->execute($id);
	$dbh->fetchall_hashref("id");
}

sub _save_revision {
	my ($id, $conc_id, $classe, $obs, $username) = @_;
	database->quick_insert( revision => {
			conc_id   => $conc_id,
			class_id  => $classe,
			username  => $username,
			timestamp => time,
			obs       => $obs,
		});
}

true;
