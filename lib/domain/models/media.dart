class Media {
  const Media({
    this.type = "photo",
    this.showAt,
    this.image,
    this.width = 0.0,
    this.height = 0.0,
  }) : assert(showAt != null),
        assert(
            (image == null) || (image != null && width > 0.0 && height > 0.0)
        );

  final String type;
  final double showAt;
  final String image;
  final double width;
  final double height;
}
