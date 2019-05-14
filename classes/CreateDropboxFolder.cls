public class CreateDropboxFolder{
    public String tag; //complete
    public cls_entries[] entries;
    public class cls_entries {
        public String tag; //success
        public cls_metadata metadata;
    }
    public class cls_metadata {
        public String name; //math
        public String id;   //id:a4ayc_80_OEAAAAAAAAAXz
        public String path_lower;   ///homework/math
        public String path_display; ///Homework/math
        public cls_sharing_info sharing_info;
        public cls_property_groups[] property_groups;
    }
    public class cls_sharing_info {
        public boolean read_only;
        public String parent_shared_folder_id;  //84528192421
        public boolean traverse_only;
        public boolean no_access;
    }
    public class cls_property_groups {
        public String template_id;  //ptid:1a5n2i6d3OYEAAAAAAAAAYa
        public cls_fields[] fields;
    }
    public class cls_fields {
        public String name; //Security Policy
        public String value;    //Confidential
    }
    /*public static CreateDropboxFolder parse(String json){
        return (CreateDropboxFolder) System.JSON.deserialize(json, CreateDropboxFolder.class);
    }

    static testMethod void testParse() {
        String json=        '{'+
        '    ".tag": "complete",'+
        '    "entries": ['+
        '        {'+
        '            ".tag": "success",'+
        '            "metadata": {'+
        '                "name": "math",'+
        '                "id": "id:a4ayc_80_OEAAAAAAAAAXz",'+
        '                "path_lower": "/homework/math",'+
        '                "path_display": "/Homework/math",'+
        '                "sharing_info": {'+
        '                    "read_only": false,'+
        '                    "parent_shared_folder_id": "84528192421",'+
        '                    "traverse_only": false,'+
        '                    "no_access": false'+
        '                },'+
        '                "property_groups": ['+
        '                    {'+
        '                        "template_id": "ptid:1a5n2i6d3OYEAAAAAAAAAYa",'+
        '                        "fields": ['+
        '                            {'+
        '                                "name": "Security Policy",'+
        '                                "value": "Confidential"'+
        '                            }'+
        '                        ]'+
        '                    }'+
        '                ]'+
        '            }'+
        '        }'+
        '    ]'+
        '}';
        CreateDropboxFolder obj = parse(json);
        System.assert(obj != null);
    } */
}