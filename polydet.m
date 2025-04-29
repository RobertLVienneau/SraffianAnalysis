% Expresses the determinant of a matrix as a polynomial.
%
% Consider the matrix B - r*A. Its determinant is a polynomial.
% A: A square matrix. Let n be the number of rows or columns.
% B: A square matrix, the same size as A.
%
% p: A row vector. The coefficients of a polynomial of degree n.

function p = polydet( A, B)

  % printf("In polydet\n");

  % Figure out the size.
  n1 = size( A, 1 );
  m1 = size( A, 2 );
  n2 = size( B, 1 );
  m2 = size( B, 2 );

  n = min( [ n1, m1, n2, m2 ] );
  if ( (n1 != n) || (m1 != n) || (n2 != n) || (m2 != n))
    printf( "*** Warning: Inconsistent matrix sizes in function polydet! ***\n" );
  endif

  % Initialize
  p = zeros( 1, n + 1);

  % Set the coefficient for r^n.
  % n choose 0 is 1.
  plusOrMinusOne = (-1)^n;
  p(1) = plusOrMinusOne*det(A);

  % Create a row vector [1, 2, ..., n].
  ramp = 1:n;

  % Each coefficient is the sum of
  %  the product of plusOrMinusOne and a number of deterninants. In the first
  %  iteration, these are all matrices built from A, with one row replaced by
  %  the corresponding row of B. In the second iteration, these are all matrices
  %  built from A with two rows replaced by the corresponding row of B. And
  %  so on.
  for idx = 1:1:(n - 1)
    % This iteration is to find the coefficient for r^power.
    power = n - idx;

    % I want all combinations of idx elements chosen from [1, 2, ..., n].
    % This bit of combinatorics is a matter of iterating through a row of
    % Pascal's trinagle, more or less.

    C = nchoosek( ramp, idx );
    % C is an array with the number of rows equal to the number of combinations.
    % Each row is a combination. For example, nchoosek( [1, 2, 3], 2 ) is
    %    [[1, 2];[1, 3];[2, 3]].

    numberIndices = size(C, 2);
    for idx2 = 1:1:size(C, 1)
      M = A;
      % TODO: Can the loop be replaced by:
      % M( C(idx2)', : ) = B( C(idx2)', : );
      for idx3 = 1:1:numberIndices
        rowIndex = C(idx2, idx3);
        M(rowIndex, : ) = B(rowIndex, : );
      endfor
      p( idx + 1 ) = p( idx + 1 ) + det( M );
    endfor

    plusOrMinusOne = (-1)*plusOrMinusOne;
    p(idx + 1) = plusOrMinusOne*p(idx + 1);

  endfor

  % Set the coefficient for the constant term.
  % n choose n is 1.
  p( n + 1) = det(B);

end
