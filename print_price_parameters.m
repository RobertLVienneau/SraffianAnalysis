% For echoing coefficients of production for a system of equations for prices.
% nCommodities: Number of commodities.
% a0: a row vector of direct labor coefficients.
% A: a square matrix of input coefficients.
% B: a square matrix of output coefficients.
% d: a column vector specifying the numeraire.
% S: a diagonal matrix.

function print_price_parameters( nCommodities, a0, A, B, d, S)

  printf( "Number of commodities: %d\n", nCommodities );
  for idx=1:1:nCommodities
    printf( "Parameters for production process for commodity number %d\n", idx );
    for idx2 = 1:1:nCommodities
       printf( "  Input of commodity number %d: %f\n", idx2, A(idx2, idx) );
    endfor

    printf( "  Labor input: %f\n", a0(idx) );
    for idx2 = 1:1:nCommodities
      printf( "  Output of commodity number %d: %f\n", idx2, B(idx2, idx) );
    endfor
    printf( "  Markup: %f\n", S(idx, idx) );

  endfor

  printf( "Components of the numeraire\n" );
  for idx=1:1:nCommodities
    printf( "  Commodity number %d: %f\n", idx, d(idx) );
  endfor

end
