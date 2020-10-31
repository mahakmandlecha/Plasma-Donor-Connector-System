


class SliderModel{

  String imageAssetPath;
  String title;
  String desc;

  SliderModel({this.imageAssetPath,this.title,this.desc});

  void setImageAssetPath(String getImageAssetPath){
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle){
    title = getTitle;
  }

  void setDesc(String getDesc){
    desc = getDesc;
  }

  String getImageAssetPath(){
    return imageAssetPath;
  }

  String getTitle(){
    return title;
  }

  String getDesc(){
    return desc;
  }

}


List<SliderModel> getSlides(){

  List<SliderModel> slides = new List<SliderModel>();
  SliderModel sliderModel = new SliderModel();

  //1
  sliderModel.setDesc("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse ornare facilisis vulputate. Integer tempus, dui et tempus semper, orci");
  sliderModel.setTitle("Donate Plasma Save Life");
  sliderModel.setImageAssetPath("assets/illustration.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //2
  sliderModel.setDesc("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse ornare facilisis vulputate. Integer tempus, dui et tempus semper, orci");
  sliderModel.setTitle("Find the Donor");
  sliderModel.setImageAssetPath("assets/illustration3.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //3
  sliderModel.setDesc("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse ornare facilisis vulputate. Integer tempus, dui et tempus semper, orci");
  sliderModel.setTitle("Become the Donor");
  sliderModel.setImageAssetPath("assets/illustration3.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  return slides;
}