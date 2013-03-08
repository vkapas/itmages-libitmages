


//------------------------------------------------------------------------------

namespace Itmages {
//------------------------------------------------------------------------------
    public class PageCommon : Gtk.Frame {

        private Gtk.Entry foldername;
        private Gtk.VBox savenew_vbox;
        private Gtk.ToggleButton openfc;
        private Gtk.CheckButton add2list;
        private Gtk.RadioButton overwrite_;

        public PageCommon () {
            Gtk.Label label;
            Gtk.VBox mainbox;
            Gtk.Alignment align;
            Gtk.Image image_openfc;
            Gtk.RadioButton savenew;
            Gtk.HBox folderentry_box, savenew_hbox;

            label = new Gtk.Label (null);
            label.set_markup (_("<b>Common</b>"));
            this.set_border_width (3);
            this.set_label_widget (label);
            this.set_shadow_type (Gtk.ShadowType.ETCHED_IN);

            mainbox = new Gtk.VBox (false, 4);
            savenew_vbox = new Gtk.VBox (false, 3);
            savenew_hbox = new Gtk.HBox (false, 3);
            folderentry_box = new Gtk.HBox (false, 4);
            openfc = new Gtk.ToggleButton ();
            foldername = new Gtk.Entry ();
            savenew = new Gtk.RadioButton (null);
            overwrite_ = new Gtk.RadioButton.with_label_from_widget (savenew, _("Overwrite original file"));
            add2list = new Gtk.CheckButton.with_label (_("Add to upload list"));
            image_openfc = new Gtk.Image.from_icon_name ("itmages-folder", Gtk.IconSize.MENU);
            
            openfc.add (image_openfc);

            align = new Gtk.Alignment (0.0f, 0.0f, 0.0f, 0.0f);
            savenew_hbox.pack_start (align, false, false, 0);
            align.add (savenew);

            align = new Gtk.Alignment (0.0f, 0.0f, 1.0f, 0.0f);
            savenew_hbox.pack_start (align, false, false, 0);
            align.add (savenew_vbox);

            align = new Gtk.Alignment (0.0f, 0.0f, 1.0f, 0.0f);
            align.add (folderentry_box);
            savenew_vbox.pack_start (align, false, false, 0);
            
            align = new Gtk.Alignment (0.0f, 0.0f, 0.0f, 0.0f);
            align.add (add2list);
            savenew_vbox.pack_start (align, false, false, 0);

            label = new Gtk.Label (_("Save to:"));
            align = new Gtk.Alignment (0.0f, 0.5f, 0.0f, 1.0f);
            align.set_padding (0, 0, 0, 3);
            align.add (label);
            folderentry_box.pack_start (align, false, false, 0);
            folderentry_box.pack_start (foldername, true, true, 0);
            folderentry_box.pack_end (openfc, false, false, 0);

            align = new Gtk.Alignment (0.0f, 0.0f, 1.0f, 0.0f);
            align.set_padding (0, 0, 2, 0);
            align.add (overwrite_);

            mainbox.pack_start (savenew_hbox, false, false, 0);
            mainbox.pack_start (align, false, false, 0);

            align = new Gtk.Alignment (0.0f, 0.0f, 1.0f, 0.0f);
            align.set_padding (0, 5, 12, 5);
            align.add (mainbox);
            this.add (align);

            openfc.toggled.connect (openfc_toggled_cb);
            savenew.toggled.connect (savenew_toggled_cb);
            string path_ = this.normpath ("");
            foldername.set_text (path_);
            foldername.set_tooltip_text (path_);
        }


        private void savenew_toggled_cb () {
            this.savenew_vbox.set_sensitive (!this.overwrite_.active);
        }

        private void openfc_toggled_cb () {
            if (openfc.active) {
                var fc = new Gtk.FileChooserDialog (_("Select folder to save"), (Gtk.Window?)this.get_toplevel (), Gtk.FileChooserAction.SELECT_FOLDER);
                fc.add_buttons (Gtk.Stock.CANCEL, Gtk.ResponseType.CANCEL, Gtk.Stock.OK, Gtk.ResponseType.OK);
                fc.current_folder_changed.connect (() => {sensitive_func (fc);});
                fc.selection_changed.connect (() => {sensitive_func (fc);});
                fc.set_response_sensitive (Gtk.ResponseType.OK, false);
                fc.show_all ();
                fc.set_current_folder (this.get_current_dir ());
                var resp = fc.run ();
                openfc.active = false;
                if (resp == Gtk.ResponseType.OK) {
                    this.set_current_dir (this.current_path_ (fc));
                }
                fc.hide ();
                fc.destroy ();
            }
        }


        private string current_path_ (Gtk.FileChooserDialog fc) {
            string fname = fc.get_filename ();
            if (fname == null)
                fname = fc.get_current_folder ();
            return fname;
        }
        

        private void sensitive_func (Gtk.FileChooserDialog fc) {
            var fname = this.current_path_ (fc);
            fc.set_response_sensitive (Gtk.ResponseType.OK, Itmages.Utils.is_writable (fname));
        }


        public bool add_to_list {
            get { return add2list.active;}
            set {add2list.active = value;}
        }


        private static string normpath (string path_) {
            unowned string res;
            if (path_.length < 2 || !Itmages.Utils.is_writable (path_)) {
                res = GLib.Environment.get_user_special_dir (GLib.UserDirectory.PICTURES);
            } else {
                res = path_;
            }
            return res;
        }


        public string get_current_dir () {

            string path_ = this.foldername.get_text ();
            path_ = this.normpath (path_);
            if (!GLib.FileUtils.test (path_, GLib.FileTest.IS_DIR)) {
                path_ = GLib.Path.get_dirname (path_);
            }
            return "%s".printf (path_);
        }


        public void set_current_dir (string value) {
            string path_ = value;
            path_ = this.normpath (path_);
            foldername.set_text (path_);
            foldername.set_tooltip_text (path_);
        }


        public bool overwrite_files {
            set { overwrite_.active = value;}
            get {return overwrite_.active;}
        }
    }
//------------------------------------------------------------------------------
}


//------------------------------------------------------------------------------
