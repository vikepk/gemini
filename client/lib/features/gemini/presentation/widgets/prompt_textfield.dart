import 'package:flutter/material.dart';
import 'package:gemini/core/constants/constant.dart';

class PromptTextfield extends StatelessWidget {
  TextEditingController value;
  bool isloading;
  PromptTextfield({required this.value, required this.isloading});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: TextFormField(
          controller: value,

          decoration: InputDecoration(
            labelText: 'Enter Prompt',
            suffix: isloading
                ? const CircularProgressIndicator(
                    color: KGreen,
                    strokeWidth: 2,
                  )
                : null,
            labelStyle: KBody1,
            hintStyle: KBody1,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: KGreen,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: KGreen,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          style: KBody1,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          // validator: (value) => validatePhoneNumber(value!),
        ),
      ),
    );
  }
}
