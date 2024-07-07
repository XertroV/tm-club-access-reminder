[Setting category="General" name="Minimum days before you get a reminder" min=1 max=1097 description="1097 days is 3 years and change. Ctrl+click to input exact number."]
float S_ReminderLimitDays = 365;

[Setting category="General" name="Notification on-screen seconds (When > 7 days left)" min=5 max=60 description="Only shown when the game starts."]
float S_NotifyGoodOnScreenSeconds = 15.;

[Setting category="General" name="Notification on-screen seconds (Warning)" min=5 max=60 description="Only shown when the game starts."]
float S_NotifyWarnOnScreenSeconds = 25.;

#if DEV
[Setting category="General" name="[DEV] First launch"]
#else
[Setting hidden]
#endif
bool S_FirstLaunch = true;
