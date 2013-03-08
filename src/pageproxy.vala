


//------------------------------------------------------------------------------

namespace Itmages {
//------------------------------------------------------------------------------
    public class ItmagesPageProxy : Gtk.Frame {

        private Gtk.Entry entry_node;
        private Gtk.Entry entry_user;
        private Gtk.Entry entry_passwd;
        private Gtk.SpinButton spin_port;
        private Gtk.ComboBox combo;
        private Config config;
        private Gtk.ListStore combomodel;

        public signal void auth_data_complete (bool value);

        public ItmagesPageProxy (Config conf) {
            ItProxyTypeItem proxy_off = ItProxyTypeItem ()
                        {desc = _("Without proxy"), index = 0, curl_code = -100};
            ItProxyTypeItem proxy_http = ItProxyTypeItem ()
                        {desc = _("HTTP proxy"), index = 1, curl_code = 0};
            ItProxyTypeItem proxy_socks4 = ItProxyTypeItem ()
                        {desc = _("SOCKS4 proxy"), index = 2, curl_code = 4};
            ItProxyTypeItem proxy_socks5 = ItProxyTypeItem ()
                        {desc = _("SOCKS5 proxy"), index = 3, curl_code = 5};

            Gtk.Alignment align;
            Gtk.Label label;

            config = conf;
            var table = new Gtk.Table (2, 6, false);

            align = new Gtk.Alignment (0.0f, 0.5f, 0.0f, 1.0f);
            label = new Gtk.Label (_("Type:"));
            align.add (label);
            table.attach (align, 0, 1, 0, 1,
                          Gtk.AttachOptions.FILL,
                          Gtk.AttachOptions.FILL,
                          2, 5);
            
            align = new Gtk.Alignment (0.0f, 0.5f, 0.0f, 1.0f);
            label = new Gtk.Label (_("Node:"));
            align.add (label);
            table.attach (align, 0, 1, 1, 2,
                          Gtk.AttachOptions.FILL,
                          Gtk.AttachOptions.FILL,
                          2, 5);
            
            align = new Gtk.Alignment (0.0f, 0.5f, 0.0f, 1.0f);
            label = new Gtk.Label (_("Port:"));
            align.add (label);
            table.attach (align, 0, 1, 2, 3,
                          Gtk.AttachOptions.FILL,
                          Gtk.AttachOptions.FILL,
                          2, 5);
            
            align = new Gtk.Alignment (0.0f, 0.5f, 0.0f, 1.0f);
            label = new Gtk.Label (_("User:"));
            align.add (label);
            table.attach (align, 2, 3, 1, 2,
                          Gtk.AttachOptions.FILL,
                          Gtk.AttachOptions.FILL,
                          2, 5);
            
            align = new Gtk.Alignment (0.0f, 0.5f, 0.0f, 1.0f);
            label = new Gtk.Label (_("Password:"));
            align.add (label);
            table.attach (align, 2, 3, 2, 3,
                         Gtk.AttachOptions.FILL,
                         Gtk.AttachOptions.FILL,
                         2, 5);

            var cell = new Gtk.CellRendererText ();
            combomodel = new Gtk.ListStore (2, typeof (string), typeof(int));
            combo = new Gtk.ComboBox.with_model (combomodel);
            combo.pack_start (cell, false);
            combo.add_attribute(cell, "text", 0);
            table.attach (combo, 1, 2, 0, 1,
                          Gtk.AttachOptions.EXPAND |
                          Gtk.AttachOptions.FILL,
                          0, 2, 5);

            add_item (combomodel, proxy_off.desc, proxy_off.curl_code);
            add_item (combomodel, proxy_http.desc, proxy_http.curl_code);
            add_item (combomodel, proxy_socks4.desc, proxy_socks4.curl_code);
            add_item (combomodel, proxy_socks5.desc, proxy_socks5.curl_code);

            entry_node = new Gtk.Entry ();
            align = new Gtk.Alignment (0.0f, 0.5f, 1.0f, 1.0f);
            align.add (entry_node);
            table.attach (align, 1, 2, 1, 2,
                          Gtk.AttachOptions.EXPAND |
                          Gtk.AttachOptions.FILL,
                          Gtk.AttachOptions.FILL,
                          2, 5);
            entry_node.set_name ("proxynode");

            var adj = new Gtk.Adjustment (config.proxyport, 1, 80000, 1, 100, 0);
            align = new Gtk.Alignment (0.0f, 0.5f, 1.0f, 1.0f);
            spin_port = new Gtk.SpinButton (adj, 0, 0);
            align.add (spin_port);
            spin_port.set_name ("proxyport");
            table.attach (align, 1, 2, 2, 3,
                          Gtk.AttachOptions.EXPAND |
                          Gtk.AttachOptions.FILL,
                          Gtk.AttachOptions.FILL,
                          2, 5);

            entry_user = new Gtk.Entry ();
            entry_user.set_name ("proxyuser");
            align = new Gtk.Alignment (0.0f, 0.5f, 1.0f, 1.0f);
            align.add (entry_user);
            table.attach (align, 3, 4, 1, 2,
                          Gtk.AttachOptions.EXPAND |
                          Gtk.AttachOptions.FILL,
                          Gtk.AttachOptions.FILL,
                          2, 5);

            entry_passwd = new Gtk.Entry ();
            entry_user.set_name("proxypass");
            align = new Gtk.Alignment (0.0f, 0.5f, 1.0f, 1.0f);
            align.add (entry_passwd);
            table.attach (align, 3, 4, 2, 3,
                          Gtk.AttachOptions.EXPAND |
                          Gtk.AttachOptions.FILL,
                          Gtk.AttachOptions.FILL,
                          2, 5);

            table.set_col_spacing (1, 12);
            align = new Gtk.Alignment (0.5f, 0.5f, 0.0f, 0.0f);
            align.set_padding (5, 5, 5, 5);
            set_shadow_type (Gtk.ShadowType.NONE);
            add (align);
            align.add (table);

            entry_node.changed.connect_after (entry_node_changed_cb);
            entry_user.changed.connect_after (entry_user_changed_cb);
            entry_passwd.changed.connect_after(entry_passwd_changed_cb);
            spin_port.value_changed.connect_after (port_value_changed_cb);
            combo.changed.connect (combo_changed_cb);

            if (config.proxynode != null) entry_node.set_text (config.proxynode);
            if (config.proxyuser != null) entry_user.set_text (config.proxyuser);
            if (config.proxypass != null) entry_passwd.set_text (config.proxypass);
            spin_port.set_value (config.proxyport);

            Gtk.TreeIter iter;
            int value;
            int active = (int) config.proxytype;
            combo.set_active (0);
            
            if (combomodel.get_iter_first (out iter)) {
                do {
                    combomodel.get (iter, 1, out value);
                    if (value == active) {
                        combo.set_active_iter (iter);
                        break;
                    }
                } while (combomodel.iter_next (ref iter));
            }
        }

        private void add_item (Gtk.ListStore model, string val1, int val2) {

            Gtk.TreeIter iter;
            model.append(out iter);
            model.set (iter, 0, val1, 1, val2);
        }


        private void combo_changed_cb () {
            int value;
            Gtk.TreeIter iter;

            if (combo.get_active_iter (out iter)) {
                combomodel.get (iter, 1, out value);
            } else {
                value = -100;
            }
            
            bool active = value > -100;
            config.proxytype = value;
            entry_node.set_sensitive (active);
            spin_port.set_sensitive (active);
            entry_user.set_sensitive (active);
            entry_passwd.set_sensitive (active);
        }


        private void port_value_changed_cb () {
            config.proxyport = spin_port.get_value_as_int ();
        }

        private void entry_node_changed_cb () {
            var value = entry_node.get_text ();
            if (value != null && value.length > 5) config.proxynode = value;
        } 


        private void entry_user_changed_cb () {
            string user = entry_user.get_text ();
            string passwd = config.proxypass;
            if (user != null && user.length > 2) config.proxyuser = user;
            auth_data_complete((user.length > 2 && passwd.length > 2));
        }


        private void entry_passwd_changed_cb () {
            string passwd = entry_passwd.get_text ();
            string user = config.proxyuser;
            if (passwd != null && passwd.length > 2) config.proxypass = passwd;
            auth_data_complete((user.length > 2 && passwd.length > 2));
        }

    }

//------------------------------------------------------------------------------
}

//------------------------------------------------------------------------------
