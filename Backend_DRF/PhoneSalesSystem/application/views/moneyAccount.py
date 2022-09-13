from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.exceptions import NotFound

from ..models import MoneyAccount
from ..pagination import GenericPagination
from ..serializers import MoneyAccountSerializer


class MoneyAccountListView(APIView):
    def get(self, request, *args, **kwargs):
        """
        Retrieve the registered moneyAccounts.
        """
        moneyAccounts = MoneyAccount.objects.all()
        moneyAccount_serializer = MoneyAccountSerializer(moneyAccounts, many=True)
        paginator = GenericPagination()
        page_moneyAccount_list = paginator.paginate_queryset(moneyAccount_serializer.data, self.request, view=self)
        return paginator.get_paginated_response(page_moneyAccount_list)

    def post(self, request, *args, **kwargs):
        """
        Create a moneyAccount.
        """
        serializer = MoneyAccountSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class MoneyAccountView(APIView):
    """
    Retrieve, update or delete a moneyAccount instance.
    """

    def get_object(self, pk):
        try:
            return MoneyAccount.objects.get(pk=pk)
        except MoneyAccount.DoesNotExist:
            raise NotFound("NOT_FOUND")

    def get(self, request, pk, *args, **kwargs):
        """
        Retrieve a moneyAccount by ID.
        """
        moneyAccount = self.get_object(pk)
        serializer = MoneyAccountSerializer(moneyAccount)
        return Response(serializer.data)

    def put(self, request, pk, *args, **kwargs):
        """
        Update a moneyAccount by ID.
        """
        moneyAccount = self.get_object(pk)
        moneyAccount.id = pk
        serializer = MoneyAccountSerializer(moneyAccount, data=request.data)
        if serializer.is_valid():
            return Response(serializer.data)

    def delete(self, request, pk, *args, **kwargs):
        """
        Delete a moneyAccount by ID.
        """
        self.get_object(pk).delete()
        return Response("OK", status=status.HTTP_204_NO_CONTENT)
