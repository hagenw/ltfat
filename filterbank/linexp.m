function y=linexp(x,C,varargin)
  
if nargin<2
  error('%s: Too few input parameters.',upper(mfilename));
end;

definput.keyvals.corner=[];
definput.flags.cornertype={'soft','hard'};

[flags,kv,corner]=ltfatarghelper({'corner'},definput,varargin);


if flags.do_soft
  y = sign(x).*(exp(abs(x))-1)/C;
end;

if flags.do_hard
  if isempty(corner)
    error('%s: You must specify a value for "corner".',upper(mfilename));
  end;
    
  mask=abs(x)>corner;
  y=exp(corner)/(C*corner)*x;
  y(mask)=sign(x(mask)).*exp(abs(x(mask)))/C;
end;