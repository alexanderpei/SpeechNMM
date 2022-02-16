function [out, win] = fn_get_timit(dt)

pathData = 'C:\Users\Alex\Documents\MATLAB\cmu\SpeechNMM_v2\timit\TRAIN\DR1\FCJF0';

% [aud, fs] = audioread(fullfile(pathData, 'SA1.wav'));
% ons = readcell(fullfile(pathData, 'SA1.WRD'), 'FileType', 'text');
fs = 16000;
load merge
aud = allAud;
ons = allWrd;

nWord = size(ons, 1);

% Add in delay between words
out = [];
delay = 0;
for iWord = 1:nWord

    tempWord = aud(ons{iWord, 1}:ons{iWord, 2});
   

    % tempDelay = randi([100 300])*fs/1000;
    tempDelay = 0*fs/1000;
    tempWord = [tempWord; zeros(tempDelay, 1)];

    ons{iWord, 1} = length(out);

    out = [out; tempWord];

    ons{iWord, 2} = length(out)-tempDelay;


end

% Get the first ten words

% out = aud;
% out = abs(hilbert(out));
out = resample(out, 1/dt, fs);

win = [];
for iWord = 1:nWord
    win = [win ; [ons{iWord, 1}/fs ons{iWord, 2}/fs]];
end

