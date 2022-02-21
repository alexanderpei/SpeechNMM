function P = fn_get_params(nr, ns)

P.nr = nr;
P.ns = ns;
P.nts = nr*ns;

% Spike input
% P.dt    = 0.001;
% P.dur   = 5;
% q = 1e4;
% n = 7;
% w = 0.005;
% t = 0:P.dt:1-P.dt;
% 
% ptr = q*(t/w).^n.*exp(-t/w);
% P.ptr = repmat(ptr, [1 5])./max(ptr)*0;
% 
% P.t     = 0:P.dt:P.dur-P.dt;

% Noise input
% P.sig = 0.05;
% P.ni  = P.sig*randn([1, length(t)]);
% P.ni(1:500) = 0;
% P.ni  = repmat(P.ni, [1 P.dur]);

% Timit input 
P.dt = 1/1000;
[P.ptr, P.win] = fn_get_timit(P.dt);
P.dur = length(P.ptr)*P.dt;
P.t = 0:P.dt:P.dur-P.dt;

P.d  = [1:nr]*10/1000;

P.A  = 3.25;
P.B  = 29.3;
P.C  = 10000;

P.e0 = 2.5;
P.v0 = 0;
P.r  = 0.56;

P.a = 1/3*1000;
P.b = 1/20*1000;

P.g1 = 50;
P.g2 = 40;
P.g3 = 12;
P.g4 = 12;


% P.ptnj  = P.sig*randn([nr, length(P.t)]);
% 
% q = 1e4;
% n = 7;
% w = 0.005;
% 
% P.ptr = [zeros(1, length(0:P.dt:P.onset)) q*(P.t/w).^n.*exp(-P.t/w)];
% P.ptr = P.ptr(1:length(P.t))./max(P.ptr)*P.C;
