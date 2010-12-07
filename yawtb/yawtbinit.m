y=[bp,filesep,'yawtb',filesep];

addpath([y,'continuous',filesep,'1d']);
addpath([y,'continuous',filesep,'1d',filesep,'wave_defs']);
addpath([y,'continuous',filesep,'1d',filesep,'win_defs']);
addpath([y,'continuous',filesep,'2d']);
addpath([y,'continuous',filesep,'2d',filesep,'wave_defs']);
addpath([y,'continuous',filesep,'1dt']);
addpath([y,'continuous',filesep,'1dt',filesep,'wave_defs']);
addpath([y,'continuous',filesep,'3d']);
addpath([y,'continuous',filesep,'3d',filesep,'wave_defs']);
addpath([y,'tools',filesep,'display']);
addpath([y,'tools',filesep,'misc']);
addpath([y,'tools',filesep,'help']);
addpath([y,'tools',filesep,'cmap']);
addpath([y,'discrete_packet_2d']);
addpath([y,'discrete_packet_2d',filesep,'wpck_defs']);
addpath([y,'sample',filesep,'sphere']);
addpath([y,'sample',filesep,'2d']);
addpath([y,'sample',filesep,'1dt']);
addpath([y,'sample',filesep,'3d']);
addpath([y,'demos',filesep,'denoising',filesep,'2d']);
addpath([y,'frames',filesep,'2d']);
addpath([y,'frames',filesep,'2d',filesep,'frame_defs']);

status=1;

global YAWTB_CONF;

%% Loading the YAWtb preferences
yawtbprefs
