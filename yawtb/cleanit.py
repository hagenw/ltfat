#!/usr/bin/python

import sys, os.path, string, re

fname = sys.argv[1]
bname = os.path.basename(fname)
fup = bname[0:-2].upper()

do_ltfat=0

print fname

patterns = [
    ('\\manchap',             fup) ,
    ('\\mansecSyntax',         'Usage:'),
    ('\\mansecDescription',    'DESCRIPTION'),
    ('\\mansubsecInputData',   'Input arguments:'),
    ('\\mansubsecOutputData',  'Output arguments'),
    ('\\mansecExample',        'Example:'),
    ('\\mansecReference',      'References:'),
    ('\\mansecSeeAlso',        'See also:'),
    ('\\mansecLicense',        'LICENSE:'),
    ('\\begin{description}',   ''),
    ('\\end{description}',     ''),
    ('\\item[',                '* ['),
    ('\\begin{itemize}',       ''),
    ('\\end{itemize}',         ''),
    ('\\item',                 '- '),
    ('\\begin{code}',          ''),
    ('\\end{code}',            ''),
    ('\\url{"',                '"'), 
    ('\\libfun{',              'XXX'),
    ('\\libvar{',              'YYY'),
    ('\\',                     ''),
    ('$',                     ''),
    ('{"',                    '"'),
    ('{',                     'ZZZ'),
    ('"}',                    '"'),
    ('}',                     'VVV')]

patternssimplified = [
    ('\\url{"',                '"'), 
    ('\\_',                    '_'), 
    ('\\YAWTB',                'YAWTB'),
    ('\\Matlab',                'Matlab'),
    ('>> ',                     '')]


C="""
% Copyright (C) 2001-2010, the YAWTB Team (see the file AUTHORS 
% distributed with this library)
"""

def findsection(sections,startstring):
    for ii in range(len(sections)):
        if sections[ii][0:len(startstring)]==startstring:
            return sections[ii]

    return None

# Common routine to do both input and output arguments, as the code is
# basically the same
def do_inputoutput(header,sections,secname,title):
    sec=findsection(sections,secname)

    if sec<>None:
        # Split into lines, strip them, kill the first one, and kill empty lines.
        buf=filter(lambda x:len(x)>0,map(lambda x:x.strip(),sec.split('\n'))[1:])

        # In this case the section is present, but empty.
        if len(buf)==0:
            return

        # assertion check: first and last line must be starting and stopping itemize.
        if buf[0].find('begin{description}')==-1:
            print 'ERRROR ITEMIZE ASSUMPTION FAILED 1'
        if buf[-1].find('end{description}')==-1:
            print 'ERRROR ITEMIZE ASSUMPTION FAILED 2'
        buf=buf[1:-1]

        descbuf=[]

        for line in buf:
            if line.find('\\item')>-1:
                # There are two standards in the code to check for
                # \item[KEY] 
                # and
                # \item key

                if '\\item[' in line:
                    line=line.replace('\\item[','')
                    seppos=line.find(']')
                else:
                    line=line.replace('\\item ','')
                    seppos=line.find(' ')

                key=line[:seppos]
                # Clear the type description from the line
                desc=line[seppos+1:]

                # Kill the type definer
                p=re.search('\[.*\]',desc)
                if p:
                    desc=desc[0:p.start(0)]+desc[p.end(0):]

                    # Kill the additional colon
                    desc=desc.lstrip()
                    if desc[0]==':':
                        desc=desc[1:].lstrip()

                descbuf.append((key,[desc]))
            else:
                descbuf[-1][1].append(line)
        
        # Determine longest key
        longestkey=reduce(max,map(lambda x:len(x[0]),descbuf),0)

        # Sometimes there is just empty initialization code, skip that!
        if longestkey>0:
            # There must be an easier way to create a whitespace string than this
            spaces=reduce(lambda x,y:x+y,map(lambda x:' ',range(longestkey)))
            
            header.append('   '+title)

            
            for line in descbuf:
                header.append('     '+line[0]+spaces[len(line[0]):]+' : '+line[1][0])
                for extraline in line[1][1:]:
                    header.append('        '+spaces+extraline)
        

        #for line in buf:
        #    header.append('       '+line)
        header.append('')



f=file(fname,'r')
buf=f.readlines()
f.close()

# Split into first line, header and code
ii=0
lineone=[]
header=[]
code=[]
while buf[ii][0]!='%':
    lineone.append(buf[ii])
    ii=ii+1

while buf[ii][0]=='%':
    header.append(buf[ii][1:]),
    ii=ii+1

for ij in range(ii,len(buf)):
    code.append(buf[ij])

# regexp the header
hh=''.join(header)

for (key,match) in patternssimplified:
    hh=hh.replace(key,match)

# uppercase libfun
while 1:
    p=re.search('\\\\libfun{.*?}',hh)
    if not p:
        break
    if do_ltfat:
        hh=hh[0:p.start(0)]+hh[p.start(0)+8:p.end(0)-1].upper()+hh[p.end(0):]
    else:
        hh=hh[0:p.start(0)]+'|'+hh[p.start(0)+8:p.end(0)-1]+'|_'+hh[p.end(0):]

# don't upcase libvar
while 1:
    p=re.search('\\\\libvar{.*?}',hh)
    if not p:
        break
    if do_ltfat:
        hh=hh[0:p.start(0)]+hh[p.start(0)+8:p.end(0)-1]+hh[p.end(0):]
    else:       
        hh=hh[0:p.start(0)]+'*'+hh[p.start(0)+8:p.end(0)-1]+'*'+hh[p.end(0):]



sections=hh.split('\\man')

header=[];

# ------------ Do the descriptive line -------------
sec=findsection(sections,'chap')

# Split into lines, strip them, kill the first one, and kill empty lines.
buf=filter(lambda x:len(x)>0,map(lambda x:x.strip(),sec.split('\n'))[1:])
if len(buf)==0:
    header.append(fup+'  XXX Description is missing')
else:    
    header.append(fup+'  '+buf[0])

# ------------ Do the Usage: section ----------------
sec=findsection(sections,'secSyntax')

# Split into lines, strip them, kill the first one, and kill empty lines.
buf=filter(lambda x:len(x)>0,map(lambda x:x.strip(),sec.split('\n'))[1:])
header.append('   Usage: '+buf[0])
for line in buf[1:]:
    header.append('       '+line)
header.append('')

# ------------ Do the Input and output argument ----------------
do_inputoutput(header,sections,'subsecInputData','Input parameters:')
do_inputoutput(header,sections,'subsecOutputData','Output parameters:')

# ------------ Do the description ---------------------------------
sec=findsection(sections,'secDescription')

if sec<>None:
    # Split into lines, strip them, kill the first one
    buf=map(lambda x:x.strip(),sec.split('\n'))[1:]
    # Kill empty lines at the beginning and the end

    while len(buf[0])==0:
        if len(buf)==1:
            buf=['XXX Description is missing.']
        else:
            buf=buf[1:]
    while len(buf[-1])==0:
        buf=buf[:-1]

    for line in buf:
        header.append('   '+line)
    header.append('')

# ------------ Do example ---------------------------------
sec=findsection(sections,'secExample')

if sec<>None:
    # Split into lines, strip them, kill the first one
    buf=map(lambda x:x.strip(),sec.split('\n'))[1:]
    # Kill empty lines at the beginning and the end

    while (len(buf))>0 and len(buf[0])==0:
        buf.pop(0)
    while (len(buf))>0 and len(buf[-1])==0:
        buf.pop()

    if len(buf)>0:
        header.append('   Example:')
        header.append('   --------')
        header.append('')
    for line in buf:
        header.append('   '+line)
    header.append('')


# ------------- Do the see also:

sec=findsection(sections,'secSeeAlso')

if sec<>None:
    # Split into lines, strip them, kill the first one, and kill empty lines.
    sec=sec.replace('/','')
    sec=sec.replace('$','')
    buf=filter(lambda x:len(x)>0,map(lambda x:x.strip(),sec.split('\n'))[1:])
 
    if len(buf)>0:   
        # Put in commas
        refs = buf[0].strip()
        refs=refs.replace(' ',', ')

        # Clean up after too many commas
        refs=refs.replace(',,',',')

        header.append('   See also: '+refs)
        header.append('')

# ------------- Search for code ------------- 

out=[]
code_on=0
skip=0
for line in header:
    if line.find('begin{code}')>-1: 
        out.append('   ::')
        out.append('')
        code_on=1
        skip=1
    if line.find('end{code}')>-1:
        out.append('')
        code_on=0
        skip=1
    if skip:
        skip=0
    else:
        if code_on:
            out.append('  '+line)
        else:
            out.append(line)            

header=out


# ------------- Search for verbatim ------------- 

out=[]
code_on=0
skip=0
for line in header:
    if line.find('begin{verbatim}')>-1:
        out.append('   ::')
        out.append('')
        code_on=1
        skip=1
    if line.find('end{verbatim')>-1:
        out.append('%')
        code_on=0
        skip=1
    if skip:
        skip=0
    else:
        if code_on:
            out.append('  '+line)
        else:
            out.append(line)            

header=out


# Turn it back into line
#header=hh.split('\n')

# Remove the license from the code
ii=0
while ii< len(code):    
    if code[ii][0:20]=='% This program is fr':
        break
    ii=ii+1

code=code[0:ii]

# Post-processing the header

# Remove right spaces
header = map(lambda x:x.rstrip(),header)


if 1:
    print lineone[0],
    for ii in range(len(header)):
        line = header[ii]

        # Skip empty line if next line is also empty
        if (len(line.strip())==0):
            # Don't print the empty line if it is the last one
            if ii==len(header)-1:
                continue

            # Don't print the empty line if the next one is also empty
            if len(header[ii+1].strip())==0:
                continue

        print '%'+line

    print C

    for line in code:
        print line,

    print  '%HANDEDIT THIS FILE'

