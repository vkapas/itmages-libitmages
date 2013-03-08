


//------------------------------------------------------------------------------

namespace Itmages {
//------------------------------------------------------------------------------

    public class UploaderInfoBar: Gtk.InfoBar {

    //    private int last_time;
        private Gtk.Image icon;
        private Gtk.Label label;
        private Gtk.Button btnclose;
        private uint source = -1;

        public UploaderInfoBar () {
            this.set_name ("UploaderInfoBar");
            var contentarea = (Gtk.Box) this.get_content_area ();
            btnclose = new Gtk.Button ();
            var image = new Gtk.Image.from_stock (Gtk.Stock.CLOSE, Gtk.IconSize.MENU);
            btnclose.add (image);
            btnclose.set_relief (Gtk.ReliefStyle.NONE);
            btnclose.set_tooltip_text (_("Close this infobar."));

            label = new Gtk.Label (null);
            label.xalign = 0.0f;
            label.set_ellipsize (Pango.EllipsizeMode.MIDDLE);

            icon = new Gtk.Image ();

            contentarea.pack_start (icon, false, false, 0);
            contentarea.pack_start (label, true, true, 0);
            contentarea.pack_end (btnclose, false, false, 0);
            this.set_no_show_all (true);
            this.set_has_tooltip (true);
            this.response.connect (() => {clear_infobar ();});
            btnclose.clicked.connect (() => {response (Gtk.ResponseType.CLOSE);});
        }

        public void push_message (string messg, string msgtp) {
            string iconname;
            Gtk.MessageType msgtype;

            switch (msgtp) {
                case "e": {
                    msgtype = Gtk.MessageType.ERROR;
                    iconname = Icons.ERROR;
                    break;
                }
                case "w": {
                    msgtype = Gtk.MessageType.WARNING;
                    iconname = Icons.WARNING;
                    break;
                }
                case "i": {
                    msgtype = Gtk.MessageType.INFO;
                    iconname = Icons.INFORMATION;
                    break;
                }
                default: {
                    msgtype = Gtk.MessageType.INFO;
                    iconname = Icons.INFORMATION;
                    break;
                }
            }

            label.set_markup (messg);
            icon.set_from_icon_name (iconname, Gtk.IconSize.MENU);
            this.set_message_type (msgtype);
            this.set_tooltip_markup (messg);

            if (source > 0) GLib.Source.remove (source);
            source = GLib.Timeout.add_seconds (60, (GLib.SourceFunc) clear_infobar);
            no_show_all = false;
            show_all ();
        }

        private bool clear_infobar () {
            no_show_all = true;
            this.hide ();
            label.set_markup ("");
            this.set_tooltip_markup ("");
            source = -1;
            return false;
        }

    } /*--------------- End class UploaderInfoBar ----------------------------*/
//------------------------------------------------------------------------------
}

//------------------------------------------------------------------------------
