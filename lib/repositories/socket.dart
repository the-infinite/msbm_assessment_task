import 'package:msbm_assessment_test/core/base.dart';
import 'package:msbm_assessment_test/core/data/repo.dart';
import 'package:msbm_assessment_test/helper/modals.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketRepository extends DataRepository {
  //? A controller function used to create and get a connection to a certain
  //? websocket address
  Future<WebSocketChannel?> getConnection(String uri) async {
    try {
      final channel = WebSocketChannel.connect(Uri.parse(uri));

      //? This is fine.
      await channel.ready;

      //? Then we notify the user that it was successful.
      ModalHelper.showSnackBar("Connected to the socket address successfully", false);

      //? Return the channel.
      return channel;
    } catch (e) {
      AppRegistry.debugLog(
        "Could not connect to socket address because ${e.toString().toLowerCase()}",
        "Helpers.WebSocket",
      );
      ModalHelper.showSnackBar("Could not connect to socket address because ${e.toString().toLowerCase()}");
    }

    // Return null.
    return null;
  }
}
