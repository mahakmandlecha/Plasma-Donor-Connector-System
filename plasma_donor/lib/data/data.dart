class SliderModel {
  String imageAssetPath;
  String title;
  String desc;

  SliderModel({this.imageAssetPath, this.title, this.desc});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String getImageAssetPath() {
    return imageAssetPath;
  }

  String getTitle() {
    return title;
  }

  String getDesc() {
    return desc;
  }
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = new List<SliderModel>();
  SliderModel sliderModel = new SliderModel();

  //1
  sliderModel.setDesc(
      "Just recovered from Covid-19 😊 or having Covid 19 😟 No worries");
  sliderModel.setTitle("Donate Plasma Save Life");
  sliderModel.setImageAssetPath("assets/illustration1.PNG");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //2
  sliderModel.setDesc("Having Covid-19? Need a plasma doner? 🔍 Donor here");
  sliderModel.setTitle("Find a donor");
  sliderModel.setImageAssetPath("assets/illustration2.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //3
  sliderModel.setDesc(
      "Congratulations on recovering from Covid-19. Help others to recover.");
  sliderModel.setTitle("Become the Donor");
  sliderModel.setImageAssetPath("assets/illustration3.PNG");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  return slides;
}
