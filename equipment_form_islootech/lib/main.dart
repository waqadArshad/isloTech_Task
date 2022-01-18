import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'models/formModel.dart';

void main() {
  runApp(const MyApp());
}

/*Please do not mind the print statements. They are a very good tool for debugging.*/
class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Equipment App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (_) => FormModel(),
        child: MyHomePage(title: 'Equipments'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 

  /* Currently we are taking lists of our choice and we are providing these
  * lists to the dropdown, but in an actual app, we would be fetching the new lists
  * based on the selection from the previous Dropdown.
  * We can implement that using Future, async and await*/
  String selectedCategory = 'Select Category';
  String selectedProduct = 'Product';
  String selectedCapacity = 'Capacity';
  String selectedMake = 'Make';
  String selectedModel = 'Model';
  String selectedYear = 'Year';
  List<String> categoryList = ['Select Category', 'Fitness', 'Diving'];
  List<String> productList = ['Product', 'Fitness Watch', 'Swim suit'];
  List<String> capacityList = ['Capacity', '10hrs', '3hrs'];
  List<String> makeList = ['Make', 'AbFit', 'Andromeda'];
  List<String> modelList = [
    'Model',
    'Abfit-2020',
    'Abfit-2021',
    'Andromeda-2020',
    'Andromeda-2021'
  ];
  List<String> yearList = ['Year', '2020', '2021'];
  final TextEditingController _categoryController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  //this map will be used to keep keys for each form
  Map<int, GlobalKey<FormState>> keyMap = {};

  //these maps will be used to keep the value being selected to individual field of individual form
  Map<int, String> categoryMap = {};
  Map<int, String> productMap = {};
  Map<int, String> capacityMap = {};
  Map<int, String> makeMap = {};
  Map<int, String> modelMap = {};
  Map<int, String> yearMap = {};

  List keys = [];

  generateKeyList(bool isRemove, int length) {
    var listLength = context.read<FormModel>().formList.length;
    if (!isRemove) {
      keys.add('_formKey${listLength}');
      keyMap.putIfAbsent(listLength, () => GlobalKey<FormState>());
      categoryMap.putIfAbsent(
          listLength, () => 'selectedCategory${listLength}');
      productMap.putIfAbsent(listLength, () => 'selectedProduct${listLength}');
      capacityMap.putIfAbsent(
          listLength, () => 'selectedCapacity${listLength}');
      makeMap.putIfAbsent(listLength, () => 'selectedMake${listLength}');
      modelMap.putIfAbsent(listLength, () => 'selectedModel${listLength}');
      yearMap.putIfAbsent(listLength, () => 'selectedYear${listLength}');

      print('in generateKeyList: $listLength');
      print('in generateKeyList list is: $keys');
      print('in generateKeyList map is: $keyMap');
      print('in generateKeyList categoryMap is: $categoryMap');
    } else if (isRemove && keys.length > 1 && keyMap.length > 1) {
      print('length passed is: $length');
      print('in generateKeyList list remove is: $keys');
      print('in generateKeyList remove map is: $keyMap');
      keys.removeLast();
      keyMap.remove(length);
      categoryMap.remove(length);
      productMap.remove(length);
      capacityMap.remove(length);
      makeMap.remove(length);
      modelMap.remove(length);
      yearMap.remove(length);
      print('in generateKeyList remove: $listLength');
      print('in generateKeyList list remove is: $keys');
      print('in generateKeyList remove map is: $keyMap');
      print('in generateKeyList remove categoryMap is: $categoryMap');
    }
  }

  File _image;
  final _imagePicker = ImagePicker();
  Future getImage() async {
    final pickedFile =
    await _imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  categoryValidator(String category) {
    if (category == null) {
      return 'Selecting a Category is Required';
    } else if (category == 'Select Category') {
      return 'Selecting a Category is Required';
    }
    return null;
  }

  productValidator(String product) {
    if (product == null) {
      return 'Selecting a Product is Required';
    } else if (product == 'Product') {
      return 'Selecting a Product is Required';
    }
    return null;
  }

  capacityValidator(String capacity) {
    if (capacity == null) {
      return 'Selecting a Capacity is Required';
    } else if (capacity == 'Capacity') {
      return 'Selecting a Capacity is Required';
    }
    return null;
  }

  makeValidator(String make) {
    if (make == null) {
      return 'Selecting a Make is Required';
    } else if (make == 'Make') {
      return 'Selecting a Make is Required';
    }
    return null;
  }

  modelValidator(String model) {
    if (model == null) {
      return 'Selecting a Model is Required';
    } else if (model == 'Model') {
      return 'Selecting a Model is Required';
    }
    return null;
  }

  yearValidator(String year) {
    if (year == null) {
      return 'Selecting a Year is Required';
    } else if (year == 'Year') {
      // print("selected Category from Top variable is: ${_categoryController.text}");
      return 'Selecting a Year is Required';
    }
    return null;
  }

  //an extracted widget for re-usability.
  Widget customDropdown(
      Map variableMap,
      int index,
      String fieldName,
      List<String> valueList,
      String selectedValue,
      Function(String) fieldValidator,
      [bool isInRow = false]) {
    return Container(
      height: 50,
      width: !isInRow
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width / 2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(2.0, 0.0, 9.0, 0.0),
        child: Row(
          children: [
            // new Icon(Icons.category_outlined),
            Expanded(
              child: Container(
                width: !isInRow
                    ? MediaQuery.of(context).size.width * 0.86
                    : (MediaQuery.of(context).size.width / 2) * 0.70,
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      fillColor: Colors.grey[200],
                      filled: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      )),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey[400],
                  ),
                  isExpanded: true,
                  validator: (val) => fieldValidator(val),
                  hint: Text(
                    fieldName,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                    ),
                  ),
                  value: selectedValue,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      variableMap[index] = newValue;
                      print("new value is $newValue");
                      print("selectedLocation is $selectedValue");
                    });
                  },
                  items: valueList.map((category) {
                    return DropdownMenuItem(
                      child: new Text(category),
                      value: category,
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*a method for checking if the form is validated or not and also which form is validated
  and which isn't*/
  _submitForm() {
    print('inside submitform');
    keyMap.forEach((key, value) {
      print('value in map validaion is: $value with key $key');
      if (value.currentState.validate()) {
        print('Number ${key.toString()} Form validated');
        // If the form passes validation, display a Snackbar.
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Number ${key.toString()} Form Validated')));
      } else {
        print('Number ${key.toString()} Not validated');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Number ${key.toString()} Form Not Validated')));
      }
    });
  }

  int value = 0;

  @override
  Widget build(BuildContext context) {
    /*Listening to the change of value using provider's watch method
    * to make sure that whenever the value is updated the keyMap and all other
    * field value maps are updated accordingly.*/
    final value = context.watch<FormModel>().formList.length;
    if (value > this.value) {
      generateKeyList(false, value);
      this.value = value;
      print(value);
    } else if (value < this.value) {
      print('inside less val value is: $value this.value is: ${this.value}');
      generateKeyList(true, this.value);
      this.value = value;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2A2F35),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        )),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.menu,
            color: Color(0xFFFFBD00),
          ),
        ),
        actions: <Widget>[
          Stack(
            children: [
              Positioned(
                  top: 9,
                  right: 9,
                  child: Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  )),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  FontAwesomeIcons.bell,
                  color: Color(0xFFFFBD00),
                ),
              ),
            ],
          ),
        ],
        title: Center(
            child: Text(
          widget.title,
          style: TextStyle(color: Color(0xFFFFBD00)),
        )),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: Container(
                height: MediaQuery.of(context).size.height - 157.999,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Consumer<FormModel>(
                        builder: (context, form, child) {
                          return ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: form.formList.length,
                              itemBuilder: (context, index) {

                                print('index here is: $index '
                                    'and todo.formList[index] ${form.formList[index]}'
                                    'and keyMap entry is: ${keyMap[index + 1]}'
                                    'and keyMap is $keyMap');
                                return Container(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                // borderRadius: BorderRadius.all(Radius.circular(50)),
                                                color: Color(0xFFFFBD00),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  form.formList[index]
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: Text(
                                                'Add your Equipment here',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Form(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        key: keyMap[index + 1],
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              customDropdown(
                                                  categoryMap,
                                                  index + 1,
                                                  'Select Category',
                                                  categoryList,
                                                  selectedCategory,
                                                  categoryValidator),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              customDropdown(
                                                  productMap,
                                                  index + 1,
                                                  'Product',
                                                  productList,
                                                  selectedProduct,
                                                  productValidator),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              customDropdown(
                                                  capacityMap,
                                                  index + 1,
                                                  'Capacity',
                                                  capacityList,
                                                  selectedCapacity,
                                                  capacityValidator),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              customDropdown(
                                                  makeMap,
                                                  index + 1,
                                                  'Make',
                                                  makeList,
                                                  selectedMake,
                                                  makeValidator),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Flexible(
                                                    child: customDropdown(
                                                        modelMap,
                                                        index + 1,
                                                        'Model',
                                                        modelList,
                                                        selectedModel,
                                                        modelValidator,
                                                        true),
                                                  ),
                                                  // SizedBox(
                                                  //   height: 10,
                                                  // ),
                                                  Flexible(
                                                    child: customDropdown(
                                                        yearMap,
                                                        index + 1,
                                                        'Year',
                                                        yearList,
                                                        selectedYear,
                                                        yearValidator,
                                                        true),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        top: 10,
                                                        left: 8,
                                                        right: 8,
                                                      ),
                                                      child: SizedBox(
                                                        height: 40,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              primary: Colors.grey[200],
                                                              shape: StadiumBorder()),
                                                          onPressed: () {
                                                            getImage();
                                                          },
                                                          child: Text('Add Image',
                                                          style: TextStyle(
                                                              color: Colors.black
                                                          ),),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ],

                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  margin: EdgeInsets.only(
                                      bottom: 8, left: 16, right: 16),
                                );
                              });
                        },
                      ),
                      Consumer<FormModel>(builder: (context, form, child) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: 16,
                                      left: 18,
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: form.formList.length > 1
                                              ? Color(0xFF04BA08)
                                              : Color(0xFFFFBD00),
                                          shape: StadiumBorder()),
                                      onPressed: () {
                                        Provider.of<FormModel>(context,
                                                listen: false)
                                            .addFormNumberInList();
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            size: 14,
                                          ),
                                          Text('Add Equipment'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                if (form.formList.length > 1)
                                  SizedBox(
                                    width: 10,
                                  ),
                                if (form.formList.length > 1)
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: 16,
                                        right: 18,
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.red,
                                            shape: StadiumBorder()),
                                        onPressed: () {
                                          Provider.of<FormModel>(context,
                                                  listen: false)
                                              .removeFormNumberFromList();
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.remove,
                                              size: 14,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Remove Equipment',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 16,
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Color(0xFFFFBD00),
                                        shape: StadiumBorder()),
                                    onPressed: _submitForm,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        ' Submit Equipment',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),

      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), topLeft: Radius.circular(10)),
        child: BottomNavigationBar(
          backgroundColor: Color(0xFF2A2F35),
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.userCircle),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                size: 28,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.briefcase),
              label: 'Jobs',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.exclamationCircle),
              label: 'Support',
            ),
          ],
          selectedItemColor: Color(0xFFFFBD00),
          unselectedItemColor: Colors.white,
        ),
      ),
    );
  }
}
