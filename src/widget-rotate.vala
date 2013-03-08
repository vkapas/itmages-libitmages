




//------------------------------------------------------------------------------

namespace Itmages {
//------------------------------------------------------------------------------
    public class PageRotate: Gtk.Frame {

        private Itmages.RadioButtonMenu degrees;
        
        public PageRotate () {
            Gtk.Label label;
            Gtk.HBox mainbox;
            Gtk.Alignment align;


            degrees = new RadioButtonMenu ();
            mainbox = new Gtk.HBox (false, 4);
            align = new Gtk.Alignment (0.0f, 0.5f, 0.0f, 0.0f);
            align.set_padding (0, 5, 20, 5);

            degrees.append_item ("90");
            degrees.append_item ("180");
            degrees.append_item ("270");
            degrees.set_active_value (0);
            
            label = new Gtk.Label (_("Rotate by"));
            label.xalign = 0.0f;
            mainbox.pack_start (label, true, false, 4);
            mainbox.pack_start (degrees, false, false, 0);

            label = new Gtk.Label (null);
            label.set_markup (_("<b>Rotate</b>"));
            this.label_widget = label;

            align.add (mainbox);
            this.add (align);
            this.border_width = 3;

        }


        public int angle {
            set {
                    int val = value;
                    if (value >= 270) {
                        val = 2;
                    } else if (value >= 180) {
                        val = 1;
                    } else if (value >= 90) {
                        val = 0;
                    } else if (value < 3) {
                        val = value;
                    } else {
                        val = 0;
                    }
                    degrees.set_active_value (val);
                }
            get {
                    int ang, ac;
                    ac = degrees.get_active_value ();
                    if (ac == 0) ang = 90;
                    else if (ac == 1) ang = 180;
                    else if (ac == 2) ang = 270;
                    else ang = 0;
                    return ang;
                }
        }

    }
//------------------------------------------------------------------------------
}

//------------------------------------------------------------------------------
