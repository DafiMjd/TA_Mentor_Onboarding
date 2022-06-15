import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_mentor_onboarding/models/activity_category.dart';
import 'package:ta_mentor_onboarding/models/user.dart';
import 'package:ta_mentor_onboarding/providers/activity/category_provider.dart';
import 'package:ta_mentor_onboarding/utils/custom_colors.dart';
import 'package:ta_mentor_onboarding/views/activity/browse_activity.dart';
import 'package:ta_mentor_onboarding/views/bottom_navbar.dart';
import 'package:ta_mentor_onboarding/widgets/category_item.dart';
import 'package:ta_mentor_onboarding/widgets/error_alert_dialog.dart';
import 'package:ta_mentor_onboarding/widgets/loading_widget.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late CategoryProvider prov;
  late List<ActivityCategory> cats;

  @override
  void initState() {
    super.initState();

    prov = Provider.of(context, listen: false);
    fetchCategories();
  }

  void error(e) async {
    cats = [];
    return showDialog(
        context: context,
        builder: (context) {
          return ErrorAlertDialog(error: "HTTP Error", title: e.toString());
        });
  }

  void fetchCategories() async {
    prov.isFetchingData = true;

    try {
      cats = await prov.fetchActivityCategories();

      prov.isFetchingData = false;
    } catch (e) {
      prov.isFetchingData = false;
      return error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    prov = context.watch<CategoryProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Category'),
        backgroundColor: ORANGE_GARUDA,
        foregroundColor: Colors.black,
      ),
      body: (prov.isFetchingData)
          ? LoadingWidget()
          : (cats.isEmpty)
              ? Center(
                  child: Text(
                    "No Data",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                )
              : GridView.count(
                  // Create a grid with 2 columns. If you change the scrollDirection to
                  // horizontal, this produces 2 rows.
                  crossAxisCount: 2,
                  // Generate 100 widgets that display their index in the List.
                  children: List.generate(cats.length, (i) {
                    return CategoryItem(
                      categoryName: cats[i].categoryName,
                      categoryColor: cats[i].categoryColor,
                      press: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return BrowseActivity(user: widget.user, cat_id: cats[i].id,);
                        }));
                      },
                    );
                  }),
                ),
    );
  }
}
