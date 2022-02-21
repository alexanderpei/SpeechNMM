%% Merge audio files together

pathData = 'C:\Users\Alex\Documents\MATLAB\cmu\SpeechNMM_v2\timit\TRAIN\DR2\FDXW0';

dirWav = dir(fullfile(pathData, '*.WAV'));
dirWrd = dir(fullfile(pathData, '*.WRD'));
dirPhn = dir(fullfile(pathData, '*.PHN'));

% Merge together
dur = 0;
allAud = [];
allWrd = [];
allPhn = [];
sent = cell(length(dirWav), 3);

for iFile = 1:2

    [aud, fs] = audioread(fullfile(pathData, dirWav(iFile).name));
    wrd       = readcell(fullfile(pathData, dirWrd(iFile).name), 'FileType', 'text');
    phn       = readcell(fullfile(pathData, dirPhn(iFile).name), 'FileType', 'text');

    % Add running total to the onset of each word and phoneme
    for iWord = 1:size(wrd, 1)
        wrd{iWord, 1} = wrd{iWord, 1} + dur;
        wrd{iWord, 2} = wrd{iWord, 2} + dur;
    end
    for iPhn = 1:size(phn, 1)
        phn{iPhn, 1} = phn{iPhn, 1} + dur;
        phn{iPhn, 2} = phn{iPhn, 2} + dur;
    end

    % Concat
    allAud = [allAud; aud];
    allWrd = [allWrd; wrd];
    allPhn = [allPhn; phn];

    dur = dur + length(aud);

end

save('merge', 'allAud', 'allWrd', 'allPhn')