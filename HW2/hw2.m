%% understand the data
figure(1)
[y, Fs] = audioread('GNR.m4a');
tr_gnr = length(y)/Fs; % record time in seconds
plot((1:length(y))/Fs,y);
xlabel('Time [sec]'); ylabel('Amplitude');
title('Sweet Child O Mine');
p8 = audioplayer(y,Fs); playblocking(p8);

%% task 1
L = tr_gnr; % time domin
n = length(y); % Fourier modes
t1 = linspace(0, L, n + 1);
t = t1(1:n);
k = (2*pi/L)*[0:n/2-1, -n/2:-1];
ks = fftshift(k);

% create Gabor filter
width = 100; % width of the filter
num_gabor = 100; % number of the time points to take
t_gabor = linspace(0, t(end), num_gabor); % discretize the time
s_gabor = zeros(length(t_gabor), n);

%%
% create the spectrogram
for i=1:length(t_gabor)
    gabor = exp(-width*(t - t_gabor(i)).^2);
    gyt = fft(gabor.*y.');
    gyts = abs(fftshift(gyt));
    [val, ind] = max(gyts(:));
    [a,b] = ind2sub(size(gyts),ind);
    s_filter = exp(-0.002 * ((ks - ks(b)).^2));
    gytf = fftshift(gyt).*s_filter;
    s_gabor(i,:) = abs(gytf);
%     s_gabor(i,:) = gyts;
end

% plot
% figure(1)
% pcolor(t_gabor, ks, log(abs(s_gabor.') + 1)), shading interp
% colormap('hot'), xlabel('Time [sec]'), ylabel('Frequency [Hz]')
% title('Log of GNR')
%%
figure(2)
% pcolor(s_gabor), shading interp
pcolor(t_gabor, ks, log(s_gabor.' + 1)), shading interp
colormap('hot'), xlabel('Time [sec]'), ylabel('Frequency [Hz]')
% axis([0, tr_gnr, -1000, 1000])
title('Log of GNR (zoom in)')

%%
figure(2)
% pcolor(s_gabor), shading interp
pcolor(t_gabor, abs(ks/(2*pi)), log(s_gabor.' + 1)), shading interp
colormap('hot'), xlabel('Time [sec]'), ylabel('Frequency [Hz]')
axis([0, tr_gnr, -5000, 5000])
title('Log of GNR (zoom in)')


