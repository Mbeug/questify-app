import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final socialAuthServiceProvider = Provider<SocialAuthService>(
  (ref) => SocialAuthService(),
);

/// Result of a social sign-in flow (client-side).
/// Contains the idToken (or accessToken on web) to send to the backend.
class SocialSignInResult {
  final String provider; // "google" or "apple"
  final String? idToken;
  final String? accessToken;
  final String? displayName;
  final String? email;

  SocialSignInResult({
    required this.provider,
    this.idToken,
    this.accessToken,
    this.displayName,
    this.email,
  }) : assert(idToken != null || accessToken != null,
            'Either idToken or accessToken must be provided');
}

class SocialAuthService {
  // Google Sign-In instance — request email + profile scopes
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  /// Trigger Google Sign-In and return the ID token (or access token on web).
  Future<SocialSignInResult> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        throw SocialAuthException('Connexion Google annulee');
      }

      final auth = await account.authentication;
      final idToken = auth.idToken;
      final accessToken = auth.accessToken;

      // On web, idToken is often null — fall back to accessToken
      if (idToken == null && accessToken == null) {
        throw SocialAuthException('Impossible de recuperer le token Google');
      }

      return SocialSignInResult(
        provider: 'google',
        idToken: idToken,
        accessToken: idToken == null ? accessToken : null,
        displayName: account.displayName,
        email: account.email,
      );
    } on SocialAuthException {
      rethrow;
    } catch (e) {
      throw SocialAuthException('Erreur lors de la connexion Google: $e');
    }
  }

  /// Trigger Apple Sign-In and return the identity token.
  Future<SocialSignInResult> signInWithApple() async {
    try {
      // Generate nonce for security
      final rawNonce = _generateNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      final idToken = credential.identityToken;
      if (idToken == null) {
        throw SocialAuthException('Impossible de recuperer le token Apple');
      }

      // Apple only provides name on the FIRST sign-in
      String? displayName;
      if (credential.givenName != null || credential.familyName != null) {
        displayName = [credential.givenName, credential.familyName]
            .where((s) => s != null && s.isNotEmpty)
            .join(' ');
        if (displayName.isEmpty) displayName = null;
      }

      return SocialSignInResult(
        provider: 'apple',
        idToken: idToken,
        displayName: displayName,
        email: credential.email,
      );
    } on SocialAuthException {
      rethrow;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw SocialAuthException('Connexion Apple annulee');
      }
      throw SocialAuthException('Erreur Apple Sign-In: ${e.message}');
    } catch (e) {
      throw SocialAuthException('Erreur lors de la connexion Apple: $e');
    }
  }

  /// Disconnect Google (for logout)
  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // Ignore errors during sign-out
    }
  }

  /// Generate a random nonce string
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }
}

class SocialAuthException implements Exception {
  final String message;
  SocialAuthException(this.message);

  @override
  String toString() => message;
}
