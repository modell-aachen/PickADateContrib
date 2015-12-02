package Foswiki::Form::Time2;

use strict;
use warnings;

use Foswiki::Plugins::JQueryPlugin ();
use Foswiki::Form::FieldDefinition ();
use Foswiki::Contrib::PickADateContrib;
our @ISA = ('Foswiki::Form::FieldDefinition');

BEGIN {
  if ($Foswiki::cfg{UseLocale}) {
    require locale;
    import locale();
  }
}

sub new {
  my $class = shift;
  my $this = $class->SUPER::new(@_);

  my $size = $this->{size} || '';
  $size =~ s/\D//g;
  $size = 10 if (!$size || $size < 1);
  $this->{size} = $size;

  return $this;
}

sub renderForEdit {
  my ($this, $topicObject, $value) = @_;
  Foswiki::Contrib::PickADateContrib::initTimePicker($topicObject);

  my $size = $this->{size} . "em";
  my $name = $this->{name};
  my $tf = $Foswiki::cfg{PickADateContrib}{TimeFormat} || '24';
  my $format = $tf =~ /24/ ? 'HH:i' : 'hh:i a';

  my $input = <<INPUT;
<input type="text" data-format="$format" data-value="$value" data-minutes="$value" name="$name" class="foswikiInputField foswikiPickATime" style="width: $size">
INPUT

  return ('', $input);
}

sub renderForDisplay {
  my ( $this, $format, $value, $attrs ) = @_;
  my $tf = $Foswiki::cfg{PickADateContrib}{TimeFormat} || '24';

  my $h = int($value/60);
  $h = '0' . $h if $h < 10;
  my $m = $value%60;
  $m = '0' . $m if $m < 10;

  if ($tf =~ /24/) {
    $value = "$h:$m";
  } else {
    my $pm = 0;
    if (int($h) > 12) {
      $pm = 1;
      $h = int($h) - 12;
      $h = '0' . $h if $h < 10;
    }

    $value = "$h:$m " . ($pm ? 'p.m.' : 'a.m.');
  }

  return $this->SUPER::renderForDisplay( $format, $value, $attrs );
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
