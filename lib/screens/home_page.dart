import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoa/components/bottom_button.dart';
import 'package:todoa/data/data_collection.dart';
import 'package:todoa/screens/add_items_page.dart';
import 'package:todoa/widgets/item_data.dart';

class HomePage extends StatefulWidget {
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late final dynamic data;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildTopBar(context),
          _buildBodyContent(context),
          _buildBottomButton(context),
        ],
      ),
    );
  }

  Stack _buildTopBar(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 140,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/bg_header.png'),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 35,
          ),
          child: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'TODOa:',
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 46,
                  fontWeight: FontWeight.bold,
                ),
                speed: Duration(milliseconds: 250),
              ),
            ],
            totalRepeatCount: 1,
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            height: 20.0,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBodyContent(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: Provider.of<TodosCollection>(context, listen: false)
            .getCollectionAsSteam(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> asyncSnapshot) {
          if (!asyncSnapshot.hasData) {
            return Center(
              child: Text('Loading...'),
            );
          }

          List<Widget> todoWidgets = [];
          asyncSnapshot.data.docs.forEach(
            (DocumentSnapshot docs) {
              final id = docs.id;

              bool isSelected = docs.data()!['isSelected'];
              String title = docs.data()!['todo'];

              final item = ItemData(
                  title: title,
                  isChecked: isSelected,
                  onCheckedChanges: (bool isChecked) {
                    context
                        .read<TodosCollection>()
                        .updateItem(id, isChecked, title);
                  },
                  onLongPressed: () {
                    _showDeleteDialog(id);
                  });

              todoWidgets.add(item);
            },
          );

          return ListView(
            children: todoWidgets,
          );
        },
      ),
    );
  }

  void _showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Item deletion'),
        content: Text('Would you like to delete this item?'),
        elevation: 24,
        actions: [
          TextButton(
            onPressed: () {
              context.read<TodosCollection>().deleteItem(id);
              Navigator.pop(context);
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('No'),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return BottomButton(
      title: 'Add Item',
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return Container(
              height: 220,
              color: Color(0xff757575),
              child: AddItemsPage(),
            );
          },
        );
      },
    );
  }
}
