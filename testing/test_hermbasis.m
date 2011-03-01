function test_failed=test_hermbasis
%TEST_HERMBASIS  Test HERMBASIS

Lr=[9,10,12];
order=[2,5,17];

test_failed=0;

disp(' ===============  TEST_HERMBASIS ==========');

for ii=1:length(Lr)
  
  for jj=1:length(order)
    L=Lr(ii);
    p=order(jj);
    
    H=hermbasis(L,p);
    
    r1=(H*H')-eye(L);
    res=norm(r1,'fro');
    [test_failed,fail]=ltfatdiditfail(res,test_failed);
    
    s=sprintf('HERMBASIS orth L:%3i %3i %0.5g %s',L,p,res,fail);
    disp(s);
  end;
end;