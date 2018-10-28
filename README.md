# iOSDISample
DIを使用したサンプル(Swift 4.2)

## OSS

|Name|Description|
|:---:|:---:|
|PromiseKit|非同期処理を単純化するプロミスパターンのライブラリ|
|Alamofire|通信処理のライブラリ|
|NVActivityIndicatorView|ローディングアニメーションのライブラリ|

## carthageでライブラリをビルドする
`$ carthage update --platform iOS`


## Protocol

```
import Foundation

/// イニシャライザインジェクションをサポートするプロトコル
protocol InitializerInjectable {
    associatedtype Dependency
    init(dependency: Dependency)
}

/// メソッドインジェクションをサポートするプロトコル
protocol MethodInjectable {
    associatedtype Dependency
    func inject(dependency: Dependency)
}
```

## Impl

### Initializer injection

```
struct PostcodeRequest: APIRequest, InitializerInjectable {
    
    struct Dependency {
        let baseURL: String
        let path: String
        let parameters: [String : Any]
    }
    
    /// baseURL, path, parametersをイニシャライザで注入する
    init(dependency: PostcodeRequest.Dependency) {
        // Injecting properties.
    }
    
    ...
}
```

#### Callers

- プロダクトコード
```
let postcodeRequestDependency = PostcodeRequest.Dependency(
    baseURL: Constants.PostcodeAPI.baseURL,
    path: Constants.PostcodeAPI.pathPostcode,
    parameters: PostcodeRequest.buildParams(postcode: postcode, general: true, office: true)
)
        
let postcodeRequest = PostcodeRequest(dependency: postcodeRequestDependency)
```

- テストコード
```
private struct PostcodeRequestMock {

    static func build(baseURL: String, path: String, postcode: String, general: Bool, office: Bool) -> PostcodeRequest {

        let params = PostcodeRequest.buildParams(postcode: postcode, general: general, office: office)
        let mock = PostcodeRequest.Dependency(baseURL: baseURL, path: path, parameters: params)

        return PostcodeRequest(dependency: mock)
    }
}

...

let postcodeRequest = PostcodeRequestMock.build(
    baseURL: "http://httpbin.org/status",
    path: "/404",
    postcode: "3320000",
    general: true,
    office: true
)
```

### Method injection

```
final class UserInfoConfirmViewController: UIViewController, MethodInjectable {

    var userName: String!
    var phonetic: String!
    var tel: String!
    var address: String!
    
    struct Dependency {
        let userName: String
        let phonetic: String
        let tel: String
        let address: String
    }

    func inject(dependency: UserInfoConfirmViewController.Dependency) {
        self.userName = dependency.userName
        self.phonetic = dependency.phonetic
        self.tel = dependency.tel
        self.address = dependency.address
    }

    static func make(dependency: UserInfoConfirmViewController.Dependency) -> UserInfoConfirmViewController {

        let vcName = UserInfoConfirmViewController.className
        let vc = UIStoryboard.viewController(
            storyboardName: vcName,
            identifier: vcName) as! UserInfoConfirmViewController

        vc.inject(dependency: dependency)

        return vc
    }

    ...
}
```

#### Callers

- プロダクトコード
```
let userInfoConfirmVCDependency = UserInfoConfirmViewController.Dependency(
    userName: name,
    phonetic: phonetic,
    tel: tel,
    address: address
)

let vc = UserInfoConfirmViewController.make(dependency: userInfoConfirmVCDependency)

navigationController?.pushViewController(vc, animated: true)
```

- テストコード
```
let mock = UserInfoConfirmViewController.Dependency(
    userName: "テスト太郎",
    phonetic: "テストタロウ",
    tel: "0312345678",
    address: "埼玉県川口市xx1-2-3"
)
userInfoConfirmVC = UserInfoConfirmViewController.make(dependency: mock)
```
