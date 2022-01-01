/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0.
 */

package software.amazon.smithy.dart.codegen.core

import software.amazon.smithy.codegen.core.Symbol
import software.amazon.smithy.dart.codegen.core.DartDependency
import software.amazon.smithy.dart.codegen.model.buildSymbol
import software.amazon.smithy.dart.codegen.model.namespace

/**
 * Commonly used runtime types. Provides a single definition of a runtime symbol such that codegen isn't littered
 * with inline symbol creation which makes refactoring of the runtime more difficult and error prone.
 *
 * NOTE: Not all symbols need be added here but it doesn't hurt to define runtime symbols once.
 */
object RuntimeTypes {
    object Http {
        val HttpBody = runtimeSymbol("HttpBody", DartDependency.HTTP)
        val HttpMethod = runtimeSymbol("HttpMethod", DartDependency.HTTP)
        val SdkHttpClient = runtimeSymbol("SdkHttpClient", DartDependency.HTTP)
        val SdkHttpClientFn = runtimeSymbol("sdkHttpClient", DartDependency.HTTP)
        val ByteArrayContent = runtimeSymbol("ByteArrayContent", DartDependency.HTTP, "content")
        val MutateHeadersMiddleware = runtimeSymbol("MutateHeaders", DartDependency.HTTP, "middleware")
        val QueryParameters = runtimeSymbol("QueryParameters", DartDependency.HTTP)
        val QueryParametersBuilder = runtimeSymbol("QueryParametersBuilder", DartDependency.HTTP)
        val toQueryParameters = runtimeSymbol("toQueryParameters", DartDependency.HTTP)
        val Md5ChecksumMiddleware = runtimeSymbol("Md5Checksum", DartDependency.HTTP, "middleware")
        val encodeLabel = runtimeSymbol("encodeLabel", DartDependency.HTTP, "util")
        val readAll = runtimeSymbol("readAll", DartDependency.HTTP)
        val parameters = runtimeSymbol("parameters", DartDependency.HTTP)
        val toByteStream = runtimeSymbol("toByteStream", DartDependency.HTTP)
        val toHttpBody = runtimeSymbol("toHttpBody", DartDependency.HTTP)
        val isSuccess = runtimeSymbol("isSuccess", DartDependency.HTTP)
        val StatusCode = runtimeSymbol("HttpStatusCode", DartDependency.HTTP)
        val splitAsQueryParameters = runtimeSymbol("splitAsQueryParameters", DartDependency.HTTP, "util")

        object Request {
            val HttpRequest = runtimeSymbol("HttpRequest", DartDependency.HTTP, "request")
            val HttpRequestBuilder = runtimeSymbol("HttpRequestBuilder", DartDependency.HTTP, "request")
            val url = runtimeSymbol("url", DartDependency.HTTP, "request")
            val headers = runtimeSymbol("headers", DartDependency.HTTP, "request")
        }

        object Response {
            val HttpCall = runtimeSymbol("HttpCall", DartDependency.HTTP, "response")
            val HttpResponse = runtimeSymbol("HttpResponse", DartDependency.HTTP, "response")
        }

        object Operation {
            val HttpDeserialize = runtimeSymbol("HttpDeserialize", DartDependency.HTTP, "operation")
            val HttpSerialize = runtimeSymbol("HttpSerialize", DartDependency.HTTP, "operation")
            val SdkHttpOperation = runtimeSymbol("SdkHttpOperation", DartDependency.HTTP, "operation")
            val OperationRequest = runtimeSymbol("OperationRequest", DartDependency.HTTP, "operation")
            val context = runtimeSymbol("context", DartDependency.HTTP, "operation")
            val roundTrip = runtimeSymbol("roundTrip", DartDependency.HTTP, "operation")
            val execute = runtimeSymbol("execute", DartDependency.HTTP, "operation")
        }

        object Engine {
            val HttpClientEngineConfig = runtimeSymbol("HttpClientEngineConfig", DartDependency.HTTP, "engine")
        }
    }


    object Core {
        val IdempotencyTokenProviderExt = runtimeSymbol("idempotencyTokenProvider", DartDependency.CORE, "client")
        val ExecutionContext = runtimeSymbol("ExecutionContext", DartDependency.CORE, "client")
        val ErrorMetadata = runtimeSymbol("ErrorMetadata", DartDependency.CORE)
        val ServiceErrorMetadata = runtimeSymbol("ServiceErrorMetadata", DartDependency.CORE)
        val Instant = runtimeSymbol("Instant", DartDependency.CORE, "time")
        val TimestampFormat = runtimeSymbol("TimestampFormat", DartDependency.CORE, "time")

        object Content {
            val ByteArrayContent = runtimeSymbol("ByteArrayContent", DartDependency.CORE, "content")
            val ByteStream = runtimeSymbol("ByteStream", DartDependency.CORE, "content")
            val StringContent = runtimeSymbol("StringContent", DartDependency.CORE, "content")
            val toByteArray = runtimeSymbol("toByteArray", DartDependency.CORE, "content")
            val decodeToString = runtimeSymbol("decodeToString", DartDependency.CORE, "content")
        }
    }
//
//    object Utils {
//        val AttributeKey = runtimeSymbol("AttributeKey", DartDependency.UTILS)
//        val urlEncodeComponent = runtimeSymbol("urlEncodeComponent", DartDependency.UTILS, "text")
//    }
//
//    object Serde {
//        val Serializer = runtimeSymbol("Serializer", DartDependency.SERDE)
//        val Deserializer = runtimeSymbol("Deserializer", DartDependency.SERDE)
//        val SdkFieldDescriptor = runtimeSymbol("SdkFieldDescriptor", DartDependency.SERDE)
//        val SdkObjectDescriptor = runtimeSymbol("SdkObjectDescriptor", DartDependency.SERDE)
//        val SerialKind = runtimeSymbol("SerialKind", DartDependency.SERDE)
//        val SerializationException = runtimeSymbol("SerializationException", DartDependency.SERDE)
//        val DeserializationException = runtimeSymbol("DeserializationException", DartDependency.SERDE)
//
//        val serializeStruct = runtimeSymbol("serializeStruct", DartDependency.SERDE)
//        val serializeList = runtimeSymbol("serializeList", DartDependency.SERDE)
//        val serializeMap = runtimeSymbol("serializeMap", DartDependency.SERDE)
//
//        val deserializeStruct = runtimeSymbol("deserializeStruct", DartDependency.SERDE)
//        val deserializeList = runtimeSymbol("deserializeList", DartDependency.SERDE)
//        val deserializeMap = runtimeSymbol("deserializeMap", DartDependency.SERDE)
//        val asSdkSerializable = runtimeSymbol("asSdkSerializable", DartDependency.SERDE)
//        val field = runtimeSymbol("field", DartDependency.SERDE)
//
//        object SerdeJson {
//            val JsonSerialName = runtimeSymbol("JsonSerialName", DartDependency.SERDE_JSON)
//            val JsonSerializer = runtimeSymbol("JsonSerializer", DartDependency.SERDE_JSON)
//            val JsonDeserializer = runtimeSymbol("JsonDeserializer", DartDependency.SERDE_JSON)
//        }
//
//        object SerdeXml {
//            val XmlSerialName = runtimeSymbol("XmlSerialName", DartDependency.SERDE_XML)
//            val XmlAliasName = runtimeSymbol("XmlAliasName", DartDependency.SERDE_XML)
//            val XmlCollectionName = runtimeSymbol("XmlCollectionName", DartDependency.SERDE_XML)
//            val XmlNamespace = runtimeSymbol("XmlNamespace", DartDependency.SERDE_XML)
//            val XmlCollectionValueNamespace = runtimeSymbol("XmlCollectionValueNamespace", DartDependency.SERDE_XML)
//            val XmlMapKeyNamespace = runtimeSymbol("XmlMapKeyNamespace", DartDependency.SERDE_XML)
//            val Flattened = runtimeSymbol("Flattened", DartDependency.SERDE_XML)
//            val XmlAttribute = runtimeSymbol("XmlAttribute", DartDependency.SERDE_XML)
//            val XmlMapName = runtimeSymbol("XmlMapName", DartDependency.SERDE_XML)
//            val XmlError = runtimeSymbol("XmlError", DartDependency.SERDE_XML)
//            val XmlSerializer = runtimeSymbol("XmlSerializer", DartDependency.SERDE_XML)
//            val XmlDeserializer = runtimeSymbol("XmlDeserializer", DartDependency.SERDE_XML)
//        }
//
//        object SerdeFormUrl {
//            val FormUrlSerialName = runtimeSymbol("FormUrlSerialName", DartDependency.SERDE_FORM_URL)
//            val FormUrlCollectionName = runtimeSymbol("FormUrlCollectionName", DartDependency.SERDE_FORM_URL)
//            val Flattened = runtimeSymbol("FormUrlFlattened", DartDependency.SERDE_FORM_URL)
//            val FormUrlMapName = runtimeSymbol("FormUrlMapName", DartDependency.SERDE_FORM_URL)
//            val QueryLiteral = runtimeSymbol("QueryLiteral", DartDependency.SERDE_FORM_URL)
//            val FormUrlSerializer = runtimeSymbol("FormUrlSerializer", DartDependency.SERDE_FORM_URL)
//        }
//    }
}

private fun runtimeSymbol(name: String, dependency: DartDependency, subpackage: String = ""): Symbol = buildSymbol {
    this.name = name
    namespace(dependency, subpackage)
}
