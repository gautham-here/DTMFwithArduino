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

for i = 1:size(key_freqs, 1)
    key = key_freqs{i, 1};
    f_low = key_freqs{i, 2};
    f_high = key_freqs{i, 3};
    
    dtmf_signal = sin(2*pi*f_low*t) + sin(2*pi*f_high*t);
    
    N = length(dtmf_signal);
    Y = fft(dtmf_signal);
    f = (0:N-1)*(fs/N);
    magnitude = abs(Y);
    figure;
    plot(f, magnitude);
    title(['Frequency Spectrum of DTMF Signal for Key ' key]);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    hold 
    xline(f_low, '--r', 'Low Freq');
    xline(f_high, '--g', 'High Freq');
    hold off;
end