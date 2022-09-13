from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.exceptions import NotFound

from ..models import StockAccount
from ..pagination import GenericPagination
from ..serializers import StockAccountSerializer


class StockAccountListView(APIView):
    def get(self, request, *args, **kwargs):
        """
        Retrieve the registered stockAccounts.
        """
        stockAccounts = StockAccount.objects.all()
        stockAccount_serializer = StockAccountSerializer(stockAccounts, many=True)
        paginator = GenericPagination()
        page_stockAccount_list = paginator.paginate_queryset(stockAccount_serializer.data, self.request, view=self)
        return paginator.get_paginated_response(page_stockAccount_list)

    def post(self, request, *args, **kwargs):
        """
        Create a stockAccount.
        """
        serializer = StockAccountSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def put(self, request, *args, **kwargs):
        """
        Update stockAccount batch.
        """
        for item in request.data:
            stockAccount = StockAccount.objects.get(pk=item.get('id'))
            stockAccount.kept = item.get('kept')
            stockAccount.balance = int(stockAccount.kept) - stockAccount.quantity
            stockAccount.note = item.get('note')
            stockAccount.save()
        return Response('OK')


class StockAccountView(APIView):
    """
    Retrieve, update or delete a stockAccount instance.
    """

    def get_object(self, pk):
        try:
            return StockAccount.objects.get(pk=pk)
        except StockAccount.DoesNotExist:
            raise NotFound("NOT_FOUND")

    def get(self, request, pk, *args, **kwargs):
        """
        Retrieve a stockAccount by ID.
        """
        stockAccount = self.get_object(pk)
        serializer = StockAccountSerializer(stockAccount)
        return Response(serializer.data)

    def put(self, request, pk, *args, **kwargs):
        """
        Update a stockAccount by ID.
        """
        stockAccount = self.get_object(pk)
        stockAccount.id = pk
        serializer = StockAccountSerializer(stockAccount, data=request.data)
        if serializer.is_valid():
            return Response(serializer.data)

    def delete(self, request, pk, *args, **kwargs):
        """
        Delete a stockAccount by ID.
        """
        self.get_object(pk).delete()
        return Response("OK", status=status.HTTP_204_NO_CONTENT)
