% For finding the maximum rate of profits in a model of joint production.

% f: The coefficients in the numerator for the rational function for the wage.

function rMax = get_r_max2( f )
  % Initialize.
  rMax = 0;

  % Do I need this?
  nCommodities = size( f, 2 ) - 1;

  % I want a copy of f with no leading or trailing zeros.

  % Sometimes, because of round-off error, the rate I want has an imaginary component.
  if ( nCommodities > 0 )
    ratesOfProfits1 = roots( f );
    % Need the following because f might have leading zeros.
    numberRates = size( ratesOfProfits1, 1);
    ratesOfProfits = [];
    % Find the one smallest in magnitued.
    for ( idx = 1:1:numberRates )
    % for ( idx = 1:1:nCommodities )
      % ratesOfProfits(idx) = abs( ratesOfProfits( idx ));
      if ( real( ratesOfProfits1( idx ) ) > 0 )
         ratesOfProfits = [ ratesOfProfits, abs( ratesOfProfits1( idx )) ];
      endif
    endfor
    ratesOfProfits = sort( ratesOfProfits );
    % Had a perturbation of D'Agata's example of intensive rent where coefficients of f
    % mostly cancelled out.
    if ( size( ratesOfProfits, 1 ) > 0 )
       rMax = ratesOfProfits( 1 );
    else

    endif;
  endif
end
