import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../cores/constants/colors.dart';
import '../cores/constants/text_styles.dart';
import '../cores/auth/auth_services.dart';
import '../custom_widget_library/animated_button.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  String _headingText = 'Sign In';
  bool _isSignIn = true;
  late TextEditingController _usernameTextController;
  late TextEditingController _passwordTextController;
  late TextEditingController _confirmPasswordTextController;
  late TextEditingController _fullNameTextController;
  late TextEditingController _emailTextController;
  late TextEditingController _heightTextController;
  late TextEditingController _weightTextController;

  DateTime? _selectedDate;

  Future<void> pickDOB(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2005),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _selectedDate = picked;
    }
  }

  String? _selectedGender = 'Male';

  void _showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsetsGeometry.symmetric(horizontal: 40, vertical: 40),
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 14),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text(
          msg,
          style: AppTextStyle.primaryText.copyWith(color: Color(0xFF000000)),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _usernameTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    _confirmPasswordTextController = TextEditingController();
    _fullNameTextController = TextEditingController();
    _emailTextController = TextEditingController();
    _heightTextController = TextEditingController();
    _weightTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final palette = Theme.of(context).extension<AppPalette>()!;

    // TODO: implement build
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(_headingText),
        titleTextStyle: GoogleFonts.nunito(
          textStyle: TextStyle(
            color: palette.headingBlueText,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.transparent,
        toolbarHeight: 50,
        elevation: 0,
        scrolledUnderElevation: 0,

        // automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 16,
            width: 16,
            margin: EdgeInsetsGeometry.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: Color(0xFFD9EEFF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_ios_rounded,
              size: 24,
              color: Color(0xFF393939),
            ),
          ),
        ),
        // flexibleSpace: IconButton(onPressed: () {}, icon: Icon(Icons.person))
      ),

      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              palette.topGradient2,
              palette.midGradient2,
              palette.midGradient2,
              palette.bottomGradient2,
            ],
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 110, width: screenWidth),
                Container(
                  height: screenHeight - 120,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // SizedBox(height: 110, width: screenWidth),
                        // // Dashboard(),
                        // SizedBox(height: 40),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsetsGeometry.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          // padding: EdgeInsetsGeometry.symmetric(
                          //   horizontal: 20,
                          //   vertical: 20,
                          // ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFAAAAAA),
                                offset: Offset(1, 1),
                                spreadRadius: 0,
                                blurRadius: 1,
                              ),
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.0, 0.3, 0.7, 1.0],
                              colors: [
                                Color(0xFF6DBDF6),
                                Colors.white,
                                Colors.white,
                                Color(0xFFE59FF6),
                              ],
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(30),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                              child: Container(
                                padding: EdgeInsetsGeometry.symmetric(
                                  horizontal: 20,
                                  vertical: 20,
                                ),
                                child: Column(
                                  spacing: 16,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      spacing: 5,
                                      children: [
                                        Text(
                                          '  '
                                          'Username',
                                        ),
                                        TextField(
                                          controller: _usernameTextController,
                                          // style: AppTextStyle.primaryText.copyWith(
                                          //   fontWeight: FontWeight.w900,
                                          // ),
                                          // autofocus: true,
                                          onTapOutside: (_) {
                                            FocusScope.of(context).unfocus();
                                          },
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsetsGeometry.symmetric(
                                                  vertical: 16,
                                                  horizontal: 30,
                                                ),
                                            prefixIcon: Icon(Icons.person),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              borderSide: BorderSide(
                                                color: Color(0xFF0D35B5),
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              borderSide: BorderSide(
                                                color: Color(0xFF777777),
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              borderSide: BorderSide(
                                                color: Color(0x98ED0F0F),
                                              ),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  borderSide: BorderSide(
                                                    color: Color(0x98ED0F0F),
                                                  ),
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (!_isSignIn)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        spacing: 5,
                                        children: [
                                          Text(
                                            '  '
                                            'Full name',
                                          ),
                                          TextField(
                                            controller: _fullNameTextController,
                                            // style: AppTextStyle.primaryText.copyWith(
                                            //   fontWeight: FontWeight.w900,
                                            // ),
                                            // autofocus: true,
                                            onTapOutside: (_) {
                                              FocusScope.of(context).unfocus();
                                            },
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsetsGeometry.symmetric(
                                                    vertical: 16,
                                                    horizontal: 30,
                                                  ),
                                              prefixIcon: Icon(
                                                Icons.person_pin_outlined,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                borderSide: BorderSide(
                                                  color: Color(0xFF0D35B5),
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                borderSide: BorderSide(
                                                  color: Color(0xFF777777),
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                borderSide: BorderSide(
                                                  color: Color(0x98ED0F0F),
                                                ),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                    borderSide: BorderSide(
                                                      color: Color(0x98ED0F0F),
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (!_isSignIn)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        spacing: 5,
                                        children: [
                                          Text(
                                            '  '
                                            'Email',
                                          ),
                                          TextField(
                                            controller: _emailTextController,
                                            // style: AppTextStyle.primaryText.copyWith(
                                            //   fontWeight: FontWeight.w900,
                                            // ),
                                            // autofocus: true,
                                            onTapOutside: (_) {
                                              FocusScope.of(context).unfocus();
                                            },
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsetsGeometry.symmetric(
                                                    vertical: 16,
                                                    horizontal: 30,
                                                  ),
                                              prefixIcon: Icon(
                                                Icons.email_outlined,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                borderSide: BorderSide(
                                                  color: Color(0xFF0D35B5),
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                borderSide: BorderSide(
                                                  color: Color(0xFF777777),
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                borderSide: BorderSide(
                                                  color: Color(0x98ED0F0F),
                                                ),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                    borderSide: BorderSide(
                                                      color: Color(0x98ED0F0F),
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (!_isSignIn)
                                      Row(
                                        spacing: 20,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            spacing: 5,
                                            children: [
                                              Text(
                                                '  '
                                                'Date of birth',
                                              ),

                                              GestureDetector(
                                                onTap: () async {
                                                  await pickDOB(context);
                                                },

                                                child: Container(
                                                  // width: screenWidth,
                                                  padding: EdgeInsets.all(16),

                                                  decoration: BoxDecoration(
                                                    border: Border.all(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),

                                                  child: Text(
                                                    _selectedDate == null
                                                        ? "Select DOB"
                                                        : "${_selectedDate!.day}/"
                                                              "${_selectedDate!.month}/"
                                                              "${_selectedDate!.year}",
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              spacing: 4,
                                              children: [
                                                Text(
                                                  '  '
                                                  'Gender',
                                                ),
                                                // Expanded(
                                                // child:
                                                DropdownButtonFormField<String>(
                                                  initialValue: _selectedGender,

                                                  decoration: InputDecoration(
                                                    // labelText: "Gender",
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                  ),

                                                  items:
                                                      [
                                                            "Male",
                                                            "Female",
                                                            "Other",
                                                          ]
                                                          .map(
                                                            (gender) =>
                                                                DropdownMenuItem(
                                                                  value: gender,

                                                                  child: Text(
                                                                    gender,
                                                                  ),
                                                                ),
                                                          )
                                                          .toList(),

                                                  onChanged: (value) {
                                                    if (value != null) {
                                                      setState(() {
                                                        _selectedGender = value;
                                                      });
                                                    }
                                                  },
                                                ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (!_isSignIn)
                                      Row(
                                        spacing: 20,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              spacing: 5,
                                              children: [
                                                Text(
                                                  '  '
                                                  'Height',
                                                ),
                                                TextField(
                                                  controller:
                                                      _heightTextController,
                                                  // style: AppTextStyle.primaryText.copyWith(
                                                  //   fontWeight: FontWeight.w900,
                                                  // ),
                                                  // autofocus: true,
                                                  onTapOutside: (_) {
                                                    FocusScope.of(
                                                      context,
                                                    ).unfocus();
                                                  },
                                                  maxLength: 3,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsetsGeometry.symmetric(
                                                          vertical: 16,
                                                          horizontal: 30,
                                                        ),
                                                    prefixIcon: Icon(
                                                      Icons.height,
                                                    ),
                                                    suffixText: 'cm',
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                16,
                                                              ),
                                                          borderSide:
                                                              BorderSide(
                                                                color: Color(
                                                                  0xFF0D35B5,
                                                                ),
                                                              ),
                                                        ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                16,
                                                              ),
                                                          borderSide:
                                                              BorderSide(
                                                                color: Color(
                                                                  0xFF777777,
                                                                ),
                                                              ),
                                                        ),
                                                    errorBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            16,
                                                          ),
                                                      borderSide: BorderSide(
                                                        color: Color(
                                                          0x98ED0F0F,
                                                        ),
                                                      ),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                16,
                                                              ),
                                                          borderSide:
                                                              BorderSide(
                                                                color: Color(
                                                                  0x98ED0F0F,
                                                                ),
                                                              ),
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              spacing: 5,
                                              children: [
                                                Text(
                                                  '  '
                                                  'Weight',
                                                ),
                                                TextField(
                                                  controller:
                                                      _weightTextController,
                                                  // style: AppTextStyle.primaryText.copyWith(
                                                  //   fontWeight: FontWeight.w900,
                                                  // ),
                                                  // autofocus: true,
                                                  onTapOutside: (_) {
                                                    FocusScope.of(
                                                      context,
                                                    ).unfocus();
                                                  },
                                                  maxLength: 3,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsetsGeometry.symmetric(
                                                          vertical: 16,
                                                          horizontal: 30,
                                                        ),
                                                    // prefixIcon: Icon(Icons.),
                                                    suffixText: 'kg',
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                16,
                                                              ),
                                                          borderSide:
                                                              BorderSide(
                                                                color: Color(
                                                                  0xFF0D35B5,
                                                                ),
                                                              ),
                                                        ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                16,
                                                              ),
                                                          borderSide:
                                                              BorderSide(
                                                                color: Color(
                                                                  0xFF777777,
                                                                ),
                                                              ),
                                                        ),
                                                    errorBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            16,
                                                          ),
                                                      borderSide: BorderSide(
                                                        color: Color(
                                                          0x98ED0F0F,
                                                        ),
                                                      ),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                16,
                                                              ),
                                                          borderSide:
                                                              BorderSide(
                                                                color: Color(
                                                                  0x98ED0F0F,
                                                                ),
                                                              ),
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      spacing: 5,
                                      children: [
                                        Text(
                                          '  '
                                          'Password',
                                        ),
                                        TextField(
                                          controller: _passwordTextController,
                                          // style: AppTextStyle.primaryText.copyWith(
                                          //   fontWeight: FontWeight.w900,
                                          // ),
                                          // autofocus: true,
                                          obscureText: true,
                                          onTapOutside: (_) {
                                            FocusScope.of(context).unfocus();
                                          },
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsetsGeometry.symmetric(
                                                  vertical: 16,
                                                  horizontal: 30,
                                                ),
                                            prefixIcon: Icon(Icons.key_rounded),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              borderSide: BorderSide(
                                                color: Color(0xFF0D35B5),
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              borderSide: BorderSide(
                                                color: Color(0xFF777777),
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              borderSide: BorderSide(
                                                color: Color(0x98ED0F0F),
                                              ),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  borderSide: BorderSide(
                                                    color: Color(0x98ED0F0F),
                                                  ),
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (!_isSignIn)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        spacing: 5,
                                        children: [
                                          Text(
                                            '  '
                                            'Confirm password',
                                          ),
                                          TextField(
                                            controller:
                                                _confirmPasswordTextController,
                                            // style: AppTextStyle.primaryText.copyWith(
                                            //   fontWeight: FontWeight.w900,
                                            // ),
                                            // autofocus: true,
                                            obscureText: true,
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            onTapOutside: (_) {
                                              FocusScope.of(context).unfocus();
                                            },
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsetsGeometry.symmetric(
                                                    vertical: 16,
                                                    horizontal: 30,
                                                  ),
                                              prefixIcon: Icon(
                                                Icons.key_rounded,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                borderSide: BorderSide(
                                                  color: Color(0xFF0D35B5),
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                borderSide: BorderSide(
                                                  color: Color(0xFF777777),
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                borderSide: BorderSide(
                                                  color: Color(0x98ED0F0F),
                                                ),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                    borderSide: BorderSide(
                                                      color: Color(0x98ED0F0F),
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
                          ),
                        ),

                        SizedBox(height: 10),

                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isSignIn = _isSignIn ? false : true;
                              if (_isSignIn) {
                                _headingText = 'sign in';
                              } else {
                                _headingText = 'register';
                              }
                            });
                          },
                          child: Text(
                            _isSignIn
                                ? 'Create new account'
                                : 'Already have an account - sign in',
                          ),
                        ),

                        SizedBox(height: 10),

                        AnimatedButton(
                          onTap: () async {
                            if (_usernameTextController.text.isEmpty) {
                              _showSnackBar(
                                context,
                                'Enter username (mandatory field)',
                              );
                              return;
                            }
                            if (!_isSignIn) {
                              if (_passwordTextController.text.length < 8) {
                                _showSnackBar(
                                  context,
                                  'password must have at least 8 character',
                                );
                                return;
                              } else if (_passwordTextController.text !=
                                  _confirmPasswordTextController.text) {
                                _showSnackBar(context, 'password mismatch');
                                return;
                              }
                            }

                            final response = _isSignIn
                                ? await AuthServices().login(
                                    username: _usernameTextController.text,
                                    password: _passwordTextController.text,
                                  )
                                : await AuthServices().register(
                                    username: _usernameTextController.text,
                                    password: _passwordTextController.text,
                                    email: _emailTextController.text,
                                    fullName: _fullNameTextController.text,
                                    height: double.parse(
                                      _heightTextController.text,
                                    ),
                                    weight: double.parse(
                                      _weightTextController.text,
                                    ),
                                    age: _selectedDate == null
                                        ? null
                                        : DateTime.now().year -
                                              _selectedDate!.year,
                                    gender: _selectedGender?.toLowerCase(),
                                  );

                            if (!context.mounted) return;

                            _showSnackBar(context, response['message']);
                            // print(
                            //   '/////////// ${response['message']} ////////////',
                            // );
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(
                            //     margin: EdgeInsetsGeometry.symmetric(
                            //       horizontal: 40,
                            //       vertical: 40,
                            //     ),
                            //     padding: EdgeInsetsGeometry.symmetric(
                            //       horizontal: 20,
                            //       vertical: 14,
                            //     ),
                            //     behavior: SnackBarBehavior.floating,
                            //     backgroundColor: Colors.white,
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(14),
                            //     ),
                            //     content: Text(
                            //       response['message'],
                            //       style: AppTextStyle.primaryText.copyWith(
                            //         color: Color(0xFF000000),
                            //       ),
                            //     ),
                            //   ),
                            // );

                            if (response['status_ok']) {
                              Navigator.pop(context, true);
                            }
                          },
                          height: 54,
                          width: screenWidth / 2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFAAAAAA),
                                offset: Offset(1, 1),
                                spreadRadius: 0,
                                blurRadius: 1,
                              ),
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.0, 0.3, 0.7, 1.0],
                              colors: [
                                Color(0xFF6DBDF6),
                                Colors.white,
                                Colors.white,
                                Color(0xFF987AF3),
                              ],
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(30),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                              child: SizedBox(
                                height: screenHeight,
                                width: screenWidth,
                                child: Center(
                                  child: Text(
                                    _headingText,
                                    style: AppTextStyle.heading5.copyWith(
                                      color: Color(0xFF0D2968),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 180),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
