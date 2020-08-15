import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/auth/auth_provider.dart';
import 'package:motel/viewmodels/profile_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VmProvider<ProfileVm>(
      vm: ProfileVm(),
      builder: (context, vm, appUser) {
        return SafeArea(
          child: vm.isUpdatingData
              ? Center(
                  child: Lottie.asset('assets/lottie/loading.json'),
                )
              : Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        _appbarBuilder(context),
                        _userImgBuilder(context, vm, appUser),
                        SizedBox(
                          height: 20.0,
                        ),
                        _nameBuilder(appUser),
                        SizedBox(
                          height: 40.0,
                        ),
                        _editProfileSection(context, appUser, vm),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _nameBuilder(AppUser appUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        '${appUser.firstName} ${appUser.lastName}',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 22.0,
        ),
      ),
    );
  }

  Widget _appbarBuilder(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () => AuthProvider().logOut(),
        ),
      ],
    );
  }

  Widget _userImgBuilder(BuildContext context, ProfileVm vm, AppUser appUser) {
    final _width = MediaQuery.of(context).size.width * 0.50;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: <Widget>[
            vm.imgFile != null
                ? Container(
                    width: _width,
                    height: _width,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 13.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(2.0, 10.0),
                            blurRadius: 20.0,
                            color: Colors.black12)
                      ],
                      image: DecorationImage(
                        image: FileImage(
                          vm.imgFile,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : appUser.photoUrl == null
                    ? Container(
                        width: _width,
                        height: _width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 13.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(2.0, 10.0),
                                blurRadius: 20.0,
                                color: Colors.black12)
                          ],
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/svgs/upload_img.svg',
                            width: _width,
                            height: _width,
                          ),
                        ),
                      )
                    : Container(
                        width: _width,
                        height: _width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 13.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(2.0, 10.0),
                                blurRadius: 20.0,
                                color: Colors.black12)
                          ],
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              appUser.photoUrl,
                            ),
                          ),
                        ),
                      ),
            Positioned(
              bottom: 0.0,
              right: 0.0,
              child: Container(
                width: 50.0,
                height: 50.0,
                child: FloatingActionButton(
                  child: Center(
                    child: Icon(Icons.photo_camera),
                  ),
                  backgroundColor: Color(0xff45ad90),
                  onPressed: () async {
                    vm.selectImage(appUser);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _editProfileSection(
      BuildContext context, AppUser appUser, ProfileVm vm) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        _editProfileItem(
          context,
          'Email',
          appUser.email,
          TextInputType.emailAddress,
          null,
          vm.updateData,
          appUser,
        ),
        _editProfileItem(
          context,
          'Phone',
          appUser.phone.toString(),
          TextInputType.phone,
          vm.phoneController,
          vm.updateData,
          appUser,
        ),
        _editProfileItem(
          context,
          'Date of birth',
          appUser.dob == 0 ? 'N/A' : appUser.dob.toString(),
          TextInputType.datetime,
          vm.dobController,
          vm.updateData,
          appUser,
        ),
        _editProfileItem(
          context,
          'Address',
          appUser.address,
          TextInputType.text,
          vm.addressController,
          vm.updateData,
          appUser,
        ),
      ],
    );
  }

  Widget _editProfileItem(
    BuildContext context,
    final String title,
    final String value,
    final TextInputType type,
    final TextEditingController controller,
    final Function sendData,
    final AppUser appUser,
  ) {
    return GestureDetector(
      onTap: () {
        if (title != 'Email') {
          _showEditDialog(context, title, type, controller, sendData, appUser);
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black38,
                          fontSize: 12.0,
                        ),
                      ),
                      if (title != 'Email')
                        SizedBox(
                          width: 5.0,
                        ),
                      if (title != 'Email')
                        Icon(
                          Icons.edit,
                          size: 14.0,
                          color: Colors.black38,
                        ),
                    ],
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }

  Future _showEditDialog(
    BuildContext context,
    final String title,
    final TextInputType type,
    final TextEditingController controller,
    final Function sendData,
    final AppUser appUser,
  ) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${title.toLowerCase()}'),
        content: TextFormField(
          keyboardType: type,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: title != 'Address'
                ? 'New ${title.toLowerCase()}'
                : 'New Street, City, Country',
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xff45ad90),
              ),
            ),
          ),
          controller: controller,
        ),
        actions: <Widget>[
          MaterialButton(
            textColor: Colors.red,
            child: Text(
              'Cancel',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          MaterialButton(
            textColor: Color(0xff45ad90),
            child: Text(
              'Save',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              String _key;
              switch (title.toLowerCase()) {
                case 'phone':
                  _key = 'phone';
                  break;
                case 'date of birth':
                  _key = 'dob';
                  break;
                case 'address':
                  _key = 'address';
                  break;
                default:
                  _key = '';
              }
              final Map<String, dynamic> _data = {
                _key: _key == 'address'
                    ? controller.text.trim()
                    : int.parse(controller.text.trim()),
              };
              sendData(_data, appUser);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
