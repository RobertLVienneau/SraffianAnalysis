% Finds coefficients of polynomials for an n-commodity model.
% a0: A row vector of labor coefficients.
% A: A square matrix of commodity inputs.
% B: A square matrix of commodity outputs.
% d: A column vector specifying the numeraire.
% S: A diagonal square matrix of relative markups.
%
% f: Coefficients of the polynomial in the numerator for the rational function
%  for the wage.
% g: Coefficients of the polynomial in the denominator for the rational functions
%  for the wage and prices of produced commodities.
% numer: Each column has coefficients of a polynomial for the numerator of a rational function.
%

function [f, g, numer] = get_rational_functionsN( a0, A, B, d, S )

  % Find out how many commodities there are.
  m1 = size( a0, 2 );

  n2 = size( A, 1 );
  m2 = size( A, 2 );
  n3 = size( B, 1 );
  m3 = size( B, 2 );
  n4 = size( d, 1 );
  n5 = size( S, 1 );
  m5 = size( S, 2 );

  if ( (m1 != n2) || (m1 != m2) || (m1 != n3) || (m1 != m3) || ...
       (m1 != n4) || (m1 != n5) || (m1 != m5) )
    printf( "*** Warning: Inconsistent matrix sizes in function polydet! ***\n" );
  endif
  numberCommodities = min( [m1, n2, m2, n3, m3, n4, n5, m5] );

  % Allocate space.
  f = zeros(1, numberCommodities + 1);
  g = zeros(1, numberCommodities);
  numer = zeros(numberCommodities, numberCommodities);

  % Find a matrix multiplied by r and a constant matrix.
  AS = A*S;
  BA = B - A;

  % Find the coefficients for the polynomial in the numerator for the\
  % the rational function for the wage curve.
  f = polydet( AS, BA);

  % Go through commodities.
  % Set the sign of the product of a0(1) and the first determinant to be
  % calculated in a given column.
  plusOrMinusOne = 1;
  for idx = 1:1:numberCommodities
    % I want to consider the column with index idx in the inverse to B - r*A.
    mySign = plusOrMinusOne;
    for idx2 = 1:1:numberCommodities
      % I want to find the element with indices (idx2, idx) in the inverse to B - r*A.
      %
      % I want a square matrix with row idx and column idx2 missing.
      myA = zeros( numberCommodities - 1, numberCommodities - 1 );
      myB = zeros( numberCommodities - 1, numberCommodities - 1 );

      % This can probably be done more shortly and elegantly with vector operators.
      rowIndex = 1;
      for row = 1:1:numberCommodities
        if (row != idx )
           colIndex = 1;
           for col = 1:1:numberCommodities
             if ( col != idx2 )
               myA( rowIndex, colIndex ) = AS( row, col );
               myB( rowIndex, colIndex ) = BA( row, col );
               colIndex = colIndex + 1;
             endif
           endfor
           rowIndex = rowIndex + 1;
        endif
      endfor

      myPoly = polydet( myA, myB );
      numer( :, idx ) = numer( :, idx) + mySign*a0(idx2)*(myPoly');
      mySign = (-1)*mySign;
    endfor
    plusOrMinusOne = (-1)*plusOrMinusOne;
  endfor

  % Find the coefficients in the polynomial in the denominators of these rational functions.
  g = numer*d;
  g = g';

end
