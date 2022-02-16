function dx = fn_dde(t, x, Z, A, As, Ad, P)

r  = interp1(P.t, P.ptr, t, 'linear');
% ni = interp1(P.t, P.ni', t, 'nearest'); 

[~, ic] = min(abs(P.t-t));

% A_  = squeeze(interp1(P.t, A, t, 'nearest'));
% As_ = squeeze(interp1(P.t, As, t, 'nearest'));
% Ad_ = squeeze(interp1(P.t, Ad, t, 'nearest'));

A_ = squeeze(A(ic, :, :));
As_ = squeeze(As(ic, :, :));
Ad_ = squeeze(Ad(ic, :, :, :, :));

fprintf('%0.6f\n', t)

% Calculate pc depolarization
for ir = 1:P.nr
    is = (ir-1)*P.ns + 1;
    x(is+8) = x(is+1) - x(is+2);
    Z(is+8, :) = Z(is+1, :) - Z(is+2, :);
end

% Calculate input 
K = zeros(size(x));
K(4) = K(4) + P.C*r; 
K = K*P.A*P.a;

% Sigmoid transform
xs = S(x, P);
Zs = S(Z, P);

% Calculate new delay matrix
dx = zeros(size(x));
id = toeplitz(1:P.nr);
for ir = 1:P.nr
    for jr = 1:P.nr
        dx = dx + squeeze(Ad_(ir, jr, :, :))*Zs(:, id(ir, jr));
    end
end

% Calculate dx
dx = dx + A_*x + As_*xs + K;

if find(isnan(dx))
% keyboard
end