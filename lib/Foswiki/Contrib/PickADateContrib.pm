package Foswiki::Contrib::PickADateContrib;

use strict;
use warnings;

use Error qw(:try);
use Foswiki::Func;
use Foswiki::Meta;
use Foswiki::Plugins::JQueryPlugin;

our $VERSION = '1.0.0';
our $RELEASE = '1.0.0';
our $SHORTDESCRIPTION = 'Just another client side date picker using jQuery';

sub initDatePicker {
  _addToZone(shift, 'date');
}

sub initTimePicker {
  _addToZone(shift, 'time');
}

sub _getMeta {
  my $session = $Foswiki::Plugins::SESSION;
  Foswiki::Meta->new($session, $session->{webName}, $session->{topicName})
}

sub _addToZone {
  my $meta = shift || _getMeta();
  my $picker = shift;

  my $debug = $Foswiki::cfg{PickADateContrib}{Debug} || 0;
  my $suffix = $debug ? '.uncompressed' : '';

  my $pluginURL = '%PUBURLPATH%/%SYSTEMWEB%/PickADateContrib';
  my $styles = <<STYLES;
<link rel="stylesheet" type="text/css" media="all" href="$pluginURL/css/classic$suffix.css" />
<link rel="stylesheet" type="text/css" media="all" href="$pluginURL/css/classic.$picker$suffix.css" />
STYLES
  Foswiki::Func::addToZone( 'head', "PICKADATECONTRIB::\U$picker\E2::STYLES", $styles);

  my $scripts = <<SCRIPTS;
<script type="text/javascript" src="$pluginURL/js/picker$suffix.js"></script>
<script type="text/javascript" src="$pluginURL/js/picker.$picker$suffix.js"></script>
<script type="text/javascript" src="$pluginURL/js/picker.init$suffix.js"></script>
SCRIPTS

  Foswiki::Plugins::JQueryPlugin::createPlugin("jqp::observe");
  my $lang = $meta->expandMacros('%LANGUAGE%');
  $scripts .= "<script type=\"text/javascript\" src=\"$pluginURL/js/i18n/$lang.js\"></script>" if $lang =~ /^(de|fr)$/;
  Foswiki::Func::addToZone( 'script', "PICKADATECONTRIB::\U$picker\E2::SCRIPTS", $scripts, 'JQUERYPLUGIN::JQP::OBSERVE, FOSWIKI::PREFERENCES' );
}

1;

__END__

# Copyright (C) 2015 Modell Aachen GmbH <http://www.modell-aachen.de>

# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.

# You should have received a copy of the GNU General Public License along
# with this program.  If not, see <http://www.gnu.org/licenses/>.
