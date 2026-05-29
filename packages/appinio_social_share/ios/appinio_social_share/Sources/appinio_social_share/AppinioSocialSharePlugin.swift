import Flutter
import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import Photos



@objc(AppinioSocialSharePlugin)
public class AppinioSocialSharePlugin: NSObject, FlutterPlugin {

    private let INSTAGRAM_DIRECT:String = "instagram_direct";
    private let INSTAGRAM_STORIES:String = "instagram_stories";
    private let INSTAGRAM_POST:String = "instagram_post";
    private let FACEBOOK:String = "facebook";
    private let FACEBOOK_STORIES = "facebook_stories";
    private let MESSENGER = "messenger";
    private let WHATSAPP:String = "whatsapp";
    private let WHATSAPP_IMG_IOS:String = "whatsapp_img_ios";
    private let TWITTER:String = "twitter";
    private let SMS:String = "sms";
    private let SYSTEM_SHARE:String = "system_share";
    private let COPY_TO_CLIPBOARD:String = "copy_to_clipboard";
    private let TELEGRAM:String = "telegram";
    private let INSTALLED_APPS:String = "installed_apps";


    var shareUtil = ShareUtil()

    // Holds the Facebook share delegate alive for the duration of a share.
    // `ShareDialog.delegate` is `weak`, so without this strong reference the
    // delegate would be deallocated before the share callback fires.
    private var shareDelegate: FBShareDelegate?



  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "appinio_social_share", binaryMessenger: registrar.messenger())
    let instance = AppinioSocialSharePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      do {
      let args = call.arguments as? [String: Any?]

      switch (call.method) {
      case INSTALLED_APPS:
          shareUtil.getInstalledApps(result: result)
          break
      case INSTAGRAM_DIRECT:
          shareUtil.shareToInstagramDirect(args:args!,result: result)
          break
      case INSTAGRAM_POST:
          shareUtil.shareToInstagramFeed(args:args!,result: result)
          break
      case INSTAGRAM_STORIES:
          shareUtil.shareToInstagramStory(args:args!,result:result)
          break
      case FACEBOOK_STORIES:
          shareUtil.shareToFacebookStory(args:args!,result:result)
          break
      case WHATSAPP_IMG_IOS:
          shareUtil.shareImageToWhatsApp(args:args!, result:result)
          break
      case WHATSAPP:
          shareUtil.shareToWhatsApp(args:args!, result:result)
          break
      case TWITTER:
          shareUtil.shareToTwitter(args:args!,result:result)
          break
      case SMS:
          shareUtil.shareToSms(args: args!, result: result)
          break
      case SYSTEM_SHARE:
          shareUtil.shareToSystem(args:args!,result: result)
          break
      case COPY_TO_CLIPBOARD:
          shareUtil.copyToClipboard(args: args!, result: result)
          break
      case FACEBOOK:
          let delegate = FBShareDelegate(result: result, successValue: shareUtil.SUCCESS, errorValue: shareUtil.ERROR)
          delegate.onFinished = { [weak self] in self?.shareDelegate = nil }
          shareDelegate = delegate
          shareUtil.shareToFacebookPost(args:args!, result: result, delegate: delegate)
          break
      case TELEGRAM:
          shareUtil.shareToTelegram(args:args!, result:result)
          break
      case MESSENGER:
          shareUtil.shareToMessenger(args: args!, result: result)
          break
      default:
          result(shareUtil.ERROR)
      }
      } catch {
          result(shareUtil.ERROR)
      }
  }

}

/// Receives Facebook `ShareDialog` callbacks and forwards them to a Flutter
/// result. This is intentionally a separate, non-`@objc`-exposed type so that
/// the `SharingDelegate` conformance (an `@objc` protocol) does not leak into
/// `AppinioSocialSharePlugin`'s generated Objective-C interface — keeping that
/// interface `<FlutterPlugin>` only and avoiding cross-module ODR conflicts in
/// the generated plugin registrant. It must be strongly retained by the plugin
/// because `ShareDialog.delegate` is `weak`.
final class FBShareDelegate: NSObject, SharingDelegate {
    private let result: FlutterResult
    private let successValue: String
    private let errorValue: String

    /// Invoked after any terminal callback so the owner can release this object.
    var onFinished: (() -> Void)?

    init(result: @escaping FlutterResult, successValue: String, errorValue: String) {
        self.result = result
        self.successValue = successValue
        self.errorValue = errorValue
    }

    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        result(successValue)
        onFinished?()
    }

    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        result(errorValue)
        onFinished?()
    }

    func sharerDidCancel(_ sharer: Sharing) {
        result(errorValue)
        onFinished?()
    }
}
