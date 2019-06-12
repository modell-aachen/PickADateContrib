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
  if (!$size || $size < 1) {
    $this->{size} = "100%";
  } else {
    $this->{size} = $size . "em";
  }

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

sub getDisplayValue {
  my ($this, $value) = @_;
  return '' if $value =~ /^\s*$/;

  $value = _convertDate($value);
  my $format = $Foswiki::cfg{DefaultDateFormat};
  $value = Foswiki::Time::formatTime($value, $format, 'servertime');
  if ($format =~ /month/) {
    $value =~ s/(?<=\s)([^\s]+)(?!=\s)/%MAKETEXT{$1}%/;
  }
  $value;
}

sub _getSkin {
  my ($this) = @_;
  my $attributes = $this->{attributes};
  if($attributes =~ /skin="(.*)"/) {
    return $1;
  }
  return;
}

sub renderForEdit {
  my ($this, $topicObject, $value) = @_;
  my $skin = $this->_getSkin();
  Foswiki::Contrib::PickADateContrib::initDatePicker($topicObject, $skin);

  $value = Foswiki::Func::encode(_convertDate($value));
  my $size = Foswiki::Func::encode($this->{size} . "em");
  my $name = Foswiki::Func::encode($this->{name});
  my $format = $Foswiki::cfg{DefaultDateFormat} || '$day $month $year';
  $format =~ s/\$year/yyyy/;
  $format =~ s/\$day/dd/;
  $format =~ s/\$month/mmm/;
  $format =~ s/\$mo/mm/;

  my $mandatoryMarker = ($this->isMandatory()) ? ' foswikiMandatory' : '';

  my $input = <<INPUT;
  <input type="text" data-format="$format" data-epoch="$value" name="$name" data-name="$name" class="foswikiInputField foswikiPickADate$mandatoryMarker" style="width: $size" />
INPUT
  if(defined $skin && $skin eq 'flat') {
    $input = <<INPUT;
      <div class="ma-date-container">
        $input
        <i class="far fa-calendar" aria-hidden="true"></i>
      </div>
INPUT
  }

  return ('', $input);
}

sub renderForDisplay {
    my ( $this, $format, $value, $attrs ) = @_;
    return $this->SUPER::renderForDisplay($format, $value, $attrs) if $value =~ /^\s*$/;

    $value = _convertDate($value);
    if ($value =~ /^\d+$/) {
      my $format = $Foswiki::cfg{DefaultDateFormat} || '$day $month $year';
      $value = Foswiki::Time::formatTime($value, $format, 'servertime');
      if ($format =~ /month/) {
        $value =~ s/(?<=\s)([^\s]+)(?!=\s)/%MAKETEXT{$1}%/;
      }
    }

    return $this->SUPER::renderForDisplay($format, $value, $attrs);
}

sub _convertDate {
  my $date = shift;
  if ($date =~ /\d{1,2}\s\w{3}\s\d{4}/ || $date =~ /^\d{4}-\d{2}-\d{2}/) {
    $date = Foswiki::Time::parseTime($date);
  }
  $date;
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
