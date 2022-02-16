function [A, As, Ad, P] = fn_get_A(P)

nr  = P.nr;  % Number of regions (dimensions)
ns  = P.ns;  % State parameters per region (Olivier David 2005 Modelling..)
nts = nr*ns; % Total number of states

nt = length(P.t);

%%
winWord = zeros([1 length(P.t)]);

% Set word onset times
% for iWin = 1:size(P.win, 1)
%     % idx = (P.t > P.win(iWin, 1)) & (P.t < mean(P.win(iWin,:)));
%     % idx = (P.t > mean(P.win(iWin,:))) & (P.t < P.win(iWin, 2));
%     idx = (P.t > mean(P.win(iWin,1))) & (P.t < P.win(iWin, 2));
%     winWord(idx) = 1;
% end
% winWord(P.t < 4) = 0;

% Feedback exponential 
for iWin = 1:size(P.win, 1)
    idx = (P.t > mean(P.win(iWin, 1))) & (P.t < P.win(iWin, 2));    
    t = 1:1:length(find(idx));
    tempExp = exp(-t/200);
    winWord(idx) = tempExp;
end

P.winWord = winWord;

% State equation matrices: As = S(A), Ad = A(t-d) with nr x nr delays
A  = zeros(nt, nts, nts);
As = zeros(nt, nts, nts);
Ad = zeros(nt, nr, nr, nts, nts);

% Forward, backward, lateral connectivity matrices
Af = zeros(nt, nr, nr);
Af(:, 2,1) = 10;
Af(:, 3,1) = 40;
% Af(:, 4,3) = 10;
% Af(:, 5,4) = 10;

Ab = zeros(nt, nr, nr);
if P.iCond == 1
    for it = 1:nt
        Ab(it, 2,3) = winWord(it)*50;
    end
else
    for it = 1:nt
        Ab(it, 2,3) = 5;
    end
end

Al = zeros(nt, nr, nr);

% -- Fill in the state equations --
for it = 1:nt
    for ir = 1:nr

        % A matrix starting index for the ir region
        is = (ir-1)*ns+1;

        % --- x1, x2, x3, x7 ---
        A(it, is, is+3)   = 1;
        A(it, is+1, is+4) = 1;
        A(it, is+2, is+5) = 1;
        A(it, is+6, is+7) = 1;

        % --- x4, EI current ---

        % Sum F and L firing rates from other regions PY
        for jr = 1:nr
            if jr ~= ir
                js = (jr-1)*ns+1;
                Ad(it, ir, jr, is+3, js+8) = P.A*P.a*(Af(it, ir, jr) + Al(it, ir, jr));
            end
        end

        As(it, is+3, is+8) = P.A*P.a*P.g1; % Firing rate from PY within region

        % Single derivative terms
        A(it, is+3, is+3) = -2*P.a;
        A(it, is+3, is)   = -P.a^2;

        % --- x5, PY +ve current ---

        % Sum B and L firing rates from other regions PY
        for jr = 1:nr
            if jr ~= ir
                js = (jr-1)*ns+1;
                Ad(it, ir, jr, is+4, js+8) = P.A*P.a*(Ab(it, ir, jr) + Al(it, ir, jr));
                % Ad(it, ir, jr, is+4, js+8) = P.A*P.a*(Al(it, ir, jr));
            end
        end

        As(it, is+4, is) = P.A*P.a*P.g2; % Firing rate from PY within region

        % Single derivative terms
        A(it, is+4, is+4) = -2*P.a;
        A(it, is+4, is+1) = -P.a^2;


        % --- x6, PY -ve current ---

        As(it, is+5, is+6) = P.B*P.b*P.g4; % Firing rate from PY within region

        % Single derivative terms
        A(it, is+5, is+5) = -2*P.b;
        A(it, is+5, is+2) = -P.b^2;


        % --- x8, II current ---
        % Sum B and L firing rates from other regions PY
        for jr = 1:nr
            if jr ~= ir
                js = (jr-1)*ns+1;
                Ad(it, ir, jr, is+7, js+8) = P.A*P.a*(Ab(it, ir, jr) + Al(it, ir, jr));
            end
        end

        As(it, is+7, is+8) = P.A*P.a*P.g3; % Firing rate from PY within region

        % Single derivative terms
        A(it, is+7, is+7) = -2*P.a;
        A(it, is+7, is+6) = -P.a^2;

    end
end
