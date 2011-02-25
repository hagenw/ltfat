function y = Disfrst(f,a,p)
%
% Computes discrete fractional sine transform
% of order a of vector f
% p (optional) is order of approximation, default N/2
% S-C Pei, M-H Yeh, IEEE Tr SP 49(6)2001, pp.1198-1207
%

N = length(f);
shft = rem((0:N-1) + fix(N/2), N) + 1;
f = f(:);
if (nargin == 2), p = N/2; end;
p = min(max(2,p),N-1);
E = dFRST(N,p);
y = E*(exp(-j*pi*a*([0:N-1])).'.*(E'*f));

function E = dFRST(N,p)
%
% function E = dFRST(N,p) returns the NxN eigenvectors of the 
% Fourier Sine transform matrix
%

global ES_saved pS_saved

if (length(ES_saved) ~= N | pS_saved ~= p),
    E = make_ES(N,p);
    ES_saved = E; pS_saved = p;
else
    E = ES_saved; 
end;

function E = make_ES(N,p)
%
% Returns sorted eigenvectors and eigenvalues of corresponding vectors
% Construct matrix H, use approx order p
%

N1 = 2*N + 2;
d2 = [1 -2 1]; d_p = 1; s = 0; st = zeros(1,N1);

for k = 1:p/2,
    d_p = conv(d2,d_p);
    st([N1-k+1:N1, 1:k+1]) = d_p; st(1) = 0;
    temp = [1:k; 1:k]; temp = temp(:)'./[1:2*k];
    s = s + (-1)^(k-1)*prod(temp)*2*st;
end;

H = toeplitz(s(:),s)+diag(real(fft(s)));

% Construct transformation matrix V

r = N;
V = [zeros(N,1),flipud(eye(N)),zeros(N,1),-eye(N)]/sqrt(2);

% Compute eigenvectors

Od = V*H*V';
[vo,eo] = eig(Od);

%
% malab eig returns sorted eigenvalues
% if different routine gives unsorted eigvals, then sort first
% [d,inde] = sort(diag(eo));
% vo = vo(:,inde');
%

E = flipud(fliplr(vo));
