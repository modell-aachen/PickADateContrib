package Foswiki::Form::Date2;

use strict;
use warnings;

use Foswiki::Contrib::PickADateContrib;
use Foswiki::Form::FieldDefinition;
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

  if($this->{value} =~ /,/ || $this->{value} =~ /=/) {
    my $val;
    foreach my $e (split(/,/, $this->{value})){
      $this->{min} = $1 if $e =~ /^\s*min\s*=\s*(\d+|true)\s*$/;
      $this->{max} = $1 if $e =~ /^\s*min\s*=\s*(\d+|true)\s*$/;
      $val = $e unless $e =~ /^\s*(min|max)/;
    }

    $this->{value} = $val;
  }

  return $this;
}

sub renderForEdit {
  my ($this, $topicObject, $value) = @_;
  Foswiki::Contrib::PickADateContrib::initDatePicker($topicObject);

  my $size = $this->{size} . "em";
  my $name = $this->{name};
  my $format = $Foswiki::cfg{DefaultDateFormat} || '$day $month $year';
  $format =~ s/\$year/yyyy/;
  $format =~ s/\$day/dd/;
  $format =~ s/\$month/mmm/;
  $format =~ s/\$mo/mm/;

  my $input = <<INPUT;
  <input type="text" data-format="$format" data-epoch="$value" name="$name" class="foswikiInputField foswikiPickADate" style="width: $size" />
INPUT

  return ('', $input);
}

sub renderForDisplay {
    my ( $this, $format, $value, $attrs ) = @_;
    if ($value =~ /^\d+$/) {
      my $format = $Foswiki::cfg{DefaultDateFormat} || '$day $month $year';
      $value = Foswiki::Time::formatTime($value, $format);
      if ($format =~ /month/) {
        $value =~ s/(?<=\s)([^\s]+)(?!=\s)/%MAKETEXT{$1}%/;
      }
    }

    return $this->SUPER::renderForDisplay($format, $value, $attrs)
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
