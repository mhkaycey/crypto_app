class CoinResult<T> {
  final bool isError;
  final String? errorMessage;
  final int? errorCode;
  final T data;

  CoinResult(
    this.data, {
    this.isError = false,
    this.errorMessage,
    this.errorCode,
  });

  @override
  String toString() {
    return isError
        ? 'CoinResult Error $errorCode: $errorMessage'
        : 'CoinResult Success: $data';
  }
}
