package ReVe;
use Dancer2;
use Dancer2::Plugin::Database;

our $VERSION = '0.1';

get '/*' => sub {
	my ($id) = splat;
	template 'project' => {
		project => _get_project($id),
		concs   => _get_concs($id),
		classes => _get_classes($id),
	}
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
	[ database->quick_select('conc', { rev_id => $id })]
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
#                          "timetamp" DATETIME NOT NULL,
#                          "obs" VARCHAR,
#                          PRIMARY KEY ("conc_id", "class_id", "username"))

true;
