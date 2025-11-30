// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import '../../data/article_model.dart';
//
// class SearchScreen extends StatefulWidget {
//   const SearchScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   // 1. FORM CONTROLLERS
//   final _formKey = GlobalKey<FormState>(); // Identifies the form for validation
//   final _searchController = TextEditingController(); // Tracks what user types
//
//   // 2. STATE VARIABLES
//   List<ArticleModel> _articles = [];
//   bool _isLoading = false;
//   String? _errorMessage;
//
//   // 3. API CALL (Directly here for simplicity/speed)
//   Future<void> _searchNews() async {
//     // A. VALIDATE FORM
//     if (!_formKey.currentState!.validate()) {
//       return; // Stop if validation fails
//     }
//
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });
//
//     try {
//       // 🔑 REPLACE WITH YOUR API KEY
//       final apiKey = 'YOUR_API_KEY_HERE';
//       final query = _searchController.text;
//
//       final response = await Dio().get(
//         'https://newsapi.org/v2/everything',
//         queryParameters: {
//           'q': query,
//           'apiKey': apiKey,
//           'sortBy': 'publishedAt',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final List<dynamic> jsonList = response.data['articles'];
//         setState(() {
//           _articles = jsonList.map((e) => ArticleModel.fromJson(e)).toList();
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = "Failed to load results. Check internet.";
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Search News")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // 4. THE FORM
//             Form(
//               key: _formKey,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: _searchController,
//                       decoration: const InputDecoration(
//                         labelText: "Enter Topic",
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.search),
//                       ),
//                       // 5. VALIDATION LOGIC
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter a keyword';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   ElevatedButton(
//                     onPressed: _searchNews,
//                     child: const Text("Search"),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // 6. RESULTS AREA (State Management UI)
//             if (_isLoading)
//               const CircularProgressIndicator()
//             else if (_errorMessage != null)
//               Text(_errorMessage!, style: const TextStyle(color: Colors.red))
//             else
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: _articles.length,
//                   itemBuilder: (context, index) {
//                     final article = _articles[index];
//                     return ListTile(
//                       title: Text(article.title),
//                       subtitle: Text(article.author ?? "Unknown"),
//                       leading: article.urlToImage != null
//                           ? Image.network(article.urlToImage!, width: 50, fit: BoxFit.cover)
//                           : const Icon(Icons.article),
//                     );
//                   },
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }