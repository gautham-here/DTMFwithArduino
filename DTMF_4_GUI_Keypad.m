f = figure('Name', 'DTMF Keypad', 'NumberTitle', 'off');
keys = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', '#'};
for i = 1:length(keys)
    uicontrol('Style', 'pushbutton', 'String', keys{i}, ...
              'Position', [50 + (mod(i-1, 3) * 50), 200 - (floor((i-1) / 3) * 50), 40, 40], ...
              'Callback', @(src, event) generateDTMF(keys{i}, fs, t));
end
function generateDTMF(key, fs, t)
    key_freqs = {
        '1', 697, 1209;
        '2', 697, 1336;
        '3', 697, 1477;
        '4', 770, 1209;
        '5', 770, 1336;
        '6', 770, 1477;
        '7', 852, 1209;
        '8', 852, 1336;
        '9', 852, 1477;
        '0', 941, 1336;
        '*', 941, 1209;
        '#', 941, 1477;
    };
    freq_pair = key_freqs(strcmp(key_freqs(:, 1), key), 2:3);
    f_low = freq_pair{1};
    f_high = freq_pair{2};
    dtmf_signal = sin(2*pi*f_low*t) + sin(2*pi*f_high*t);
    sound(dtmf_signal, fs);
    disp(['Key Pressed: ' key]);
end
