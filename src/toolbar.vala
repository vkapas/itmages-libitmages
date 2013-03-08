//------------------------------------------------------------------------------


namespace Itmages {
//------------------------------------------------------------------------------
    public class UploaderToolbar: Gtk.Toolbar {

        public signal void exit_activated ();
        public signal void add_activated ();
        public signal void stop_activated ();
        public signal void remove_activated ();
        public signal void config_activated ();
        public signal void upload_activated ();

        public signal void radio_toggled (int index);
        public signal void check_toggled (bool active);
        public signal void copy_activated (int index);
        public signal void resize_activated ();
        public signal void rotate_activated ();
        public signal void imaging_activated ();
        public signal void autostart_toggled (bool new_active);

        public int radio_active {set; get;}
        private GLib.SList <Gtk.RadioMenuItem> group;
        
        public Gtk.Menu addition_menu;
        private Gtk.MenuToolButton btncopy;
        private Gtk.ToggleToolButton btncheck;
        private Gtk.ToggleToolButton btntools;
        private Gtk.CheckMenuItem itemautostart;
        
        public UploaderToolbar (int active_type) {
            Gtk.Menu menu;
            Gtk.SeparatorToolItem separator;
            Gtk.ToolButton btnupload, btnquiting, btnstop, btnadd, btnremove;
            Gtk.Image imageupload, imagecopy, imagestop, imagequiting, imagetools, imageconf, imageadd, imageremove, imageselect, imageresize, imagerotate, imageimaging;
            Gtk.ImageMenuItem itemconfig, itemresize, itemrotate, itemimaging;
            group = new GLib.SList <Gtk.RadioMenuItem> ();
            
//            tooltips = true;
            show_arrow = false;
            icon_size_set = true;
            set_icon_size (Gtk.IconSize.SMALL_TOOLBAR);
            toolbar_style = Gtk.ToolbarStyle.ICONS;
            radio_active = active_type;

            imageadd = new Gtk.Image.from_icon_name (Icons.ADD, Icons.SIZE);
            imagestop = new Gtk.Image.from_icon_name (Icons.STOP, Icons.SIZE);
            imagecopy = new Gtk.Image.from_icon_name (Icons.COPY, Icons.SIZE);
            imageremove = new Gtk.Image.from_icon_name (Icons.REMOVE, Icons.SIZE);
            imagequiting = new Gtk.Image.from_icon_name (Icons.QUIT, Icons.SIZE);
            imageupload = new Gtk.Image.from_icon_name (Icons.UPLOAD, Icons.SIZE);
            imageconf = new Gtk.Image.from_icon_name (Icons.SETTINGS, Icons.SIZE);
            imagetools = new Gtk.Image.from_icon_name (Icons.TOOLS, Icons.SIZE);
            imageresize = new Gtk.Image.from_icon_name (Icons.RESIZE, Icons.SIZE);
            imagerotate = new Gtk.Image.from_icon_name (Icons.ROTATE, Icons.SIZE);
            imageselect = new Gtk.Image.from_icon_name (Icons.SELECT_ALL, Icons.SIZE);
            imageimaging = new Gtk.Image.from_icon_name (Icons.UTILS, Icons.SIZE);

            menu = new Gtk.Menu ();
            btncheck = new Gtk.ToggleToolButton ();
            btntools = new Gtk.ToggleToolButton ();
            separator = new Gtk.SeparatorToolItem ();
            btnadd = new Gtk.ToolButton (imageadd, null);
            btnstop = new Gtk.ToolButton (imagestop, null);
            btnupload = new Gtk.ToolButton (imageupload, null);
            btncopy = new Gtk.MenuToolButton (imagecopy, null);
            btnremove = new Gtk.ToolButton (imageremove, null);
            btnquiting = new Gtk.ToolButton (imagequiting, null);
            btncheck.set_icon_widget (imageselect);
            btntools.set_icon_widget (imagetools);

            addition_menu = new Gtk.Menu ();
            itemresize = new Gtk.ImageMenuItem.with_label (_("Resize images"));
            itemrotate = new Gtk.ImageMenuItem.with_label (_("Rotate images"));
            itemimaging = new Gtk.ImageMenuItem.with_label (_("Utils"));
            itemconfig = new Gtk.ImageMenuItem.from_stock (Gtk.Stock.PREFERENCES, null);
            itemautostart = new Gtk.CheckMenuItem.with_label (_("Autostart"));

            itemresize.set_image (imageresize);
            itemrotate.set_image (imagerotate);
            itemconfig.set_image (imageconf);
            itemimaging.set_image (imageimaging);

            addition_menu.append (itemautostart);
            addition_menu.append (itemresize);
            addition_menu.append (itemrotate);
            addition_menu.append (itemimaging);
            addition_menu.append (itemconfig);

            btnadd.set_homogeneous (false);
            btnstop.set_homogeneous (false);
            btncopy.set_homogeneous (false);
            btncheck.set_homogeneous (false);
            btnupload.set_homogeneous (false);
            btnremove.set_homogeneous (false);
            btnquiting.set_homogeneous (false);

            separator.set_draw (false);
            separator.set_expand (true);

            itemconfig.tooltip_text  = _("Open settings dialog.");
            btncheck.tooltip_text = _("Select/Unselect all items of list.");
            btnremove.tooltip_text = _("Remove all selected items from list.");
            btnquiting.tooltip_text = _("Close this window and exit from this program.");
            btnadd.tooltip_text = _("Open dialog for choose and add new files to current list.");
            btnupload.tooltip_text = _("Start action 'Upload' for all files from current list.");
            btnstop.tooltip_text = _("Cancel action 'upload' for selected or all files of this list.");

            for (int i = 0; i < Const.COMBO_ITEMS.length; i++) {
                Gtk.RadioMenuItem menuitem;
                menuitem = new Gtk.RadioMenuItem.with_label (group, _(Const.COMBO_ITEMS[i]));
                menuitem.activate.connect (radio_item_toggled_cb);
                menu.append (menuitem);
                group.append (menuitem);
                if (active_type == i) {
                    menuitem.active = true;
                    btncopy.set_has_tooltip (true);
                    btncopy.tooltip_text = _("Copy '%s' to clipboard").printf (menuitem.label);
                } else {
                    menuitem.active = false;
                }
            }

            menu.show_all ();
            btncopy.set_menu (menu);
            btnupload.clicked.connect (() => {upload_activated ();});
            btnquiting.clicked.connect (() => {exit_activated ();});
            btnstop.clicked.connect (() => {stop_activated ();});
            itemconfig.activate.connect (() => {config_activated ();});
            btnadd.clicked.connect (() => {add_activated ();});
            btnremove.clicked.connect (() => {remove_activated ();});
            btncheck.toggled.connect (() => {check_toggled (btncheck.get_active());});
            btncopy.clicked.connect (() => {copy_activated (radio_active);});

            btntools.toggled.connect (btntools_toggled_cb);
            itemrotate.activate.connect (() => {rotate_activated ();});
            itemresize.activate.connect (() => {resize_activated ();});
            itemimaging.activate.connect (() => {imaging_activated ();});
            addition_menu.cancel.connect (() => {btntools.active = false;});
            addition_menu.selection_done.connect (() => {btntools.active = false;});
            itemautostart.toggled.connect_after (item_autostart_toggled_cb);
            addition_menu.show_all ();

            this.add (btnupload);
            this.add (btnstop);
            this.add (btnadd);
            this.add (btnremove);
            this.add (btncopy);
            this.add (btncheck);
            this.add (btntools);
            this.add (separator);
            this.add (btnquiting);
        }

        private void radio_item_toggled_cb () {
            int cnt = 0;
            foreach (var menuitem in group) {
                if (menuitem.get_active ()) {
                    this.radio_active = cnt;
                    this.radio_toggled (cnt);
                    this.btncopy.tooltip_text = _("Copy '%s' to clipboard").printf (menuitem.label);
                    break;
                }
                cnt++;
            }
        }


        private void btntools_toggled_cb () {
            if (btntools.active) {
                addition_menu.popup (null, null,  this.calculate_position, 3, 0);
            } else {
                addition_menu.popdown ();
            }
        }


        private void calculate_position (Gtk.Menu menu, out int x, out int y, out bool push_in) {
            Utils.get_coords_attached_menu ((Gtk.Widget) btntools, menu, out x, out y);
            push_in = false;
        }
 

        public bool select_all {
            get {return btncheck.get_active ();}
            set {btncheck.set_active (value);}
        }

        public bool autostart {
            set {itemautostart.active = value;}
            get {return itemautostart.active;}
        }

        private void item_autostart_toggled_cb () {
            autostart_toggled (itemautostart.active);
        }
    } /*-------------- End Class UploaderToolbar -----------------------------*/

//------------------------------------------------------------------------------
}


//------------------------------------------------------------------------------
