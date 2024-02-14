 function o=combinecell(c1,c2);
 % combine two cells constructs
 
 [n1,m1]=size(c1);
 [n2,m2]=size(c2);
 
 if n1==n2
     o=cell(n1,m1+m2);
     for i=1:m1
         o{n1,i}=c1{n1,i};
     end
     for i=m1+1:m1+m2
         o{n1,i}=c2{n2,i-m1};
     end
 elseif m1==m2
     o=cell(n1+n2,m1);
     for i=1:n1
         o{i,m1}=c1{i,m1};
     end
     for i=n1+1:n1+n2
         o{i,m1}=c2{i-n1,m2};
     end
 elseif n1==0
     o=c2;
     warning('not the same cell constructs')
 else
     o=c1;
     warning('not the same cell constructs')
 end
 
     