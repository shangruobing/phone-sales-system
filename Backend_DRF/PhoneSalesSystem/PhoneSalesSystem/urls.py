from django.urls import path
from application.views import employee, product, receipt, receiptDetail, moneyAccount, stockAccount, moneyTaking

urlpatterns = [
    # Post 增加小票
    path('api/receipt/', receipt.ReceiptListView.as_view()),
    path('api/receipt/<int:pk>/', receipt.ReceiptView.as_view()),

    # Put 付款
    path('api/payment/', receipt.PaymentView.as_view()),
    # Put 出库
    path('api/outbound/', receipt.OutBoundView.as_view()),
    path('api/outbound/<str:pk>/', receipt.OutBoundView.as_view()),
    # Post 批量入库
    path('api/enterbound/', receipt.OutBoundView.as_view()),

    path('api/employee/', employee.EmployeeListView.as_view()),
    path('api/employee/<int:pk>/', employee.EmployeeView.as_view()),

    path('api/product/', product.ProductListView.as_view()),
    path('api/product/<int:pk>/', product.ProductView.as_view()),

    path('api/receiptDetail/', receiptDetail.ReceiptDetailListView.as_view()),
    path('api/receiptDetail/<int:pk>/', receiptDetail.ReceiptDetailView.as_view()),

    path('api/moneyAccount/', moneyAccount.MoneyAccountListView.as_view()),
    path('api/moneyAccount/<int:pk>/', moneyAccount.MoneyAccountView.as_view()),

    path('api/stockAccount/', stockAccount.StockAccountListView.as_view()),
    path('api/stockAccount/<int:pk>/', stockAccount.StockAccountView.as_view()),

    path('api/moneyTaking/', moneyTaking.MoneyTakingListView.as_view()),
    path('api/moneyTaking/<int:pk>/', moneyTaking.MoneyTakingView.as_view())
]
