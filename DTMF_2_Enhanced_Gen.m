fs = 8000; 
t = 0:1/fs:0.5; 

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

dtmf_frequencies_row = [697, 770, 852, 941];
dtmf_frequencies_col = [1209, 1336, 1477];
dtmf_keypad = [
    '1', '2', '3';
    '4', '5', '6';
    '7', '8', '9';
    '*', '0', '#'
];

figure;
for i = 1:size(key_freqs, 1)
       key = key_freqs{i, 1};
    f_low = key_freqs{i, 2};
    f_high = key_freqs{i, 3};
    
  dtmf_signal = sin(2*pi*f_low*t) + sin(2*pi*f_high*t);
    
    N = 2^nextpow2(length(dtmf_signal)); 
    windowed_signal = dtmf_signal .* hamming(length(dtmf_signal))'; 
    Y = fft(windowed_signal, N);
    f = (0:N-1)*(fs/N);
    magnitude = abs(Y);
    
    subplot(3, 4, i); 
    plot(f, magnitude);
    title(['Key ' key]);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    xlim([600 1600]); 
    
    xline(f_low, '--r', 'Low Freq');
    xline(f_high, '--g', 'High Freq');
    
    
    threshold = 5; 
    detected_indices = find(magnitude > threshold);
    detected_freqs = f(detected_indices);
    
    fprintf('Key %s: Detected Frequencies: ', key);
    disp(detected_freqs);
    
    
    tolerance = 10; 
    row_freq = detected_freqs(arrayfun(@(x) any(abs(x - dtmf_frequencies_row) < tolerance), detected_freqs));
    col_freq = detected_freqs(arrayfun(@(x) any(abs(x - dtmf_frequencies_col) < tolerance), detected_freqs));
    
    if ~isempty(row_freq)
        [~, closest_row_idx] = min(abs(dtmf_frequencies_row - row_freq(1)));
        row_freq = dtmf_frequencies_row(closest_row_idx);
    end
    if ~isempty(col_freq)
        [~, closest_col_idx] = min(abs(dtmf_frequencies_col - col_freq(1)));
        col_freq = dtmf_frequencies_col(closest_col_idx);
    end
    
    fprintf('Key %s: Matched Row Freq: %.2f Hz\n', key, row_freq);
    fprintf('Key %s: Matched Col Freq: %.2f Hz\n', key, col_freq);
    
    
    if ~isempty(row_freq) && ~isempty(col_freq)
        row_idx = find(dtmf_frequencies_row == row_freq);
        col_idx = find(dtmf_frequencies_col == col_freq);
        detected_key = dtmf_keypad(row_idx, col_idx);
        fprintf('Detected Key for input %s: %s\n', key, detected_key);
    else
        fprintf('Failed to detect a valid key for input %s\n', key);
    end
end
