function P = fn_get_params_PAC(nr, ns)

P.nr = nr;
P.ns = ns;
P.nts = nr*ns;

% Static input
% P.dt    = 0.001;
% P.dur   = 5;
% P.t     = 0:P.dt:P.dur-P.dt;
% P.ni    = ones([P.ns, length(P.t)]);

% Noise input
% P.dt    = 0.001;
% P.dur   = 2;
% P.t     = 0:P.dt:P.dur-P.dt;
% P.ni    = randn([P.ns, length(P.t)]);

% Spike input
% P.dt    = 0.001;
% P.dur   = 5;
% P.t     = 0:P.dt:P.dur-P.dt;
% q = 1e4;
% n = 7;
% w = 0.005;
% P.ni    = q*(P.t/w).^n.*exp(-P.t/w);
% P.ni    = P.ni./max(P.ni);
% P.ni    = repmat(P.ni, [P.ns 1]);

% Timit input 
P.dt = 1/1000;
[P.ptr, P.win] = fn_get_timit(P.dt);
P.ptr = P.ptr./max(P.ptr);
P.dur = length(P.ptr)*P.dt;
P.t = 0:P.dt:P.dur-P.dt;
P.ni    = repmat(P.ptr', [P.ns 1]);

% Add static input to layers 
P.ni(6, :) = randn([1, length(P.t)]);
P.ni(6, 1000:end) = 0;

P.d  = [1:nr]*10/1000;

% P.G = [5.17, 5.17, 4.45, 50, 5.17, 4.45, 40, 5.17, 5.17, 4.45, 40, 5.17, 4.45, 30];
P.G = [3.25, 3.25, 30, 10, 3.25, 30, 10, 3.25, 3.25, 30, 10, 3.25, 30, 10];
% P.k = [60, 70, 30, 300, 60, 30, 250, 60, 70, 30, 250, 60, 30, 250];
P.k = [60, 70, 30, 350, 60, 30, 350, 60, 70, 30, 350, 60, 30, 350];
P.p = [0, 0, 0, 0, 500, 100, 150, 0, 0, 0, 0, 0, 0, 0];
% P.p = [10, 10, 10, 10, 10, 10, 5, 10, 10, 10, 10, 10, 10, 10];
P.b = [2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2];

P.e0 = 5;
P.v0 = 6;
P.r  = 0.56;

P.g = readmatrix('G.txt'); 
P.g = P.g;