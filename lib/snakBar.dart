import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';


//permette la creazione dei pop-up con la quale
//si comuna il successo o un problema in una certa operazione
class GlobalValues {
  static showSnackbar(ScaffoldMessengerState st, String titolo,String msg ,String type) {
    if(type=="successo") {
      st.showSnackBar(SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: titolo,
          message: msg,
          contentType: ContentType.success,
        ),
      ),
      );
    }else if(type=="fallito"){
      st.showSnackBar(SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: titolo,
          message: msg,
          contentType: ContentType.failure,
        ),
      ),
      );
    }else{
      st.showSnackBar(SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: titolo,
          message: msg,
          contentType: ContentType.warning,
        ),
      ),
      );
    }
  }
}