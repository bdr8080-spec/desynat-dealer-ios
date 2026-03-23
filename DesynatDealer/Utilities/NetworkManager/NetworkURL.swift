import Foundation

let kisOnBoardingChecked = "isOnBoardingChecked"

enum BaseURL {
    static let development  = "http://157.241.119.72"
    static let release      = "http://157.241.119.72"
    
    static func value() -> String {
        switch BuildConfiguration.shared.environment {
        case .debug:
            return BaseURL.development
        case .release:
            return BaseURL.release
        }
    }
}

enum NetworkEndPoint: String {
    
    case register                     = "user-registration/basic-registration"
    case uploadImage                  = "/api/upload"
    case createAccount                = "/api/seller/create_account"
    case otpVerification              = "/api/seller/verify_otp"
    case storeInformation             = "/api/seller/store_information"
    case uploadDocument               = "/api/seller/store_document_and_bank_details"
    case login                        = "/api/seller/login"
    case createPassword               = "/api/seller/create_password"
    case forgotPassword               = "/api/seller/forgot_password"
    case summary                      = "/api/seller/seller_review"
    case submitSummary                = "/api/seller/seller_store_submit_request"
    case logout                       = "/api/seller/logout"
    case country                      = "/api/country"
    case resendOtp                    = "/api/seller/resend_otp"
    case getPlans                     = "/api/seller/all-plans"
    case purchasePlan                 = "/api/seller/create-subcription-plan-buy"
    case subcriptionPlan                 = "/api/seller/payment-subcription-plan"
    
    // M3
    case updateStoreStatus            = "/api/seller/store_on_off"
    case getCategoryList              = "/api/seller/category"
    case getSubCategoryList           = "/api/seller/sub-category"
    case getBrandsList                = "/api/seller/all-brand"
    case getColorsList                = "/api/seller/all-color"
    case getSizesList                 = "/api/seller/all-size"
    case addProduct                   = "/api/seller/add-product1"
    case getProductsList              = "/api/seller/all-product"
    case productsActiveStatus         = "/api/seller/product-status-active-inactive"
    case getProductsDetails           = "/api/seller/single-product-details"
    case deleteProductsDetails        = "/api/seller/product-delete"
    case editProductsDetails          = "/api/seller/edit-product1"
    case getSellerProfile             = "/api/seller/seller-profile"
    
    
    //M4
    case getProfile                       = "/api/seller/view-profile"
    case updateStoreInformation           = "/api/seller/update-store-information"
    case updateBankInformation            = "/api/seller/update-store-bank-details"
    case allInventoryList                 = "/api/seller/all-Inventory-product"
    case updateInventoryDetails           = "/api/seller/update-stock-inventory"
    case updateAffiliatedValue            = "/api/seller/update-affilate-commission"
    
    
    //M5
    case getBanners                     = "/api/seller/all-banners"
    case addBanner                      = "/api/seller/add-banner"
    case getBannerPrice                 = "/api/seller/get-seller-banner-price"
    case bannerPayment                  = "/api/seller/complete-banner-payment"
    
    //M6
    case ordersList                       = "/api/seller/all-orders"
    case singleOrderDetails               = "/api/seller/single-orders-data"
    case updateOrderStatus                = "/api/seller/update-single-order-status"
    //Chat
    case getAllChatsRecord                = "/api/seller/all-chats-records"
    case getSingleChats                   = "/api/seller/single-chats-records"
    case qutationChatEdit                 = "/api/seller/Modify-single-chats-records"
    case sendInMessageChat                = "/api/send-message-in-chats"
    case updateReturnExchangeStatus       = "/api/seller/update-order-exchange-return-status"
    
    
    //M7
    case getAllDealsList                = "/api/seller/view-deals"
    case getDealsDetails                = "/api/seller/view-single-deals"
    case addProductsInDeals             = "/api/seller/Add-products-in-deal-inside"
    case removeProductsInDeals          = "/api/seller/remove-products-in-deal"
    
    
    //M8
    case getliveCoverageRequest         = "/api/seller/get_live_requests"
    case getTimeSlotsRequest            = "/api/seller/get_timeslots"
    case cancelLiveCoverageRequest      = "/api/seller/cancel_live_request"
    case sendLiveCoverageRequest        = "/api/seller/send_live_request"
    
    
    //M10
    case getNotifications               = "/api/seller/get_my_notifications_list"
    case markReadNotification           = "/api/seller/mark_notification_as_read"
    case markAllReadNotification        = "/api/seller/mark_all_notification_as_read"
    case myPlanList                     = "/api/seller/my_plans"
    case renewSubcriptionPlanBuy        = "/api/seller/renew_subcription_plan_buy"
    
    func withBaseURL() -> String {
        return "\(BaseURL.value())\(self.rawValue)"
    }
}

enum NetworkURL {
    case endpoint(NetworkEndPoint)
    case custom(String)
}

