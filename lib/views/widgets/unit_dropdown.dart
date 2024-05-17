import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/models/unit.dart';

class UnitDropdown extends StatefulWidget {
  final Function(Unit?) onChanged;
  final int? idSelected;
  final List<Unit> units;
  const UnitDropdown(
      {super.key,
      this.idSelected,
      required this.onChanged,
      required this.units});

  @override
  State<UnitDropdown> createState() => _UnitDropdownState();
}

class _UnitDropdownState extends State<UnitDropdown> {
  int? idSelected;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    idSelected = widget.idSelected;
  }

  void _onChanged(Unit? unit) {
    setState(() {
      idSelected = unit?.id;
    });

    if (unit != null) {
      widget.onChanged(unit);
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.units.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : DropdownButtonHideUnderline(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue, // Light grey border
                ),
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButton2<Unit>(
                isExpanded: true,
                hint: Text(
                  'Select value',
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        Colors.white.withOpacity(0.6), // Light grey text color
                  ),
                ),
                items: widget.units
                    .map((unit) => DropdownMenuItem(
                          value: unit,
                          child: Text(
                            '${unit.name} - ${unit.abbreviation}',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                    .toList(),
                value: widget.units.firstWhere((unit) => unit.id == idSelected,
                    orElse: () => widget.units.first),
                onChanged: _onChanged,
                buttonStyleData: ButtonStyleData(
                  padding: EdgeInsets.zero, // Remove padding inside button
                  height: 60,
                  width: MediaQuery.of(context).size.width -
                      32, // Full width minus padding
                ),
                dropdownStyleData: const DropdownStyleData(
                  maxHeight: 200,
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                ),
                dropdownSearchData: DropdownSearchData(
                  searchController: textEditingController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Container(
                    height: 50,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: TextFormField(
                      expands: true,
                      maxLines: null,
                      controller: textEditingController,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        hintText: 'Search for a unit...',
                        hintStyle: const TextStyle(fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return item.value!.name
                        .toLowerCase()
                        .contains(searchValue.toLowerCase());
                  },
                ),
                // This to clear the search value when you close the menu
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    textEditingController.clear();
                  }
                },
              ),
            ),
          );
  }
}
