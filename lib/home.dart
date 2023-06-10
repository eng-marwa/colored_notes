import 'package:flutter/material.dart';
import 'package:flutter_day2_iti3/Note.dart';
import 'package:flutter_day2_iti3/colors.dart';
import 'package:flutter_day2_iti3/curd.dart';
import 'package:flutter_day2_iti3/date_time_util.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _globalKey = GlobalKey();
  final GlobalKey<FormState> _editKey = GlobalKey();
  final TextEditingController _noteTitle = TextEditingController();
  final TextEditingController _noteText = TextEditingController();
  late TextEditingController _editTitle;
  late TextEditingController _editText;

  List<Note> _notes = [];
  int _selectedColorIndex = 0;

  @override
  void initState() {
    super.initState();
    viewNotes();
  }

  @override
  void dispose() {
    super.dispose();
    _noteTitle.dispose();
    _noteText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(children: [
          const Text(
            'New Note',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
                fontSize: 25),
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(8)),
            margin: EdgeInsets.all(8),
            child: Form(
                key: _globalKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: 'Note Title'),
                      controller: _noteTitle,
                      validator: (value) =>
                          value!.isEmpty ? 'Note Title is required' : null,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: 'Note Text'),
                      controller: _noteText,
                      validator: (value) =>
                          value!.isEmpty ? 'Note Text is required' : null,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_globalKey.currentState!.validate()) {
                            String title = _noteTitle.value.text;
                            String text = _noteText.value.text;
                            Note note = Note(
                                title: title,
                                text: text,
                                date: DateTimeUtil.getCurrentDateTime(),
                                color: colors[_selectedColorIndex].value);

                            saveNote(note);
                          }
                        },
                        child: const Text('Add New Note'))
                  ],
                )),
          ),
          SizedBox(
              height: 55,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(itemCount: colors.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => InkWell(
                      child: Container(
                          width: 55,
                          color: colors[index],
                          child: Visibility(
                            visible: _selectedColorIndex == index,
                            child: const Icon(Icons.check),
                          )),
                      onTap: () {
                        setState(() {
                          _selectedColorIndex = index;
                        });
                      }),
                ),
              )),
          _notes.isEmpty
              ? Container(
                  height: 300,
                  alignment: Alignment.center,
                  child: const Text(
                    'No Notes Found',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20),
                  ),
                )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _notes.length,
                      itemBuilder: (context, index) => Padding(padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                        child: ListTile(
                              tileColor: Color(_notes[index].color!),
                              title: Text(_notes[index].title),
                              subtitle: Text(_notes[index].text),
                              leading: const Icon(
                                Icons.notes,
                                color: Colors.deepPurple,
                              ),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(children: [
                                  IconButton(
                                      onPressed: () {
                                        deleteNote(_notes[index].id);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        showEditNoteDialog(_notes[index]);
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.green,
                                      )),
                                ]),
                              ),
                            ),
                      ),
                )
        ]),
      )),
    );
  }

  void saveNote(Note note) {
    Curd.curd.insertNote(note).then((row) {
      showMessage('Note Added successfully');
      viewNotes();
      emptyAllFields();
    });
  }

  void viewNotes() {
    Curd.curd.getAllNotes().then((notes) {
      setState(() {
        _notes = notes;
        print(notes);
      });
    });
  }

  void deleteNote(int? id) {
    Curd.curd.deleteNote(id!).then((row) {
      showMessage('Note deleted successfully');
      viewNotes();
    });
  }

  void editNote(Note note) {
    Curd.curd.editNote(note).then((row) {
      showMessage('Note updated successfully');
      viewNotes();
    });
  }

  void showEditNoteDialog(Note note) {
    _editTitle = TextEditingController(text: note.title);
    _editText = TextEditingController(text: note.text);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Update Note'),
                content: Wrap(children: [
                  Form(
                      key: _editKey,
                      child: Column(children: [
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(labelText: 'Note Title'),
                          controller: _editTitle,
                          validator: (value) =>
                              value!.isEmpty ? 'Note Title is required' : null,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(labelText: 'Note Text'),
                          controller: _editText,
                          validator: (value) =>
                              value!.isEmpty ? 'Note Text is required' : null,
                        )
                      ])),
                ]),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _editText.dispose();
                        _editTitle.dispose();
                      },
                      child: Text('Cancel')),
                  TextButton(
                      onPressed: () {
                        if (_editKey.currentState!.validate()) {
                          String title = _editTitle.value.text;
                          String text = _editText.value.text;
                          note.title = title;
                          note.text = text;
                          editNote(note);
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Update')),
                ]));
  }

  void emptyAllFields() {
    _noteText.text = "";
    _noteTitle.text = "";
  }

  void showMessage(String s) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
  }
}
