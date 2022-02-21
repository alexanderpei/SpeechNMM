function dx = fn_dde_PAC(t, x, Z, A, As, Ad, P)

r = interp1(linspace(0, P.dur, size(P.ni, 2)), P.ni',   t, 'nearest');

[~, ic] = min(abs(P.t-t));

% A_  = squeeze(interp1(P.t, A, t, 'nearest'));
% As_ = squeeze(interp1(P.t, As, t, 'nearest'));
% Ad_ = squeeze(interp1(P.t, Ad, t, 'nearest'));

A_  = squeeze(A(ic, :, :));
As_ = squeeze(As(ic, :, :));
Ad_ = squeeze(Ad(ic, :, :, :, :));

fprintf('%0.6f\n', t)

% Calculate input 
K = zeros(size(x));
K(15:28) = P.G'.*P.k'.*P.p'.*r';

% Calculate dx
xs = S_PAC(x, P);
Zs = S_PAC(Z, P);

dx = A_*x + As_*xs + K;
