


//------------------------------------------------------------------------------

namespace Itmages {
//------------------------------------------------------------------------------
    public class PageResize: Gtk.Frame {
        /*
            resize-custom   bool  
            resize-width    int
            resize-height   int
            resize-percent  int
            resize-aspect   bool
            
        */

        private Gtk.VBox box_custom;
        private Gtk.HBox box_percent;
        private Gtk.CheckButton aspect;
        private Gtk.RadioButton custom;
        private Gtk.RadioButton percent;
        private Gtk.SpinButton spin_width;
        private Gtk.SpinButton spin_height;
        private Gtk.SpinButton spin_percent;

        public PageResize () {
            Gtk.Label label;
            Gtk.VBox mainbox;
            Gtk.Alignment align;
            Gtk.HBox box_size, box;
            Gtk.Adjustment adjwidth, adjheight, adjpercent;

            label = new Gtk.Label (null);
            label.set_markup (_("<b>Resize</b>"));
            this.label_widget = label;
            this.set_shadow_type (Gtk.ShadowType.ETCHED_IN);

            aspect = new Gtk.CheckButton.with_label (_("Constrain proportions"));
            custom = new Gtk.RadioButton (null);
            percent = new Gtk.RadioButton.from_widget (custom);
            adjwidth = new Gtk.Adjustment (1280.0, 100.0, 8000.0, 1.0, 10.0, 0.0);
            adjheight = new Gtk.Adjustment (800.0, 100.0, 8000.0, 1.0, 10.0, 0.0);
            adjpercent = new Gtk.Adjustment (50.0, 0.0, 500.0, 1.0, 10.0, 0.0);
            spin_width = new Gtk.SpinButton (adjwidth, 10.0, 0);
            spin_height = new Gtk.SpinButton (adjheight, 10.0, 0);
            spin_percent = new Gtk.SpinButton (adjpercent, 5.0, 0);
            mainbox = new Gtk.VBox (false, 5);
            box_custom = new Gtk.VBox (false, 5);
            box_size = new Gtk.HBox (false, 4);
            box_percent = new Gtk.HBox (false, 4);

            label = new Gtk.Label (_("Resize to"));
            box_size.pack_start (label, true, false, 0);
            box_size.pack_start (spin_width, false, false, 0);
            label = new Gtk.Label ("x");
            box_size.pack_start (label, false, false, 0);
            box_size.pack_start (spin_height, false, false, 0);
            label = new Gtk.Label ("pix");
            box_size.pack_start (label, false, false, 0);
            box_custom.pack_start (box_size, false, false, 0);
            box_custom.pack_start (aspect, false, false, 0);
            box = new Gtk.HBox (false, 4);
            align = new Gtk.Alignment (0.0f, 0.0f, 0.0f, 0.0f);
            align.add (custom);
            box.pack_start (align, false, false, 0);
            box.pack_start (box_custom, false, false, 0);
            mainbox.pack_start (box, false, false, 0);

            label = new Gtk.Label (_("Resize by"));
            box_percent.pack_start (label, true, false, 0);
            box_percent.pack_start (spin_percent, false, false, 0);
            label = new Gtk.Label ("%");
            box_percent.pack_start (label, false, false, 0);
            box = new Gtk.HBox (false, 4);
            box.pack_start (percent, false, false, 0);
            box.pack_start (box_percent, false, false, 0);
            mainbox.pack_start (box,false, false, 0);

            align = new Gtk.Alignment (0.0f, 0.5f, 0.0f, 0.0f);
            align.set_padding (0, 5, 12, 5);
            align.add (mainbox);
            this.add (align);
            mainbox.show_all ();
            this.border_width = 3;

    //        mainbox.border_width = 5;
            custom.toggled.connect (custom_toggled_cb);
            custom_toggled_cb ();
        }

        private void custom_toggled_cb () {
            box_custom.sensitive = custom.active;
            box_percent.sensitive = !custom.active;
        }


        public int width {
            get {
                    return spin_width.get_value_as_int ();
                }

            set {
                    spin_width.set_value ((double) value);
                }
        }
        

        public int height {
            get {
                    return spin_height.get_value_as_int ();
                }

            set {
                    spin_height.set_value ((double) value);
                }
        }

        public int percentage {
            get {
                    return spin_percent.get_value_as_int ();
                }

            set {
                    spin_percent.set_value ((double) value);
                }
        }

        public bool aspect_ratio {
            get {
                    return this.aspect.active;
                }

            set {
                    this.aspect.active = value;
                }
        }


        public bool custom_size {
            get {
                    return this.custom.active;
                }

            set {
                    this.custom.active = value;
                    this.percent.active = !value;
                }
        }
    }
//------------------------------------------------------------------------------
}

//------------------------------------------------------------------------------
