import 'package:fridayonline/model/address/address_list.dart';
import 'package:fridayonline/model/address/address_show.dart';
import 'package:fridayonline/model/address/response_update_address.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/address/address_service.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  SetData data = SetData();
  AddressList? addressAll;
  AddressShow? addressShow;
  AddressList? addressList1;
  AddressList? addressList3;
  Datum? addressMslSaveOrder = Datum(
    msladdrId: 0,
    repSeq: 0,
    addrtype: '',
    seqno: 0,
    shortName: '',
    addrline1: '',
    addrline2: '',
    tumbonId: '',
    addrline3: '',
    tumbonCode: '',
    tumbonName: '',
    amphurId: '',
    amphurCode: '',
    amphurName: '',
    provinceId: '',
    provinceCode: '',
    provinceName: '',
    postalCode: '',
    mobileNo: '',
    mobile2: '',
    faxNo: '',
    deliverContact: '',
    headoffice: '',
    deliveryNote: '',
    branch: '',
    enduserId: '',
    defaultFlag: '',
  );
  var isDataLoading = false.obs;
  String? repName;

  ResponseUpdateAddress? response;
  var isDataLoadingUpdate = false.obs;

  getAddressData() async {
    repName = await data.repName;
    try {
      isDataLoading(true);
      addressShow = await callAddressShow();
      addressList1 = await callAddressList1();
      addressList3 = await callAddressList3();
    } finally {
      update();
      isDataLoading(false);
    }
  }

  fetchAddressSaveOrder() async {
    try {
      isDataLoading(true);
      addressAll = await callAddressListAll();
      repName = await data.repName;
      if (addressAll!.data.isNotEmpty) {
        addressMslSaveOrder = addressAll!.data[0];
      }
    } finally {
      update();
      isDataLoading(false);
    }
  }

  setAddressSaveOrder(address) {
    addressMslSaveOrder = address;
    update();
  }

  saveAddressMsl(address1, address2, amphurCode, defaultFlag, note, contactName,
      mobileNo, tumbonCode, provinceCode, postalCode) async {
    try {
      isDataLoadingUpdate(true);
      response = await callSaveAddressMsl(
          address1,
          address2,
          amphurCode,
          defaultFlag,
          note,
          contactName,
          mobileNo,
          tumbonCode,
          provinceCode,
          postalCode);
    } finally {
      getAddressData();
      update();
      isDataLoadingUpdate(false);
    }
  }

  updateAddressMsl(addressId, address1, address2, amphurCode, defaultFlag, note,
      contactName, mobileNo, tumbonCode, provinceCode, postalCode) async {
    try {
      isDataLoadingUpdate(true);
      response = await callUpdateAddressMsl(
          addressId,
          address1,
          address2,
          amphurCode,
          defaultFlag,
          note,
          contactName,
          mobileNo,
          tumbonCode,
          provinceCode,
          postalCode);
    } finally {
      getAddressData();
      update();
      isDataLoadingUpdate(false);
    }
  }

  deleteAddressMsl(addressId) async {
    try {
      isDataLoadingUpdate(true);
      response = await callDeleteAddressMsl(addressId);
    } finally {
      getAddressData();
      update();
      isDataLoadingUpdate(false);
    }
  }
}
