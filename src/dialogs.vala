


//------------------------------------------------------------------------------

namespace Itmages {
//------------------------------------------------------------------------------
    public class ItmagesNetworkDialog : Gtk.Dialog {

        private ItmagesPageLogin pagelogin;
        private ItmagesPageProxy pageproxy;
        private Config config = Config.get_default ();

        public ItmagesNetworkDialog (Gtk.Window? parent, int page = 0) {

            
            set_title (_("Network"));
            set_transient_for (parent);
            add_button (Gtk.Stock.CLOSE, Gtk.ResponseType.OK);
/*
            add_buttons(Gtk.Stock.CANCEL,
                              Gtk.ResponseType.CANCEL,
                              Gtk.Stock.OK,
                              Gtk.ResponseType.OK);
*/
            
            pagelogin = new ItmagesPageLogin (config);
            pageproxy = new ItmagesPageProxy (config);
            var notebook = new Gtk.Notebook ();
            var label = new Gtk.Label (_("Account"));
            notebook.append_page (pagelogin, label);
            label = new Gtk.Label (_("Proxy"));
            notebook.append_page (pageproxy, label);
            var align = new Gtk.Alignment (0.5f, 0.5f, 1.0f, 1.0f);
            align.set_padding (5, 5, 5, 5);
            align.add (notebook);
            var vbox = (Gtk.Box) get_content_area ();
            vbox.pack_start(align, true, true, 0);
            vbox.show_all ();
            set_resizable (false);
            notebook.map ();
            notebook.show_all ();
            notebook.page = page;
        }
    }

//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
    public class PictureChooser : Gtk.FileChooserDialog {

        private Gtk.Image preview;

        public PictureChooser (Gtk.Window parent) {
            this.add_buttons (
                                Gtk.Stock.CANCEL,
                                Gtk.ResponseType.CANCEL,
                                Gtk.Stock.OK,
                                Gtk.ResponseType.OK
                              );
            transient_for = parent;
            select_multiple = true;
            action = Gtk.FileChooserAction.OPEN;
            preview = new Gtk.Image ();
            set_preview_widget (preview);
            
            var filefilter = new Gtk.FileFilter ();
            filefilter.add_pixbuf_formats ();
            set_filter (filefilter);
            update_preview.connect (update_preview_cb);
        }


        private void update_preview_cb () {
            bool have_preview;
            var filename = get_preview_filename ();
            if (filename == null) return;
            
            try {
                var pixbuf = new Gdk.Pixbuf.from_file_at_size(filename, 128, 128);
                preview.set_from_pixbuf (pixbuf);
                have_preview = true;
            } catch (GLib.Error err) {
                have_preview = false;
            }
            set_preview_widget_active (have_preview);
        }


        public bool start (ref string startdir, out string[] selectedfiles) {
            set_current_folder (startdir);
            if (this.run () == Gtk.ResponseType.OK) {
                startdir = get_current_folder ();
                GLib.SList<string> fnames = get_filenames ();
                if (fnames.length () > 0) {
                    selectedfiles = new string[fnames.length ()];
                    for (uint i = 0; i < fnames.length (); i++) {
                        unowned string fn = fnames.nth_data (i);
                        selectedfiles[i] = fn;
                    }
                    return (selectedfiles.length > 0);
                } else {
                    return false;
                }
            } else {
                return false;
            }
        }
        
    }
//------------------------------------------------------------------------------
}

//------------------------------------------------------------------------------
