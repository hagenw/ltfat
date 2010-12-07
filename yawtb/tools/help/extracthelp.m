function s=extracthelp(fname);


fn=which(fname);

[status,s]=system(['/home/peter/nw/ltfat/print_header.py ',fn],1);
