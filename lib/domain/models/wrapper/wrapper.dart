abstract class AbsWrapper<In, Out> {
  Out transform(In input);
}

class ListWrapper<In, Out> extends AbsWrapper<List<In>, List<Out>> {

  ListWrapper(this.itemWrapper) : assert(itemWrapper != null);

  final AbsWrapper<In, Out> itemWrapper;

  @override
  List<Out> transform(List<In> input) {
    if (input == null) {
      return null;
    }
    final List<Out> rets = new List();
    for (In origin in  input) {
      final Out out = itemWrapper.transform(origin);
      rets.add(out);
    }
    return rets;
  }

}
