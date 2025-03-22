import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import '../UI/colors.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final TextEditingController? startTimeController;

  CustomTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    //required this.onChanged,
    required this.controller,
    this.startTimeController,
  });
  bool isObscure = false;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  var timeData;
  @override
  Widget build(BuildContext context) {
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
      // enabled: widget.hintText == "Start Time" ||
      //         widget.hintText == "Start Time" ||
      //         widget.hintText == "End Date"
      //     ? false
      //     : true,
      readOnly: widget.hintText == "Start Time" ||
          widget.hintText == "End Time" ||
          widget.hintText == "End Date",
      obscureText: widget.isObscure,
      controller: widget.controller,
      autocorrect: false,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20, 10.0, 20.0, 10.0),
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(60),
          borderSide: const BorderSide(color: ColorsApp.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(60),
          borderSide: const BorderSide(color: ColorsApp.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(60),
          borderSide: const BorderSide(
            color: ColorsApp.primary,
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
                        color: Colors.black,
                      )
                    : const Icon(
                        Icons.visibility,
                        color: Colors.black,
                      ),
              )
            : null,
        prefixIcon: (widget.hintText == "Start Time" ||
                widget.hintText == "End Date" ||
                widget.hintText == "End Time")
            ? IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.black),
                onPressed: () {
                  if (widget.hintText == "Start Time") {
                    _pickStartTime();
                  } else if (widget.hintText == "End Time") {
                    _pickEndTime();
                  } else if (widget.hintText == "End Date") {
                    _pickDateTime();
                  }
                },
              )
            : null,
      ),
      validator: (data) {
        final emailRegex = RegExp(r'^[\w.-]+@[a-zA-Z\d.-]+\.[a-zA-Z]{2,}$');
        if (widget.hintText == "Email" || widget.hintText == "email") {
          if (data == null || data.trim().isEmpty) {
            return "empty field";
          } else if (!data.trim().contains("@")) {
            return "the email must contain an '@' symbol";
          } else if (data.trim().indexOf("@") != data.trim().lastIndexOf("@")) {
            return "you can only contain one instance of '@' in your email";
          } else if (!emailRegex.hasMatch(data.trim())) {
            return "Invalid email format, it should be similar to 'test@example.com'";
          } else {
            return null;
          }
          // Valid email
        } else if (widget.hintText == "Password" ||
            widget.hintText == "Confirm Password") {
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
        } else if (widget.hintText == "Phone Number") {
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
