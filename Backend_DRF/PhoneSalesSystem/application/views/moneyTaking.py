from django.db.models import Sum
from django.utils.datetime_safe import datetime
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.exceptions import NotFound

from ..models import MoneyTaking, MoneyAccount, Employee
from ..pagination import GenericPagination
from ..serializers import MoneyTakingSerializer
from ..utils.identityGenerator import generateId


class MoneyTakingListView(APIView):
    def get(self, request, *args, **kwargs):
        """
        Retrieve the registered moneyTakings.
        """
        moneyTakings = MoneyTaking.objects.all()
        moneyTaking_serializer = MoneyTakingSerializer(moneyTakings, many=True)
        paginator = GenericPagination()
        page_moneyTaking_list = paginator.paginate_queryset(moneyTaking_serializer.data, self.request, view=self)
        return paginator.get_paginated_response(page_moneyTaking_list)

    def post(self, request, *args, **kwargs):
        """
        Create a moneyTaking.
        """
        data = request.data
        income = MoneyAccount.objects.aggregate(income=Sum('total')).get('income')
        ending_balance = float(income) + float(data.get('ending_balance'))
        cashier = Employee.objects.filter(id=data.get('employee').get('id')).first()
        MoneyTaking.objects.create(
            id=generateId(),
            beginning_balance=data.get("ending_balance"),
            ending_balance=ending_balance,
            employee=cashier,
            date=datetime.now(),
            total_price=data.get('total_price'),
            balance=float(data.get('total_price')) - ending_balance,
            note=data.get('note')
        )
        return Response("OK", status=status.HTTP_201_CREATED)


class MoneyTakingView(APIView):
    """
    Retrieve, update or delete a moneyTaking instance.
    """

    def get_object(self, pk):
        try:
            return MoneyTaking.objects.get(pk=pk)
        except MoneyTaking.DoesNotExist:
            raise NotFound("NOT_FOUND")

    def get(self, request, pk, *args, **kwargs):
        """
        Retrieve a moneyTaking by ID.
        """
        moneyTaking = self.get_object(pk)
        serializer = MoneyTakingSerializer(moneyTaking)
        return Response(serializer.data)

    def put(self, request, pk, *args, **kwargs):
        """
        Update a moneyTaking by ID.
        """
        moneyTaking = self.get_object(pk)
        moneyTaking.id = pk
        serializer = MoneyTakingSerializer(moneyTaking, data=request.data)
        if serializer.is_valid():
            return Response(serializer.data)

    def delete(self, request, pk, *args, **kwargs):
        """
        Delete a moneyTaking by ID.
        """
        self.get_object(pk).delete()
        return Response("OK", status=status.HTTP_204_NO_CONTENT)
