import 'package:flutter/material.dart';
import 'package:haftaa/core/enums.dart';
import 'package:haftaa/validation/validators.dart';

class ProductTypeDropdown extends StatefulWidget {
  Function(AdType) onChange;
  ProductTypeDropdown();
  bool selectionIsRequired = false;
  ProductTypeDropdown.custom({this.selectionIsRequired, this.onChange});
  @override
  _ProductTypeDropdownState createState() => _ProductTypeDropdownState();
}

class _ProductTypeDropdownState extends State<ProductTypeDropdown> {
  String productTypeValue;
  final _dropdownKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width - 90,
          child: DropdownButtonFormField<String>(
            validator: (value) => widget.selectionIsRequired
                ? Validators.notEmptyItemSelection(value)
                : null,
            hint: Text('حدد الغرض'),
            value: productTypeValue,
            items: ["بيع", "شراء", "مزاد"].map((typeName) {
              return DropdownMenuItem(
                child: Text(typeName),
                value: typeName,
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                switch (value) {
                  case 'بيع':
                    widget.onChange(AdType.sale);
                    break;
                  case 'شراء':
                    widget.onChange(AdType.request);
                    break;
                  case 'مزاد':
                    widget.onChange(AdType.auction);
                    break;
                }
                productTypeValue = value;
              });
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
              productTypeValue = null;
            });
          },
        )
      ],
    );
  }
}
