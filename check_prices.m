% Checks prices equations at iterated rates of profits for a one-commodity model.
% f: Coefficients of the polynomial in the numerator for the rational function
%  for the wage.
% g: Coefficients of the polynomial in the denominator for the rational functions
%  for the wage and prices of produced commodities.
% numer: Each column has coefficients of a polynomial for the numerator of a rational function.
% a0: a row vector of direct labor coefficients.
% A: a square matrix of input coefficients.
% B: a square matrix of output coefficients.
% d: a column vector specifying the numeraire.
% S: a diagonal matrix.
% epsilon: An error tolerance.
% echoWarning: 1, if a warning should be echoed to standard out when the price system is not solved correctly.
% techniqueName: The name of the technique, for the error message.
% Returns 1 (true) if the price system is solved correctly; 0 (false) else.
function isok = check_prices( rInit, rMax, rDivisions, f, g, numer, a0, A, B, d, S, epsilon, echoWarning, techniqueName)

  % Initialize to true.
  isok = 1;

  printf( "Checking solution of price system for %s.\n", techniqueName );

  numberCommodities = size(numer, 2);

  if ( numberCommodities == 1 )
     isok = check_prices1( rInit, rMax, rDivisions, f, g, numer, ...
         a0, A, B, d, S, epsilon);
  elseif ( numberCommodities == 2)
     isok = check_prices2( rInit, rMax, rDivisions, f, g, numer(:,1), numer(:, 2), ...
         a0, A, B, d, S, epsilon);
  elseif ( numberCommodities == 3)
     isok = check_prices3( rInit, rMax, rDivisions, f, g, numer(:,1), numer(:, 2), numer(:,3), ...
         a0, A, B, d, S, epsilon);
   elseif ( numberCommodities == 4 )
     isok = check_prices4( rInit, rMax, rDivisions, f, g, ...
         numer(:,1), numer(:, 2), numer(:,3), numer(:, 4), ...
         a0, A, B, d, S, epsilon);
   endif

   if ( (~isok) && echoWarning )
     printf( "Error in finding rational functions for %s!\n", techniqueName);
   endif


end
