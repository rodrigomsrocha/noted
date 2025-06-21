import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Result class for API responses
class HuggingFaceResponse {
  final String content;
  final bool isSuccess;
  final int? statusCode;
  final String? error;

  const HuggingFaceResponse({
    required this.content,
    required this.isSuccess,
    this.statusCode,
    this.error,
  });

  factory HuggingFaceResponse.success(String content) =>
      HuggingFaceResponse(content: content, isSuccess: true);

  factory HuggingFaceResponse.error(String error, {int? statusCode}) =>
      HuggingFaceResponse(
        content: '',
        isSuccess: false,
        error: error,
        statusCode: statusCode,
      );
}

/// Efficient Hugging Face API client using Inference Providers
class HuggingFaceService {
  static const String _baseUrl = 'https://router.huggingface.co';
  static const Duration _timeout = Duration(seconds: 60);

  late final String _apiKey;
  late final http.Client _client;
  late final Map<String, String> _headers;

  // Global configuration for consistent model and provider usage
  final String defaultModel;
  final String defaultProvider;

  HuggingFaceService({
    this.defaultModel = 'deepseek/deepseek-v3-0324',
    this.defaultProvider = 'novita',
  }) {
    _apiKey = dotenv.env['HF_KEY'] ?? '';
    _client = http.Client();
    _headers = {
      'Authorization': 'Bearer $_apiKey',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  /// Get current model and provider configuration
  Map<String, String> get currentConfig => {
        'model': defaultModel,
        'provider': defaultProvider,
      };

  /// Create a new service instance with different model/provider
  /// This is the recommended way to change configuration
  factory HuggingFaceService.withConfig({
    required String model,
    required String provider,
  }) =>
      HuggingFaceService(defaultModel: model, defaultProvider: provider);

  /// Dispose HTTP client when done
  void dispose() => _client.close();

  /// Check if API key is configured
  bool get isConfigured => _apiKey.isNotEmpty && _apiKey != 'YOUR_API_KEY_HERE';

  /// Generate text using Hugging Face Inference Providers
  /// Uses text generation models for responses
  Future<HuggingFaceResponse> generateText({
    required String message,
    String? model,
    String? provider,
    int maxTokens = 256,
    double temperature = 0.7,
  }) async {
    final actualModel = model ?? defaultModel;
    final actualProvider = provider ?? defaultProvider;

    if (!isConfigured) {
      return HuggingFaceResponse.error(
        'API key not configured. Please set HF_KEY in .env file.',
        statusCode: 401,
      );
    }

    final context =
        "Seu nome é Nia, você é uma assistente de IA dentro de um aplicativo de anotações. Sua tarefa é ajudar os usuários a gerar respostas para suas anotações. Sua criadora Ana Clara foi muito atencionsa e projetou você da melhor forma possivel! Lembre-se de sempre deixar isso claro sempre que você responder uma pergunta. Você deve responder de forma clara e concisa, mantendo o contexto da conversa. Você deve evitar respostas muito longas ou complexas, a menos que o usuário solicite especificamente uma explicação detalhada. Você deve sempre manter um tom amigável e prestativo, como se fosse uma assistente pessoal. Você deve evitar usar jargões técnicos ou termos complicados, a menos que o usuário solicite especificamente. Você deve sempre tentar entender o contexto da conversa e responder de forma relevante e útil. Você deve sempre tentar manter a conversa fluindo, fazendo perguntas relevantes e respondendo de forma clara e concisa.";

    final prompt = '$context\n\n$message';

    final url = Uri.parse(
      '$_baseUrl/$actualProvider/v3/openai/chat/completions',
    );

    final payload = {
      'messages': [
        {'role': 'user', 'content': prompt},
      ],
      'model': actualModel,
      'max_tokens': maxTokens,
      'temperature': temperature,
      'stream': false,
    };

    try {
      final response = await _client.post(
        url,
        headers: _headers,
        body: jsonEncode(payload),
      );

      return _handleResponse(response);
    } catch (e) {
      return HuggingFaceResponse.error('Network error: $e');
    }
  }

  /// Generate chat response with conversation history support
  Future<HuggingFaceResponse> generateChatResponse({
    required List<Map<String, String>> messages,
    String? model,
    String? provider,
    int maxTokens = 256,
    double temperature = 0.7,
  }) async {
    final actualModel = model ?? defaultModel;
    final actualProvider = provider ?? defaultProvider;

    if (!isConfigured) {
      return HuggingFaceResponse.error(
        'API key not configured. Please set HF_KEY in .env file.',
        statusCode: 401,
      );
    }

    final url = Uri.parse(
      '$_baseUrl/$actualProvider/v3/openai/chat/completions',
    );
    final payload = {
      'messages': messages,
      'model': actualModel,
      'max_tokens': maxTokens,
      'temperature': temperature,
      'stream': false,
    };

    try {
      final response = await _client
          .post(url, headers: _headers, body: jsonEncode(payload))
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      return HuggingFaceResponse.error('Network error: $e');
    }
  }

  /// Main query method - optimized for text generation
  Future<String> query(
    String inputText, {
    String? provider,
    String? model,
    int? maxTokens,
  }) async {
    if (inputText.trim().isEmpty) {
      return 'Please enter some text to process.';
    }

    final response = await generateText(
      message: inputText,
      provider: provider,
      model: model,
      maxTokens: maxTokens ?? 256,
    );

    if (response.isSuccess) {
      return response.content;
    } else {
      return _formatError(response);
    }
  }

  /// Convenience method for detailed explanations (uses more tokens)
  Future<String> explain(String topic) async {
    return query(
      'Please provide a detailed explanation about: $topic',
      maxTokens: 512,
    );
  }

  /// Convenience method for code-related queries (preserves formatting)
  Future<String> codeHelp(String codeQuestion) async {
    return query(
      'Please help with this coding question: $codeQuestion',
      maxTokens: 256,
    );
  }

  /// Convenience method for step-by-step instructions
  Future<String> stepByStep(String task) async {
    return query(
      'Please provide step-by-step instructions for: $task',
      maxTokens: 256,
    );
  }

  /// Chat with system prompt support
  Future<String> chatWithSystem({
    required String systemPrompt,
    required String userMessage,
    String? model,
    String? provider,
    int maxTokens = 256,
  }) async {
    final messages = [
      {'role': 'system', 'content': systemPrompt},
      {'role': 'user', 'content': userMessage},
    ];

    final response = await generateChatResponse(
      messages: messages,
      model: model,
      provider: provider,
      maxTokens: maxTokens,
    );

    if (response.isSuccess) {
      return response.content;
    } else {
      return _formatError(response);
    }
  }

  /// Multi-turn conversation support
  Future<String> continueConversation({
    required List<Map<String, String>> conversationHistory,
    required String newMessage,
    String? model,
    String? provider,
    int maxTokens = 256,
  }) async {
    final messages = List<Map<String, String>>.from(conversationHistory);
    messages.add({'role': 'user', 'content': newMessage});

    final response = await generateChatResponse(
      messages: messages,
      model: model,
      provider: provider,
      maxTokens: maxTokens,
    );

    if (response.isSuccess) {
      return response.content;
    } else {
      return _formatError(response);
    }
  }

  /// Test connectivity with different providers
  /// Returns a simple response to verify the service is working
  Future<String> testProvider({String? provider, String? model}) async {
    return query(
      'Hello! Please respond with "Service is working correctly."',
      provider: provider,
      model: model,
      maxTokens: 50,
    );
  }

  /// Get list of popular provider/model combinations
  static List<Map<String, String>> get popularCombinations => [
        {'provider': 'novita', 'model': 'deepseek/deepseek-v3-0324'},
        {'provider': 'groq', 'model': 'meta-llama/Llama-3.3-70B-Instruct'},
        {'provider': 'together', 'model': 'meta-llama/Llama-3.3-70B-Instruct'},
        {
          'provider': 'fireworks',
          'model': 'accounts/fireworks/models/llama-v3p3-70b-instruct',
        },
        {'provider': 'cerebras', 'model': 'llama3.3-70b'},
      ];

  /// Handle HTTP response efficiently with proper UTF-8 decoding
  HuggingFaceResponse _handleResponse(http.Response response) {
    // Properly decode the response body as UTF-8
    final responseBody = utf8.decode(response.bodyBytes);

    switch (response.statusCode) {
      case 200:
        return _parseSuccessResponse(responseBody);
      case 401:
        return HuggingFaceResponse.error(
          'Invalid API key or endpoint access denied. Check your .env file.',
          statusCode: 401,
        );
      case 404:
        return HuggingFaceResponse.error(
          'Endpoint not found or unavailable.',
          statusCode: 404,
        );
      case 422:
        return HuggingFaceResponse.error(
          'Invalid request parameters. Please check your input.',
          statusCode: 422,
        );
      case 503:
        return _parseLoadingResponse(responseBody);
      case 429:
        return HuggingFaceResponse.error(
          'Rate limit exceeded. Please wait and try again.',
          statusCode: 429,
        );
      case 400:
        return HuggingFaceResponse.error(
          'Bad request. Please check your input.',
          statusCode: 400,
        );
      default:
        return HuggingFaceResponse.error(
          'API error (${response.statusCode}): $responseBody',
          statusCode: response.statusCode,
        );
    }
  }

  /// Parse successful API response from Hugging Face Inference Providers
  HuggingFaceResponse _parseSuccessResponse(String responseBody) {
    try {
      final data = jsonDecode(responseBody);

      // Handle OpenAI-compatible chat completions format
      if (data is Map<String, dynamic>) {
        final choices = data['choices'];
        if (choices is List && choices.isNotEmpty) {
          final firstChoice = choices[0];
          if (firstChoice is Map<String, dynamic>) {
            final message = firstChoice['message'];
            if (message is Map<String, dynamic>) {
              final content = message['content'];
              if (content is String && content.trim().isNotEmpty) {
                return HuggingFaceResponse.success(content.trim());
              }
            }
          }
        }

        // Fallback: check for direct text response
        final text = data['text'];
        if (text is String && text.trim().isNotEmpty) {
          return HuggingFaceResponse.success(text.trim());
        }
      }

      return HuggingFaceResponse.error(
        'No content generated or invalid response format',
      );
    } catch (e) {
      return HuggingFaceResponse.error('Failed to parse response: $e');
    }
  }

  /// Parse loading response (503 status)
  HuggingFaceResponse _parseLoadingResponse(String responseBody) {
    try {
      final data = jsonDecode(responseBody);
      final estimatedTime = data['estimated_time'] as num?;
      final message = estimatedTime != null
          ? 'Model loading (estimated ${estimatedTime.toInt()}s). Please try again.'
          : 'Model is loading. Please try again in a moment.';

      return HuggingFaceResponse.error(message, statusCode: 503);
    } catch (e) {
      return HuggingFaceResponse.error(
        'Model is loading. Please try again.',
        statusCode: 503,
      );
    }
  }

  /// Format error message for display
  String _formatError(HuggingFaceResponse response) {
    final prefix = switch (response.statusCode) {
      401 => '🔐',
      404 => '❓',
      422 => '⚠️',
      503 => '⏳',
      429 => '⚠️',
      _ => '❌',
    };

    return '$prefix ${response.error}';
  }
}
