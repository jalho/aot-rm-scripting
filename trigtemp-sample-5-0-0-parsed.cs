void main(void)
{
}

rule _injection
minInterval 4
inactive
{
   bool bVar0 = (true);
   bool tempExp = (bVar0);
   if (tempExp) {
      trSetUnitIdleProcessing(true);
      trSetUnitIdleProcessing();
      xsDisableSelf();
   }
}

// ^^^^^ init brings up to this ^^^^^
