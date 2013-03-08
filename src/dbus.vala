//------------------------------------------------------------------------------

namespace Itmages {
//------------------------------------------------------------------------------
    [DBus (name = "org.freedesktop.ITmagesEngine")]
    public interface ItDbusClientIface : GLib.Object {

        
        [DBus (name = "Shared")]
        public abstract GLib.HashTable<string, GLib.Variant>
                            send_method (GLib.HashTable<string, GLib.Variant> msg)
                            throws GLib.IOError;

        [DBus (name = "ItemInfoGet")]
        public abstract GLib.HashTable<string, GLib.Variant> get_item_info (string filename) throws GLib.IOError;

        [DBus (name = "ItemInfoGetLine")]
        public abstract string get_item_info_string (string filename) throws GLib.IOError;


        [DBus (name = "ItemsListGet")]
        public abstract string[] get_items_list () throws GLib.IOError;

        [DBus (name = "SetItemStatus")]
        public abstract bool set_item_status (string name, int status) throws GLib.IOError;

        [DBus (name = "ListMethodsGet")]
        public abstract string[] availabled_methods () throws GLib.IOError;

        [DBus (name = "AddNewItem")]
        public abstract bool item_add (string filename) throws GLib.IOError;

        [DBus (name = "DelItem")]
        public abstract bool item_delete (string filename) throws GLib.IOError;

        [DBus (name = "action_started")]
        public signal void action_started (string action, string filename);

        [DBus (name = "action_complete_string_line")]
        public signal void action_complete_string_line (string line);


        [DBus (name = "progress_event")]
        public signal void progress_event (int action = -1, string filename, double dt, double dr, double ut, double ur);
        [DBus (name = "item_status_changed")]
        public signal void item_status_changed (
                                                    string filename,
                                                    uint8 old_status,
                                                    uint8 new_status
                                                 );

//        [DBus (name = "item_deleted")]
        public signal void item_deleted (string filename);

//        [DBus (name = "new_item_added")]
        public signal void new_item_added(GLib.HashTable<string, GLib.Variant> imageinfo);


    }
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
    [DBus (name = "org.freedesktop.ITmages.Uploader")]
    public class UploaderMiniServer: GLib.Object {
        private UploaderWindow window;

        public UploaderMiniServer (UploaderWindow win) {
            window = win;
        }


        public bool ping (GLib.BusName sender) {
            return true;
        }

        public void append_files (string[] filelist, bool present, bool autostart) {
            bool add_ok = false;
            if (filelist.length  > 0) {
                foreach (string fname in filelist) {
                    if (window.append (fname)) {
                        add_ok = true;
                    }
                }
                if (present && add_ok) window.present ();
                if (autostart && add_ok) window.upload_start ();
                
            } else {
                window.show_all ();
                window.present ();
            }
        }


        public void resize_image (
                                    string srcname,
                                    bool replace,
                                    string destdir,
                                    bool aspect,
                                    int width,
                                    int height,
                                    int percent
                                  ) {
            var loader = new ImageLoader ();
            bool res = loader.set_attributes (
                                                    srcname,
                                                    "resize", true,
                                                    "replace", replace,
                                                    "folder", destdir,
                                                    "aspect", aspect,
                                                    "width", width,
                                                    "height", height,
                                                    "percent", percent
                                             );
            if (res) {
                res = loader.start ();
            }
            resize_complete (srcname, loader.destname, replace, res);
        }

        public signal void resize_complete (string srcname, string destname, bool replace, bool all_good);

        public void rotate_image (
                                        string srcname,
                                        bool replace,
                                        string destdir,
                                        int angle
                                  ) {
            var loader = new ImageLoader ();
            bool res = loader.set_attributes (
                                                    srcname,
                                                    "rotate", true,
                                                    "replace", replace,
                                                    "folder", destdir,
                                                    "angle", angle
                                              );
            if (res) {
                res = loader.start ();
            }
            rotate_complete (srcname, loader.destname, replace, res);
        }
        
        public signal void rotate_complete (string srcname, string destname, bool replace, bool all_good);
    }
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
    [DBus (name = "org.freedesktop.ITmages.Uploader")]
    public interface UploaderMiniClient: GLib.Object {

        public abstract bool ping () throws GLib.IOError;
        public abstract void append_files (string[] filelist, bool present, bool autostart) throws GLib.IOError;
        public abstract async void resize_image (string srcname, bool replace, string destdir, bool aspect, int width, int height, int percent) throws GLib.IOError;
        public abstract async void rotate_image (string srcname, bool replace, string destdir, int angle) throws GLib.IOError;
        public abstract signal void rotate_complete (string srcname, string destname, bool replace, bool all_good);
        public abstract signal void resize_complete (string srcname, string destname, bool replace, bool all_good);
    }
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
    public static bool miniclient_set_filelist (string[] filelist, bool present = false, bool autostart = false) {
        bool result = false;
        Itmages.UploaderMiniClient client = null;
        try {
            client = GLib.Bus.get_proxy_sync<UploaderMiniClient> (
                                                GLib.BusType.SESSION,
                                                UPLOADER_DBUS_IFACE,
                                                UPLOADER_DBUS_PATH
                                            );
            if (filelist.length > 0 && client.ping ()) {
                client.append_files (filelist, present, autostart);
                result = true;
            }
            
        } catch (GLib.Error err) {
            result = false;
        }
        return result;
    } 

//------------------------------------------------------------------------------
/*
    public void start_server () {
        GLib.Bus.own_name (
                            GLib.BusType.SESSION,
                            UPLOADER_DBUS_IFACE,
                            GLib.BusNameOwnerFlags.NONE,
                            on_bus_aquired,
                            () => {},
                            () => stderr.printf ("Could not aquire name\n")
                          );
    }

*/

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
}
