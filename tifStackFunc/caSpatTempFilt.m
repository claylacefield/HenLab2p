function [Y] = caSpatTempFilt(Y, toTrim, tau, sigma)

%% USAGE: [Y] = caSpatTempFilt(Y, toTrim, tau, sigma);


tStart = tic;

% trim the stack (may not be necessary if exported correctly from sima)
if toTrim
[Y] = trim2pStack(Y);
end


% temporal exponential filter
if tau>0
%tau = 10;
[Y] = caExpFilt(Y, tau);
else
    disp('No temporal filtering');
end

% trim extra frames from conv2 filtering
% NOTE: not necessary if using 'same' argument to conv2 in caExpFilt
%Y = Y(:,:,150:size(Y,3)-200);

if sigma>0
disp('Gaussian spatial filter, sigma=2 ...');
tic;
Y = imgaussfilt(Y,2);
toc;
else
   disp('No spatial filtering'); 
end


disp('Total elapsed time...');
toc(tStart);
