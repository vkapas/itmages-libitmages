

//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
namespace Itmages {

    
    public class Config : GLib.Object {


        private const int LOGIN = 0;
        private const int PASSWD = 1;
        private const int CONTENT = 1;

        private const string SEP1 = ":::";
        private const string SEP2 = ";;;";
        private string? tmpstrdata;
    //    private int[]? tmpintlst;

        public static const int AUTH_HOSTING = 1;
        public static const int AUTH_PROXY = 2;


        private static Config instance = null;
        private GLib.Settings client;
        
        private Config (string confname) {
            this.client = new GLib.Settings (confname);
        }

        public static Config get_default (string confname = "org.gnome.itmages.library") {
            if (instance == null) {
                instance = new Config (confname);
            }
            return instance;
        }

        public void apply_changes () {
            this.client.sync ();
        }

        public int get_int (string key) {
            return this.client.get_int (key);
        }

        public void set_int (string key, int value) {
            this.client.set_int (key, value);
            apply_changes ();
        }

        public bool get_bool (string key) {
            return client.get_boolean (key);
        }

        public void set_bool (string key, bool value) {
            client.set_boolean (key, value);
            apply_changes ();
        }

        public string? get_string (string key) {
            string? tmp = client.get_string (key);
            return tmp;
        }

        public void set_string (string key, string value) {
            client.set_string (key, value);
            apply_changes ();
        }



        private string[]? parse_userdata (string data) {
            string[] outdata = new string[2];
            string decoded = b64.decode (data);

            if (decoded != null) {
                string[] valist = decoded.split (SEP2);

                if (valist.length == 2) {
                    outdata[LOGIN] = valist[LOGIN].split(SEP1)[CONTENT];
                    outdata[PASSWD] = valist[PASSWD].split(SEP1)[CONTENT];

                    if ("null" in outdata[LOGIN]) outdata[LOGIN] = null;
                    if ("null" in outdata[PASSWD]) outdata[PASSWD] = null;

                    return outdata;

                } else
                    return null;
            } else
                return null;
        }

        private string? create_userdata (string key, string value, int arg) {
            string? outdata = null;
            string[]? saved_lst = null;
            string? saved = get_string (key);
            string login = "login" + SEP1 + (arg == LOGIN ? value : "(none)");
            string passwd = "passwd" + SEP1 + (arg == PASSWD ? value : "(none)");

            if (saved != null)
                saved_lst = parse_userdata (saved);
                    
            if (saved_lst != null) {
                if (arg == LOGIN)
                    passwd = "passwd" + SEP1 + saved_lst[PASSWD].to_string();

                else if (arg == PASSWD)
                    login = "passwd" + SEP1 + saved_lst[LOGIN].to_string();
            }

            outdata = login + SEP2 + passwd;
            return b64.encode (outdata);
        }
        

        private string? userdata_getter_adapter (string key, int arg) {
            string? outdata = null;
            string? data = get_string (key);
            string[]? parsed = null;
            if (data != null) {
                parsed = parse_userdata (data);
                if (parsed != null) outdata = parsed[arg];
            }
            return outdata;
        }

        public string username {
            set {
                    string data = create_userdata (USER_DATA, value, LOGIN);
                    set_string (USER_DATA, data);
                }
            get { this.tmpstrdata = userdata_getter_adapter (USER_DATA, LOGIN);
                  return (string) this.tmpstrdata;}
        }


        public string password {
            set {
                    var userdata = create_userdata (USER_DATA, value, PASSWD);
                    set_string (USER_DATA, userdata);
                }
            get {
                    this.tmpstrdata = userdata_getter_adapter (USER_DATA, PASSWD);
                    return (string) this.tmpstrdata;}
        }


        public string proxyuser {
            set {
                    var userdata = create_userdata (PROXYAUTH, value, LOGIN);
                    set_string (PROXYAUTH, userdata);
                }
            get {
                    this.tmpstrdata = userdata_getter_adapter (PROXYAUTH, LOGIN);
                    return (string) this.tmpstrdata;}
        }


        public string proxypass {
            set {
                    var userdata = create_userdata (PROXYAUTH, value, PASSWD);
                    set_string (PROXYAUTH, userdata);
                }
            get {
                  this.tmpstrdata = userdata_getter_adapter (PROXYAUTH, PASSWD);
                  return (string) this.tmpstrdata;}
        }


        public string proxynode {
            set {set_string (PROXYNODE, value);}
            get {
                    this.tmpstrdata = get_string (PROXYNODE);
                    return (string) this.tmpstrdata;
                }
        }


        public int proxyport {
            set {set_int (PROXYPORT, value);}
            get {return (int) get_int (PROXYPORT);}
        }

        public int proxytype {
            set {set_int (PROXYTYPE, value);}
            get {return (int) get_int (PROXYTYPE);}
        }


        public bool without_profile {
            set {set_bool (WITHOUT_PROFILE, value);}
            get {return (bool) get_bool (WITHOUT_PROFILE);}
        }


        public bool savedata {
            set {set_bool (SAVE_USERDATA, value);}
            get {return (bool) get_bool (SAVE_USERDATA);}
        }
        
        public bool verbose {
            set {set_bool (VERBOSE, value);}
            get {return (bool) get_bool (VERBOSE);}
        }
        
        public bool first_start {
            set {set_bool (FIRSTSTART, value);}
            get {return (bool) get_bool (FIRSTSTART);}
        }


        /*--------------------------------------------------------------------*/
        /* This methods replaced to current program */
        public string last_folder {
            set {set_string (UPLDR_LAST_FOLDER, value);}
            get {
                    this.tmpstrdata = get_string (UPLDR_LAST_FOLDER);
                    return (string) this.tmpstrdata;
                }
        }


        public int last_type {
            set {set_int (UPLDR_LAST_TYPE, value);}
            get {return (int) get_int (UPLDR_LAST_TYPE);}
        }


        public bool select_all {
            set {set_bool (UPLDR_SELECT_ALL, value);}
            get {return (bool) get_bool (UPLDR_SELECT_ALL);}
        }


        public int delay {
            set {set_int (UPLDR_HIDE_DELAY, value);}
            get {return (int) get_int (UPLDR_HIDE_DELAY);}
        }


        public int window_height {
            set {set_int (UPLDR_WIN_HEIGHT, value);}
            get {return (int) get_int (UPLDR_WIN_HEIGHT);}
        }


        public int resize_width {
            set {set_int (RESIZE_WIDTH, value);}
            get {return (int) get_int (RESIZE_WIDTH);}
        }

        public int resize_height {
            set {set_int (RESIZE_HEIGHT, value);}
            get {return (int) get_int (RESIZE_HEIGHT);}
        }

        public int resize_percent {
            set {set_int (RESIZE_PERCENT, value);}
            get {return (int) get_int (RESIZE_PERCENT);}
        }

        public int rotate_angle {
            set {set_int (ROTATE_ANGLE, value);}
            get {return (int) get_int (ROTATE_ANGLE);}
        }

        public bool resize_custom {
            set {set_bool (RESIZE_CUSTOM, value);}
            get {return (bool) get_bool (RESIZE_CUSTOM);}
        }

        public bool resize_aspect {
            set {set_bool (RESIZE_ASPECT, value);}
            get {return (bool) get_bool (RESIZE_ASPECT);}
        }

        public bool imaging_dialog_show {
            set {set_bool (SHOW_IMAGING_DLG, value);}
            get {return (bool) get_bool (SHOW_IMAGING_DLG);}
        }

        public bool add_modified {
            set {set_bool (IMAGING_ADD, value);}
            get {return (bool) get_bool (IMAGING_ADD);}
        }

        public bool overwrite_modified {
            set {set_bool (IMAGING_OVERWRITE, value);}
            get {return (bool) get_bool (IMAGING_OVERWRITE);}
        }


        public bool autostart {
            set {set_bool (UPLDR_AUTOSTART, value);}
            get {return (bool) get_bool (UPLDR_AUTOSTART);}
        }


        public string imaging_folder {
            set {
                    set_string (MODIF_FOLDER, value);
                }
            get {
                    this.tmpstrdata = get_string (MODIF_FOLDER);
                    return this.tmpstrdata;
                }
        }
    }

}
//------------------------------------------------------------------------------
