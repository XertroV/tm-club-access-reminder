const string PluginName = Meta::ExecutingPlugin().Name;
const string MenuIconColor = "\\$f5d";
const string PluginIcon = Icons::Cogs;
const string MenuTitle = MenuIconColor + PluginIcon + "\\$z " + PluginName;

string subName = "None";

void Main() {
    yield(5);
    sleep(200);
    auto app = GetApp();
    auto userMgr = app.UserManagerScript;

    auto clubEnd = userMgr.Subscription_GetEndTimeStamp(userMgr.Users[0].Id, "Club");
    auto stdEnd = userMgr.Subscription_GetEndTimeStamp(userMgr.Users[0].Id, "Standard");

    if (clubEnd == 0 && stdEnd == 0) {
        NotifyError("No club/standard subscription found.");
        return;
    }

    subName = clubEnd >= stdEnd ? "Club" : "Standard";

    auto timeLeft = int64(Math::Max(clubEnd, stdEnd)) - Time::Stamp;
    auto daysLeft = float(timeLeft) / 86400;
    trace("Days left: " + daysLeft + " of " + subName + " access.");

    if (daysLeft > S_ReminderLimitDays && !S_FirstLaunch) {
        return;
    }

    bool wasFirstLaunch = S_FirstLaunch;
    S_FirstLaunch = false;

    if (daysLeft > 7) {
        NotifySuccess(DaysLeftToHuman(daysLeft, "\n"), subName + " Access Remaining");
        if (daysLeft > S_ReminderLimitDays && wasFirstLaunch) {
            Notify("Note: You won't be reminded again until you have less than " + Text::Format("%.0f", S_ReminderLimitDays) + " days left. (Adjust in settings)");
        }
    } else if (daysLeft > 1) {
        NotifyWarning("Your " + subName + " access expires in:\n\n" + DaysLeftToHuman(daysLeft, "\n"), subName + " Access Remaining");
    } else if (daysLeft > 0) {
        NotifyError("Your " + subName + " access expires in:\n\n" + DaysLeftToHuman(daysLeft, "\n"), subName + " Access Remaining");
    } else {
        NotifyError("Your access has expired.");
    }

#if DEVx
    sleep(1000);
    S_FirstLaunch = true;
#endif
}

const float DAYS_PER_YEAR = 365.25;
const float DAYS_PER_MONTH = 30.4375;
const int PARTS_LIMIT = 3;

string DaysLeftToHuman(float daysLeft, const string &in separator = ", ") {
    if (daysLeft < 0) return "in the past";
    string[] ret;
    int done = 0;
    if (daysLeft > DAYS_PER_YEAR) {
        int years = int(Math::Floor(daysLeft / DAYS_PER_YEAR));
        ret.InsertLast(Text::Format("%d year", years) + (years > 1 ? "s" : ""));
        daysLeft -= DAYS_PER_YEAR * years;
        done++;
    }
    if (done < PARTS_LIMIT && daysLeft > DAYS_PER_MONTH) {
        int months = int(Math::Floor(daysLeft / DAYS_PER_MONTH));
        ret.InsertLast(Text::Format("%d month", months) + (months > 1 ? "s" : ""));
        daysLeft -= DAYS_PER_MONTH * months;
        done++;
    }
    if (done < PARTS_LIMIT && daysLeft > 1) {
        int days = int(Math::Floor(daysLeft));
        ret.InsertLast(Text::Format("%d day", days) + (daysLeft > 1 ? "s" : ""));
        daysLeft -= days;
        done++;
    }
    if (done < PARTS_LIMIT && daysLeft > 0) {
        int hours = int(Math::Floor(daysLeft * 24.0));
        ret.InsertLast(Text::Format("%d hour", hours) + (hours > 1 ? "s" : ""));
        daysLeft -= hours / 24.0;
        done++;
    }
    if (done < PARTS_LIMIT && daysLeft > 0) {
        int minutes = int(Math::Floor(daysLeft * 1440.0));
        ret.InsertLast(Text::Format("%d minute", minutes) + (minutes > 1 ? "s" : ""));
        daysLeft -= minutes / 1440.0;
        done++;
    }
    if (done < PARTS_LIMIT && daysLeft > 0) {
        int seconds = int(Math::Floor(daysLeft * 86400.0));
        ret.InsertLast(Text::Format("%d second", seconds) + (seconds > 1 ? "s" : ""));
        done++;
    }
    return string::Join(ret, separator);
}
