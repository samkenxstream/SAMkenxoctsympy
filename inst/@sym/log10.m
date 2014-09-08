%% Copyright (C) 2014 Colin B. Macdonald
%%
%% This file is part of OctSymPy.
%%
%% OctSymPy is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 3 of the License,
%% or (at your option) any later version.
%%
%% This software is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty
%% of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
%% the GNU General Public License for more details.
%%
%% You should have received a copy of the GNU General Public
%% License along with this software; see the file COPYING.
%% If not, see <http://www.gnu.org/licenses/>.

%% -*- texinfo -*-
%% @deftypefn {Function File} {@var{y} =} log10 (@var{x})
%% Symbolic log base 10 function.
%%
%% @seealso{log,log2}
%% @end deftypefn

%% Author: Colin B. Macdonald
%% Keywords: symbolic

function z = log10(x)

  cmd = [ '(x,) = _ins\n' ...
          'y = sp.log(x,10)\n' ...
          'return (y,)' ];

  z = python_cmd_string (cmd, x);

end


%!assert (isequal (log10 (sym (1000)), sym (3)))
