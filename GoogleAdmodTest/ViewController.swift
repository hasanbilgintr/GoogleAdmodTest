//
//  ViewController.swift
//  GoogleAdmodTest
//
//  Created by hasan bilgin on 19.12.2023.
//

import UIKit
//eklendi
import GoogleMobileAds
//ATT için eklendi
import AppTrackingTransparency

//GADFullScreenContentDelegate çağırmalar için eklendi
class ViewController: UIViewController,GADFullScreenContentDelegate {
    //eklendi
    private var interstitial: GADInterstitialAd?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         Reklam alma
         Google admob ios için (https://developers.google.com/admob/ios/quick-start?hl=tr)
         -bu sadece firabase siz dir firebase kullanılcaksa link sitede mevcuttur
         - Create an AdMob account yeri ile kayıt olalım admoba ora incelenebilir yada direk buna gidin https://apps.admob.com tabi burda kayıtlı değilse kayıt edilcek vs kayıtlı ise direk giriş yapabiliriz
         -ana ekran gelicektir sol üstte uygulamalar var tıkla ordan uygulama ekle tıklıyoruz. platform ve uygulama yayınlandımı diye sorar cevaplayıp devam deriz.uygulama adı girilir. kullanıcı metrikleri açık kalsın uygulama ekle deriz. tamamlandı tıklarız. açılan ekranda sol üstte uygulamalar ve tüm uygulamaları seçip uygulama adı ne ise ordan Uygulama Kimliği(app id) ne ise kopyalanır (Constants.appId. Ardından uygulama ne ise ona tıklanır. Reklam birimi ekleyin tıklıyoruz ama öncesine pods yada spm dir spm den yüklücez. oda üstten File -> Add Package Dependencies... tıklanır. bunu aratarak https://github.com/googleads/swift-package-manager-google-mobile-ads.git çıkanı add Package diyoruz çıkan GoogleMobileAds çıkıcaktır Add Package tıklıyoruz. eklendikten sonra info.plist e eklenicek olan kodları kopyalayıp info.plist i sağ tık ile open as -> source Code tıklanırsa ilk <dict> hemne altına eklenebilir.BUNLAR Güncel tutulması ŞART. Tekrar info.plist i property list açılırsa eski halin gelicektir. yada propert list seçilmesine gerekte yok info.plist kapatılıp açılırsa eski haliyle açılcaktır. eklendiğini görünecektir ve çıkan app id bura ile değiştirilcektir. bu arada bu app id markete konduktan yada yayınladıktan sonra aktif oluyor ondna dolayısıyla test için verilen yani bunu Constants.testAppId kullanıcaz ama biz Constants.appId kullandık sorun olmadı   tabi yayınlamadan önce gerçek appid değiştirilmesi gerekicek . instance edince  . ardından ilk dökümantasyondan yada uygulama seçince uygulama birimlerinden devam ediyoruz orda
         Banner-> ekranın üstünde veya altında çıkan  küçük devam çıkan reklamlar için
         interstitial(geçişli) -> ise en çok kullanılan reklamdır. ekran arası geçişlerde çıkan tam sayfa reklamlardır. ekran geçişi varsa gayette uygun bir reklam oluyor. biz bunu kullanıcaz
         Native(yerel biçim)-> kendimize göre bir reklam çeşidi oluşturabiliyoruz
         Rewarded(ödül olarak verildi) -> oyunlarda vs kullanılan şu işlemi yaparsan sana oyun parası can vs verne reklam türüdür.
         -interstitial altındaki implement an interstitial tıklayarak ilerliyoruz. yada uygulama birimlerinden devam ediyoruz. seçtik -> isim veriyoruz -> FirstAdd -> ardından reklam birimini oluştur(create ad unit) dedik. iki id vericektir. ilki app id  Constants.appId diğeri ise reklam için özel olan unit id Constants.interstitialAdId (herreklama farklı reklam id oluşturabiliriz) tabi 1 reklam tüm ekranlarda gösterilebilir ama önerilmez her ekrsana farklı reklam id ile tanımlanması gerekiyor GOOGLE tavsiyesidir ve tamamlandı(done) tıklıyoruz. ardından reklam id tıklayıp uygulama talimatları tıklayıp uygulama klavuzua tıklarsak ilk linkin reklam implementasyon tıklanınca açılcak olan yer açılcaktır. biz yine reklam test id verildi bu Constants.testInterstitialAdId kullanıcaz
         
         .....
         */
        //ATT için
        //ios 14 ve üzeri ise anlamına geliyor
        if #available(iOS 14, *) {
            //admobla alakası yok bunun
            ATTrackingManager.requestTrackingAuthorization { status in
                
                
                //eklendi
                //kişisel reklam ile sorun yoksa dışına çıkartabiliriz
                let request = GADRequest()
                GADInterstitialAd.load(withAdUnitID: Constants.testInterstitialAdId, request: request, completionHandler: {
                    [self] ad, error in
                    if let error = error {
                        print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                        return
                    }
                    interstitial = ad
                    
                    //3 metot için eklendi
                    interstitial?.fullScreenContentDelegate = self
                }
                )
                
                
                //ATT için
                //izin verildiyse ne yapılcak
                if status == .authorized {
                    
                }//izin verilmediyse ne yapılcak
                else if status == .denied {
                    
                }
            }
        }
        

    }
    
    //yüklenmekten vazgeçerse yada fail ederse çalışçak olan
    /// Tells the delegate that the ad failed to present full screen content.
      func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
      }

    //yüklenirse çalışçak olan
      /// Tells the delegate that the ad will present full screen content.
      func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
      }

    //yüklendi reklam bitti çalışçak olan
      /// Tells the delegate that the ad dismissed full screen content.
      func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
      }
    
    @IBAction func nextClicked(_ sender: Any) {
        
        if interstitial != nil {
          interstitial!.present(fromRootViewController: self)
        } else {
          print("Ad wasn't ready")
        }
        
        //info.plistte şunuda ekleyelim GADIsAdManagerApp keyi Boolean tipinde valuesi YES yani 1 de denebilir. eklencek
        //ana klasöre gelip Build Setting -> Linking - General de Other Linker Flags soldan açılır yerini açıp Debug keyi sağına + basılarak çıkan keyin hemen valuesine -ObjC aynı şekilde Release valuede aynısı yazıyoruz
        
        
    }
    
    //app tracking Transparency (https://developer.apple.com/documentation/apptrackingtransparency)(https://developers.google.com/admob/ios/privacy/strategies?hl=tr)(ATT)
    //kullanıcıya gelen reklamların etkileşim olursa bu bilgi izni alma diyebiliriz, ios 14.5 itibari gedi amacı kişisel kullanıcı reklamı mesela bilgisayara tıkladı diğer uygulamalardands bilgisayar getirmesi
    /*
     - info.pliste keyi Privacy - Tracking Usage Description / String tipinde ve value ise Kişisel reklamlar için izin alınması gerekir(This identifier will be used to deliver personalized ads to you.)
     zaten bu izinde kullanıcıdan izin bile öngörmüyor
     


     */
    
}

