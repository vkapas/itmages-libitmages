

public class UploaderUnityEntry: GLib.Object  {

    private Itmages.UploaderWindow uploader;
    private bool vstarted = false;
    private Unity.LauncherEntry launcher;
    private Dbusmenu.Menuitem menu;
    private Dbusmenu.Menuitem item_copy1;
    private Dbusmenu.Menuitem item_copy2;
    private Dbusmenu.Menuitem item_start;
    private Dbusmenu.Menuitem item_stop;
    private uint source = 0;

    private const int START = 0;
    private const int STOP = 1;

    public UploaderUnityEntry.with_parent (Itmages.UploaderWindow window) {
    
        string desktop_name = "%s.desktop".printf (GLib.Environment.get_application_name ());

        launcher = Unity.LauncherEntry.get_for_desktop_id (desktop_name);
        launcher.count = 0;
        launcher.progress = 0.0;
        launcher.count_visible = false;
        launcher.progress_visible = false;
        launcher.urgent = false;
        uploader = window;

        menu = new Dbusmenu.Menuitem ();

        item_copy1 = new Dbusmenu.Menuitem ();
        item_copy1.property_set (Dbusmenu.MENUITEM_PROP_LABEL, _("Take all or selected"));
        item_copy1.item_activated.connect (() => {
                                                    uploader.copy_many ();
                                                    reset_urgent ();
                                                 });

        item_copy2 = new Dbusmenu.Menuitem ();
        item_copy2.property_set (Dbusmenu.MENUITEM_PROP_LABEL, _("Take the latest"));
        item_copy2.item_activated.connect (() => {
                                                    uploader.copy_last ();
                                                    reset_urgent ();
                                                 });

        item_start = new Dbusmenu.Menuitem ();
        item_start.property_set (Dbusmenu.MENUITEM_PROP_LABEL, _("Start upload"));
        item_start.item_activated.connect (() => {
                                                    reset_urgent ();
                                                    uploader.upload_start ();
                                                 });

        item_stop = new Dbusmenu.Menuitem ();
        item_stop.property_set (Dbusmenu.MENUITEM_PROP_LABEL, _("Stop upload"));
        item_stop.item_activated.connect (() => {
                                                    uploader.upload_stop ();
                                                    reset_urgent ();
                                                });

        set_item_visible (STOP);

        menu.child_append (item_copy1);
        menu.child_append (item_copy2);
        menu.child_append (item_start);
        menu.child_append (item_stop);
        launcher.quicklist = menu;

        menu.about_to_show.connect (() => {return false;});
        menu.event.connect (menu_event_cb);

        uploader.progress_changed.connect (uploader_progress_changed_cb);
        uploader.started.connect (uploader_action_started_cb);
        uploader.complete.connect (uploader_action_complete_cb);
        uploader.focus_in_event.connect_after (uploader_show_all_cb);

    }

    private bool uploader_show_all_cb (Gdk.EventFocus event) {
        if (launcher.urgent && uploader.is_focus)
            launcher.urgent = false;
            source = 0;    
        return false;
    }
    

    private void uploader_progress_changed_cb (int cnt, double fract) {
        launcher.progress = fract;
        launcher.count = (int64) cnt;
    }


    private void uploader_action_started_cb (int cnt) {
        if (cnt > 0) {
            this.started = true;
            launcher.count = (int64) cnt;
            launcher.progress = 0.0;
        }
    }


    private void uploader_action_complete_cb (bool status, int cnt) {
        if (cnt == 0) {
            this.started = false;
            launcher.count = (int64) cnt;
        }
        if (!uploader.is_active) {
            launcher.urgent = true;
            if (source > 0) GLib.Source.remove (source);
            source = GLib.Timeout.add (4000, (GLib.SourceFunc) urgent_retry);
        }
    }
    

    private bool started {
        set {
                launcher.count_visible = value;
                launcher.progress_visible = value;
                vstarted = value;
                set_item_visible ((value)? START: STOP);
            }
        get {return vstarted;}
    }

    private bool urgent_retry () {
        if (source > 0 && !uploader.is_focus) {
            var value = !launcher.urgent;
            launcher.urgent = value;
        } else {
            launcher.urgent = false;
        }
        return (source > 0);
    }

    private void set_item_visible (int action) {
        bool tmp = (action == START);
        item_start.property_set_bool (Dbusmenu.MENUITEM_PROP_ENABLED, !tmp);
        item_stop.property_set_bool (Dbusmenu.MENUITEM_PROP_ENABLED, tmp);
    }


    private bool menu_event_cb (string name, GLib.Variant value, uint timestamp) {
        if (name != Dbusmenu.MENUITEM_EVENT_OPENED) {
            reset_urgent ();
        }
        return true;
    }

    private void reset_urgent () {
        launcher.urgent = false;
        source = 0;
    }
}
