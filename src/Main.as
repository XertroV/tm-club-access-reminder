const string PluginName = Meta::ExecutingPlugin().Name;
const string MenuIconColor = "\\$f5d";
const string PluginIcon = Icons::Cogs;
const string MenuTitle = MenuIconColor + PluginIcon + "\\$z " + PluginName;

string subName = "None";

void Main() {
    auto app = GetApp();
    auto userMgr = app.UserManagerScript;

    auto clubEnd = userMgr.Subscription_GetEndTimeStamp(userMgr.Users[0].Id, "Club");
    auto stdEnd = userMgr.Subscription_GetEndTimeStamp(userMgr.Users[0].Id, "Standard");

    if (clubEnd == 0 && stdEnd == 0) {
        print("No subscription found.");
        return;
    }

    subName = clubEnd > stdEnd ? "Club" : "Standard";

    auto timeLeft = int64(Math::Max(clubEnd, stdEnd)) - Time::Stamp;
    auto daysLeft = float(timeLeft) / 86400;
    trace("Days left: " + daysLeft + " of " + subName + " access.");

    if (daysLeft > 7) {
        NotifySuccess("You have " + DaysLeftToHuman(daysLeft) + " left of your " + subName + " access.");
        return;
    }

    if (daysLeft > 1) {
        NotifyWarning("You have " + DaysLeftToHuman(daysLeft) + " left of your " + subName + " access.");
        return;
    }

    if (daysLeft > 0) {
        NotifyError("You have " + DaysLeftToHuman(daysLeft) + " left of your " + subName + " access.");
        return;
    }

    NotifyError("Your access has expired.");
}

const float DAYS_PER_YEAR = 365.25;
const float DAYS_PER_MONTH = 30.4375;

string DaysLeftToHuman(float daysLeft) {
    string[] ret;
    int done = 0;
    if (daysLeft > DAYS_PER_YEAR) {
        int years = Math::Floor(daysLeft / DAYS_PER_YEAR);
        ret.InsertLast(Text::Format("%d year", years) + (years > 1 ? "s" : ""));
        daysLeft -= DAYS_PER_YEAR * years;
        done++;
    }
    if (daysLeft > DAYS_PER_MONTH) {
        int months = Math::Floor(daysLeft / DAYS_PER_MONTH);
        ret.InsertLast(Text::Format("%d month", months) + (months > 1 ? "s" : ""));
        daysLeft -= DAYS_PER_MONTH * months;
        done++;
    }
    if (done < 2 && daysLeft > 1) {
        int days = Math::Floor(daysLeft);
        ret.InsertLast(Text::Format("%d day", days) + (daysLeft > 1 ? "s" : ""));
        daysLeft -= days;
        done++;
    }
    if (done < 2 && daysLeft > 0) {
        int hours = Math::Floor(daysLeft * 24.0);
        ret.InsertLast(Text::Format("%d hour", hours) + (hours > 1 ? "s" : ""));
        daysLeft -= hours / 24.0;
        done++;
    }
    if (done < 2 && daysLeft > 0) {
        int minutes = Math::Floor(daysLeft * 1440.0);
        ret.InsertLast(Text::Format("%d minute", minutes) + (minutes > 1 ? "s" : ""));
        daysLeft -= minutes / 1440.0;
        done++;
    }
    if (done < 2 && daysLeft > 0) {
        int seconds = Math::Floor(daysLeft * 86400.0);
        ret.InsertLast(Text::Format("%d second", seconds) + (seconds > 1 ? "s" : ""));
        done++;
    }
    return string::Join(ret, ", ");
}
