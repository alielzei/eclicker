import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eclicker_flutter/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePollPage extends StatefulWidget {
  @override
  _CreatePollPageState createState() => _CreatePollPageState();
}

class _CreatePollPageState extends State<CreatePollPage> {

  dynamic _titleController = new TextEditingController();
  List _optionsControllers = [
    new TextEditingController(),
    new TextEditingController()
  ];
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return _loading
      ? Center(
        child: CircularProgressIndicator()
      )
      : ListView(
        children: <Widget>[
          _buildTitle(),
          ..._buildOptions(),
          _buildActionButtons(),
          SizedBox(
            height: 100,
          )
        ],
      );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('create'),
    //   ),
    //   body: _loading
    //     ? Center(
    //       child: CircularProgressIndicator()
    //     )
    //     : ListView(
    //     children: <Widget>[
    //       _buildTitle(),
    //       ..._buildOptions(),
    //       _buildActionButtons(),
    //       SizedBox(
    //         height: 100,
    //       )
    //     ],
    //   )
    // );
  }

  Widget _buildTitle(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: _titleController,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        style: TextStyle(
          fontSize: 21.0,
          fontWeight: FontWeight.bold
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
          hintText: "A title"
        ),
      ),
    );
  }

  List<Widget> _buildOptions(){
    return List.generate(
      _optionsControllers.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _optionsControllers[index],
                  decoration: InputDecoration(
                    hintText: "Option ${index+1}"
                  ),
                ),
              ),
              Visibility(
                visible: index > 1,
                child: IconButton(
                  onPressed: (){
                    setState((){ _optionsControllers.removeAt(index); });
                  },
                  color: Colors.grey,
                  icon: Icon(Icons.close),
                ),
              )
            ],
          ),
        );
      }
    );
  }

  Widget _buildActionButtons(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildAddOptionButton(),
          _buildPostButton(context)
        ],
      ),
    );
  }

  Widget _buildAddOptionButton(){
    return FlatButton.icon(
      onPressed: (){
        setState((){
          _optionsControllers.add(new TextEditingController());
        });
      },
      icon: Icon(Icons.add),
      label: Text('Add option',
        style: TextStyle(
            fontWeight: FontWeight.bold
        )
      ),
    );
  }

  Widget _buildPostButton(BuildContext context){
    return RaisedButton(
      onPressed: (){
        setState((){
          _loading = true;
        });
        final firestore = Provider.of<FirestoreService>(context, listen: false);
        firestore.postPoll(
          title: _titleController.text,
          options: List<String>.from(_optionsControllers.map((c) => c.text)),
          // options: [],
        )
        .whenComplete((){
          setState((){
            _loading = false;
          });
        });
      },
      highlightElevation: 0,
      elevation: 0,
      child: Text('POST', style: TextStyle(
        fontWeight: FontWeight.bold
      )),
    );
  }

}