import Foundation

let kisOnBoardingChecked = "isOnBoardingChecked"

enum BaseURL {
    static let development  =   "https://desynat.com.kw"//"http://157.241.119.72"
    static let release      = "https://desynat.com.kw"//"http://157.241.119.72"
    
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
    case subcriptionPlan              = "/api/seller/payment-subcription-plan"
    case uploadWithResolutionPromotional = "/api/uploadWithResolutionPromotional"
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
    case markAllchatThread                = "/api/seller/mark_all_chat_msg_as_read"
    case qutationChatEdit                 = "/api/seller/Modify-single-chats-records"
    case sendInMessageChat                = "/api/send-message-in-chats"
    case updateReturnExchangeStatus       = "/api/seller/update-order-exchange-return-status"
    case sendNotification                 = "/api/sendPushNotificationApp"
    
    
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
    case countOfNotifcation             = "/api/seller/get_seller_notifications_count"
    
    //M11
    case addNewStory                   = "/api/seller/add_story"
    case addNewReels                   = "/api/seller/add_reels"
    case addNewHighlights              = "/api/seller/add_highlights"
    case uploadImageAndVideo           = "/api/uploadFile"
    case getMyHighlight                = "/api/seller/get_my_highlights"
    case getMyReels                    = "/api/seller/get_my_reels"
    case deleteMyReels                 = "/api/seller/delete_reel"
    case updateMyReelsStatus           = "/api/seller/update_reel_status"
    case editMyReels                   = "/api/seller/update_reel"
//    case getMyStories                  = "/api/seller/get_my_stories"
    case getAdminStories               = "/api/seller/get_Seller_admin_stories"
    case goLive                        = "/api/agora/token"
    case deleteHightLight              = "/api/seller/delete_highlight"
    case deleteStory                   = "/api/seller/delete_story"
    case liveRoomRecordForAgroa        = "/api/seller/live_room_records"
    case getMystoriesForToday          = "/api/seller/get_my_stories_today"
    case raiseTicket                   = "/api/seller/raise_ticket"
    case getRaiseTicket                = "/api/seller/get_raised_tickets"
    case getTicketsType                = "/api/ticket_types"
    case getDealersLiveList            = "/api/seller/other-seller-live-room-records"
    //M13
    case getContacts                     = "/api/contact_us"
    case termsAndCondition               = "/api/terms_conditions"
    case returnPolicy                    = "/api/return_policy"
    case aboutUs                         = "/api/about_us"
    case cancellationPolicy              = "/api/cancellation_policy"
    case exchangePolicy                  = "/api/exchange_policy"
    case getFAQ                          = "/api/faqs"
    case pushNotificationOnOff           = "/api/seller/notification_on_off"
    case inAppNotificationOnOff          = "/api/seller/app_notification_on_off"
    
    case getAllSeller          = "/api/seller/seller-all-menu"
    case addSeller          = "/api/seller/add-new-staff"
    case editSeller          = "/api/seller/edit-new-staff"
    case getSingleStaffDetail = "/api/seller/view-single-staff-details"
    case deleteStaff          = "/api/seller/staff-delete-staff"
    case getAllRoles          = "/api/seller/new-staff-category-type"
    case getAllStaff          = "/api/seller/All-staff-details"
    case activeInactiveStaff = "/api/seller/staff-active-inactive"
    case getRefundOrder = "/api/seller/get_refund_orders"
    case getNewOrderCount   = "/api/seller/order_notification_unread_count"
    case readNewOrderCount   = "/api/seller/mark_all_order_notification"
    case changePassword      = "/api/seller/update_password"
    case deleteAccount       = "/api/seller/delete_account"
    case sellerDashboard     = "/api/seller/dashboard_data"
    case seeStory            = "/api/see_story"
    case deliveryTimeList    = "/api/delivery_times"
    
    
    case getSellerStoryPrice  = "/api/seller/get_seller_story_price"
    case completeStoryPayment = "/api/seller/complete_story_payment"
    case getMyStoriesRequests = "/api/seller/get_my_stories_requests"
    
    func withBaseURL() -> String {
        return "\(BaseURL.value())\(self.rawValue)"
    }
}

enum NetworkURL {
    case endpoint(NetworkEndPoint)
    case custom(String)
}

