fs = 8000; 
t = 0:1/fs:0.5; 

key = input('Enter a DTMF key (0-9, *, #): ', 's');

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
if isempty(freq_pair)
    error('Invalid key entered.');
end
f_low = freq_pair{1};
f_high = freq_pair{2};

dtmf_signal = sin(2*pi*f_low*t) + sin(2*pi*f_high*t);
sound(dtmf_signal, fs); % Play the generated DTMF tone

figure;
subplot(2, 1, 1);
plot(t, dtmf_signal);
title(['DTMF Signal for Key ' key]);
xlabel('Time (s)');
ylabel('Amplitude');

N = 2^nextpow2(length(dtmf_signal));
Y = fft(dtmf_signal .* hamming(length(dtmf_signal))', N);
f = (0:N-1)*(fs/N);
magnitude = abs(Y);
subplot(2, 1, 2);
plot(f, magnitude);
title('Frequency Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([600 1600]); 
