import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/model/register/addressuser.dart';
import 'package:fridayonline/service/address/address.dart';
import 'package:fridayonline/service/address/serviceaddress.dart';
import 'package:flutter/material.dart';
export 'package:flutter/services.dart';

class Searchaddress extends StatefulWidget {
  const Searchaddress({super.key});

  @override
  State<Searchaddress> createState() => _SearchaddressState();
}

class _SearchaddressState extends State<Searchaddress> {
  bool isLoading = false;
  late TextEditingController controller;
  final List<Address> _userOptions = [];

  static String _displayStringForOption(Address option) => option.name;

  Future fetchAutoCompleteData() async {
    Addressuser addresslist = await GetAddresslocation();
    setState(() {
      isLoading = true;

      List<Datum> listaddress = addresslist.data;
      //   log('5555555555555');
      for (var element in listaddress) {
        // ประกาศตัวแปลเพื่อที่จะทำการ List ข้อมูลของระบบ
        String lsprovince;
        String lsprovinceID;
        String lspostCode;
        String lsAmphur;
        String lsAmphurID;
        String lstumbon;
        String lstumbonID;
        List<Item> item = element.item;
        String nameaddredd;
        lsprovince = element.province.toString();
        lsprovinceID = element.provinceCode.toString();

        for (var element in item) {
          lsAmphur = element.amphur.toString();
          lsAmphurID = element.amphurCode.toString();
          for (var element in element.tumbon) {
            lstumbon = element[0].toString();
            lspostCode = element[1].toString();
            lstumbonID = element[2].toString();
            nameaddredd =
                '${element[0]} $lsAmphur $lsprovince'; //? กรณีที่ไม่ใช้เลข รหัสไปรษณีย์
            // nameaddredd = '${element[0]} $lsAmphur $lsprovince ${element[1]}';//? กรณีที่ใช้เลข รหัสไปรษณีย์

            // กรณีที่ทำการ Add Object
            _userOptions.add(Address(
                name: nameaddredd,
                tumbon: lstumbon,
                tumbonID: lstumbonID,
                amphur: lsAmphur,
                amphurID: lsAmphurID,
                province: lsprovince,
                provinceID: lsprovinceID,
                postCode: lspostCode));
          }
        }
      }
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAutoCompleteData();
    // GetlocationData();
  }

  // void GetlocationData() async {
  //   // กรณีที่ทำการ Get Data
  //   Addressuser addresslist = await GetAddresslocation();
  //   // log(addresslist.data.length.toString());

  //   List<Datum> listaddress = addresslist.data;

  //   // กรณีที่ทำการ Set Data
  //   setState(() {
  //     // ดูก่อนว่ามี Data กี่ตัวก่อน

  //     listaddress.forEach((element) {
  //       // String lsprovince;
  //       // String Amphur;
  //       // List<Item> item = element.item;

  //       // lsprovince = element.province.toString();
  //       // for (var element in item) {
  //         // Amphur = element.amphur.toString();
  //         // for (var element in element.tumbon) {
  //           // log(element[0].toString() +
  //           //     ' >> ' +
  //           //     Amphur +
  //           //     ' >> ' +
  //           //     lsprovince +
  //           //     ' >> ' +
  //           //     element[1].toString());
  //         // }
  //       // }
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        // iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: theme_color_df,
        title: const Text(
          "ระบุที่อยู่ในการจัดส่งสินค้า",
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'notoreg',
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: isLoading
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Autocomplete<Address>(
                      displayStringForOption: _displayStringForOption,
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        try {
                          if (textEditingValue.text == '') {
                            return const Iterable<Address>.empty();
                          }

                          return _userOptions.where((Address option) {
                            return option
                                .toString()
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        } catch (e) {
                          //   log('003'+textEditingValue.text.toString());
                          return const Iterable<Address>.empty();
                        }
                      },
                      optionsViewBuilder:
                          (context, Function(Address) onSelected, options) {
                        return Material(
                          // elevation: 2,
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              //   log('AAAA');
                              final option = options.elementAt(index);
                              //   log('0001');
                              return Card(
                                child: ListTile(
                                  // title: Text(option.toString()),
                                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),

                                  leading: const Icon(Icons.home),
                                  title: Text(option.name),
                                  //  subtitle: Text("This is subtitle"),
                                  onTap: () {
                                    //onSelected(option.name.toString());
                                    //log('Mess001');
                                    Navigator.of(context).pop(option);
                                  },
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: options.length,
                          ),
                        );
                      },
                      onSelected: (selectedString) {
                        // print(selectedString);
                        //log('Mess002');
                      },
                      fieldViewBuilder:
                          (context, controller, focusNode, onEditingComplete) {
                        this.controller = controller;
                        return TextFormField(
                          //  maxLines: 1,
                          controller: controller,
                          focusNode: focusNode,
                          onEditingComplete: onEditingComplete,

                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'notoreg',
                          ),

                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            hintText:
                                "พิมพ์ชื่อ ตำบล อำเภอ จังหวัด หรือรหัสไปรษณีย์",
                            hintStyle: const TextStyle(fontSize: 15),
                            prefixIcon: const Icon(Icons.search),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 150.0,
                    ),
                    // Container(
                    //   child: Center(
                    //     child: Column(
                    //       children: [
                    //         Image.asset(
                    //           "assets/images/logo/locationdata.jpg",
                    //           height: 150,
                    //           width: 150,
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
      ),
    );
  }
}
