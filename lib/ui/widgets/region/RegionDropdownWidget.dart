import 'package:flutter/material.dart';
import 'package:haftaa/Category/BaseCategory.dart';
import 'package:haftaa/Category/CategoryController.dart';
import 'package:haftaa/region/region-controller.dart';
import 'package:haftaa/region/region.dart';
import 'package:haftaa/validation/validators.dart';
// import 'package:haftaa/governorate/governorate.dart';
// import 'package:haftaa/governorate/governorateController.dart';

class RegionDropdownWidget extends StatefulWidget {
  RegionController _regionController = RegionController();
  //List _menuItemlist;
  Function(Region) onChange;
  String title;
  String hintText;
  String governorateID;
  Region selectedRegion;
  bool selectionIsRequired = false;
  List<DropdownMenuItem<Region>> menuitems = List<DropdownMenuItem<Region>>();

  RegionDropdownWidget({Key key}) : super(key: key) {}
  RegionDropdownWidget.custom(
      {this.onChange,
      this.title,
      this.hintText,
      this.governorateID,
      this.selectionIsRequired,
      this.selectedRegion}) {
    // listenToStream();
    //_regionController.loadRegions('sdsdsd233FG333323');
  }

  @override
  _RegionDropdownWidgetState createState() {
    return _RegionDropdownWidgetState();
  }

  String _defaultSelectedRegionID;
  loadRegions(governorateID, {defaultSelectedRegionID}) {
    menuitems.clear();
    _defaultSelectedRegionID = defaultSelectedRegionID;
    _regionController.loadRegions(governorateID).then((regions) {
      if (_defaultSelectedRegionID != null) {
        selectedRegion = regions
            .where((region) => region.Id == _defaultSelectedRegionID)
            .first;
        _defaultSelectedRegionID = null;
      }
    });
  }
}

class _RegionDropdownWidgetState extends State<RegionDropdownWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 20.0),
          child: Text(
            widget.title,
            style: TextStyle(fontFamily: "Gotik", color: Colors.black26),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 20.0)),
        Row(
          children: <Widget>[
            Container(
              width: mediaQuery.size.width - 90,
              child: StreamBuilder(
                stream: widget._regionController.regionsStream,
                builder: (context, AsyncSnapshot<List<Region>> snapshot) {
                  widget.menuitems.clear();
                  if (snapshot.hasData) {
                    snapshot.data.forEach((region) {
                      widget.menuitems.add(DropdownMenuItem<Region>(
                        child: Text(
                          region.title,
                          style: TextStyle(fontSize: 13),
                        ),
                        value: region,
                      ));
                    });

                    return DropdownButtonFormField<Region>(
                      decoration: InputDecoration(
                        icon: Icon(Icons.location_on),
                      ),
                      validator: (value) => widget.selectionIsRequired
                          ? Validators.notEmptyItemSelection(value)
                          : null,
                      onChanged: (selected_region) {
                        setState(() {
                          widget.selectedRegion = selected_region;
                        });
                      },
                      hint: Text(
                        'اختر المنطقة',
                        style: TextStyle(fontSize: 13),
                      ),
                      value: (widget._defaultSelectedRegionID != null &&
                              widget.selectedRegion == null)
                          ? widget.menuitems
                              .where((menuitem) =>
                                  menuitem.value.Id ==
                                  widget._defaultSelectedRegionID)
                              .first
                              .value
                          : widget.selectedRegion,
                      items: widget.menuitems,
                    );
                  }
                },
              ),
            ),
            IconButton(
              alignment: Alignment.topLeft,
              icon: Icon(
                Icons.cancel,
                color: Colors.blueAccent.shade200,
              ),
              onPressed: () {
                setState(() {
                  widget.selectedRegion = null;
                });
              },
            )
          ],
        ),
      ],
    );
  }
}
