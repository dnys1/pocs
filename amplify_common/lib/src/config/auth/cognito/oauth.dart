import 'package:aws_common/aws_common.dart';
import 'package:json_annotation/json_annotation.dart';

part 'oauth.g.dart';

/// The Cognito HostedUI configuration.
@awsSerializable
class CognitoOAuthConfig
    with AWSEquatable<CognitoOAuthConfig>, AWSSerializable {
  // From: https://github.com/aws-amplify/aws-sdk-ios/blob/main/AWSAuthSDK/Sources/AWSMobileClient/AWSMobileClient.swift#L253

  const CognitoOAuthConfig({
    required this.appClientId,
    this.appClientSecret,
    required this.scopes,
    required this.signInRedirectUri,
    required this.signOutRedirectUri,
    required this.webDomain,
    this.signInUri,
    this.signOutUri,
    this.tokenUri,
    this.signInUriQueryParameters,
    this.signOutUriQueryParameters,
    this.tokenUriQueryParameters,
  });

  /// The FQDN of your Cognito endpoint, e.g. https://mydomain.region.auth.amazoncognito.com.
  final String webDomain;

  /// The application ID.
  final String appClientId;

  /// The application secret.
  final String? appClientSecret;

  /// The redirect URI for sign in.
  @JsonKey(name: 'SignInRedirectURI')
  final String signInRedirectUri;

  @JsonKey(name: 'SignInURI')
  final String? signInUri;

  @JsonKey(name: 'SignInURIQueryParameters')
  final Map<String, String>? signInUriQueryParameters;

  @JsonKey(name: 'SignOutRedirectURI')
  final String signOutRedirectUri;

  @JsonKey(name: 'SignOutURI')
  final String? signOutUri;

  @JsonKey(name: 'SignOutURIQueryParameters')
  final Map<String, String>? signOutUriQueryParameters;

  @JsonKey(name: 'TokenURI')
  final String? tokenUri;

  @JsonKey(name: 'TokenURIQueryParameters')
  final Map<String, String>? tokenUriQueryParameters;

  final Set<String> scopes;

  @override
  List<Object?> get props => [
        webDomain,
        appClientId,
        appClientSecret,
        signInRedirectUri,
        signInUri,
        signInUriQueryParameters,
        signOutRedirectUri,
        signOutUri,
        signOutUriQueryParameters,
        tokenUri,
        tokenUriQueryParameters,
        scopes,
      ];

  factory CognitoOAuthConfig.fromJson(Map<String, Object?> json) =>
      _$CognitoOAuthConfigFromJson(json);

  @override
  Map<String, Object?> toJson() => _$CognitoOAuthConfigToJson(this);
}