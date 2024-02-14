function standard=alignspec(ref,standard);
% standard=alignspec(ref,standard);
% No documentation is available
% Usage and changes of this software is restricted, contact:
% Urs Utzinger, Spectroscopy Laboratory UT Austin 1999
global dbg
   zone=0:200;
   zone=zone';
   AmountToMove=0;
   Test=ref(700:900)./standard(700:900);
   [TestPoly,s]=polyfit(zone,Test,4);
   [Y,Delta]=polyval(TestPoly,zone,s);
   Subtracted=Test-Y;
   StdevOld=std(Subtracted);
   
   for f=-50:1:50
      Test=ref(700:900)./standard(700+f:900+f);
      [TestPoly,s]=polyfit(zone,Test,4);
      [Y,Delta]=polyval(TestPoly,zone,s);
      Subtracted=Test-Y;
      StdevNew=std(Subtracted);
      if StdevNew<StdevOld
         AmountToMove=f;
         StdevOld=StdevNew;
      end      
   end

  [r,c]=size(ref);
  temp=ones(r,1);
  
  if dbg; disp(['Amount to move:' num2str(AmountToMove)]); end;
   
  if AmountToMove<0
      temp(-AmountToMove+1:r)=standard(1:r+AmountToMove);
      standard=temp;
  end
   
  if AmountToMove>0
      temp(1:r-AmountToMove)=standard(AmountToMove+1:r);
      standard=temp;
  end
return

