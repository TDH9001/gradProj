import 'package:flutter/material.dart';
import 'package:grad_proj/services/snackbar_service.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../screen/theme/light_theme.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final TextEditingController? startTimeController;
  final TextEditingController? compareWithController;

  CustomTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    //required this.onChanged,
    required this.controller,
    this.startTimeController,
    this.compareWithController,
  });
  bool isObscure = false;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  var timeData;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    void initstate() {
      super.initState();
      widget.isObscure = widget.isPassword;
    }

    Future<void> _pickStartTime() async {
      TimeOfDay? pickedStartTime = await showTimePicker(
        helpText: "Start Time",
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedStartTime != null) {
        setState(() {
          timeData = pickedStartTime;
          widget.controller.text = pickedStartTime.format(context);
        });
      }
    }

    Future<void> _pickEndTime() async {
      TimeOfDay? pickedEndTime = await showTimePicker(
        helpText: "End Time",
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedEndTime != null) {
        setState(() {
          timeData = pickedEndTime;
          widget.controller.text = pickedEndTime.format(context);
        });
      }
    }

    Future<void> _pickDateTime() async {
      DateTime? pickedDateTime = await showOmniDateTimePicker(
        context: context,
        title: const Text("Temporary schedule's end date"),
      );

      if (pickedDateTime != null) {
        setState(() {
          widget.controller.text = pickedDateTime.toString();
        });
      }
    }

    int _convertTimeToInt(String time) {
      List<String> timeParts = time.split(" ");
      String formattedTime = timeParts[0].replaceAll(":", "");
      int timeInt = int.parse(formattedTime);

      if (timeParts.length > 1 && timeParts[1].contains("PM")) {
        timeInt += 1200; // Convert PM times properly
      }
      return timeInt;
    }

    return TextFormField(
      readOnly: widget.hintText == "Start Time" ||
          widget.hintText == "End Time" ||
          widget.hintText == "End Date",
      obscureText: widget.isObscure,
      controller: widget.controller,
      autocorrect: false,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
        filled: true,
        fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: LightTheme.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: LightTheme.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: LightTheme.primary,
          ),
        ),
        //contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    widget.isObscure = !widget.isObscure;
                  });
                },
                icon: widget.isObscure
                    ? const Icon(
                        Icons.visibility_off,
                        color: LightTheme.primary,
                      )
                    : const Icon(
                        Icons.visibility,
                        color: LightTheme.primary,
                      ),
              )
            : null,
        prefixIcon: (widget.hintText == "Start Time" ||
                widget.hintText == "تاريخ الانتهاء" ||
                widget.hintText == "End Date" ||
                widget.hintText == "وقت النهاية" ||
                widget.hintText == "End Time" ||
                widget.hintText == "وقت البداية")
            ? IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.grey),
                onPressed: () {
                  if (widget.hintText == "Start Time" ||
                      widget.hintText == "وقت البداية") {
                    _pickStartTime();
                  } else if (widget.hintText == "End Time" ||
                      widget.hintText == "وقت النهاية") {
                    _pickEndTime();
                  } else if (widget.hintText == "End Date" ||
                      widget.hintText == "تاريخ الانتهاء") {
                    _pickDateTime();
                  }
                },
              )
            : null,
      ),
      validator: (data) {
        final emailRegex = RegExp(r'^[\w.-]+@[a-zA-Z\d.-]+\.[a-zA-Z]{2,}$');
        if (widget.hintText.contains("Email") ||
            widget.hintText.contains("البريد الإلكتروني") ||
            widget.hintText.contains("البريد الإلكتروني") ||
            widget.hintText.contains("email")) {
          if (data == null || data.trim().isEmpty) {
            return "empty field";
          } else if (!data.trim().contains("@")) {
            return "the email must contain an '@' symbol";
          } else if (data.trim().indexOf("@") != data.trim().lastIndexOf("@")) {
            return "you can only contain one instance of '@' in your email";
          } else if (!emailRegex.hasMatch(data.trim())) {
            return "Invalid email format, it should be similar to 'test@example.com'";
          } else if (data.trim().toLowerCase() ==
                  "mohamedyehia707@gmail.com".toLowerCase() ||
              data.trim().toLowerCase() ==
                  "thedragonheart9001@gmail.com".toLowerCase() ||
              data.trim().toLowerCase() == "jamesH@gmail.com".toLowerCase() ||
              data.trim().toLowerCase() ==
                  "sciConnect1@outlook.com".toLowerCase() ||
              data.trim().toLowerCase() ==
                  "sciConnect2@outlook.com".toLowerCase() ||
              data.trim().toLowerCase() ==
                  "sciConnect3@outlook.com".toLowerCase()) {
            SnackBarService.instance.showsSnackBarSucces(text: "welcome admin");
            return null;
          } else if (!data
              .trim()
              .toLowerCase()
              .contains("@sci.asu.edu.eg".trim())) {
            return "requires academic email adress";
          } else {
            return null;
          }
          // Valid email
        }
        // else if (widget.hintText.contains("Email1") ||
        //     widget.hintText.contains("email1")) {
        //   if (data == null || data.trim().isEmpty) {
        //     return "empty field";
        //   } else if (!data.trim().contains("@")) {
        //     return "the email must contain an '@' symbol";
        //   } else if (data.trim().indexOf("@") != data.trim().lastIndexOf("@")) {
        //     return "you can only contain one instance of '@' in your email";
        //   } else if (!emailRegex.hasMatch(data.trim())) {
        //     return "Invalid email format, it should be similar to 'test@example.com'";
        //   } else {
        //     return null;
        //   }
        //   // Valid email
        // }
        else if (widget.hintText.contains("Confirm Password") ||
            widget.hintText.contains("تأكيد كلمة المرور")) {
          if (data == null || data.trim().isEmpty) {
            return "Password cannot be empty.";
          } else if (widget.compareWithController != null &&
              widget.compareWithController!.text.trim() != data.trim()) {
            return "Passwords do not match.";
          }
          if (data.trim().length < 8) {
            return "Password must be at least 8 characters long.";
          }
          final upperCase = RegExp(r'[A-Z]');
          final lowerCase = RegExp(r'[a-z]');
          final number = RegExp(r'\d');
          final specialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
          if (!upperCase.hasMatch(data.trim())) {
            return "Password must include an uppercase letter.";
          }
          if (!lowerCase.hasMatch(data.trim())) {
            return "Password must include a lowercase letter.";
          }
          if (!number.hasMatch(data.trim())) {
            return "Password must include a number.";
          }
          if (!specialChar.hasMatch(data.trim())) {
            return "Password must include a special character.";
          } else {
            return null;
          } //
        } else if (widget.hintText.contains("Password") ||
            widget.hintText.contains("كلمة المرور")) {
          if (data == null || data.trim().isEmpty) {
            return "Password cannot be empty.";
          }
          if (data.trim().length < 8) {
            return "Password must be at least 8 characters long.";
          }
          final upperCase = RegExp(r'[A-Z]');
          final lowerCase = RegExp(r'[a-z]');
          final number = RegExp(r'\d');
          final specialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
          if (!upperCase.hasMatch(data.trim())) {
            return "Password must include an uppercase letter.";
          }
          if (!lowerCase.hasMatch(data.trim())) {
            return "Password must include a lowercase letter.";
          }
          if (!number.hasMatch(data.trim())) {
            return "Password must include a number.";
          }
          if (!specialChar.hasMatch(data.trim())) {
            return "Password must include a special character.";
          } else {
            return null;
          } // Valid password
        } else if (widget.hintText == "First Name" ||
            widget.hintText == "الاسم الأول" ||
            widget.hintText == "الاسم الأخير" ||
            widget.hintText == "Last Name") {
          if (data == null || data.trim().isEmpty) {
            return "empty field";
          } else if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(data)) {
            return 'Name can only contain letters and spaces.';
          } else if (data.length < 2) {
            return 'Name must be at least 2 characters long.';
          } else if (data.length > 50) {
            return 'Name must not exceed 50 characters.';
          }
        } else if (widget.hintText == "Phone Number" ||
            widget.hintText == "رقم الهاتف") {
          if (data == null || data.trim().isEmpty) {
            return 'Phone number cannot be empty.';
          }
          // Check if the input contains only digits
          if (!RegExp(r'^\d+$').hasMatch(data)) {
            return 'Phone number must contain only digits.';
          }
          // Optional: Enforce length constraints
          if (data.length != 11) {
            return 'Phone number must be exactly 11 digits long.';
          }
          return null; // Valid input
        } else if (widget.hintText == "Academic Year") {
          if (data == null || data.trim().isEmpty) {
            return 'Phone number cannot be empty.';
          }
          if (!RegExp(r'^\d+$').hasMatch(data)) {
            return 'Year number must contain digits.';
          }
          if (data.trim().length > 1) {
            return 'year must contain only digits.';
          }
        } else if (widget.hintText == "Start Time" ||
            widget.hintText == "End Date" ||
            widget.hintText == "End Time") {
          if (widget.hintText == "End Time") {
            if (data == null || data.trim().isEmpty) {
              return "End time cannot be empty.";
            }

            // Get start time from controller
            String? startTimeText = widget.startTimeController?.text;
            if (startTimeText == null || startTimeText.trim().isEmpty) {
              return "Please select a start time first.";
            }

            // Convert Start Time & End Time to comparable integers
            int startTimeInt = _convertTimeToInt(startTimeText);
            int endTimeInt = _convertTimeToInt(data);

            if (endTimeInt < startTimeInt) {
              return "End time cannot be before start time.";
            }
          } else if (widget.hintText == "End Date") {
            if (data == null || data.trim().isEmpty) {
              return "end date can not be empty";
            } else if (DateTime.parse(data).isBefore(DateTime.now())) {
              return "the end date can not be earlier than the current date";
            }
          }
          return null;
        } else if (widget.hintText == "scedule Name" ||
            widget.hintText == "location") {
          if (data == null || data.trim().isEmpty) {
            return "${widget.hintText} can not be empty ";
          }
        }
        // if (widget.hintText == "day") {
        //   if (int.parse(data.toString().trim()) > 6) {
        //     return "number must be lower than or =6";
        //   }
        // } //username , phone , etc
      },
    );
  }
}
