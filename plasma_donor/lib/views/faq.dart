import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FAQ extends StatefulWidget {
  @override
  _FAQState createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.amberAccent[700],
        elevation: 1.0,
        centerTitle: true,
        title:  Text(
            "FAQ",
            
          ),
      
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.reply, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Who can donate blood?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "In most states, donors must be age 17 or older. Some states allow donation by 16-year-olds with a signed parental consent form. Donors must weigh at least 110 pounds and be in good health. Additional eligibility criteria apply."),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "What should I do before donating blood?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Before your blood donation:Get plenty of sleep the night before you plan to donate.Eat a healthy meal before your donation.Avoid fatty foods, such as hamburgers, french fries or ice cream before donating. Tests for infections done on all donated blood can be affected by fats that appear in your blood for several hours after eating fatty foods.Drink an extra 16 ounces (473 milliliters) of water and other fluids before the donation.If you are a platelet donor, remember that you must not take aspirin for two days prior to donating. Otherwise, you can take your normal medications as prescribed."),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "What should I do after donating blood?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Drink an extra four glasses (eight ounces each) of non-alcoholic liquids.Keep your bandage on and dry for the next five hours, and do not do heavy exercising or lifting.If the needle site starts to bleed, raise your arm straight up and press on the site until the bleeding stops.Because you could experience dizziness or loss of strength, use caution if you plan to do anything that could put you or others at risk of harm. Eat healthy meals and consider adding iron-rich foods to your regular dieIf you get dizzy or lightheaded:  Stop what you are doing, lie down, and raise your feet until the feeling passes "),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "How long does a blood donation take?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "The entire process takes about one hour and 15 minutes; the actual donation of a pint of whole blood unit takes eight to 10 minutes. However, the time varies slightly with each person depending on several factors including the donor’s health history and attendance at the blood drive."),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "How long will it take to replenish the pint of blood I donate?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "The plasma from your donation is replaced within about 24 hours. Red cells need about four to six weeks for complete replacement. That’s why at least eight weeks are required between whole blood donations."),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("How much plasma can an individual give safely?",style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "The amount of plasma that can be safely donated is based on your weight and amount of red blood cells in your body. The Red Cross apheresis machine or cell separator carefully calculates this at each donation to ensure the donor’s safety. With each donation, COVID-19 survivors may now have a unique ability to help up to four patients recover from the virus"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("What is convalescent plasma donation?",style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "COVID-19 convalescent plasma is a type of blood donation collected from individuals who have recovered from COVID-19. The convalescent plasma contains antibodies that might help patients actively fighting the virus."),
              )
            ],
          ),
        ),
      ),
    );
  }
}
