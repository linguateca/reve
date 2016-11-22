#!/usr/bin/env perl

use Plack::Builder;
use FindBin;
use lib "$FindBin::Bin/../lib";

use ReVe;


builder {
    mount '/reve' => ReVe->to_app;
};
