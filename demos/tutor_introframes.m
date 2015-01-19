function tutor_introframes %TUTOR
%TUTOR_INTROFRAMES Introduction to frames in finite dimensions
%
%   This demonstration explains some basic concepts of the frame theory using
%   linear algebra examples in $\mathbb{R}^L$ ($L=3$, $L=2$). 
%
%   Basic frame theory
%   ------------------
%
%   A frame in a Hilbert space $\mathcal{H}$ is a collection of vectors 
%   $\varphi_n\in\mathcal{H}$ for which the following holds for all $f\in \mathcal{H}$ :
%
%   ..
%       A||f||^2 <= sum |<\varphi_n,f>|^2 <= B||f||^2
%                    n
%
%   .. math:: A||f||^2 \leq \sum_n |\langle \varphi_n,f \rangle|^2\leq
%      B||f||^2
%
%   with frame bounds $A,B$ being $0<A\leq B < \infty$. Analysis operator
%   associated with a frame is denoted $F^*:\mathcal{H}\rightarrow\mathcal{G}$,
%   and acts as $F^*f=\langle \varphi_n,f \rangle$ for all $n$
%   The synthesis operator is denoted as $F:\mathcal{G}\rightarrow\mathcal{H}$ 
%   and acts as $Fc=\sum_n\varphi_n c_n$. Operators are adjoint to each
%   other.
%   A frame operator $S:\mathcal{H}\rightarrow\mathcal{H}$ is
%   invertible on $\mathcal{H}$ and it is formed as $S=FF^*$. The Grammian
%   $G:\mathcal{G}\rightarrow\mathcal{G}$ is given as $G=F^*F$.
%
%   A general bounded operator is a a 
%
%   In case $\mathcal{H}=\mathbb{C}^L$, frame vectors can be organized as
%   columns of a matrix which then forms the frame synthesis operator 
%   $F$ and the analysis operator is its adjoint $F^*$. 
%
%   References: ch08 koche08 caku13
%


%% 
%   Example 1
%   ---------
%   In the following code, we create a test signal
%   MAT2DOC: AUDIO 'Play gspi.wav' gspi 44100 
f = [0.1,0.2,0.3]';

%%
%   Orthonormal basis is $\mathbb{R}^3$

F1 = eye(3) %F1(end) = 0.98;

A = min(svd(F1))^2;
B = max(svd(F1))^2; 
fprintf('A=%d, B=%d\n',A,B)


%%
%   Something
%   MAT2DOC: AUDIO 'This is gspi' gspi 44100

% Analysis operator F1'
c1 = F1'*f;

% Condition number is a
cond_num = norm(B/A) 

% Norm of a matrix
matrix_norm = sqrt(B) 

% Redundancy of a frame
[M,N] = size(F1);


% Is it tight?
is_tight = A == B

% Is it Parseval tight
is_parsevaltight = (A == 1 && B == 1)

% Is it equal norm?
is_equalnorm = all(sum(F1.^2).^(1/2) == norm(F1(:,1)))

% Is it equiangular?
% (All off-diagonal entries in the Gram matrix should be equal)
G = F1'*F1;
is_equiangular = all( G(~eye(size(G))) == G(1,2) )

plotCurrent(F1,f,f)

  



% [U,s,V]=svd([1,0;0,1;1,1]);

% Project orthonormal basis in 3D to a 2D plane and check properties 
% of the resulting frame (Naimark theorem) 

%%
%   Another orthonormal basis in R^3
%   This is unitary isomorphic to F1 as it is obtained
%   as F2=R*F1, where R is unitary rotation matrix.
%   Gram matrices of frames F1 and F2 are equal
%   (rotated by 20 degrees)
F2 = rot(F1,20);
plotfinframe(F2);
plotCurrent(F2,f,f)


%%
%   Tight frames
%   ------------
%
%   Frame is tight if $A=B$.




function plotfinframe(A,B)
% Funkce vykresli v R^3 system generatoru obsazeny ve sloupcich A,
% pokud je zadano, tak i B, pak jinou barvou vykresli i druhy system
% generatoru.
% h....handle na osy, v nichz probehlo vykresleni

%% Kresleni
[~,n] = size(A);
% puvodni frejm
zer = zeros(n,1);
quiver3(zer,zer,zer,A(1,:)',A(2,:)',A(3,:)','b');
hold on;
for cnt = 1:n
    text(A(1,cnt), A(2,cnt), A(3,cnt),['e_' num2str(cnt)]);
end

xlabel('x');
ylabel('y');
zlabel('z');
axis equal;

% druhy frejm
if nargin>1
    quiver3(zer,zer,zer,B(1,:)',B(2,:)',B(3,:)','r');
    for cnt = 1:n
        text(B(1,cnt), B(2,cnt), B(3,cnt),['f_' num2str(cnt)]);
    end
end
axis equal;
hold off;


function plotCurrent(A,x,xhat)
%% Vykresleni v grafu
[m,n] = size(A);
if m ~= 3
    disp('POZOR: Graf je pro R^3, vstupni matice nevyhovuje, graf nebude vykreslen')
    return
end


clf;
% dva frejmy
plotfinframe(A);
hold on;
zer = zeros(3,1);

% vykresleni puvodniho a rekonstruovaneho vektoru
bJsouTotozne = norm(x-xhat) < 1e-3;


h = plot3(x(1),x(2),x(3),'Xk'); % vykreslení pùvodního vektoru
set(h,'LineWidth',2);
set(h,'MarkerSize',12);
if bJsouTotozne
    text(x(1)+0.05,x(2),x(3),['x=xhat']) %jsou
else
    text(x(1)+0.05,x(2),x(3),['x']) %nejsou
end

% pokud se x a xhat lisi, pak se vykresli jeste to xhat
if ~bJsouTotozne
    h = plot3(xhat(1),xhat(2),xhat(3),'Xg'); % vykreslení rekonstruovaného vektoru
    text(xhat(1)+0.05,xhat(2),xhat(3),['xhat'])
    set(h,'LineWidth',2);
    set(h,'MarkerSize',12);
end
axis auto
axis equal
hold off;

function [xhat,dualsystem,coefs] = demo_frejmy(A,f)

% Demo funkce, která ukazuje báze a frejmy jednak výpoètem, jednak v grafu
% (pøed prvním sputìním je tøeba naèíst data: load('frejmy-data.mat') )

%% Vypocty
% výpoèet souradnic v primarnim systému generátorù pomoci skalarnich
% soucinu s duálním systemem
[coefs,B] = dualcoefs(A,f);
dualsystem = B;

% rekonstruovany vektor
xhat = A*coefs;


%% Vykresleni v grafu
[m,n] = size(A);
if m ~= 3
    disp('POZOR: Graf je pro R^3, vstupni matice nevyhovuje, graf nebude vykreslen')
    return
end

figure
% dva frejmy
h = plotfinframe(A,B);

% vykresleni puvodniho a rekonstruovaneho vektoru
bJsouTotozne = norm(f-xhat) < 10e-3;

axes(h)
h = plot3(f(1),f(2),f(3),'Xk'); % vykreslení pùvodního vektoru
set(h,'LineWidth',2);
set(h,'MarkerSize',12);
if bJsouTotozne
    text(f(1)+0.05,f(2),f(3),['x=xhat']) %jsou
else
    text(f(1)+0.05,f(2),f(3),['x']) %nejsou
end

% pokud se x a xhat lisi, pak se vykresli jeste to xhat
if ~bJsouTotozne
    h = plot3(xhat(1),xhat(2),xhat(3),'Xg'); % vykreslení rekonstruovaného vektoru
    text(xhat(1)+0.05,xhat(2),xhat(3),['xhat'])
    set(h,'LineWidth',2);
    set(h,'MarkerSize',12);
end
axis auto
axis equal

function F = rot(F,angle,rotaxis)
%   ROT Rotate vectors

if nargin<3
    rotaxis = [1,1,1]';
end

t = pi*angle/180;
rotaxis = rotaxis/norm(rotaxis);
u = rotaxis(1); v = rotaxis(2); w = rotaxis(3);
R = [u^2+(1-u^2)*cos(t), u*v*(1-cos(t))-w*sin(t), u*w*(1-cos(t))+v*sin(t);...
     u*v*(1-cos(t))+w*sin(t), v^2+(1-v^2)*cos(t), v*w*(1-cos(t))-u*sin(t);...
     u*w*(1-cos(t))-w*sin(t), v*w*(1-cos(t))+u*sin(t), w^2+(1-w^2)*cos(t) ];
 
F = R*F;

% Null space of F*: Fc=0
% 
% For full-space frames  
% null(F*) = {0}

% Invertible == bijective == injective kerT={0} (null) and surjective ranT = R^N
% ker T = orth. complement of (ran T*)

% Projection P is orthogonal if it is self adjoint.

% Frames for subspaces of R^2

% Tightness

% Equal norm

% Maximally robust (every n x n submatrix of F* is invertible)
% (Full spark)

% Equiangularity

% Equivalence of frames (isomorphism of frames): Frames F,G are equivalent 
% (or uniratily isomorphic) if UF=G, where U is arbitrary square matrix. 
% Parseval tight frame obtained as G = S^(-1/2)F is equivalent with F as
% well as the canonical dual frame is isomorphic (the only one among all 
% dual frames). Kernels and ranges are equal.
% Unitary isomorphic frames: The same but U is unitary. 
% ||Fc|| == ||Gc||
% F*F==G*G


% Symmetry https://www.math.auckland.ac.nz/~waldron/Preprints/Frame-symmetries/CA-02-060-RD.pdf

% Naimark theorem Parseval tight frame is a projection of a ONB from a
% higher dimension, general frame is a projection of a Riez basis from a higher dimension

% If F is a frame then_
% (1) VFU is a frame for any invertible matrices U, V .
% (2) If F is tight frame/unit-norm tight frame, then aVFU is tight
% frame/unit-norm tight frame for any unitary matrices U, V and a ~= 0.
%(3) If F is equal-norm, then aDFU is equal-norm for any
%diagonal unitary matrix D, unitary matrix U , and a = 0.
%(4) If F is maximally robust, then DFU is maximally robust
%for any invertible diagonal matrix D and any invertible
%matrix U .
%(5) If F is unit-norm tight frame and maximally robust, then
%DFU is unit-norm tight frame and maximally robust for any
%unitary diagonal matrix D and any unitary matrix U .

