
void Notify(const string &in msg) {
    UI::ShowNotification(Meta::ExecutingPlugin().Name, msg);
    trace("Notified: " + msg);
}

void NotifySuccess(const string &in msg, const string &in heading = "") {
    UI::ShowNotification(heading.Length > 0 ? heading : Meta::ExecutingPlugin().Name, msg, vec4(.4, .7, .1, .3), int(S_NotifyGoodOnScreenSeconds * 1000.));
    trace("Notified: " + msg);
}

void NotifyError(const string &in msg, const string &in heading = "") {
    warn(msg);
    UI::ShowNotification(heading.Length > 0 ? heading : (Meta::ExecutingPlugin().Name + ": Error"), msg, vec4(.9, .3, .1, .3), int(S_NotifyWarnOnScreenSeconds * 1000.));
}

void NotifyWarning(const string &in msg, const string &in heading = "") {
    warn(msg);
    UI::ShowNotification(heading.Length > 0 ? heading : (Meta::ExecutingPlugin().Name + ": Warning"), msg, vec4(.7, .4, .1, .3), int(S_NotifyWarnOnScreenSeconds * 1000.));
}
