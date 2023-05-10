

import '../../models/messegmodel.dart';

abstract class ChatStats{}
class InitialChatStats extends ChatStats{}
class SuccessSendMessege extends ChatStats{}
class GetMessagesLoadingState extends ChatStats{}
class GetMessagesSuccessState extends ChatStats{
  List<MessageModel> messeges;
  GetMessagesSuccessState({required this.messeges});
}