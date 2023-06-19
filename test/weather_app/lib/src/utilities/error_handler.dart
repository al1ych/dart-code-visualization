void handleError(Exception exception) {
  if (exception is http.ClientException) {
    print('Network Error: ${exception.message}');
  } else {
    print('Unexpected Error: ${exception.toString()}');
  }
}
