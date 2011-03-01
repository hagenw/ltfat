function test_failed=test_dfft
%TEST_DFFT  Test DFFT

Lr=[9,10,12];
order=[2,5,17];

test_failed=0;

disp(' ===============  TEST_DFFT ==========');

for ii=1:length(Lr)
  
  for jj=1:length(order)
    L=Lr(ii);
    p=order(jj);

    f=normalize(crand(L,1),'2');
    
    % --- test of correct normalization -------
    h=dfft(f,.3);
    
    res=norm(h)-1;
    [test_failed,fail]=ltfatdiditfail(res,test_failed);
    
    s=sprintf('DFFT norm L:%3i %3i %0.5g %s',L,p,res,fail);
    disp(s);
    
    % --- test of order 4 == identity  -------
    h=dfft(f,4);
    
    res=norm(h-f);
    [test_failed,fail]=ltfatdiditfail(res,test_failed);
    
    s=sprintf('DFFT iden L:%3i %3i %0.5g %s',L,p,res,fail);
    disp(s);

    % --- test of order 1 == dft      -------
    h=dfft(f,1);
    
    res=norm(h-dft(f));
    [test_failed,fail]=ltfatdiditfail(res,test_failed);
    
    s=sprintf('DFFT dft  L:%3i %3i %0.5g %s',L,p,res,fail);
    disp(s);
    
  end;
end;