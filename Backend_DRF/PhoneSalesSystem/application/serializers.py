from rest_framework import serializers
from .models import Employee, Receipt, ReceiptDetail, Product, MoneyAccount, StockAccount, MoneyTaking


class EmployeeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Employee
        fields = '__all__'


class ReceiptDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = ReceiptDetail
        fields = '__all__'
        depth = 1


class ReceiptSerializer(serializers.ModelSerializer):
    details = ReceiptDetailSerializer(many=True, read_only=True)

    class Meta:
        model = Receipt
        fields = '__all__'
        depth = 2


class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = '__all__'


class MoneyAccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = MoneyAccount
        fields = '__all__'
        depth = 2


class StockAccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = StockAccount
        fields = '__all__'
        depth = 2


class MoneyTakingSerializer(serializers.ModelSerializer):
    class Meta:
        model = MoneyTaking
        fields = '__all__'
        depth = 1
