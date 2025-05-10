% Returns switch points.
% fAlpha: Coefficients for polynonmial in numerator for a rational function.
% gAlpha: Coefficients for polynomial in denominator for a rational function.
% fBeta: Coefficients for polynonmial in numerator for a rational function.
% gBeta: Coefficients for polynomial in denominator for a rational function.
% rLowerBound:Switch points must not have a rate of profits below this.
% rUpperBoud: Switch points must not have a rate of profits above this.
%
% How about finding when supernormal profits in a Beta process area zero at Alpha prices?

function [nPoints, switchPoints] = get_switch_points( fAlpha, gAlpha, fBeta, gBeta, ...
    rLowerBound, rUpperBound)

    % Initialize for stub
    switchPoints = zeros(1, 1);
    nPoints = 0;
    switchPoints(1) = -1;    % Dummy value.

    myPoly = conv(fAlpha, gBeta) - conv( fBeta, gAlpha);

    points = roots(myPoly);
    numberPoints = size(points, 1);

    for idx = 1:1:numberPoints
       if ( isreal( points(idx) ) )
          if ( ~( (points(idx) < rLowerBound) || (rUpperBound < points(idx)) ) )
            if ( nPoints == 0 )
              % Re-initialize the returned variables.
              switchPoints = zeros(1, 1);
              nPoints = 1;
              switchPoints(1) = points( idx );
            else
              % Concatenate points( idx ) to the returned variables
              tmpPoints = zeros( 1, nPoints );
              for idx2 = 1:1:nPoints
                tmpPoints( idx2 ) = switchPoints( idx2 );
              endfor

              switchPoints = zeros( 1, nPoints + 1 );
               for idx2 = 1:1:nPoints
                switchPoints( idx2 ) = tmpPoints( idx2 );
              endfor

              nPoints = nPoints + 1;
              switchPoints( nPoints ) = points( idx );

            endif
          endif
       endif
    endfor

    if (nPoints == 0)
       switchPoints = [];
    endif

    % Sort switchPoints in ascending order by the rate of profits.
    switchPoints = sort( switchPoints );

end
