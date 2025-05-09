import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/Voice_bubble_widgets/caht_cubit/chat_cubit_states.dart';

class CahtCubit extends Cubit {
  CahtCubit() : super(ChatCubitInitial());

  static CahtCubit get(context) => BlocProvider.of(context);
  final TextEditingController txt = TextEditingController();
  
}
