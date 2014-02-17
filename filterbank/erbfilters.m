function [g,a,fc,L]=erbfilters(fs,Ls,varargin)
%ERBFILTERS   ERB-spaced filters
%   Usage:  [g,a,fc]=erbfilters(fs,Ls);
%           [g,a,fc]=erbfilters(fs,Ls,...);
%
%   Input parameters:
%      fs    : Sampling rate (in Hz).
%      Ls    : Signal length.
%   Output parameters:
%      g     : Cell array of filters.
%      a     : Downsampling rate for each channel.
%      fc    : Center frequency of each channel.
%      L     : Next admissible length suitable for the generated filters.
% 
%   `[g,a,fc]=erbfilters(fs,Ls)` constructs a set of filters *g* that are
%   equidistantly spaced on the ERB-scale (see |freqtoerb|) with bandwidths
%   that are proportional to the width of the auditory filters
%   |audfiltbw|. The filters are intended to work with signals with a
%   sampling rate of *fs*. The signal length *Ls* is mandatory, since we 
%   need to avoid too narrow frequency windows.
%
%   By default, a Hann window on the frequency side is choosen, but the
%   window can be changed by passing any of the window types from
%   |firwin| as an optional parameter.
%
%   Because the downsampling rates of the channels must all divide the
%   signal length, |filterbank| will only work for multiples of the
%   least common multiple of the downsampling rates. See the help of
%   |filterbanklength|.
%
%   `[g,a,fc]=erbfilters(fs,L,'fractional')` constructs a filterbank with
%   fractional downsampling rates *a*. The rates are constructed such
%   that the filterbank can handle signal length that are multiples of
%   *L*, so the benefit of the fractional downsampling is that you get to
%   choose the value returned by |filterbanklength|.
%
%   `[g,a,fc]=erbfilters(fs,'uniform')` constructs a uniform filterbank
%   where the downsampling rate is the same for all channels.
%
%   `erbfilters` accepts the following optional parameters:
%
%     'spacing',b     Specify the spacing in ERBS between the
%                     filters. Default value is *b=1*.
%
%     'M',M           Specify the number of filters, *M*. If this
%                     parameter is specified, it overwrites the
%                     `'spacing'` parameter.
%
%     'redmul',redmul  Redundancy multiplier. Increasing the value of this
%                      will make the system more redundant by lowering the
%                      channel downsampling rates. It is only used if the
%                      filterbank is a non-uniform filterbank. Default
%                      value is *1*. If the value is less than one, the
%                      system may no longer be painless.
%
%     'symmetric'     Create filters that are symmetric around their centre
%                     frequency. This is the default.
%
%     'warped'        Create asymmetric filters that are symmetric on the
%                     Erb-scale.
%
%     'complex'       Construct a filterbank that covers the entire
%                     frequency range.
%
%     'regsampling'   Choose the downsampling rates to be products of 2
%                     and 3 (see |floor23| and |ceil23|). This is the
%                     default.
%
%     'fractional'    Use fractional downsampling. If this flag is
%                     specified, you must also specify the `'L'` parameter.
%
%     'bwmul',bwmul   Bandwidth of the filters relative to the bandwidth
%                     returned by |audfiltbw|. Default is $bwmul=1$.
%
%     'min_win',min_win     Minimum admissible window length (in samples).
%                           Default is *4*. This restrict the windows not 
%                           to become too narrow when *L* is low. 
%
%   Examples:
%   ---------
%
%   In the first example, we construct a highly redudant uniform
%   filterbank and visualize the result:::
%
%     [f,fs]=greasy;  % Get the test signal
%     [g,a,fc]=erbfilters(fs,length(f),'uniform','M',100);
%     c=filterbank(f,g,a);
%     plotfilterbank(c,a,fc,fs,90,'audtick');
%
%   In the second example, we construct a non-uniform filterbank with
%   fractional sampling that works for this particular signal length, and
%   test the reconstruction. The plot displays the response of the
%   filterbank to verify that the filters are well-behaved both on a
%   normal and an ERB-scale:::
%
%     [f,fs]=greasy;  % Get the test signal
%     L=length(f);
%     [g,a,fc]=erbfilters(fs,L,'fractional');
%     c=filterbank(f,{'realdual',g},a);
%     r=2*real(ifilterbank(c,g,a));
%     norm(f-r)
%
%     % Plot the response
%     subplot(2,1,1);     
%     R=filterbankresponse(g,a,L,fs,'real','plot');
%
%     subplot(2,1,2);
%     semiaudplot(linspace(0,fs/2,L/2+1),R(1:L/2+1));
%     ylabel('Magnitude');
%
%   See also: filterbank, ufilterbank, ifilterbank, ceil23
%
%   References: ltfatnote027

% Authors: Peter L. Søndergaard

if nargin<2
    error('%s: Not enough input argumets.',upper(mfilename))
end

complain_notposint(fs,'fs');
complain_notposint(Ls,'Ls');

definput.import = {'firwin'};
definput.keyvals.M=[];
definput.keyvals.bwmul=1;
definput.keyvals.redmul=1;
definput.keyvals.min_win = 4;
definput.keyvals.spacing=1;
definput.flags.warp     = {'symmetric','warped'};
definput.flags.real     = {'real','complex'};
definput.flags.sampling = {'regsampling','uniform','fractional',...
                           'fractionaluniform'};

[flags,kv]=ltfatarghelper({},definput,varargin);

% Get the bandwidth of the choosen window by doing a probe
winbw=norm(firwin(flags.wintype,1000)).^2/1000;

% Construct the Erb filterbank


if flags.do_real
    if isempty(kv.M)
        M2=ceil(freqtoerb(fs/2)/kv.spacing)+1;
        M=M2;
    else
        M=kv.M;
        M2=M;
    end;
else
    if isempty(kv.M)
        M2=ceil(freqtoerb(fs/2)/kv.spacing)+1;
        M=2*(M2-1);
    else
        M=kv.M;
        if rem(M,2)>0
            error(['%s: M must be even for full frequency range ' ...
                   'filterbanks.',upper(mfilename)]);
        end;
        M2=M/2+1;
    end;
    
end;

fc=erbspace(0,fs/2,M2).';

    
%% Compute the frequency support
if flags.do_symmetric
    % fsupp is measured in Hz
    fsupp=round(audfiltbw(fc)/winbw*kv.bwmul);
else
    % fsupp_erb is measured in Erbs
    % The scaling is incorrect, it does not account for the warping
    fsupp_erb=1/winbw*kv.bwmul;
    
    % Convert fsupp into the correct widths in Hz, necessary to compute
    % "a" in the next if-statement
    fsupp=erbtofreq(freqtoerb(fc)+fsupp_erb/2)-erbtofreq(freqtoerb(fc)-fsupp_erb/2);
    
end;

% Do not allow lower bandwidth than keyvals.min_win
fsuppmin = kv.min_win/Ls*fs;
for ii = 1:numel(fsupp)
    if fsupp(ii) < fsuppmin;
        fsupp(ii) = fsuppmin;
    end
end

% Find suitable channel subsampling rates
aprecise=fs./fsupp/kv.redmul; 
aprecise=aprecise(:);

%% Compute the downsampling rate
if flags.do_regsampling
    % Shrink "a" to the next composite number       
    a=floor23(aprecise); 
        
    % Determine the minimal transform length
    L=filterbanklength(Ls,a);
    
    % Heuristic trying to reduce lcm(a)
    while L>2*Ls && ~(all(a)==a(1))
        maxa = max(a);
        a(a==maxa) = 0;
        a(a==0) = max(a);
        L = filterbanklength(Ls,a);
    end
    
elseif flags.do_fractional
    L = Ls;
    N=ceil(Ls./aprecise);
    a=[repmat(Ls,M2,1),N];                
elseif flags.do_fractionaluniform
    L = Ls;
    N=ceil(Ls./min(aprecise));
    a= repmat([Ls,N],M2,1); 
elseif flags.do_uniform
    a=floor(min(aprecise));  
    L=filterbanklength(Ls,a);
    a = repmat(a,M2,1);
end;

% Get an expanded "a"
afull=comp_filterbank_a(a,M2,struct());

%% Compute the scaling of the filters
scal=sqrt(afull(:,1)./afull(:,2));

%% Construct the real or complex filterbank

if flags.do_real
    % Scale the first and last channels
    scal(1)=scal(1)/sqrt(2);
    scal(M2)=scal(M2)/sqrt(2);
else
    % Replicate the centre frequencies and sampling rates, except the first and
    % last
    if flags.do_nonuniform
        a=[a;flipud(a(2:M2-1,:))];
    end;
    scal=[scal;flipud(scal(2:M2-1))];
    fc  =[fc; -flipud(fc(2:M2-1))];
    if flags.do_symmetric
        fsupp=[fsupp;flipud(fsupp(2:M2-1))];
    end;
    
end;


%% Compute the filters
if flags.do_symmetric
    g=blfilter(flags.wintype,fsupp,fc,'fs',fs,'scal',scal,'inf','min_win',4);    
else
    g=warpedblfilter(flags.wintype,fsupp_erb,fc,fs,@freqtoerb,@erbtofreq, ...
                     'scal',scal,'inf'); 
end;

end

