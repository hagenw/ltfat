function y=linlog(x,C,varargin)
  
if nargin<2
  error('%s: Too few input parameters.',upper(mfilename));
end;

definput.keyvals.corner=[];
definput.flags.cornertype={'soft','hard'};

[flags,kv,corner]=ltfatarghelper({'corner'},definput,varargin);

if flags.do_soft
  y = sign(x).*log(1+abs(x)*C);
end;

if flags.do_hard
  if isempty(corner)
    error('%s: You must specify a value for "corner".',upper(mfilename));
  end;
  
  mask=abs(x)>exp(corner)/C;
  % Do the linear part (just everywhere, this is easier) 
  y=C*corner/exp(corner)*x;
  
  % Do the log part by overwriting the linear part
  y(mask)=sign(x(mask)).*log(abs(x(mask)*C));
end;
