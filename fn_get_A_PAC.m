%%

clear all 
close all

nr  = 1;     % Number of regions (dimensions)
ns  = 14;     % State parameters per region (Olivier David 2005 Modelling..)
nts = nr*ns*2; % Total number of states

P = fn_get_params_PAC(nr, ns);
nt = length(P.t);

% State equation matrices: As = S(A), Ad = A(t-d) with nr x nr delays
A  = zeros(nt, nts, nts);
As = zeros(nt, nts, nts);
Ad = zeros(nt, nr, nr, nts, nts);

% Forward, backward, lateral connectivity matrices
Af = zeros(nt, nr, nr);
Ab = zeros(nt, nr, nr);
Al = zeros(nt, nr, nr);

% -- Fill in the state equations --
for it = 1:nt
    for ir = 1:nr

        % A matrix starting index for the ir region
        is = (ir-1)*ns+1;

        for m = 1:ns
            A(it, m, m+ns)     = 1;

            A(it, m+ns, m+ns)  = -2*P.k(m)*P.b(m);
            A(it, m+ns, m)     = -P.k(m)^2;

            As(it, m+ns, is:is+ns-1) = P.G(m)*P.k(m)*P.g(:, m);
        end

    end
end

%%

tSpan = [0 P.dur];
init  = zeros(1, nts);
opts  = ddeset('MaxStep', P.dt);

sol = dde23(@(t,x,Z) fn_dde_PAC(t, x, Z, A, As, Ad, P), P.d, init, tSpan, opts);
sol.y = resample(sol.y', sol.x, 1/P.dt)';
sol.y(isnan(sol.y)) = 0;
sol.y = sol.y(:,1:length(P.t));

%%

t = size(sol.y, 2);
iStart = 1;
iEnd   = t;

figure
for i = 1:14
    subplot(4,4,i)
    plot(sol.y(i, iStart:iEnd))
end

%%

figure
for i = 1:4
    subplot(5,1,i+1)
    switch i 
        case 1
            plot(mean(sol.y(1:4, iStart:iEnd)))
        case 2
            plot(mean(sol.y(5:7, iStart:iEnd)))
        case 3
            plot(mean(sol.y(8:11, iStart:iEnd)))
        case 4
            plot(mean(sol.y(12:14, iStart:iEnd)))
    end
end

subplot(5,1,1)
plot(P.ptr)