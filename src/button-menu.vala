

// The formal changes to start build 


//------------------------------------------------------------------------------

namespace Itmages {
//------------------------------------------------------------------------------
    public class RadioButtonMenu: Gtk.ToggleButton {

        public Gtk.Menu menu;
        private Gtk.Label label_widget;
        public signal void value_changed (int val);
        private Gtk.RadioMenuItem first_widget;
        private int index = 0;
        private int orig_index = 0;
        private int last_index = 0;

        private GLib.SList <int> ignored;
        private GLib.HashTable<string, string> content;

        public RadioButtonMenu () {
            menu = new Gtk.Menu ();
            label_widget = new Gtk.Label (null);
            ignored = new GLib.SList<int> ();
            content = new GLib.HashTable <string, string> (str_hash, str_equal);

            menu.show_all ();
            menu.cancel.connect (menu_state_changed);
            menu.selection_done.connect (menu_state_changed);
            this.toggled.connect (this_toggled_cb);
            this.add (label_widget);
            label_widget.xalign = 0.0f;
        }


        public string get_active_content () {
            unowned string value;
            value = this.content.lookup (this.index.to_string ());
            return (string) value;
        }
            
        public string get_content (int key) {
            unowned string value;
            value = this.content.lookup (key.to_string ());
            return (string) value;
        }
            

        public bool set_content (int key, string value) {
            bool result = false;
            if (key < menu.get_children ().length ()) {
                if (value.length > 0) {
                    this.content.insert (key.to_string (), value);
                    result = true;
                } else {
                    Gtk.Widget item = menu.get_children ().nth_data (key);
                    item.no_show_all = true;
                    item.visible = false;
                    if (this.active == key) this.active = 0;
                    this.ignored.append (key);
                }
            }
            return result;
        }


        public bool is_ignored_index (int key) {
            bool result = false;
            foreach (var val in this.ignored) {
                if (val == key || (0 > key && key >= menu.get_children ().length ())) {
                    result = true;
                    break;
                }
            }
            return result;
        }

        public bool is_changed {
            get {return (this.orig_index != this.active);}
        }


        private void menuitem_toggled (Gtk.RadioMenuItem item) {
            if (item.active) {
                this.label_widget.set_text (item.get_label ());
                int val = item.get_data ("value");
                value_changed (val);
            }
        }


        private void set_active_label () {
            var text = get_active_label ();
            if (text != null) this.set_label (get_active_label ());
        }


        public string? get_active_label () {
            string? text = null;
            foreach (var item in menu.get_children ()) {
                if (((Gtk.RadioMenuItem) item).active) {
                    text = ((Gtk.RadioMenuItem) item).get_label ();
                    break;
                }
            }
            return text;
        }


        public void append_item (string text) {
            uint last = menu.get_children ().length ();
            Gtk.RadioMenuItem item;

            if (first_widget == null) {
                var group = new GLib.SList<Gtk.RadioMenuItem> ();
                item = new Gtk.RadioMenuItem.with_label (group, _(text));
                first_widget = item;
            } else {
                item = new Gtk.RadioMenuItem.with_label_from_widget (first_widget, _(text));
            }
            
            item.set_data ("value", (int) last);
            item.toggled.connect (() => {menuitem_toggled (item);});
            menu.append (item);
            if (text.length > label_widget.width_chars)
                label_widget.width_chars = text.length;
        }


        public void append_from_valist (string[] list) {
            foreach (var s in list) append_item (s);
        }


        public int get_active_value () {
            int result = -1;
            foreach (var item in menu.get_children ()) {
                if (((Gtk.RadioMenuItem) item).active) {
                    result = item.get_data ("value");
                    break;
                }
            }
            return result;
        }


        public void set_active_value (int value) {
            int num;
            if (this.is_ignored_index (value)) num = 0;
            else num = value;
            last_index = num;

            if (value < menu.get_children ().length () && !this.is_changed) {
                this.orig_index = num;

                foreach (var widget in menu.get_children ()) {
                    int val = widget.get_data ("value");

                    if (val == value) {
                        ((Gtk.RadioMenuItem) widget).active = true;
                        label_widget.set_text (((Gtk.RadioMenuItem) widget).get_label ());
                        break;
                    }
                }
            }
        }


        public void set_visible_item (int val, bool setting) {
            foreach (var item in menu.get_children ()) {
                int value = item.get_data ("value");
                if (value == val) {
                    item.no_show_all = !setting;
                    item.visible = setting;
                    break;
                }
            }
        }
        
        private void menu_state_changed () {
            this.set_active (false);
        }


        private void this_toggled_cb () {
            if (this.get_active ()) {
                menu.show_all ();
                menu.popup (null, null, calculate_menu_position, 3, 0);
            } else {
                menu.popdown ();
            }
        }

        private void calculate_menu_position (Gtk.Menu menu, out int x, out int y, out bool push_in) {
            Utils.get_coords_attached_menu ((Gtk.Widget) this, menu, out x, out y);
            push_in = false;
        }


        public new int active {
            set {
                    set_active_value (value);
                }
            get {
                    return get_active_value ();
                }
        }
    }


//------------------------------------------------------------------------------
}

//------------------------------------------------------------------------------
