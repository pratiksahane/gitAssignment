import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _refreshPressed() {
    debugPrint("Refresh Clicked");
  }
  List<String> _todoTitles = [];
  bool _isLoading = false;  

  @override
void initState() {
  super.initState();
  _fetchTodoTitles();
}

Future<void> _fetchTodoTitles() async {
  setState(() => _isLoading = true);
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));
  if (response.statusCode == 200) {
    final List todos = json.decode(response.body);
    setState(() {
      _todoTitles = todos.map((todo) => todo['title'] as String).toList();
      _isLoading = false;
    });
  } else {
    setState(() => _isLoading = false);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        "Search the best Freight Rates",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      backgroundColor: const Color.fromRGBO(255, 255, 255, 0.5),
      actions: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEEF2FF),
              foregroundColor: const Color(0xFF0050FF),
              side: const BorderSide(
                color: Color(0xFF0050FF),
                width: 1,
              ),
        
            ),
            onPressed: _refreshPressed,
            child: const Text("Refresh"),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Container(
      color: const Color.fromRGBO(230, 234, 248, 1),
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Card(
          color: Color.fromRGBO(255, 255, 255, 1),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextFieldFrame(),
                const SizedBox(height: 16),
                _buildCheckBoxFrame(),
                const SizedBox(height: 16),
                _buildThirdFrame(),
                const SizedBox(height: 16),
                _buildFourthFrame("Shipment Type"),
                const SizedBox(height: 16),
                _buildFifthFrame(),
                const SizedBox(height: 16),
                _buildSixthFrame(),
                const SizedBox(height: 14),
                _buildSeventhFrame(),
                const SizedBox(height: 16),
                _buildFourthFrame("Container Internal Dimensions"),
                const SizedBox(height: 16),
                _buildEightFrame(),
                const SizedBox(height: 16),
                _buildSearchButton(),
                // Add other widgets below the text fields here
                // _buildCheckBoxFrame(),
                // _buildSearchButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

Widget _buildTextFieldFrame() {
  return Row(
    children: [
      // Origin Autocomplete
      SizedBox(
        width: 652,
        child: Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<String>.empty();
            }
            return _todoTitles.where((String option) {
              return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: (String selection) {
            debugPrint('Selected: $selection');
          },
          fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              onEditingComplete: onEditingComplete,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: const Text("Origin"),
                labelStyle: TextStyle(
                  color: Colors.grey[600],
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            );
          },
        ),
      ),

      const SizedBox(width: 24),

      // Destination Autocomplete
      SizedBox(
        width: 652,
        child: Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<String>.empty();
            }
            return _todoTitles.where((String option) {
              return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: (String selection) {
            debugPrint('Selected: $selection');
          },
          fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              onEditingComplete: onEditingComplete,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: const Text("Destination"),
                labelStyle: TextStyle(
                  color: Colors.grey[600],
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}


Widget _buildCheckBoxFrame() {
  bool includeNearbyOrigin = false;
  bool includeNearbyDestination = false;

  return SizedBox(
    width: 1328,
    child: Padding(
      padding: const EdgeInsets.only(top: 8),  // Matches vertical spacing
      child: Row(
        children: [
          SizedBox(
            width: 652,
            child: Row(
              children: [
                StatefulBuilder(
                  builder: (context, setState) {
                    return Transform.scale(
                      scale: 0.8,
                      child: Checkbox(
                        value: includeNearbyOrigin,
                        onChanged: (bool? value) {
                          setState(() {
                            includeNearbyOrigin = value ?? false;
                          });
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                const Text(
                  "Include nearby origin ports",
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),  // Matches text field spacing exactly
          SizedBox(
            width: 652,
            child: Row(
              children: [
                StatefulBuilder(
                  builder: (context, setState) {
                    return Transform.scale(
                      scale: 0.8,
                      child: Checkbox(
                        value: includeNearbyDestination,
                        onChanged: (bool? value) {
                          setState(() {
                            includeNearbyDestination = value ?? false;
                          });
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                const Text(
                  "Include nearby destination ports",
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildThirdFrame() {
  String? selectedCommodity;
  DateTime? selectedDate;
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  return SizedBox(
    width: 1328,
    height: 56,
    child: Row(
      children: [
        // Commodity Dropdown
        SizedBox(
          width: 652,
          height: 56,
          child: InputDecorator(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedCommodity,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
                hint: const Text(
                  "Commodity",
                  style: TextStyle(color: Colors.grey),
                ),
                items: <String>['Dry Van', 'Reefer', 'Flatbed', 'Tanker']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCommodity = newValue;
                  });
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 24), // Consistent spacing
        
        // Date Selection TextField
        SizedBox(
          width: 652,
          height: 56,
          child: TextField(
            controller: _dateController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              labelText: "Cut off Date",
              labelStyle: TextStyle(
                color: Colors.grey[600],
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
            ),
            readOnly: true,
            onTap: () => _selectDate(context),
          ),
        ),
      ],
    ),
  );
}

bool _fcl = false;
bool _lcl = false;
Widget _buildFourthFrame(String data){
  return SizedBox(
    width:1328,
    height:26,
    child: Text(data, style: TextStyle(color:Color.fromRGBO(33, 33, 33, 1), fontFamily: "Public Sans", fontSize: 16,fontWeight: FontWeight.bold),),
  );
}

  // Change handler for checkboxes
  void _handleCheckboxChange(bool? value, String type) {
    setState(() {
      if (type == 'fcl') {
        _fcl = value ?? false;
        // Ensure only one can be selected at a time
        if (_fcl) _lcl = false;
      } else {
        _lcl = value ?? false;
        // Ensure only one can be selected at a time
        if (_lcl) _fcl = false;
      }
    });
  }

  Widget _buildFifthFrame() {
    return SizedBox(
      width: 173,
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width:75 ,
            height:20 ,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                  scale: 0.8,
                  child: Checkbox(
                    value: _fcl,
                    onChanged: (value) => _handleCheckboxChange(value, 'fcl'),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  "FCL",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          SizedBox(
            width:75 ,
            height:20 ,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                  scale: 0.8,
                  child: Checkbox(
                    value: _lcl,
                    onChanged: (value) => _handleCheckboxChange(value, 'lcl'),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  "LCL",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSixthFrame(){
    String? selectedValue;
    return SizedBox(
      width:1328,
      height:56,
      child: Row(
        children: [
          SizedBox(
          width: 652,
          height: 56,
          child: InputDecorator(
            decoration: InputDecoration(
              label: Text("Customer Size"),
              labelStyle: TextStyle(
                color: Color.fromRGBO(158, 158, 158, 1),
              ),
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedValue,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
                hint: const Text(
                  "40' Standard",
                  style: TextStyle(color: Color.fromRGBO(102, 102, 102, 1)),
                ),
                items: <String>['Dry Van', 'Reefer', 'Flatbed', 'Tanker']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue;
                  });
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 24),
        SizedBox(
          width:314,
          height:56,
          child: TextField(
            decoration:InputDecoration(
              border: OutlineInputBorder(),
              label: Text("No. of Boxes"),
              labelStyle: TextStyle(
                color: Color.fromRGBO(158, 158, 158, 1),
              )
            ),
          ),
        ),
        const SizedBox(width: 24),
        SizedBox(
          width:314,
          height:56,
          child: TextField(
            decoration:InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Weight kg"),
              labelStyle: TextStyle(
                color: Color.fromRGBO(158, 158, 158, 1),
              )
            ),
          ),
        ),
        ],
      ),
    );
  }

  Widget _buildSeventhFrame() {
  return SizedBox(
    width: 987,
    height: 16.000001907348633,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Icon(
            Icons.info_outline,
            color: const Color.fromRGBO(102, 102, 102, 1),
            size: 16,
          ),
        ),
        Expanded(
          child: Text(
            "To obtain accurate rate for spot rate with guaranteed space and booking, please ensure your container count and weight per container is accurate",
            style: TextStyle(
              color: const Color.fromRGBO(102, 102, 102, 1),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: "Public Sans",
              height: 1.14, // This matches your exact height requirement (16/14 ≈ 1.14)
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildEightFrame(){
  return SizedBox(
    width:1328 ,
    height:96 ,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text("Length 39.46ft"),
              const SizedBox(height: 8,),
              Text("Width 7.70ft"),
              const SizedBox(height: 8,),
              Text("Height 7.84ft")
            ],
          ),
        ),
        const SizedBox(width: 24,),
        Image.asset('assets/images/image1.png', 
        width: 255.7593994140625,
        height: 96,
        )
      ],
    ),
  );
}

void _functionSearch(){
debugPrint("SearchButton Clicked");
}

Widget _buildSearchButton() {
  return SizedBox(
    width: 1328,
    height: 40,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end, // This aligns children to the end (right)
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEEF2FF),
              foregroundColor: const Color(0xFF0050FF),
              side: const BorderSide(
                color: Color(0xFF0050FF),
                width: 1,
              ),
          ),
          onPressed: _functionSearch,
          child: const Text(
            "Search",
            style: TextStyle(
              fontFamily: "Public Sans",
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color.fromRGBO(1, 57, 255, 1),
            ),
          ),
        ),
      ],
    ),
  );
}
}

