import 'package:flutter/material.dart';
import '../model/filter.dart';
import 'homepage.dart';

class Setting extends StatefulWidget {
  final String user_id;

  const Setting({super.key, required this.user_id});

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String selectedGender = 'everyone';
  var ageRange = RangeValues(18, 40);
  var compabilityRange = RangeValues(0, 100);
  String selectedState = 'All';

  final List<String> states = [
    'All',
    'Johor',
    'Kedah',
    'Kelantan',
    'Melaka',
    'Negeri Sembilan',
    'Pahang',
    'Penang',
    'Perak',
    'Perlis',
    'Selangor',
    'Terengganu',
    'Kuala Lumpur',
    'Labuan',
    'Putrajaya'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 20),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 3,
              blurRadius: 10,
            )
          ]),
          child: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_left_sharp,
                size: 50,
                color: Color(0xff4C315C),
              ),
            ),
            title: Text(
              'Perference',
              style: TextStyle(fontFamily: 'Itim', fontSize: 25),
            ),
            backgroundColor: Colors.white,
          ),
        ),
      ),
      body: Container(
        //main body setting
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              //Filter
              margin: EdgeInsets.fromLTRB(10, 30, 0, 20),
              child: Text(
                'Filter',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xff9D9D9D)),
              ),
            ),
            Container(
              //Gender
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xff9D9D9D)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gender',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff9D9D9D)),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        gender_option(
                          icon: Icons.male,
                          label: 'Male',
                        ),
                        gender_option(
                          icon: Icons.female,
                          label: 'Female',
                        ),
                        gender_option(
                          icon: Icons.person,
                          label: 'Everyone',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              //Age Range
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xff9D9D9D)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Age Range',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff9D9D9D)),
                        ),
                        Text(
                          '${ageRange.start.round()} - ${ageRange.end.round()}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff9D9D9D)),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    RangeSlider(
                      values: ageRange,
                      min: 18,
                      max: 50,
                      labels: RangeLabels(ageRange.start.round().toString(),
                          ageRange.end.round().toString()),
                      activeColor: Color(0xff4C315C),
                      inactiveColor: Color(0xff9D9D9D),
                      onChanged: (RangeValues values) {
                        setState(() => ageRange = values);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              //Compability Range
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xff9D9D9D)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Compability Range',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff9D9D9D)),
                        ),
                        Text(
                          '${compabilityRange.start.round()}% - ${compabilityRange.end.round()}%',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff9D9D9D)),
                        ),
                      ],
                    ),
                    RangeSlider(
                      values: compabilityRange,
                      min: 0,
                      max: 100,
                      labels: RangeLabels(
                          compabilityRange.start.round().toString(),
                          compabilityRange.end.round().toString()),
                      activeColor: Color(0xff4C315C),
                      inactiveColor: Color(0xff9D9D9D),
                      onChanged: (RangeValues values) {
                        setState(() => compabilityRange = values);
                      },
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(21, 0, 15, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '0',
                            style: TextStyle(
                                color: Color(0xff9D9D9D),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          Text(
                            '100',
                            style: TextStyle(
                                color: Color(0xff9D9D9D),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              //Location Range
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xff9D9D9D)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff9D9D9D)),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedState,
                      isExpanded: true,
                      decoration: InputDecoration(
                        hintText: null,
                        filled: true,
                        border: InputBorder.none,
                        enabledBorder: null,
                        focusedBorder: null,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                      ),
                      dropdownColor: Colors.white,
                      items: states.map((String state) {
                        return DropdownMenuItem<String>(
                          value: state,
                          child: Text(
                            state,
                            style: TextStyle(
                                color: Color(0xff4C315C),
                                fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedState = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50),
            Center(
              child: SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    print(
                        "$selectedGender, $ageRange, $compabilityRange, $selectedState");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(
                          user_id: widget.user_id,
                          filterModel: FilterModel(
                              selectedGender: selectedGender,
                              ageRange: ageRange,
                              compatibilityRange: compabilityRange,
                              selectedState: selectedState),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff4C315C),
                  ),
                  child: Text(
                    'Save Changes',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget gender_option({required IconData icon, required String label}) {
    bool isSelected = selectedGender == label.toLowerCase();
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = label.toLowerCase();
        });
      },
      child: Container(
        width: 100,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF4C315C) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey,
              size: 30,
            ),
            SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(color: isSelected ? Colors.white : Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
