function y = Disfrct(f,a,p)
%
% Computes discrete fractional cosine transform
% of order a of vector f
% p (optional) is order of approximation, default N/2
% S-C Pei, M-H Yeh, IEEE Tr SP 49(6)2001, pp.1198-1207
%

N = length(f);
shft = rem((0:N-1) + fix(N/2), N) + 1;
f = f(:);
if (nargin == 2), p = N/2; end;
p = min(max(2,p),N-1);
E = dFRCT(N,p);
y = E*(exp(-j*pi*a*([0:N-1])).'.*(E'*f));

function E = dFRCT(N,p)
%
% function E = dFRCT(N,p) returns the NxN eigenvectors of the 
% Fourier Cosine transform matrix
%

global EC_saved pC_saved

if (length(EC_saved) ~= N | pC_saved ~= p),
    E = make_EC(N,p);
    EC_saved = E; pC_saved = p;
else
    E = EC_saved; 
end;

function E = make_EC(N,p)
%
% Returns sorted eigenvectors and eigenvalues of corresponding vectors
% Construct matrix H, use approx order p
%

N1 = 2*N-2;
d2 = [1 -2 1]; d_p = 1; s = 0; st = zeros(1,N1);
for k = 1:p/2,
    d_p = conv(d2,d_p);
    st([N1-k+1:N1,1:k+1]) = d_p; st(1) = 0;
    temp = [1:k;1:k]; temp = temp(:)'./[1:2*k];
    s = s + (-1)^(k-1)*prod(temp)*2*st;
end;
H = toeplitz(s(:),s) + diag(real(fft(s)));

% Construct transformation matrix V

V = [zeros(N-2,1), eye(N-2), zeros(N-2,1), flipud(eye(N-2))] / sqrt(2);
V = [1,zeros(1,N1-1); V; zeros(1,N-1),1,zeros(1,N-2)];

% Compute eigenvectors

Ev = V*H*V';
[ve,ee] = eig(Ev);

%
% malab eig returns sorted eigenvalues
% if different routine gives unsorted eigvals, then sort first
% [d,inde] = sort(diag(ee));
% ve = ve(:,inde');
%

E = fliplr(ve);
E(end,:) = E(end,:) / sqrt(2);
