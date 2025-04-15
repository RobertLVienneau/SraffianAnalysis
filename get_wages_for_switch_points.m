% Gets the wagesfor switch points.
% switchPoints: The rates of profits for switch point.
% f: Coefficients of polynomial in numerator for rational function for the wage.
% g: Coefficients of polynomial in denominator for rational function for the wage.
% echoOut: True, if something should be echoed.
% label: for example, "Alpha vs. Beta"
%
% The corresponding wages.

function wages = get_wages_for_switch_points(switchPoints, f, g, rMax, echoOut, label)

    numberPoints = size( switchPoints, 2 );
    wages = zeros(1, numberPoints );
    if ( numberPoints == 0)
       if ( echoOut)
         printf( "No Switch Points Exist for %s\n", label );
       endif
     else
       if ( echoOut)
         printf( "Switch Points for %s:\n", label );
       endif
     for idx = 1:1:numberPoints
         wages( idx ) = get_wage_rational( ...
             switchPoints( idx ), f, g, rMax );

         if ( echoOut)
           printf( "  Rate of profits: %f,  Wage: %f\n", ...
                switchPoints(idx), wages(idx) );
         endif
      endfor
    endif

end
