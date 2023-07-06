import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:file_picker/file_picker.dart';

class PdfViewerScreen extends StatefulWidget {
  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  List<File> _recentFiles = [];
  File? _selectedFile;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text('PDF Viewer'),
        ),
        body: Center(
          child: _selectedFile != null
              ? SfPdfViewer.file(_selectedFile!)
              : _buildRecentFilesGrid(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _pickPDFFile,
          child: Icon(Icons.attach_file),
        ),
        drawer: Drawer(
          child: ListView.builder(
            itemCount: _recentFiles.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return DrawerHeader(
                  child: Text(
                    'Recent Files',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              final fileIndex = index - 1;
              final file = _recentFiles[fileIndex];
              return ListTile(
                title: Text(file.path),
                onTap: () {
                  _openFile(file);
                  Navigator.pop(context); // Close the drawer
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    if (_selectedFile != null) {
      setState(() {
        _selectedFile = null;
      });
      return false;
    }
    return true;
  }

  void _pickPDFFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      File selectedFile = File(result.files.first.path!);
      _openFile(selectedFile);
    }
  }

  void _openFile(File file) {
    setState(() {
      _selectedFile = file;
      _recentFiles.insert(0, file);
    });
  }

  Widget _buildRecentFilesGrid() {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(16.0),
      children: _recentFiles.map((file) {
        final fileName = file.path.split('/').last; // Extract the file name

        return GestureDetector(
          onTap: () {
            _openFile(file);
          },
          child: Card(
            color: Colors.amber, // Set card color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 2.0,
            child: Padding(
              padding: EdgeInsets.all(16.0), // Add padding
              child: Center(
                child: Text(
                  fileName, // Display the file name
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black, // Set text color
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _removeFile(File file) {
    setState(() {
      _recentFiles.remove(file);
    });
  }
}
