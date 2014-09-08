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
%% @deftypefn  {Function File} {@var{L}, @var{U} =} lu (@var{A})
%% @deftypefnx {Function File} {@var{L}, @var{U}, @var{P} =} lu (@var{A})
%% @deftypefnx {Function File} {... =} lu (@var{A}, 'vector')
%% Symbolic LU factorization of a matrix.
%%
%% @end deftypefn

%% Author: Colin B. Macdonald
%% Keywords: symbolic

function [L, U, P] = lu(A, opt)

  if (nargin < 2)
    opt = 'matrix';
  end
  assert (strcmp(opt, 'matrix') || strcmp(opt, 'vector'))

  cmd = [ '(A,opt) = _ins\n'  ...
          'if not A.is_Matrix:\n' ...
          '    A = sp.Matrix([A])\n' ...
          '(L, U, p) = A.LUdecomposition()\n' ...
          '# convert list to P\n' ...
          'n = L.shape[0]\n' ...
          'if opt == "matrix":\n' ...
          '    P = sp.eye(n)\n' ...
          'else:\n' ...
          '    P = sp.Matrix(range(1, n+1))\n' ...
          'for w in p:\n' ...
          '    P.row_swap(*w)\n' ...
          'return (L, U, P)' ];

  [L, U, P] = python_cmd_string (cmd, sym(A), opt);

  if (nargout == 2)
    L = P.' * L;
  end
end



%!test
%! % scalar
%! [l, u, p] = lu(sym(6));
%! assert (isequal (l, sym(1)))
%! assert (isequal (u, sym(6)))
%! assert (isequal (p, sym(1)))
%! syms x
%! [l, u, p] = lu(x);
%! assert (isequal (l*u, p*x))
%! [l, u] = lu(x);
%! assert (isequal (l*u, x))

%!test 
%! % perm
%! A = sym(fliplr(2*eye(3)));
%! [L, U, P] = lu(A);
%! assert (isequal (L*U, P*A))
%! [L, U, P] = lu(A, 'matrix');
%! assert (isequal (L*U, P*A))
%! [L, U, p] = lu(A, 'vector');
%! assert (isequal (L*U, A(p,:)))
%! [L, U] = lu(A);
%! assert (isequal (L*U, A))

%!test
%! % p is col vectpr
%! A = sym([0 2; 3 4]);
%! [L, U, p] = lu(A, 'vector');
%! assert(iscolumn(p))

%!test
%! % simple matrix
%! A = [1 2; 3 4];
%! B = sym(A);
%! [L, U, P] = lu(B);
%! assert (isequal (L*U, P*A))
%! assert (isequal (U(2,1), sym(0)))
%! % needs pivot
%! A = [0 2; 3 4];
%! B = sym(A);
%! [L, U, P] = lu(B);
%! [Ld, Ud, Pd] = lu(A);
%! assert (isequal (L*U, P*A))
%! assert (isequal (U(2,1), sym(0)))
%! % matches regular LU
%! assert ( max(max(double(L)-Ld)) <= 10*eps)
%! assert ( max(max(double(U)-Ud)) <= 10*eps)
%! assert ( isequal (P, Pd))

