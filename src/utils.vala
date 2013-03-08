/*
 *      itmages-screenshoter-config.vala
 *      
 *      Copyright 2011 Voldemar Khramtsov <harestomper@gmail.com>
 *      
 *      This program is free software; you can redistribute it and/or modify
 *      it under the terms of the GNU General Public License as published by
 *      the Free Software Foundation; either version 2 of the License, or
 *      (at your option) any later version.
 *      
 *      This program is distributed in the hope that it will be useful,
 *      but WITHOUT ANY WARRANTY; without even the implied warranty of
 *      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *      GNU General Public License for more details.
 *      
 *      You should have received a copy of the GNU General Public License
 *      along with this program; if not, write to the Free Software
 *      Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 *      MA 02110-1301, USA.
 */


// The formal changes to start build


//------------------------------------------------------------------------------
namespace Itmages {

    private const int PWIDTH = 120;
    private const int PHEIGHT = 75;

    public const uint URI_LIST = 83;
    public const uint IMAGE_PNG = 80;
    public const uint IMAGE_JPG = 81;
    public const uint IMAGE_GIF = 82;
    public const string F_GIF = "image/gif";
    public const string F_PNG = "image/png";
    public const string F_JPEG = "image/jpeg";

    /* Keys for dconf */
    public const string VERBOSE = "verbose"; //bool
    public const string FIRSTSTART = "first-start"; //bool
    public const string USER_DATA = "userdata"; //string
    public const string SAVE_USERDATA = "save-data"; //bool
    public const string WITHOUT_PROFILE = "without-profile"; //bool
    public const string PROXYAUTH = "proxydata"; //string
    public const string PROXYNODE = "proxynode"; //string
    public const string PROXYPORT = "proxyport"; //int
    public const string PROXYTYPE = "proxytype"; //int
    public const string UPLDR_LAST_FOLDER = "uploader-last-folder"; //string
    public const string UPLDR_LAST_TYPE = "uploader-last-linktype"; //int
    public const string UPLDR_WIN_HEIGHT = "uploader-window-height"; //int
    public const string UPLDR_SELECT_ALL = "uploader-select-all"; // bool
    public const string UPLDR_HIDE_DELAY = "uploader-infobar-hide-delay"; //int
    public const string UPLDR_AUTOSTART = "uploader-autostart-upload"; //bool

        /* Resize and rotate actions */
    public const string RESIZE_WIDTH = "resize-width"; //int
    public const string RESIZE_HEIGHT = "resize-height"; //int
    public const string RESIZE_PERCENT = "resize-percent"; //int
    public const string RESIZE_CUSTOM = "resize-cudtom"; //bool
    public const string RESIZE_ASPECT = "resize-aspect"; //bool
    public const string ROTATE_ANGLE = "rotate-angle"; //int
    public const string SHOW_IMAGING_DLG = "imaging-dialog-show"; //bool
    public const string MODIF_FOLDER = "imaging-modif-folder"; //string
    public const string IMAGING_ADD = "add-after-modification"; //bool
    public const string IMAGING_OVERWRITE = "imaging-overwrite-file"; //bool
    //------------------------- Keys for dconf ---------------------------------
    
    public const string ITMAGES_DBUS_PATH = "/org/freedesktop/ITmagesEngine";
    public const string ITMAGES_DBUS_IFACE = "org.freedesktop.ITmagesEngine";

    public const string UPLOADER_DBUS_PATH = "/org/freedesktop/ITmages/Uploader";
    public const string UPLOADER_DBUS_IFACE = "org.freedesktop.ITmages.Uploader";


//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
    public class Const {
        public static const string MARKUP_INFO = "<b>Size:</b> %s, <b>Res.:</b> %dx%dpix";
        public static const string MARKUP_NAME = "<b>Name:</b> %s";
        public static const string MARKUP_STATUS = "<b>Status: </b>%s";

        public static const string STATUS_WAIT = "wait";
        public static const string STATUS_RUN = "run";
        public static const string STATUS_DONE = "done";
        public static const string STATUS_FAIL = "fail";

        public static const string LABEL_WAIT = "In Queue.";
        public static const string LABEL_FAIL = "Upload failed!";
        public static const string LABEL_DONE = "Upload is successful!";
        public static const string LABEL_CNCL = "Upload is cancelled!";
        
        public static const string[] COMBO_ITEMS = {
                                                    "Link to full size image",
                                                    "Link to preview",
                                                    "Page with all links",
                                                    "HTML preview for forum", 
                                                    "HTML full size image",
                                                    "BB preview for forum",
                                                    "BB full size image",
                                                    "Short link"
                                                };
        public static const string GTKRC_STYLE = """
                                    style "buttons"
                                    {
                                        GtkButtonBox::child-min-width = 1
                                        GtkButtonBox::child-min-height = 1
                                        GtkButtonBox::child-internal-pad-y = 0
                                        GtkButtonBox::child-internal-pad-x = 0
                                        GtkButtonBox::border-width = 0
                                    }
                                    widget "*.ControlButtonBox"
                                    style "buttons"

                                    style "uploaderinfo"
                                    {
                                        GtkInfoBar::content-area-border = 0
                                        GtkInfoBar::action-area-border = 0
                                        GtkInfoBar::button-spacing = 0
                                    }
                                    widget "*.UploaderInfoBar"
                                    style "uploaderinfo"

                                    style "itembox"
                                    {
                                        GtkToolBar::space-size = 2
                                        GtkToolBar::internal-padding = 0
                                        GtkToolBar::max-child-expand = 0
                                        GtkToolBar::button-relie = GTK_RELIEF_HALF
                                        GtkToolBar::shadow-type = GTK_SHADOW_ETCHED_OUT
                                        GtkToolBar::space-style = GTK_TOOLBAR_SPACE_LINE
                                    }

                                    widget "*.PictureItemsBox"
                                    style "itembox"
                                    
                                    style "combo"
                                    {
                                        GtkComboBox::relief = GTK_RELIEF_NONE
                                    }
                                    class "GtkComboBox"
                                    style "combo"
                                    """;

    }
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
    public class Icons {
        public static const string ADD = "itmages-add";
        public static const string QUIT = "itmages-quit";
        public static const string STOP = "itmages-stop";
        public static const string CANCEL = "itmages-cancel";
        public static const string UPLOAD = "itmages-upload";
        public static const string REMOVE = "itmages-remove";
        public static const string COPY = "itmages-copy-link";
        public static const string SETTINGS = "itmages-settings";
        public static const string BROWSER = "itmages-open-browser";
        public static const string SELECT_ALL = "itmages-select-all";
        public static const string ROTATE = "itmages-rotate";
        public static const string RESIZE = "itmages-resize";
        public static const string UTILS = "itmages-utils";
        public static const string TOOLS = "itmages-tools";
        public static const string ERROR = "itmages-error";
        public static const string WARNING = "itmages-warning";
        public static const string QUESTION = "itmages-question";
        public static const string INFORMATION = "itmages-information";
        public static const Gtk.IconSize SIZE = Gtk.IconSize.BUTTON;
    }
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
    public class Utils {

        public static void init_widget (Gtk.Widget widget, ...) {
            bool wait = false;
            bool fail = false;
            bool run = false;
            bool done = false;
            string? val = null;
            var args = va_list ();
            do {
                val = args.arg ();
                if (val == null) break;

                switch (val) {
                    case Const.STATUS_WAIT: {
                        wait = true;
                        break;
                    }
                    case Const.STATUS_FAIL: {
                        fail = true;
                        break;
                    }
                    case Const.STATUS_RUN: {
                        run = true;
                        break;
                    }
                    case Const.STATUS_DONE: {
                        done = true;
                        break;
                    }
                    default: break;
                }
            } while (val != null);
            
            widget.set_data ("wait",  wait);
            widget.set_data ("done",  done);
            widget.set_data ("fail", fail);
            widget.set_data ("run",  run);
            widget.can_focus = false;
        }

        public static bool create_pixbuf (string fname, out Gdk.Pixbuf pixbuf, out int width, out int height) {
            int x, y;
            float k, src_w, src_h, dest_w, dest_h, tmp_w, tmp_h, res;
            Gdk.Pixbuf tmppix;
            try {
                tmppix = new Gdk.Pixbuf.from_file (fname);

                width = tmppix.width;
                height = tmppix.height;
                src_w = (float) tmppix.width;
                src_h = (float) tmppix.height;
                dest_w = tmp_w = (float) PWIDTH;
                dest_h = tmp_h = (float) PHEIGHT;
                res = 0.0f;

                k = src_h / src_w;
                tmp_w = (src_w > src_h)? dest_h/k: tmp_w;
                tmp_h = (src_w <= src_h)? dest_w*k: tmp_h;
                res = (tmp_h < dest_h)? res+(dest_h-tmp_h): res;
                res = (tmp_w < dest_w)? res+(dest_w-tmp_w): res;
                tmp_w += res;
                tmp_h = tmp_w*k;

                x = (int) ((tmp_w - dest_w)/2.0f);
                y = (int) ((tmp_h - dest_h)/2.0f);

                tmppix = tmppix.scale_simple ((int) tmp_w, (int) tmp_h, Gdk.InterpType.BILINEAR);
                pixbuf = new Gdk.Pixbuf.subpixbuf (tmppix, x, y, PWIDTH, PHEIGHT);
                return true;
                
            } catch (GLib.Error err) {
                message ("Failed to load file '%s'", fname);
                return false;
            }
        }

        public static string convert_fsize_to_string (float filesize) {
            string strfsize = filesize.to_string (_("%.2fB"));
            foreach (string s in new string[] {_("B"), _("KB"), _("MB")}) {

                if (filesize > 1024.0f) {
                    filesize = filesize / 1024.0f;
                } else {
                    strfsize = filesize.to_string ("%.2f" + s);
                    break;
                }
            }
            return strfsize;
        }
        

        public static void get_coords_attached_menu (Gtk.Widget widget, Gtk.Menu menu, out int x, out int y) {
            int monitor_num;
            Gdk.Screen screen;
            Gdk.Rectangle monitor;
            Gtk.TextDirection direction;
            Gtk.Requisition menu_req = {};
            Gdk.Window window = widget.get_window ();
            Gtk.Allocation allocation;

            widget.get_allocation (out allocation);
            menu.map ();

            menu_req = menu.get_requisition ();
            direction = widget.get_direction ();
            screen = widget.get_screen ();
            monitor_num = screen.get_monitor_at_window (window);
            if (monitor_num < 0) monitor_num = 0;
            screen.get_monitor_geometry (monitor_num, out monitor);

            window.get_origin (out x, out y);
            x += allocation.x;
            y += allocation.y;

            if (direction == Gtk.TextDirection.LTR) {
                x += int.max (allocation.width - menu_req.width, 0);
            } else if (menu_req.width > allocation.width) {
                x -= menu_req.width - allocation.width;
            }

            if ((y + allocation.height + menu_req.height) <= monitor.y + monitor.height) {
                y += allocation.height;
            } else if ((y - menu_req.height) >= monitor.y) {
                y -= menu_req.height;
            } else if (monitor.y + monitor.height - (y + allocation.height) > y) {
                y += allocation.height;
            } else {
                y -= menu_req.height;
            }
        }


        public static bool is_writable (string fname) {
            bool res = false;
            res = (Posix.access (fname, Posix.W_OK) == 0);
            return res;
        }


        public static Gdk.Pixbuf? get_default_icon (string? iconname = null) {
            var icon_theme = Gtk.IconTheme.get_default ();
            if (iconname == null)
                iconname = GLib.Environment.get_prgname ();
            try {
                return icon_theme.load_icon (iconname, 48, Gtk.IconLookupFlags.USE_BUILTIN);
            } catch (GLib.Error err) {
                return null;
            } 
        }

    }
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
    public class b64 : GLib.Object {

        public static string? encode (string value) {
            return Base64.encode ((uchar[]) value.to_utf8 ());
        }

        public static string? decode (string value) {
            string ret = (string) Base64.decode (value);
            return ret;
        }
    }
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------

    private struct ItProxyTypeItem {
        string desc;
        int index;
        int curl_code;
    //    int soup_code;
    //    int gnet_code;
    }
//------------------------------------------------------------------------------

}
