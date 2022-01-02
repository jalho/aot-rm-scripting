//==============================================================================
// TEST TRIGGER SCRIPT
//==============================================================================


void main(void)
{
   trEventSetHandler(8,  "eventHandler");
   trEventSetHandler(4,  "eventHandler");
   trEventSetHandler(6,  "eventHandler");
   trEventSetHandler(5,  "eventHandler");
   trEventSetHandler(7,  "eventHandler");
   trEventSetHandler(13,  "eventHandler");
   trEventSetHandler(9,  "eventHandler");
   trEventSetHandler(11,  "eventHandler");
   trEventSetHandler(10,  "eventHandler");
   trEventSetHandler(12,  "eventHandler");
}

void eventHandler(int eventID=-1)
{
   switch(eventID)
   {
   case 8:
   {
      xsEnableRule("_StartCountdown1");
      trEcho("Trigger enabling rule StartCountdown1");
      break;
   }
   case 4:
   {
      xsEnableRule("_CountdownWarning1");
      trEcho("Trigger enabling rule CountdownWarning1");
      break;
   }
   case 6:
   {
      xsEnableRule("_CriticalCountdownWarning1");
      trEcho("Trigger enabling rule CriticalCountdownWarning1");
      break;
   }
   case 5:
   {
      xsEnableRule("_StopCountdown1");
      trEcho("Trigger enabling rule StopCountdown1");
      break;
   }
   case 7:
   {
      xsEnableRule("_Victory1");
      trEcho("Trigger enabling rule Victory1");
      break;
   }
   case 13:
   {
      xsEnableRule("_StartCountdown2");
      trEcho("Trigger enabling rule StartCountdown2");
      break;
   }
   case 9:
   {
      xsEnableRule("_CountdownWarning2");
      trEcho("Trigger enabling rule CountdownWarning2");
      break;
   }
   case 11:
   {
      xsEnableRule("_CriticalCountdownWarning2");
      trEcho("Trigger enabling rule CriticalCountdownWarning2");
      break;
   }
   case 10:
   {
      xsEnableRule("_StopCountdown2");
      trEcho("Trigger enabling rule StopCountdown2");
      break;
   }
   case 12:
   {
      xsEnableRule("_Victory2");
      trEcho("Trigger enabling rule Victory2");
      break;
   }
   }
}

rule _StartCountdown1
minInterval 4
active
{
   bool bVar0 = (true);

   bool bVar1 = (trPlayerUnitCountSpecific(1, "Plenty Vault KOTH") > 0);


   bool tempExp = (bVar0 && bVar1);
   if (tempExp)
   {
      trSetUnitIdleProcessing(true);
      trChatSend(0, "{PlayerNameString(1,22593)}");
      trSoundPlayFN("Fanfare.wav", "1", -1, "","");
      trCounterAddTime("victoryCounter1", 480, 120, "{PlayerIDNameString(1,22594)}", 4);
      trEventFire(5);
      xsDisableRule("_StartCountdown1");
      trEcho("Trigger disabling rule StartCountdown1");
   }
}

rule _CountdownWarning1
minInterval 4
inactive
{
   bool bVar0 = (true);


   bool tempExp = (bVar0);
   if (tempExp)
   {
      trSetUnitIdleProcessing(true);
      trChatSend(0, "{PlayerNameString(1,22595)}");
      trSoundPlayFN("Fanfare.wav", "1", -1, "","");
      trCounterAddTime("victoryCounter21", 120, 30, "{PlayerIDNameString(1,22594)}", 6);
      xsDisableRule("_CountdownWarning1");
      trEcho("Trigger disabling rule CountdownWarning1");
   }
}

rule _CriticalCountdownWarning1
minInterval 4
inactive
{
   bool bVar0 = (true);


   bool tempExp = (bVar0);
   if (tempExp)
   {
      trSetUnitIdleProcessing(true);
      trChatSend(0, "{PlayerNameString(1,22596)}");
      trSoundPlayFN("Fanfare.wav", "1", -1, "","");
      trCounterAddTime("victoryCounter31", 30, 0, "{PlayerIDNameString(1,22594)}", 7);
      xsDisableRule("_CriticalCountdownWarning1");
      trEcho("Trigger disabling rule CriticalCountdownWarning1");
   }
}

rule _StopCountdown1
minInterval 4
inactive
{
   bool bVar0 = (true);

   bool bVar1 = (trPlayerUnitCountSpecific(1, "Plenty Vault KOTH") < 1);


   bool tempExp = (bVar0 && bVar1);
   if (tempExp)
   {
      trSetUnitIdleProcessing(true);
      trCounterAbort("victoryCounter1");
      trCounterAbort("victoryCounter21");
      trCounterAbort("victoryCounter31");
      trChatSend(0, "{PlayerNameString(1,22597)}");
      trEventFire(8);
      xsDisableRule("_StopCountdown1");
      trEcho("Trigger disabling rule StopCountdown1");
   }
}

rule _Victory1
minInterval 4
inactive
{
   bool bVar0 = (true);


   bool tempExp = (bVar0);
   if (tempExp)
   {
      trSetUnitIdleProcessing(true);
      trChatSend(0, "{PlayerNameString(1,22598)}");
      trSoundPlayFN("Fanfare.wav", "1", -1, "","");
      trSetPlayerWon(1);
      xsDisableRule("_Victory1");
      trEcho("Trigger disabling rule Victory1");
   }
}

rule _StartCountdown2
minInterval 4
active
{
   bool bVar0 = (true);

   bool bVar1 = (trPlayerUnitCountSpecific(2, "Plenty Vault KOTH") > 0);


   bool tempExp = (bVar0 && bVar1);
   if (tempExp)
   {
      trSetUnitIdleProcessing(true);
      trChatSend(0, "{PlayerNameString(2,22593)}");
      trSoundPlayFN("Fanfare.wav", "1", -1, "","");
      trCounterAddTime("victoryCounter2", 480, 120, "{PlayerIDNameString(2,22594)}", 9);
      trEventFire(10);
      xsDisableRule("_StartCountdown2");
      trEcho("Trigger disabling rule StartCountdown2");
   }
}

rule _CountdownWarning2
minInterval 4
inactive
{
   bool bVar0 = (true);


   bool tempExp = (bVar0);
   if (tempExp)
   {
      trSetUnitIdleProcessing(true);
      trChatSend(0, "{PlayerNameString(2,22595)}");
      trSoundPlayFN("Fanfare.wav", "1", -1, "","");
      trCounterAddTime("victoryCounter22", 120, 30, "{PlayerIDNameString(2,22594)}", 11);
      xsDisableRule("_CountdownWarning2");
      trEcho("Trigger disabling rule CountdownWarning2");
   }
}

rule _CriticalCountdownWarning2
minInterval 4
inactive
{
   bool bVar0 = (true);


   bool tempExp = (bVar0);
   if (tempExp)
   {
      trSetUnitIdleProcessing(true);
      trChatSend(0, "{PlayerNameString(2,22596)}");
      trSoundPlayFN("Fanfare.wav", "1", -1, "","");
      trCounterAddTime("victoryCounter32", 30, 0, "{PlayerIDNameString(2,22594)}", 12);
      xsDisableRule("_CriticalCountdownWarning2");
      trEcho("Trigger disabling rule CriticalCountdownWarning2");
   }
}

rule _StopCountdown2
minInterval 4
inactive
{
   bool bVar0 = (true);

   bool bVar1 = (trPlayerUnitCountSpecific(2, "Plenty Vault KOTH") < 1);


   bool tempExp = (bVar0 && bVar1);
   if (tempExp)
   {
      trSetUnitIdleProcessing(true);
      trCounterAbort("victoryCounter2");
      trCounterAbort("victoryCounter22");
      trCounterAbort("victoryCounter32");
      trChatSend(0, "{PlayerNameString(2,22597)}");
      trEventFire(13);
      xsDisableRule("_StopCountdown2");
      trEcho("Trigger disabling rule StopCountdown2");
   }
}

rule _Victory2
minInterval 4
inactive
{
   bool bVar0 = (true);


   bool tempExp = (bVar0);
   if (tempExp)
   {
      trSetUnitIdleProcessing(true);
      trChatSend(0, "{PlayerNameString(2,22598)}");
      trSoundPlayFN("Fanfare.wav", "1", -1, "","");
      trSetPlayerWon(2);
      xsDisableRule("_Victory2");
      trEcho("Trigger disabling rule Victory2");
   }
}

rule _Enable_Vault
minInterval 4
active
{
   bool bVar0 = (true);

   bool bVar1 = ((trTime()-cActivationTime) >= 30);


   bool tempExp = (bVar0 && bVar1);
   if (tempExp)
   {
      trSetUnitIdleProcessing(true);
      trTechSetStatus(1, 378, 4);
      trTechSetStatus(2, 378, 4);
      xsDisableRule("_Enable_Vault");
      trEcho("Trigger disabling rule Enable_Vault");
   }
}

