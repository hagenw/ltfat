function s=extracthelp(fname);


fn=which(fname);
['/home/peter/nw/ltfat/yawtb/print_header.py ',fn]
[status,s]=system(['/home/peter/nw/ltfat/yawtb/print_header.py ',fn]);
