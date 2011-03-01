function [E,lambda]=hermbasis(L,p)
%HERMBASIS  Orthonormal basis of discrete Hermite functions.
%   Usage:  V=hermbasis(L,p);
%
%   HERMBASIS(L) will compute an orthonormal basis of discrete Hermite
%   functions of length L. The vectors are returned as columns in the
%   output.
%
%   All the vectors in the output are eigenvectors of the discrete Fourier
%   transform, and resemble samplings of the continuous Hermite functions
%   to some degree.
%
%   HERMBASIS(L,p) will do the same for an approximation order of p. p
%   must be between 2 and 2*L. Default value is L/2.
%
%   [V,lambda]=HERMBASIS(...) additionally returns the eigenvalues of the DFT.
%
%   The code for this file was originally published on
%   http://nalag.cs.kuleuven.be/research/software/FRFT/
%
%   See also:  dft, pherm
%
%R  bultheel2004computation

%   AUTHOR : A. Bultheel
%   TESTING: TEST_HERMBASIS
%   REFERENCE: OK

if nargin<2
  p=round(L/2);
end;

if p<2  
  error('p must be greater than 1.');
end;

if p>L
  error('p must be less than L.');
end;
  

d2 = [1 -2 1];
d_p = 1;
s = 0;
st = zeros(1,L);

for k = 1:p/2,
  d_p = conv(d2,d_p);
  st([L-k+1:L,1:k+1]) = d_p;
  st(1) = 0;
  temp = [1:k;1:k];
  temp = temp(:)'./[1:2*k];
  s = s + (-1)^(k-1)*prod(temp)*2*st;        
end;

% H = circulant + diagonal

col = (0:L-1)'; row = (L:-1:1);
idx = col(:,ones(L,1)) + row(ones(L,1),:);
st = [s(L:-1:2).';s(:)];
H = st(idx) + diag(real(fft(s)));

% Construct transformation matrix V

r = floor(L/2);
even = ~rem(L,2);
V1 = (eye(L-1) + flipud(eye(L-1))) / sqrt(2);
V1(L-r:end,L-r:end) = -V1(L-r:end,L-r:end);
if (even)
  V1(r,r) = 1;
end
V = eye(L); V(2:L,2:L) = V1;

% Compute eigenvectors

VHV = V*H*V';
E = zeros(L);
Ev = VHV(1:r+1,1:r+1);           Od = VHV(r+2:L,r+2:L);
[ve,ee] = eig(Ev);               [vo,eo] = eig(Od); 

%
% malab eig returns sorted eigenvalues
% if different routine gives unsorted eigvals, then sort first
%
% [d,inde] = sort(diag(ee));      [d,indo] = sort(diag(eo));
% ve = ve(:,inde');               vo = vo(:,indo');
%

E(1:r+1,1:r+1) = fliplr(ve);     E(r+2:L,r+2:L) = fliplr(vo);
E = V*E;

% shuffle eigenvectors

ind = [1:r+1;r+2:2*r+2]; ind = ind(:);
if (even)
  ind([L,L+2]) = [];
else
  ind(L+1) = [];
end
E = E(:,ind');

if nargout==2
  
  lambda = exp(j*pi/2*([0:L-2 L-1+even])).';

end;

if 0
  % This is the old method from %R  ozzaku01.
  % It only works for order=2, and in this case, it return exactly the
  % same eigenvector, except for +/- differences.
  
  % Create tridiagonal sparse matrix
  A=ones(L,3);
  A(:,2)=(2*cos((0:L-1)*2*pi/L)-4).';
  H=spdiags(A,-1:1,L,L);
  
  H(1,L)=1;
  H(L,1)=1;
  
  H=H*pi/(i*2*pi)^2;
  
  % This seem to be the only way to compute the eigenvalue of a tridiagonal
  % matrix in Matlab/Octave.
  [V,D]=eig(full(H));
  % FIXME: The speed could be greatly optimized by writing a C interface to
  % the DSTEV routine in LAPACK.
  
  % If L is not a factor of 4, then all the eigenvalues of the tridiagonal
  % matrix are distinct. If L IS a factor of 4, then one eigenvalue has
  % multiplicity 2, and we must split the eigenspace belonging to this
  % eigenvalue into a an even and an odd subspace.
  if mod(L,4)==0
    x=V(:,L/2);
    x_e=(x+involute(x))/2;
    x_o=(x-involute(x))/2;
    
    x_e=x_e/norm(x_e);
    x_o=x_o/norm(x_o);
    
    V(:,L/2)=x_o;
    V(:,L/2+1)=x_e;
    
  end;
end;
