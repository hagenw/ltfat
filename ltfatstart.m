function ltfatstart()
%LTFATSTART   Start the LTFAT toolbox
%   Usage:  ltfatstart;
%
%   `ltfatstart` starts the LTFAT toolbox. This command must be run
%   before using any of the functions in the toolbox.
%
%   To configure default options for functions, you can use the
%   |ltfatsetdefaults|_ function in your startup script. A typical startup
%   file could look like::
%
%     addpath('/path/to/my/work/ltfat');
%     ltfatstart;
%     ltfatsetdefaults('sgram','nocolorbar');
%
%   This will add the main LTFAT directory to you path, start the
%   toolbox, and configure |sgram|_ to not display the colorbar.
%
%   See also:  ltfatsetdefaults, ltfatmex, ltfathelp

%   AUTHOR : Peter L. Søndergaard.  
%   TESTING: NA
%   REFERENCE: NA

%% ------- Settings: ----------------------------------

% --- general settings ---
% Print the banner at startup?
printbanner=1;


% ----------------------------------------------------
% -------   do not edit below this line   ------------
%%----------------------------------------------------

% Get the basepath as the directory this function resides in.
% The 'which' solution below is more portable than 'mfilename'
% becase old versions of Matlab does not have "mfilename('fullpath')"
basepath=which('ltfatstart');
% Kill the function name from the path.
basepath=basepath(1:end-13);

% add the base path
addpath(basepath);

bp=[basepath,filesep];

% Load the version number
[FID, MSG] = fopen ([bp,'ltfat_version'],'r');
if FID == -1
    error(MSG);
else
    ltfat_version = fgetl (FID);
    fclose(FID);
end


%% -----------  install the modules -----------------

modules={};
nplug=0;

% List all files in base directory
d=dir(basepath);

for ii=1:length(d)
  
  % We only look for directories
  if ~d(ii).isdir
    continue;
  end;
  
  % Skip the default directories . and ..
  if (d(ii).name(1)=='.')
    continue;
  end;
  
  % Skip directories without an init file
  name=d(ii).name;
  % CThe file is a directory and it does not start with '.' This could
  % be a module
  if ~exist([bp,name,filesep,name,'init.m'],'file')
    continue
  end;
    
  % Now we know that we have found a module
  
  % Set 'status' to zero if the module forgets to define it.
  status=0;
  
  module_version=ltfat_version;
     
  % Add the module dir to the path
  addpath([bp,name])  
  
  % Execute the init file to see if the status is set.
  eval([name,'init']);
  if status>0
    if status==1
      nplug=nplug+1;
      modules{nplug}.name=name;
      modules{nplug}.version=module_version;
    end;
  else
    % Something failed, restore the path
    rmpath([bp,name]);
  end;
end;


% Check if Octave was called using 'silent'
%if isoctave
%  args=argv;
%  for ii=1:numel(args)
%    s=lower(args{ii});
%    if strcmp(s,'--silent') || strcmp(s,'-q')
%      printbanner=0;
%    end;
%  end;
%end;

if printbanner
  s=which('comp_pgauss');
  if isempty(s)
    error('comp_pgauss not found, something is wrong.')
  end;
  
  if strcmp(s(end-1:end),'.m')
    backend = 'LTFAT is using the script language backend.';
  else
    if isoctave
      backend = 'LTFAT is using the C++ Octave backend.';
    else
      backend = 'LTFAT is using the MEX backend.';
    end;
  end;
  
  banner = sprintf(['LTFAT version %s. Copyright 2005-2013 Peter L. Søndergaard. ' ...
                    'For help, please type "ltfathelp". %s'], ...
                   ltfat_version,backend);
  
  disp(banner);
  
  if exist('ltfat_binary_notes.m','file')
    ltfat_binary_notes;    
  end;

end;

%% ---------- load information into ltfathelp ------------

% As comp is now in the path, we can call ltfatarghelper
ltfatsetdefaults('ltfathelp','versiondata',ltfat_version,...
                 'modulesdata',modules);

%% ---------- other initializations ---------------------

% Force the loading of FFTW, necessary for Matlab 64 bit on Linux. Thanks
% to NFFT for this trick.
fft([1,2,3,4]);
