from django.utils.datetime_safe import datetime
from rest_framework import status
from rest_framework.exceptions import NotFound
from rest_framework.response import Response
from rest_framework.views import APIView

from ..models import Receipt, Employee, ReceiptDetail, Product, MoneyAccount, StockAccount
from ..pagination import GenericPagination
from ..serializers import ReceiptSerializer, ReceiptDetailSerializer, StockAccountSerializer
from ..utils.identityGenerator import generateId


class ReceiptListView(APIView):
    def get(self, request, *args, **kwargs):
        """
        Retrieve the registered receipts.
        """
        receipts = Receipt.objects.all()
        receipt_serializer = ReceiptSerializer(receipts, many=True)
        paginator = GenericPagination()
        page_receipt_list = paginator.paginate_queryset(receipt_serializer.data, self.request, view=self)
        return paginator.get_paginated_response(page_receipt_list)

    def post(self, request, *args, **kwargs):
        """
        Create a receipt with details.
        """
        data = request.data
        receipt_id = generateId()
        seller = Employee.objects.filter(id=data.get('seller')).first()
        cashier = Employee.objects.filter(id=data.get('cashier')).first()
        receipt = Receipt.objects.create(id=receipt_id,
                                         date=datetime.now(),
                                         total_price=data.get('total_price'),
                                         seller=seller,
                                         cashier=cashier,
                                         status=1)
        for i in data.get('receiptDetails'):
            product = Product.objects.filter(id=i.get('productId')).first()
            ReceiptDetail.objects.create(id=generateId(),
                                         product=product,
                                         receipt=receipt,
                                         quantity=i.get('quantity'),
                                         amount=i.get('total'))
        return Response({"Receipt Id": receipt_id, "message": "OK"}, status=status.HTTP_201_CREATED)


class ReceiptView(APIView):
    """
    Retrieve, update or delete a receipt instance.
    """

    def get_object(self, pk):
        try:
            return Receipt.objects.get(pk=pk)
        except Receipt.DoesNotExist:
            raise NotFound("NOT_FOUND")

    def get(self, request, pk, *args, **kwargs):
        """
        Retrieve a receipt by ID.
        """
        receipt = self.get_object(pk)
        serializer = ReceiptSerializer(receipt)
        receiptDetails = ReceiptDetail.objects.filter(receipt_id=pk)
        receiptSerializer = ReceiptDetailSerializer(receiptDetails, many=True)
        data = serializer.data
        data["receiptDetails"] = receiptSerializer.data
        return Response(data)

    def put(self, request, pk, *args, **kwargs):
        """
        Update a receipt by ID.
        """
        receipt = self.get_object(pk)
        receipt.id = pk
        serializer = ReceiptSerializer(receipt, data=request.data)
        if serializer.is_valid():
            return Response(serializer.data)

    def delete(self, request, pk, *args, **kwargs):
        """
        Delete a receipt by ID.
        """
        self.get_object(pk).delete()
        return Response("OK", status=status.HTTP_204_NO_CONTENT)


class PaymentView(APIView):
    def get_object(self, pk):
        try:
            return Receipt.objects.get(pk=pk)
        except Receipt.DoesNotExist:
            raise NotFound("NOT_FOUND")

    def put(self, request, *args, **kwargs):
        """
        Payment
        """
        receipt = self.get_object(request.data.get("id"))
        receipt.status = 2
        receipt.save()
        employee = Employee.objects.get(pk=receipt.cashier_id)
        MoneyAccount.objects.create(id=generateId(),
                                    receipt=receipt,
                                    employee=employee,
                                    date=datetime.now(),
                                    total=receipt.total_price)
        serializer = ReceiptSerializer(receipt)
        return Response(serializer.data)


class OutBoundView(APIView):
    def get_object(self, pk):
        try:
            return Receipt.objects.get(pk=pk)
        except Receipt.DoesNotExist:
            raise NotFound("NOT_FOUND")

    def get(self, request, pk, *args, **kwargs):
        obj = StockAccount.objects.filter(product_id=pk).first()
        return Response(StockAccountSerializer(obj).data)

    def put(self, request, *args, **kwargs):
        """
        Out Bound
        """
        receipt = self.get_object(request.data.get("id"))
        receipt.status = 3
        receipt.save()
        receiptDetails = ReceiptDetail.objects.filter(receipt_id=receipt.id)
        for receiptDetail in receiptDetails:
            product = Product.objects.get(pk=receiptDetail.product_id)
            stockAccount = StockAccount.objects.filter(product__id=product.id).first()
            stockAccount.quantity -= receiptDetail.quantity
            stockAccount.save()

        serializer = ReceiptSerializer(receipt)
        return Response(serializer.data)

    def post(self, request, *args, **kwargs):
        """
        Create or Update StockList.
        If exists Update, else update.
        """
        for item in request.data:
            quantity = item.get('quantity')
            product = Product.objects.get(pk=item.get('productId'))
            employee = Employee.objects.get(pk=item.get('employeeId'))
            stockAccount = StockAccount.objects.filter(product_id=product.id).first()
            if stockAccount:
                stockAccount.quantity += int(quantity)
                stockAccount.note = item.get('note')
                stockAccount.save()
            else:
                StockAccount.objects.create(id=generateId(),
                                            product=product,
                                            employee=employee,
                                            date=datetime.now(),
                                            quantity=quantity,
                                            note=item.get('note')
                                            )
        return Response({"message": "OK"}, status=status.HTTP_201_CREATED)
