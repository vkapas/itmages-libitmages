


//------------------------------------------------------------------------------

namespace Itmages {
//------------------------------------------------------------------------------

    public class ItmagesPageLogin : Gtk.Frame {

        private Gtk.CheckButton profile; 
        private Gtk.Entry login = new Gtk.Entry ();
        private Gtk.Entry passwd = new Gtk.Entry ();
        private Gtk.Table table = new Gtk.Table (2, 2, false);

        private Config dconfig;

        public ItmagesPageLogin (Config conf) {

            dconfig = conf;

            profile = new Gtk.CheckButton.with_label (_("Without profile"));

            Gtk.VBox vbox = new Gtk.VBox (false, 10);
            Gtk.Label lbLogin = new Gtk.Label (_("Login:"));
            Gtk.Label lbPasswd = new Gtk.Label (_("Password:"));

            Gtk.Alignment alProf = new Gtk.Alignment (0.0f, 0.5f, 0.5f, 0.5f);
            Gtk.Alignment allbLog = new Gtk.Alignment (0.0f, 0.5f, 0.0f, 0.5f);
            Gtk.Alignment allbPass = new Gtk.Alignment (0.0f, 0.5f, 0.0f, 0.5f);
            Gtk.Alignment alentLog = new Gtk.Alignment (0.0f, 0.5f, 0.5f, 0.5f);
            Gtk.Alignment alentPass = new Gtk.Alignment (0.0f, 0.5f, 0.5f, 0.5f);

            login.set_can_focus (true);
            login.set_activates_default (true);
            
            passwd.set_visibility (false);
            passwd.set_activates_default (true);

            if (dconfig.username != null) login.set_text (dconfig.username);
            if (dconfig.password != null) passwd.set_text (dconfig.password);

            profile.toggled.connect_after (profile_toggled_cb);
            login.changed.connect_after (entry_login_changed_cb);
            passwd.changed.connect_after (entry_passwd_changed_cb);

            profile.set_active (dconfig.without_profile);

            alProf.set_padding (0, 0, 6, 0);
            allbLog.set_padding (0, 0, 10, 0);
            allbPass.set_padding (0, 10, 10, 0);
            alentLog.set_padding (0, 0, 0, 10);
            alentPass.set_padding (0, 10, 0, 10);
            vbox.set_spacing (2);
            vbox.set_border_width (5);
            table.set_row_spacings (10);
            table.set_col_spacings (10);
            alProf.add (profile);
            allbLog.add (lbLogin);
            allbPass.add (lbPasswd);
            alentLog.add (login);
            alentPass.add (passwd);
            table.attach (allbLog, 0, 1, 0, 1,
                                               // Gtk.AttachOptions.EXPAND |
                                                Gtk.AttachOptions.FILL,
                                                Gtk.AttachOptions.EXPAND |
                                                Gtk.AttachOptions.FILL,
                                                0, 0);
            table.attach (allbPass, 0, 1, 1, 2,
                                                //Gtk.AttachOptions.EXPAND |
                                                Gtk.AttachOptions.FILL,
                                                Gtk.AttachOptions.EXPAND |
                                                Gtk.AttachOptions.FILL,
                                                0, 0);
            table.attach (alentLog, 1, 2, 0, 1,
                                                Gtk.AttachOptions.EXPAND |
                                                Gtk.AttachOptions.FILL,
                                                Gtk.AttachOptions.EXPAND |
                                                Gtk.AttachOptions.FILL,
                                                0, 0);
            
            table.attach (alentPass, 1, 2, 1, 2,
                                                Gtk.AttachOptions.EXPAND |
                                                Gtk.AttachOptions.FILL,
                                                Gtk.AttachOptions.EXPAND |
                                                Gtk.AttachOptions.FILL,
                                                0, 0);
            
            vbox.pack_start (table, true, true, 0);
            vbox.pack_start (alProf, true, true, 0);
            vbox.show_all ();
            Gtk.Alignment align = new Gtk.Alignment (0.0f, 0.0f, 0.5f, 0.5f);
            align.set_padding (5, 5, 5, 5);
            set_shadow_type (Gtk.ShadowType.NONE);
            align.add (vbox);
            add (align);
        }


        private void profile_toggled_cb () {
                                              
            bool active = profile.get_active ();
            table.set_sensitive (!active);
            dconfig.without_profile = active;

        }


        private void entry_login_changed_cb () {

            dconfig.username = login.get_text ();
        }


        private void entry_passwd_changed_cb () {

            dconfig.password = passwd.get_text ();
        }

    } // Class ItmagesPageLogin

//------------------------------------------------------------------------------
}


//------------------------------------------------------------------------------
