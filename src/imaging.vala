


//------------------------------------------------------------------------------


namespace Itmages {
//------------------------------------------------------------------------------
    public class ImagingDialog: Gtk.Dialog {

        private Config client;
        private Gtk.CheckButton showdialog;
        private PageResize wresize;
        private PageRotate wrotate;
        private PageCommon wcommon;
        public static const int BOTH = 0;
        public static const int RESIZE = 1;
        public static const int ROTATE = 2;

        public ImagingDialog (Gtk.Window? parent, int mode) {

            client = Config.get_default ();
            this.set_transient_for (parent);
            this.set_title (_("Imaging"));
            var content_area = (Gtk.Box) this.get_content_area ();
            var action_area = (Gtk.ButtonBox) this.get_action_area ();

            wresize = new PageResize ();
            wrotate = new PageRotate ();
            wcommon = new PageCommon ();
            showdialog = new Gtk.CheckButton.with_label (_("Show this dialog"));
            var align = new Gtk.Alignment (0.0f, 0.0f, 0.0f, 0.0f);

            align.add (showdialog);
            align.set_padding (2, 2, 5, 2);

            content_area.pack_start (wresize, false, false, 0);
            content_area.pack_start (wrotate, false, false, 0);
            content_area.pack_start (wcommon, false, false, 0);
            content_area.pack_end (align, false, false, 0);
            content_area.show_all ();

            this.add_buttons (Gtk.Stock.CANCEL, Gtk.ResponseType.CANCEL, Gtk.Stock.OK, Gtk.ResponseType.OK);
            action_area.show_all ();

            if (mode == ROTATE) {
                wresize.set_no_show_all (true);
                wresize.set_visible (false);
            } else if (mode == RESIZE) {
                wrotate.set_no_show_all (true);
                wrotate.set_visible (false);
            } else {
                wrotate.set_no_show_all (false);
                wresize.set_no_show_all (false);
            }

            wresize.aspect_ratio = client.resize_aspect;
            wresize.custom_size = client.resize_custom;
            wresize.percentage = client.resize_percent;
            wresize.height = client.resize_height;
            wresize.width = client.resize_width;
            wrotate.angle = client.rotate_angle;
            wcommon.overwrite_files = client.overwrite_modified;
            wcommon.add_to_list = client.add_modified;
            wcommon.set_current_dir (client.imaging_folder);
            showdialog.active = client.imaging_dialog_show;
            this.response.connect (this.response_cb);
        }


        private void response_cb (int response_id) {
            if (response_id == Gtk.ResponseType.OK) {
                client.imaging_folder = wcommon.get_current_dir ();
                client.overwrite_modified = wcommon.overwrite_files;
                client.resize_aspect = wresize.aspect_ratio;
                client.resize_custom = wresize.custom_size;
                client.resize_percent = wresize.percentage;
                client.resize_height = wresize.height;
                client.resize_width = wresize.width;
                client.rotate_angle = wrotate.angle;
                client.add_modified = wcommon.add_to_list;
                client.imaging_dialog_show = showdialog.active;
            }
        }
    }
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
    public class ImageLoader : GLib.Object {

//        private Gtk.Widget? parent = null;
        public Gdk.Pixbuf pixbuf;
        private bool is_loaded = false;

        public bool rotate = false;
        public bool resize = false;
        private int percentage = -1;
        private int out_width = -1;
        private int out_height = -1;
        private bool aspect_ratio = true;
        private bool overwrite_original = false;
        private string? save_folder = "/tmp";
        private string? extension = null;
        public string filename {get; private set;}
        public string destname {get; private set;}
        private Gdk.PixbufRotation rotate_angle = Gdk.PixbufRotation.NONE;
        private GExiv2.Orientation orientation = GExiv2.Orientation.NORMAL;

        public ImageLoader () {
        }

        public bool set_attributes (string fname, ...) {
            filename = fname;

            /*
                Parse input arguments
            */
            var inlst = va_list ();
            while (true) {
                string? key = inlst.arg ();
                if (key == null) break;
                if (key == "resize") resize = inlst.arg ();
                else if (key == "rotate") rotate = inlst.arg ();
                else if (key == "width" || key == "w") out_width = inlst.arg ();
                else if (key == "height" || key == "h") out_height = inlst.arg ();
                else if (key == "percentage" || key == "percent") percentage = inlst.arg ();
                else if (key == "overwrite" || key == "replace") overwrite_original = inlst.arg ();
                else if (key == "folder" || key == "dir" || key == "save_folder") save_folder = inlst.arg ();
                else if (key == "aspect_ratio" || key == "aspect" || key == "ratio") aspect_ratio = inlst.arg ();
                else if (key == "angle") {
                    int ang = inlst.arg ();
                    if (ang == 2 || ang >= 270) {
                        orientation = GExiv2.Orientation.ROT_270;
                        rotate_angle = Gdk.PixbufRotation.CLOCKWISE;
                    } else if (ang == 1 || ang >= 180) {
                        rotate_angle = Gdk.PixbufRotation.UPSIDEDOWN;
                        orientation = GExiv2.Orientation.ROT_180;
                    } else if (ang == 0 || ang >= 90) {
                        rotate_angle = Gdk.PixbufRotation.COUNTERCLOCKWISE;
                        orientation = GExiv2.Orientation.ROT_90;
                    } else {
                        rotate_angle = Gdk.PixbufRotation.NONE;
                        orientation = GExiv2.Orientation.NORMAL;
                    }
                }
            }
            destname = "";
            string mime = "";
            bool res = false;
            GLib.File giofile;
            GLib.FileInfo file_info;

            giofile = GLib.File.new_for_commandline_arg (fname);

            try {
                file_info = giofile.query_info ("standard::content-type", 0, null);
                mime = file_info.get_content_type ();
                res = (mime == "image/jpeg" || mime == "image/png" || mime == "image/gif");
            } catch (GLib.Error err) {
                debug (err.message);
            }

            if (res) {

                if (mime == "image/jpeg") extension = "jpeg";
                else if (mime == "image/gif") extension = "gif";
                else extension = "png";

                if (rotate && rotate_angle == Gdk.PixbufRotation.NONE) rotate = false;
                if (resize && !((out_width > 0 && out_height > 0) || percentage > 0)) {
                } else {
                    is_loaded = true;
                }
            }
            return is_loaded;
        }


        public bool start () {
            if (is_loaded) {
                return perform_changes ();
            }
            return false;
        }
        

        public bool perform_changes () {
            bool ok = false;
            string srcfname = this.filename;
            if (srcfname == null) return false;
            try {
                pixbuf = new Gdk.Pixbuf.from_file (srcfname);
            } catch (GLib.Error pixbuf_err) {
                debug (pixbuf_err.message);
                return false;
            }

            if (rotate && rotate_angle != Gdk.PixbufRotation.NONE) {
                pixbuf = pixbuf.rotate_simple (rotate_angle);
            }

            if (resize) {
                int w, h;
                if (percentage > 0) {
                    w = pixbuf.width * percentage / 100;
                    h = pixbuf.height * percentage / 100;
                } else if (!aspect_ratio && out_width > 0 && out_height > 0) {
                    w = out_width;
                    h = out_height;
                } else if (aspect_ratio && out_width > 0 && out_height > 0) {

                    float k, tmp_w, tmp_h, src_w, src_h, dest_w, dest_h;
                    src_w = (float) pixbuf.get_width ();
                    src_h = (float) pixbuf.get_height ();
                    dest_w = (float) out_width;
                    dest_h = (float) out_height;
                    k = src_w / src_h;
                    if (src_h > src_w) {
                        tmp_h = dest_h;
                        tmp_w = tmp_h * k;
                    } else {
                        tmp_w = dest_w;
                        tmp_h = tmp_w / k;
                    }
                    w = (int) tmp_w;
                    h = (int) tmp_h;

                } else {
                    w = h = 0;
                    resize = false;
                }

                if (w > 0 && h > 0) {
                    pixbuf = pixbuf.scale_simple (w, h, Gdk.InterpType.HYPER);
                }
            }
            ok = this.save_new_image (srcfname);
            return ok;
        }
        

        public bool save_new_image (string srcfname) {
            bool ok = false;
            string suffix;
            GLib.Regex regex;
            string? ext = null;
            string? fname = null;
            GExiv2.Metadata srcmeta;
            GExiv2.Metadata destmeta;
            MatchInfo match_info = null;

            if (rotate || resize) {
                try {
                    regex = new GLib.Regex ("""(^.*).(jpg|jpeg|JPG|JPEG|PNG|GIF|png|gif)""");
                } catch (GLib.RegexError regex_err) {
                    debug (regex_err.message);
                    return false;
                }
                
                if (overwrite_original) {
                    fname = srcfname;
                } else {
                    if (rotate && !resize) {
                        suffix = "rotated";
                    } else if (!rotate && resize) {
                        suffix = "resized";
                    } else {
                        suffix = "modified";
                    }

                    fname = GLib.Path.get_basename (srcfname);
                    
                    if (regex.match (fname, 0, out match_info)) {
                        ext = match_info.fetch (2);
                        string? fn = match_info.fetch (1);
                        ext = (ext == null)? extension: ext;
                        fname = (fn == null)? fname: fn;
                    }

                    fname = GLib.Path.build_filename (this.save_folder, @"$fname-$suffix.$ext");
                }
                this.destname = fname;
                try {
                    int xresol = pixbuf.get_width ();
                    int yresol = pixbuf.get_height ();
                    srcmeta = new GExiv2.Metadata ();
                    srcmeta.open_path (srcfname);
                    destmeta = new GExiv2.Metadata ();

                    /*
                        Recaving a new or original exif orientation.
                    */
                    if (rotate) {
                        pixbuf.save (fname, extension);
                        destmeta.open_path (fname);
                        orientation = destmeta.get_orientation ();

                    } else {
                        orientation = srcmeta.get_orientation ();
                        pixbuf.save (fname, extension);
                        destmeta.open_path (fname);
                    }

                    destmeta.erase_exif_thumbnail ();
                    srcmeta.erase_exif_thumbnail ();

                    /*
                        Copying srcmeta to destinational image.
                    */
                    foreach (var s in srcmeta.get_exif_tags ()) {
                        string? val;
                        int nom, den;
                        val = srcmeta.get_exif_tag_string (s);
                        if (val != null && destmeta.set_exif_tag_string (s, (string) val)) continue;
                        if (destmeta.set_exif_tag_long (s, srcmeta.get_exif_tag_long (s))) continue;
                        if (srcmeta.get_exif_tag_rational (s, out nom, out den)) {
                            if (!destmeta.set_exif_tag_rational (s, nom, den)) continue;
                        }
                    }

                    /*
                        Restore size and orientation to destinational image
                    */
                    destmeta.set_exif_tag_long ("Exif.Photo.PixelXDimension", (long) xresol);
                    destmeta.set_exif_tag_long ("Exif.Photo.PixelYDimension", (long) yresol);
                    destmeta.set_exif_tag_string ("Exif.Image.Software", "libitmages");
                    destmeta.set_orientation (orientation);
                    destmeta.save_file (fname);
                    ok = true;

                } catch (GLib.Error save_err) {
                    debug (save_err.message);
                }
            }
            return ok;
        } //----- save_new_image
    }
//------------------------------------------------------------------------------
}


//------------------------------------------------------------------------------
