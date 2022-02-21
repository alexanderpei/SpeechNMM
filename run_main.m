%% Main script 

clear all
close all

nr  = 2;     % Number of regions (dimensions)
ns  = 9;     % State parameters per region (Olivier David 2005 Modelling..)
nts = nr*ns; % Total number of states

P = fn_get_params(nr, ns);
nCond = 2;

%% Run solver

for iCond = 1:nCond

    P.iCond = iCond;
    [A, As, Ad, P] = fn_get_A(P);

    tSpan = [0 P.dur];
    init  = zeros(1, nts);
    opts  = ddeset('MaxStep', P.dt);

    sol(iCond) = dde23(@(t,x,Z) fn_dde(t, x, Z, A, As, Ad, P), P.d, init, tSpan, opts);
    sol(iCond).y = resample(sol(iCond).y', sol(iCond).x, 1/P.dt)';
    sol(iCond).y(isnan(sol(iCond).y)) = 0;
    sol(iCond).y = sol(iCond).y(:,1:length(P.t));

end
%%

load merge

fprintf('Phn: %d Rate: %0.4f\n',size(allPhn, 1), size(allPhn, 1)./P.dur)
fprintf('Wrd: %d Rate: %0.4f\n',size(allWrd, 1), size(allWrd, 1)./P.dur)

%%

figure
hold on

for ir = 1:nr
    is = (ir-1)*ns+1;
    subplot(nr+2,1,ir+2)
    hold on
    for iCond = 1:nCond
        temp = sol(iCond).y(is+1,:) - sol(iCond).y(is+2,:);
        % temp = temp./max(temp);
        plot(P.t, temp)
    end
    ylabel(['Pop. ' num2str(ir)], 'FontWeight', 'bold')
end

subplot(nr+2,1,1)
plot(P.t, P.winWord)
ylabel('Input', 'FontWeight', 'bold')

subplot(nr+2,1,2)
plot(P.t, P.ptr)
ylabel('Input', 'FontWeight', 'bold')

%%

fStart = 2;
fEnd   = 100;

figure
hold on
for ir = 1:nr
    is = (ir-1)*ns+1;
    subplot(nr+1,1,ir+1)
    hold on

    for iCond = 1:nCond
        temp = sol(iCond).y(is+1,:) - sol(iCond).y(is+2,:);
        % temp = temp./max(temp);
        [p, f] = pspectrum(temp, 1/P.dt);
        [~,iStart] = min(abs(f-fStart));
        [~,iEnd] = min(abs(f-fEnd));
        plot(f(iStart:iEnd),p(iStart:iEnd))
    end

    ylabel(['Pop. ' num2str(ir)], 'FontWeight', 'bold')

end
subplot(nr+1,1,1)
plot(P.t, P.ptr)
ylabel('Input', 'FontWeight', 'bold')

% %% Calculate ratio of energy between layers
% 
% % Energy of each of the ei layesr
% 
% en = zeros(1, nr+1);
% figure
% for ir = 1:nr
%     is = (ir-1)*ns+1;
%     temp = sol(1).y(is+1,:) - sol(1).y(is+2,:);
%     subplot(nr+1,1,ir+1)
%     plot(S(temp, P))
%     en(ir+1) = mean(abs(S(temp, P)));
% end
% subplot(nr+1,1,1)
% plot(S(P.ptr, P))
% 
% en(1) = mean(abs(S(P.ptr, P)));
% 
% % Mean firing rate of the speech input
