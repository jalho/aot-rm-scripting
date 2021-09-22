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

// injectInitNote() injects this:

rule _post_initial_note
highFrequency
active
{
   static int last = 0;
   int now = trTimeMS() - 5000;
   if(now - last < 250) {
      return();
   }
   last = now;
   if(false) {
      trChatHistoryClear();
   }
   trChatSend(0, "<color=1.0,1.0,1.0>Voobly Balance Patch 5.0</color>");
   trChatSend(0, "<color=1.0,1.0,1.0>Alfheim</color>");
   trChatSendSpoofed(1, "<color=0.2,0.2,1.0>+Raudus (Zeus)</color>");
   trChatSend(0, "<color=1.0,1.0,1.0>----- vs. -----</color>");
   trChatSendSpoofed(2, "<color=1.0,0.2,0.2>Heliopolis (Set)</color>");
   trSoundPlayFN("\chatreceived.wav", "1", -1,"", "");
   xsDisableSelf();
}