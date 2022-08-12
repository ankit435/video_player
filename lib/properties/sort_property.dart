import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/helper/file.dart';
import 'package:video/helper/files.dart';
import 'package:video/helper/storage.dart';

class short_property extends StatefulWidget {
  void Function(String, bool) sorting;
  final Map<String, bool>? sort_cond;
  final String sort_by;
  short_property(
      {Key? key,
      required this.sorting,
      required this.sort_cond,
      required this.sort_by})
      : super(key: key);
  @override
  State<short_property> createState() => _video_propertyState();
}

class _video_propertyState extends State<short_property> {
  @override
  var sort;
  bool Name=false,Length=false,Date=false,Size=false,sortc=false;


  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      sort = widget.sort_by;
    });

    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: AlertDialog(
          insetPadding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          scrollable: true,
          title: Text('Sort by'),
          content: Container(
            width: MediaQuery.of(context).size.width - 20,
            child: Column(
              children: <Widget>[
                Divider(),
                ListTile(
                  leading: Radio(
                    value: "Name",
                    groupValue: sort,
                    onChanged: (value) {
                      setState(() {
                        sort = value.toString();
                      });
                    },
                  ),
                  title: Text("Name"),
                  trailing: sort == "Name"
                      ? IconButton(
                          icon: Icon(Name
                              ? Icons.arrow_downward
                              : Icons.arrow_upward),
                          onPressed: () {
                            setState(() {
                              Name=!Name;
                              sortc=Name;
                            });
                          },
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      sort = "Name";
                    });
                  },
                ),
                ListTile(
                  leading: Radio(
                    value: "Date",
                    groupValue: sort,
                    onChanged: (value) {
                      setState(() {
                        sort = value.toString();
                      });
                    },
                  ),
                  title: Text("Date"),
                  trailing: sort == "Date"
                      ? IconButton(
                          icon: Icon(Date
                              ? Icons.arrow_downward
                              : Icons.arrow_upward),
                          onPressed: () {
                            setState(() {
                              Date=!Date;
                              sortc=Date;
                            });
                          },
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      sort = "Date";
                    });
                  },
                ),
                ListTile(
                  leading: Radio(
                    value: "Size",
                    groupValue: sort,
                    onChanged: (value) {
                      setState(() {
                        sort = value.toString();
                      });
                    },
                  ),
                  title: Text("Size"),
                  trailing: sort == "Size"
                      ? IconButton(
                          icon: Icon(Size
                              ? Icons.arrow_downward
                              : Icons.arrow_upward),
                          onPressed: () {
                            setState(() {
                              Size=!Size;
                              sortc=Size;
                            });
                          },
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      sort = "Size";
                    });
                  },
                ),
                ListTile(
                  leading: Radio(
                    value: "Length",
                    groupValue: sort,
                    onChanged: (value) {
                      setState(() {
                        sort = value.toString();
                      });
                    },
                  ),
                  title: Text("Length"),
                  trailing: sort == "Length"
                      ? IconButton(
                          icon: Icon(Length
                              ? Icons.arrow_downward
                              : Icons.arrow_upward),
                          onPressed: () {
                            setState(() {
                              Length=!Length;
                              sortc=Length;
                            });
                          },
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      sort = "Length";
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                print(sortc);
                Navigator.pop(context);
                widget.sorting(sort, sortc);
              },
              child: Text('OK'),
            ),
          ],
        ));
  }
}
