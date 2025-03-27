// ignore_for_file: deprecated_member_use, duplicate_ignore, use_build_context_synchronously, avoid_print, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart'; // Added for network checks

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Gemini? gemini; // Changed to nullable to handle initialization failures
  final ImagePicker _imagePicker = ImagePicker();

  List<List<ChatMessage>> chatSessions = [[]];
  int currentChatIndex = 0;
  bool isSidebarOpen = false;
  bool isLoading = false; // Added to track API call state

  // Define users as static constants to avoid recreation
  static ChatUser currentUser = ChatUser(id: "0", firstName: "You");
  static ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Gemini",
    profileImage: "assets/images/chatbot.png",
  );

  @override
  void initState() {
    super.initState();
    _initializeGemini();
  }

  // Separated initialization to handle errors properly
  Future<void> _initializeGemini() async {
    try {
      // Check network connectivity first
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        print("No internet connection available");
        _showErrorSnackBar(
          "No internet connection. Please check your network.",
        );
        return;
      }

      gemini = Gemini.instance;
      // Test API connection
      final response = gemini?.streamGenerateContent("Hello");
      if (response == null) {
        print("API returned null response during initialization test");
        _showErrorSnackBar(
          "Could not connect to Gemini API. Please check your API key.",
        );
      } else {
        print("Gemini initialized successfully");
      }
    } catch (e) {
      print("Error initializing Gemini: $e");
      _showErrorSnackBar("Failed to initialize Gemini: $e");
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: _initializeGemini,
            textColor: Colors.white,
          ),
        ),
      );
    });
  }

  // Memoize UI elements that don't change frequently
  final inputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.green.shade50,
    hintText: "Type your message...",
    hintStyle: TextStyle(color: Colors.green.shade700, fontFamily: 'Poppins'),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildChatUI(),
          if (isSidebarOpen) _buildOverlay(),
          _buildSlidingSidebar(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        "AgriChat",
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 22,
        ),
      ),
      actions: [
        if (isLoading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(color: Colors.white),
          ),
        IconButton(
          icon: const Icon(Icons.history, color: Colors.white),
          onPressed: () => setState(() => isSidebarOpen = true),
        ),
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4CAF50), Color.fromARGB(255, 47, 195, 165)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _buildChatUI() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.jpg"),
          fit: BoxFit.cover,
          opacity: 1,
        ),
      ),
      child: DashChat(
        currentUser: currentUser,
        onSend: _sendMessage,
        messages: chatSessions[currentChatIndex],
        messageOptions: const MessageOptions(
          currentUserContainerColor: Color(0xFF388E3C), // Using constant color
          containerColor: Color(0xFF6D4C41), // Using constant color
          textColor: Colors.white,
          currentUserTextColor: Colors.white,
          messagePadding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        ),
        inputOptions: InputOptions(
          trailing: [
            IconButton(
              onPressed: _sendMediaMessage,
              icon: const Icon(Icons.image, color: Colors.green),
            ),
          ],
          inputDecoration: inputDecoration,
        ),
      ),
    );
  }

  Widget _buildOverlay() {
    return GestureDetector(
      onTap: () => setState(() => isSidebarOpen = false),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }

  Widget _buildSlidingSidebar() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      right: isSidebarOpen ? 0 : -280,
      top: 0,
      bottom: 0,
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(-4, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF1B5E20)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Chats",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: _startNewChat,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: chatSessions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("Chat #${index + 1}"),
                    selected: index == currentChatIndex,
                    selectedTileColor: Colors.green.withOpacity(0.1),
                    onTap:
                        () => setState(() {
                          currentChatIndex = index;
                          isSidebarOpen = false;
                        }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(ChatMessage chatMessage) async {
    // Check if gemini is initialized
    if (gemini == null) {
      _showErrorSnackBar("Gemini is not initialized. Please retry.");
      return;
    }

    // Add user message immediately
    setState(() {
      chatSessions[currentChatIndex].insert(0, chatMessage);
      isLoading = true;
    });

    // Prepare bot response
    ChatMessage botMessage = ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text: "is typing...",
    );

    // Add the "is typing..." message
    setState(() {
      chatSessions[currentChatIndex].insert(0, botMessage);
    });

    try {
      // First check connectivity
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        throw Exception("No internet connection available");
      }

      print("Sending message to Gemini: ${chatMessage.text}");

      // Set up stream listener
      String fullResponse = "";
      bool receivedAnyResponse = false;

      // Use a timeout to prevent hanging
      await for (final event in gemini!
          .streamGenerateContent(chatMessage.text)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: (sink) {
              sink.close();
              if (!receivedAnyResponse) {
                throw TimeoutException(
                  "Request timed out. No response received.",
                );
              }
            },
          )) {
        receivedAnyResponse = true;
        String newText =
            event.content?.parts
                ?.whereType<TextPart>()
                .map((p) => p.text)
                .join(" ") ??
            "";

        print("Received chunk: $newText");
        fullResponse += newText;

        setState(() {
          botMessage.text = fullResponse;
        });
      }

      if (fullResponse.isEmpty) {
        throw Exception("Received empty response from API");
      }

      print("Completed response: $fullResponse");
    } catch (e) {
      print("Gemini error: $e");
      setState(() {
        botMessage.text = "Error: Failed to get response. ${e.toString()}";
      });
      _showErrorSnackBar("API error: ${e.toString()}");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _sendMediaMessage() async {
    if (gemini == null) {
      _showErrorSnackBar("Gemini is not initialized. Please retry.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      XFile? file = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // Lower quality for better performance
      );
      if (file == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      Uint8List imageBytes = await file.readAsBytes();

      // Create user message with image
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "Describe this picture?",
        medias: [
          ChatMedia(url: file.path, fileName: file.name, type: MediaType.image),
        ],
      );

      // Add user message (with image) to chat
      setState(() {
        chatSessions[currentChatIndex].insert(0, chatMessage);
      });

      // Create bot response message with "is typing..."
      ChatMessage botMessage = ChatMessage(
        user: geminiUser,
        createdAt: DateTime.now(),
        text: "is typing...",
      );

      setState(() {
        chatSessions[currentChatIndex].insert(0, botMessage);
      });

      // Check connectivity
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        throw Exception("No internet connection available");
      }

      print("Processing image with Gemini");

      // Process image with Gemini
      String fullResponse = "";
      bool receivedAnyResponse = false;

      await for (final event in gemini!
          .streamGenerateContent(
            "Describe this image in detail",
            images: [imageBytes],
          )
          .timeout(
            const Duration(seconds: 60),
            onTimeout: (sink) {
              sink.close();
              if (!receivedAnyResponse) {
                throw TimeoutException(
                  "Request timed out. No response received.",
                );
              }
            },
          )) {
        receivedAnyResponse = true;
        String newText =
            event.content?.parts
                ?.whereType<TextPart>()
                .map((p) => p.text)
                .join(" ") ??
            "";

        print("Received image response chunk: $newText");
        fullResponse += newText;

        setState(() {
          botMessage.text = fullResponse;
        });
      }

      if (fullResponse.isEmpty) {
        throw Exception("Received empty response from API");
      }

      print("Completed image response: $fullResponse");
    } catch (e) {
      print("Error processing image: $e");
      // Handle error
      setState(() {
        // Find the bot message and update it with error
        for (int i = 0; i < chatSessions[currentChatIndex].length; i++) {
          if (chatSessions[currentChatIndex][i].user.id == geminiUser.id &&
              chatSessions[currentChatIndex][i].text == "is typing...") {
            chatSessions[currentChatIndex][i].text =
                "Error processing image: $e";
            break;
          }
        }
      });
      _showErrorSnackBar("Error processing image: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _startNewChat() {
    setState(() {
      chatSessions.insert(0, []);
      currentChatIndex = 0;
    });
  }
}

// Added exception class for timeouts
class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => message;
}
