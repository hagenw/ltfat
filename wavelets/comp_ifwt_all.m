function f = comp_ifwt_all(c,g,J,a,Ls,type,ext)
%COMP_IFWT_ALL Compute Inverse DWT
%   Usage:  f = comp_ifwt_all(c,g,J,Ls,type,ext);
%
%   Input parameters:
%         c     : Coefficients stored in a cell-array.
%         g     : Synthesis wavelet filters.
%         Ls    : Length of the reconstructed signal.
%         type  : 'dec','undec' Type of the wavelet transform.
%         ext   : 'per','zpd','sym','symw','asym','asymw','ppd','sp0' Type of the forward transform boundary handling.
%
%   Output parameters:
%         f     : Reconstructed data.
%


if(strcmp(ext,'per'))
    doNoExt = 1;
else
    doNoExt = 0;
end

filts = numel(g);
fLen = length(g{1}.h);
len = zeros(J+1,1);
    for jj=1:J
       len(jj) = length(c{(jj-1)*(filts-1)+2});
    end
    len(jj+1) = Ls;

[cLen,chans] = size(c{end});   
f = zeros(Ls,chans);
tmpin = cell(filts,1);

tmpg = cell(length(g),1);
for ff=1:length(g)
    tmpg{ff} = g{ff}.h;
end

if(strcmp(type,'dec'))
    upFac= a(1);
    if(doNoExt)
        skip = g{1}.d -1;
    else
        skip = fLen - 2;
    end

    if all(a == a(1))
       % all subsampling factors are equal
       for ch=1:chans
          tempca = c{1}(:,ch);
          for jj=2:J+1
             tmpin{1} = tempca;
             for ff=1:filts-1
               % tmpin{1+ff}= c{jj,ff}(:,ch);
               tmpin{1+ff}= c{(jj-2)*(filts-1)+ff+1}(:,ch);
             end
             tempca = up_conv_td(tmpin, len(jj),tmpg,upFac,skip,doNoExt,0);
          end
          f(:,ch) = tempca;
       end
    else
       % not all subsampling factors are equal
        for ch=1:chans
           tempca = c{1}(:,ch);
           for jj=2:J+1
              tempca = up_conv_td({tempca}, len(jj),{tmpg{1}},a(1),skip,doNoExt,0);
              for ff=1:filts-1
                 tempca = tempca + up_conv_td({c{(jj-2)*(filts-1)+ff+1}(:,ch)}, len(jj),{tmpg{ff+1}},a(ff+1),skip,doNoExt,0);  
              end
           end
           f(:,ch) = tempca; 
        end
    end

elseif(strcmp(type,'undec'))
    upFac= 1;
    % Since no downsampling takes place, normalize impulse responses
    for ii = 1:numel(tmpg)
       tmpg{ii} = tmpg{ii}/sqrt(a(ii));
    end

    skip = zeros(J,1);
    if(doNoExt)
       for jj=1:J
           filtUps = a(1)^(J-jj); 
           skip(jj) = floor(filtUps*g{1}.d) - filtUps; 
       end
    else
       for jj=1:J
           filtUps = a(1)^(J-jj); 
           skip(jj) = filtUps*fLen - (filtUps-1) - 1; 
       end 
    end
    
       for ch=1:chans
          tempca = c{1}(:,ch);
          for jj=2:J+1
             tmpin{1} = tempca;
             for ff=1:filts-1
                 % tmpin{1+ff}= c{jj,ff}(:,ch);
                 tmpin{1+ff}=c{(jj-2)*(filts-1)+ff+1}(:,ch);
             end
             tempca = up_conv_td(tmpin,len(jj),tmpg,upFac,skip(jj-1),doNoExt,a(1)^(J+1-jj));
          end
          f(:,ch) = tempca;
       end
end
    
    