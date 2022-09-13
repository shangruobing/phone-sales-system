from django.db import models


class Employee(models.Model):
    id = models.CharField(primary_key=True, max_length=20)
    name = models.CharField(max_length=20, blank=True, null=True)
    role = models.CharField(max_length=20, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'tb_employee'


class MoneyAccount(models.Model):
    id = models.CharField(primary_key=True, max_length=20)
    receipt = models.ForeignKey('Receipt', models.DO_NOTHING)
    employee = models.ForeignKey(Employee, models.DO_NOTHING)
    date = models.DateTimeField(blank=True, null=True)
    total = models.DecimalField(max_digits=10, decimal_places=0, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'tb_money_account'


class Product(models.Model):
    id = models.CharField(primary_key=True, max_length=20)
    brand = models.CharField(max_length=20, blank=True, null=True)
    type = models.CharField(max_length=20)
    model = models.CharField(max_length=20, blank=True, null=True)
    price = models.DecimalField(max_digits=10, decimal_places=0)

    class Meta:
        managed = False
        db_table = 'tb_product'


class Receipt(models.Model):
    id = models.CharField(primary_key=True, max_length=20)
    date = models.DateTimeField(blank=True, null=True)
    total_price = models.DecimalField(max_digits=10, decimal_places=0, blank=True, null=True)
    seller = models.ForeignKey(Employee, models.DO_NOTHING, db_column='seller', blank=True, null=True,
                               related_name="seller_to_employee")
    cashier = models.ForeignKey(Employee, models.DO_NOTHING, db_column='cashier', blank=True, null=True,
                                related_name="cashier_to_employee")
    status = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'tb_receipt'


class ReceiptDetail(models.Model):
    id = models.CharField(primary_key=True, max_length=20)
    product = models.ForeignKey(Product, models.DO_NOTHING, blank=True, null=True)
    receipt = models.ForeignKey(Receipt, models.DO_NOTHING, blank=True, null=True)
    quantity = models.IntegerField(blank=True, null=True)
    amount = models.DecimalField(max_digits=10, decimal_places=0, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'tb_receipt_detail'


class StockAccount(models.Model):
    id = models.CharField(primary_key=True, max_length=20)
    product = models.ForeignKey(Product, models.DO_NOTHING)
    employee = models.ForeignKey(Employee, models.DO_NOTHING)
    date = models.DateTimeField(blank=True, null=True)
    quantity = models.IntegerField(blank=True, null=True)
    kept = models.IntegerField(blank=True, null=True)
    balance = models.IntegerField(blank=True, null=True)
    note = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'tb_stock_account'


class MoneyTaking(models.Model):
    id = models.CharField(primary_key=True, max_length=20)
    beginning_balance = models.DecimalField(max_digits=10, decimal_places=0)
    ending_balance = models.DecimalField(max_digits=10, decimal_places=0)
    employee = models.ForeignKey(Employee, models.DO_NOTHING, blank=True, null=True)
    date = models.DateTimeField(blank=True, null=True)
    total_price = models.DecimalField(max_digits=10, decimal_places=0)
    balance = models.DecimalField(max_digits=10, decimal_places=0, blank=True, null=True)
    note = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'tb_money_taking'
