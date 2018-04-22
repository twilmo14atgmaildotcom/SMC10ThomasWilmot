function [yn,en] = RLS_spike(ref,sig,lamda)

if nargin < 4
    lamda = 1; % default
end

M = size(ref,1);
n = length(sig);              %Signal Length
w = zeros(M,1);               %Weights
P = eye(length(w))*0.01;      %Inverse input autocorrelation
invlamda = 1/lamda;
yn = zeros(1,n);              %Output
en = zeros(1,n);              %error sig

% Adaptive Loop
 for i = 1 : n
    %u = [ref(i); u(1:end-1)]; %[u(n)...,u(n-M+1)]
    u = ref(:,i);
    yn(i) = w'*u;             %Output of Adaptive Filter
    en(i) = sig(i) - yn(i);   %Error Sig
    
    r = invlamda*P*u;         % Inverse Correlation Matrix
    g = r/(1+u'*r);           % Update Gradient
    w = w + g.*en(i);         % Update Weights
    
    P = invlamda*(P-g*u'*P);  % Inverse Corr matrix
    
 end










end