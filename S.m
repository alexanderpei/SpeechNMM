function out = S(v, P)

out = 2*P.e0 ./ (1 + exp(-P.r*v)) - P.e0;