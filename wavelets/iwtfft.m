function f = iwtfft(c,G,a,varargin)



    if nargin<2
      error('%s: Too few input parameters.',upper(mfilename));
    end;


%% PARSE INPUT
definput.keyvals.L=[];    
definput.import = {'wtfft'};

[flags,kv,L]=ltfatarghelper({'L'},definput,varargin);

[Gr,Gc] = size(G);

if(isempty(a))
    a = ones(Gc,1);
end

[sigHalfLen,W] = size(c{end});
f = zeros(L,W);


N = zeros(Gc,1);
for gg=1:Gc
    N(gg)=size(c{gg},1);
end


for w=1:W
   for gg=1:Gc
      f(:,w)=f(:,w)+ifft(repmat(fft(c{gg}(:,w)),a(gg),1).*G(:,gg));
   end
end



