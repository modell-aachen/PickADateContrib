// Copyright (C) 2015 Modell Aachen GmbH <http://www.modell-aachen.de>

// This program is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option)
// any later version.

// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
// more details.

// You should have received a copy of the GNU General Public License along
// with this program.  If not, see <http://www.gnu.org/licenses/>.


(function($) {
  var initDatePicker = function() {
    var $picker = $(this);
    var format = $picker.data('format') || 'dd mmm yyyy';
    var name = $picker.attr('name');

    var opts = {
      format: format,
      formatSubmit: format,
      hiddenName: true,
      selectMonths: true,
      selectYears: true,
      onClose: function() {
        var $hidden = $('input[name="' + name + '"]');
        if (!/^\d+$/.test($hidden.val())) {
          $hidden.val($(this.$node[0]).data('epoch'));
        }
      },
      onSet: function(ctx) {
        var $hidden = $('input[name="' + name + '"]');
        if (ctx.clear === null) {
          $(this.$node[0]).data('epoch', '');
        } else if (typeof ctx.select !== typeof 0) {
          return;
        }

        var epoch = ctx.select;
        if (epoch) {
          if (typeof moment === 'function') {
            var m = moment(epoch);
            epoch = m.utc().unix();
          } else {
            epoch = epoch/1000;
          }
        }

        $hidden.val(epoch);
      }
    };

    var dmin = $picker.data('min');
    if (/^true$/i.test(dmin)) {
      opts.min = true;
    } else if (/^-?\d+$/.test(dmin)) {
      opts.min = parseInt(dmin);
    }

    var dmax = $picker.data('max');
    if (/^true$/i.test(dmax)) {
      opts.max = true;
    } else if (/^-?\d+$/.test(dmax)) {
      opts.max = parseInt(dmax);
    }

    $picker.pickadate(opts);
    var epoch = $picker.data('epoch');
    if (epoch) {
      epoch = 1000 * parseInt(epoch);
      $picker.pickadate('picker').set('select', epoch);
    }

    $picker.closest('form').on('submit', function() {
      var $hidden = $('input[name="' + name + '"]');
      if (!/^\d+$/.test($hidden.val())) {
        $hidden.val($picker.data('epoch'));
      }
    });
  };

  var initTimePicker = function() {
    var $picker = $(this);
    var name = $picker.attr('name');

    var format = $picker.data('format') || 'HH:i';
    var opts = {
      format: format,
      formatSubmit: format,
      hiddenName: true,
      onClose: function() {
        var $hidden = $('input[name="' + name + '"]');
        if (!/^\d+$/.test($hidden.val())) {
          $hidden.val($(this.$node[0]).data('minutes'));
        }
      },
      onSet: function(ctx) {
        var $hidden = $('input[name="' + name + '"]');
        if (ctx.clear === null) {
          $(this.$node[0]).data('minutes', '');
        } else if (typeof ctx.select !== typeof 0) {
          return;
        }

        $hidden.val(ctx.select);
      }
    };

    $picker.pickatime(opts);
    $picker.closest('form').on('submit', function() {
      var $hidden = $('input[name="' + name + '"]');
      if (!/^\d+$/.test($hidden.val())) {
        $hidden.val($picker.data('minutes'));
      }
    });
  };

  $(document).ready( function() {
    $('.foswikiPickADate').livequery(function() {
      initDatePicker.call(this);
    });

    $('.foswikiPickATime').livequery(function() {
      initTimePicker.call(this);
    });
  });
})(jQuery);
